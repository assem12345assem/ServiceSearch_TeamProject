package com.example.demo.service;

import com.example.demo.dto.FindUserNameDto;
import com.example.demo.dto.UserDto;
import com.example.demo.dto.ViewerDto;
import com.example.demo.entities.*;
import com.example.demo.enums.UserType;
import com.example.demo.repository.*;
import com.example.demo.utils.CountryCode;
import com.example.demo.utils.Utility;
import jakarta.mail.MessagingException;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.time.LocalDateTime;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


@Slf4j
@Service
@RequiredArgsConstructor
public class UserService {
    public static final String SPECIALIST = "specialist";
    private static final String DEFAULTPHOTO = "https://servicesearchlalaservice.s3.eu-north-1.amazonaws.com/default_user_photo.jpg";
    private final UserRepository repository;
    private final SpecialistRepository specialistRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder encoder;
    private final AuthUserDetailsService service;
    private final GeolocationRepository geolocationRepository;
    private final AuthorityRepository authorityRepository;
    private final SpecialistService specialistService;
    private final UpdateCountsRepository updateCountsRepository;
    private final SpecialistsAuthoritiesRepository specialistsAuthoritiesRepository;
    private final StorageService storageService;
    private final ThemeRepository themeRepository;
    private final EmailService emailService;
    private final PostRepository postRepository;
    private final ResumeRepository resumeRepository;

    public List<User> getAllUsers() {
        return repository.findAll();
    }

    public void register(UserDto userDto) throws IOException {
        var u = repository.findByPhoneNumber(userDto.getPhoneNumber());
        var geolocation = geolocationRepository.findByCountryAndCity(userDto.getCountry(), userDto.getCity());
        Geolocation geo = null;
        if (geolocation.isPresent()) geo = geolocation.get();

        if (!isValidPhoneNumber(userDto.getPhoneNumberCode(), userDto.getPhoneNumber())) {
            throw new InvalidPropertiesFormatException("Некорректный формат номера");
        }

        if (u.isEmpty()) {
            String phoneNumber = userDto.getPhoneNumberCode() + userDto.getPhoneNumber();
            Role role = defineUserRole(userDto.getRole());
            String userType = defineUserType(userDto.getRole());
            var user = User.builder()
                    .phoneNumber(phoneNumber)
                    .email(userDto.getEmail())
                    .password(encoder.encode(userDto.getPassword()))
                    .userName(userDto.getUserName())
                    .userType(userType)
                    .role(role)
                    .photo(DEFAULTPHOTO)
                    .geolocation(geo)
                    .enabled(Boolean.TRUE)
                    .registrationDate(LocalDateTime.now())
                    .build();
            repository.saveAndFlush(user);
            if (userType.equalsIgnoreCase(SPECIALIST)) {
                var newUser = repository.findByPhoneNumber(userDto.getPhoneNumber());
                if (newUser.isPresent()) {
                    Specialist s = specialistRepository.saveAndFlush(Specialist.builder()
                            .user(newUser.get())
                            .build());
                    saveNewSpecialistAuthority(s);
                }
            }

        } else {
            log.warn("User already exists: {}", userDto.getPhoneNumber());
            throw new IllegalArgumentException("User already exists");
        }
    }

    private void saveNewSpecialistAuthority(Specialist s) {
        Authority a = getFullAuthority();
        specialistsAuthoritiesRepository.save(SpecialistsAuthorities.builder()
                .specialist(s)
                .authority(a)
                .dateStart(LocalDateTime.now())
                .dateEnd(LocalDateTime.now().plusMonths(1))
                .build());
    }

    private Role defineUserRole(String userRole) {
        Role role = null;
        if (userRole.equalsIgnoreCase("role_specialist")) {
            role = roleRepository.findByRole("ROLE_SPECIALIST");
        }
        if (userRole.equalsIgnoreCase("role_customer")) {
            role = roleRepository.findByRole("ROLE_CUSTOMER");
        }

        if (role == null) {
            log.warn("Invalid role name: {}", userRole);
            throw new IllegalArgumentException("Invalid role name: " + userRole);
        }
        return role;
    }

    public User getUserFromSecurityContextHolder() {
        String username = getUsernameFromSecurityContextHolder();
        if (username.isEmpty()) return null;
        return findUserByUsername(username);
    }

    public String defineUserType(String userRole) {
        if (userRole == null) {
            log.warn("Passed a null value for user role");
            throw new IllegalArgumentException("User role cannot be null");
        }
        int underscoreIndex = userRole.indexOf('_');
        String type = userRole.substring(underscoreIndex + 1);
        UserType userType = null;
        for (UserType t : UserType.values()) {
            if (t.name().equalsIgnoreCase(type)) {
                userType = t;
            }
        }
        if (userType == null) {
            log.warn("Unknown user role was passed as argument");
            throw new IllegalArgumentException("User role has unknown value");
        }
        return userType.name();
    }

    public List<String> getRoles() {
        return roleRepository.findAll().stream()
                .map(Role::getRole)
                .toList();
    }

    private Authority getFullAuthority() {
        return authorityRepository.findByAuthorityName("FULL");
    }

    public void updateUser(HttpServletRequest request, Authentication auth) {
        String selectedRole = request.getParameter("role");
        Role role = defineUserRole(selectedRole);
        String userType = defineUserType(selectedRole);
        var userAuth = (OAuth2User) auth.getPrincipal();
        String email = userAuth.getAttribute("email");
        var user = repository.getByEmail(email);
        var geolocation = geolocationRepository.findByCountryAndCity(request.getParameter("country"), request.getParameter("city"));
        Geolocation geo = null;
        if (geolocation.isPresent()) geo = geolocation.get();
        if (user.isPresent()) {
            User u = user.get();
            u.setRole(role);
            u.setGeolocation(geo);
            u.setUserType(userType);
            repository.saveAndFlush(u);

            if (role.getRole().equalsIgnoreCase("ROLE_SPECIALIST")) {
                Specialist s = specialistRepository.save(Specialist.builder()
                        .user(u)
                        .build());
                saveNewSpecialistAuthority(s);

            }
            service.loadUserByUsernameEmail(user.get().getEmail());
        }

    }

    public UserDto getUserByAuthentication(Authentication auth) {
        var principal = auth.getPrincipal();
        if (principal instanceof CustomOAuth2User c) {
            return makeUserDto(repository.findByEmail((c.getEmail())).orElseThrow(() -> new NoSuchElementException("Auth is null, user email not found")));
        } else {
            org.springframework.security.core.userdetails.User user = (org.springframework.security.core.userdetails.User) principal;
            if (isValidEmail(user.getUsername())) {
                return makeUserDto(repository.findByEmail(user.getUsername()).orElseThrow(() -> new NoSuchElementException("Auth is null, user email not found")));
            } else {
                System.out.println("Rep role:"+repository.findByPhoneNumber(user.getUsername()).orElseThrow(() -> new NoSuchElementException("Auth is null, user phone number not found")).getRole().getRole());
                return makeUserDto(repository.findByPhoneNumber(user.getUsername()).orElseThrow(() -> new NoSuchElementException("Auth is null, user phone number not found")));
            }
        }
    }

    public UserDto getUserByPhone(String phone) {
        return makeUserDto(repository.findByPhoneNumber(phone).orElseThrow(() -> new NoSuchElementException("Auth is null, user not found")));
    }

    private UserDto makeUserDto(User user) {
        return UserDto.builder()
                .id(user.getId())
                .userName(user.getUserName())
                .role(user.getRole().getRole())
                .phoneNumber(user.getPhoneNumber())
                .email(user.getEmail())
                .photo(user.getPhoto())
                .country(user.getGeolocation().getCountry())
                .city(user.getGeolocation().getCity())
                .build();
    }

    public String getUsernameFromSecurityContextHolder() {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth == null || !auth.isAuthenticated()) {
                return null;
            }
            var principal = auth.getPrincipal();
            if (principal instanceof CustomOAuth2User c) {
                return c.getEmail();
            } else {
                org.springframework.security.core.userdetails.User user = (org.springframework.security.core.userdetails.User) principal;

                return user.getUsername();
            }
        } catch (Exception e) {

            return null;
        }
    }

    public ViewerDto defineViewer() {
        String username = getUsernameFromSecurityContextHolder();

        if (username == null) return null;

        User user = findUserByUsername(username);
        if (user == null) {
            return null;
        } else {
            if (user.getUserType().equalsIgnoreCase(SPECIALIST)) {
                var specialist = specialistRepository.findByUser(user);
                if (specialist.isPresent()) {
                    String authority = null;
                    if (specialistService.isFullAuthority(specialist.get())) {
                        authority = "full";
                    }
                    return ViewerDto.builder()
                            .userId(user.getId())
                            .specialistId(specialist.get().getId())
                            .userType(user.getUserType())
                            .specialistAuthority(authority)
                            .build();
                }

            } else if (user.getUserType().equalsIgnoreCase("customer")) {
                return ViewerDto.builder()
                        .userId(user.getId())
                        .specialistId(null)
                        .userType(user.getUserType())
                        .build();
            } else {
                return null;
            }
        }
        return null;
    }

    private User findUserByUsername(String username) {
        if (isValidEmail(username)) {
            return repository.findByEmail(username).orElse(null);
        } else {
            return repository.findByPhoneNumber(username).orElse(null);
        }
    }

    public boolean isValidEmail(String email) {
        String regex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(email);
        return matcher.matches();
    }

    public UserDto getSpecialistUserById(Long specialistId) {
        Specialist specialist = specialistRepository.findById(specialistId).orElseThrow(() -> new NoSuchElementException("Specialist not found"));
        var user = repository.findById(specialist.getUser().getId());
        return user.map(this::makeUserDto).orElse(null);
    }

    public List<FindUserNameDto> getUserNameList() {
        List<User> users = repository.findAll();
        List<FindUserNameDto> list = new ArrayList<>();
        for (User u : users) {
            StringBuilder s = new StringBuilder().append(u.getUserName());
            if (u.getUserType().equalsIgnoreCase(SPECIALIST)) {
                var specialist = specialistRepository.findByUser(u);
                if (specialist.isPresent() && specialist.get().getCompanyName() != null) {
                    s.append("/").append(specialist.get().getCompanyName());
                }
            }
            list.add(FindUserNameDto.builder()
                    .id(u.getId())
                    .userName(s.toString())
                    .build());
        }
        return list;
    }

    public void editProfile(UserDto userDto) {
        User user = getUserFromSecurityContextHolder();
        if (user != null) {
            if (userDto.getFileInput() != null) {
                if (!user.getPhoto().equalsIgnoreCase(DEFAULTPHOTO)) {
                    storageService.deleteFile(user.getPhoto());
                }
                user.setPhoto(storageService.uploadPhoto(userDto.getFileInput()));
            }

            if (userDto.getUserName() != null) {
                user.setUserName(userDto.getUserName());
            }
            if (userDto.getCountry() != null && userDto.getCity() != null) {
                var geolocation = geolocationRepository.findByCountryAndCity(userDto.getCountry(), userDto.getCity());
                if (geolocation.isPresent()) user.setGeolocation(geolocation.get());
            }
            repository.save(user);
        }


/*
 я закомментировала эту часть кода, т.к. up'ать профиль - в нашей интерпретации - это про резюме
 */
//        if (!updateCountsRepository.existsByUserId(user.getId())) {
//            updateCountsRepository.save(UpdateCounts.builder()
//                    .userId(user.getId())
//                    .updateTime(new Timestamp(System.currentTimeMillis()))
//                    .count(1)
//                    .build());
//            repository.updateUserInformationWithGeolocation(user.getId(), user.getUserName(), user.getPhoneNumber(),
//                    user.getEmail(), geolocation);
//
//        } else {
//            int currentCount = updateCountsRepository.findByUserId(user.getId()).
//                    orElseThrow(() -> new NoSuchElementException("No such count!")).getCount();
//            if (currentCount < 5) {
//                currentCount++;
//                updateCountsRepository.setCountForUser(user.getId(), currentCount);
//                repository.updateUserInformationWithGeolocation(user.getId(), user.getUserName(), user.getPhoneNumber(),
//                        user.getEmail(), geolocation);
//            }
//        }
    }


    public void saveTheme(String theme) {
        User user = getUserFromSecurityContextHolder();
        if (user != null) {
            Theme userTheme = extractThemeValue(theme);
            if (userTheme != null) {
                if (user.getTheme() == null || !user.getTheme().equals(userTheme)) {
                    user.setTheme(userTheme);
                    repository.save(user);
                }
            }
        }
    }

    private Theme extractThemeValue(String theme) {
        int startIndex = theme.indexOf(":") + 1;
        int endIndex = theme.indexOf("}");
        if (startIndex >= 0 && endIndex >= 0) {
            String value = theme.substring(startIndex, endIndex).trim();
            // 0 light
            //1 dark
            if (value.equalsIgnoreCase("0")) {
                return themeRepository.findByThemeName("light");
            } else {
                return themeRepository.findByThemeName("dark");
            }
        }
        return null;
    }

    public String getTheme() {
        User user = getUserFromSecurityContextHolder();
        if (user == null || user.getTheme() == null) {
            return "0";
        } else {
            if (user.getTheme().getThemeName().equalsIgnoreCase("dark")) {
                return "1";
            } else {
                return "0";
            }
        }
    }

    public List<CountryCode> getCountryCodes() throws IOException {
        List<CountryCode> list = new ArrayList<>();
        list.add(new CountryCode(996, "\uD83C\uDDF0\uD83C\uDDEC", 9));
        return list;
    }

    private boolean isValidPhoneNumber(Integer phoneNumberCode, String phoneNumber) throws IOException {
        List<CountryCode> countryCodes = getCountryCodes();

        if (phoneNumberCode != null) {
            Optional<CountryCode> countryCodeOptional = countryCodes.stream()
                    .filter(countryCode -> Objects.equals(countryCode.getCode(), phoneNumberCode))
                    .findFirst();

            if (countryCodeOptional.isPresent()) {
                CountryCode countryCode = countryCodeOptional.get();
                int expectedDigitCount = countryCode.getCountOfNumber();

                String regex = "^\\d{" + expectedDigitCount + "}$";
                Pattern pattern = Pattern.compile(regex);
                Matcher matcher = pattern.matcher(phoneNumber);
                return matcher.matches();
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    public Optional<User> getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        org.springframework.security.core.userdetails.User user = (org.springframework.security.core.userdetails.User) auth.getPrincipal();
        return repository.findByPhoneNumber(user.getUsername());
    }

    public void makeResetPasswdLink(HttpServletRequest request) throws UsernameNotFoundException, UnsupportedEncodingException, MessagingException {
        String email = request.getParameter("email");
        String token = UUID.randomUUID().toString();
        updateResetPasswordToken(token, email);

        String resetPasswordLink = Utility.getSiteUrl(request) + "/auth/reset_password?token=" + token;
        emailService.sendEmail(email, resetPasswordLink);
    }

    private void updateResetPasswordToken(String token, String email) {
        User user = repository.findUserByEmail(email).orElseThrow(() -> new UsernameNotFoundException("Could not find any user with the email " + email));
        user.setResetPasswordToken(token);
        repository.saveAndFlush(user);
    }

    public UserDto getByResetPasswordToken(String token) {
        User u = repository.findUserByResetPasswordToken(token).orElseThrow(() -> new UsernameNotFoundException("User not found"));
        return UserDto.builder()
                .email(u.getEmail())
                .password(u.getPassword())
                .userName(u.getUsername())
                .resetPasswordToken(u.getResetPasswordToken())
                .build();
    }

    public void updatePassword(UserDto userDto, String newPasswd) {
        User u = repository.findUserByEmail(userDto.getEmail()).orElseThrow(() -> new UsernameNotFoundException("User not found"));
        u.setResetPasswordToken(null);
        u.setPassword(encoder.encode(newPasswd));
        repository.saveAndFlush(u);
    }

    public UserDto makeUserDtoWithEnabled(User user) {
        return UserDto.builder()
                        .id(user.getId())
                        .userName(user.getUserName())
                        .role(user.getRole().getRole())
                        .phoneNumber(user.getPhoneNumber())
                        .email(user.getEmail())
                        .photo(user.getPhoto())
                        .country(user.getGeolocation().getCountry())
                        .city(user.getGeolocation().getCity())
                        .enabled(user.isEnabled())
                .build();
    }

    public Map<UserDto, List<Long>> getAllUsersAndResumesIdsForAdmin() {
        List<User> users = repository.findAll().stream()
                .filter(u -> !u.getUserType().equalsIgnoreCase("admin"))
                .toList();
        Map<UserDto, List<Long>> usersAndTheirResumesIds = new HashMap<>();

        for (User u : users) {
            usersAndTheirResumesIds.put(makeUserDtoWithEnabled(u), resumeRepository.findByUserIdForAdmin(u.getId()).stream()
                    .map(Resume::getId)
                    .toList());
        }
        return usersAndTheirResumesIds;
    }

    public Map<UserDto, List<Long>> getAllUsersAndPostsIdsForAdmin() {
        List<User> users = repository.findAll().stream()
                .filter(u -> !u.getUserType().equalsIgnoreCase("admin"))
                .toList();
        Map<UserDto, List<Long>> usersAndPostIds = new HashMap<>();
        for (User u : users) {
            usersAndPostIds.put(makeUserDtoWithEnabled(u), postRepository.getPostsByUser_Id(u.getId()).stream()
                    .map(Post::getId)
                    .toList());
        }
        return usersAndPostIds;
    }

    public ResponseEntity<?> blockOrUnBlockUserByUserId(Long userId) {
        Optional<User> user = repository.findById(userId);
        if (user.isEmpty()) {
            return new ResponseEntity<>("Not found", HttpStatus.NOT_FOUND);
        }
        User changedUser = user.get();
        changedUser.setEnabled(!user.get().isEnabled());
        repository.saveAndFlush(changedUser);
        if (changedUser.isEnabled()) {
            log.info("User un blocker" + changedUser.getPhoneNumber());
            return new ResponseEntity<>("Un blocked", HttpStatus.OK);
        } else {
            log.info("User blocker" + changedUser.getPhoneNumber());
            return new ResponseEntity<>("Blocked", HttpStatus.OK);
        }
    }


    public String getPhoneNumberBySpecialistId(Long specialistId){
        User user = repository.findBySpecialistId(specialistId).orElseThrow(() -> new NoSuchElementException("User not found"));
        return user.getPhoneNumber();
    }

    public UserDto getUserById(long id){
        return makeUserDto(repository.findById(id).orElseThrow());
    }

}