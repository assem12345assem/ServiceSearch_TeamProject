package com.example.demo.controller.impl;

import com.example.demo.controller.ProfileController;
import com.example.demo.dto.UserDto;
import com.example.demo.entities.Specialist;
import com.example.demo.entities.User;
import com.example.demo.repository.SpecialistRepository;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.glxn.qrgen.javase.QRCode;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;
import org.springframework.ui.Model;

import java.io.ByteArrayOutputStream;
import java.util.Base64;
import java.util.NoSuchElementException;
import java.util.Objects;

@RequiredArgsConstructor
@Component
@Slf4j
public class ProfileControllerImpl implements ProfileController {
    private final UserRepository userRepository;
    private final UserService userService;
    private final ResumeService resumeService;
    private final RatingService ratingService;
    private final PostService postService;
    private final SpecialistRepository specialistRepository;
    private final PortfolioService portfolioService;
    private final GeolocationService geolocationService;
    private final ContactsService contactsService;

    @Override
    public String profile(Authentication auth, Model model) {
        UserDto currentUser = userService.getUserByAuthentication(auth);


        if (currentUser.getRole().equalsIgnoreCase("ROLE_SPECIALIST")) {
            Long specialistId = specialistRepository.findByUser_Id(currentUser.getId()).orElseThrow(() -> new NoSuchElementException("Specialist not found")).getId();

            model.addAttribute("resumes", resumeService.getResumesByUserId(currentUser.getId()));
            model.addAttribute("portfolios", portfolioService.getPortfolioListBySpecialistId(specialistId));
            model.addAttribute("rating", ratingService.getSpecialistRatingById(specialistId));
        }

        if (currentUser.getRole().equalsIgnoreCase("ROLE_CUSTOMER")) {
            model.addAttribute("stands", postService.getCustomerPostDtos(currentUser.getId()));
        }

        model.addAttribute("user", currentUser);

        return "users/profile";
    }

    @Override
    public String getProfileByUserId(Long userId, Model model, Authentication auth) {
        UserDto currentUser = userService.getUserByAuthentication(auth);
        if (Objects.equals(currentUser.getId(), userId)) {
            return "redirect:/profile";
        }
        UserDto userDto = userService.getUserById(userId);
        User user = userRepository.findById(userId).orElseThrow();
        String userRole = userDto.getRole();
        if (userRole.equalsIgnoreCase("ROLE_SPECIALIST")) {
            model.addAttribute("resumes", resumeService.getResumesByUserId(user.getId()));
            model.addAttribute("rating", ratingService.getSpecialistRatingById(user.getSpecialist().getId()));
            model.addAttribute("specialistId", user.getSpecialist().getId());
            model.addAttribute("portfolios", portfolioService.getPortfolioListBySpecialistId(user.getSpecialist().getId()));
        }
        if (userRole.equalsIgnoreCase("ROLE_CUSTOMER")) {
            model.addAttribute("stands", postService.getCustomerPostDtos(user.getId()));
        }
        model.addAttribute("user", userDto);
        model.addAttribute("businessCard", contactsService.getBusinessCardByUser(user));
        return "users/profileForAnother";
    }

    @Override
    public String getProfileEdit(Model model, Authentication auth) {
        UserDto currentUser = userService.getUserByAuthentication(auth);
        model.addAttribute("countries", geolocationService.getCountries());
        model.addAttribute("user", currentUser);
        return "users/edit";
    }

    @Override
    public String updateProfile(UserDto userDto, Authentication auth) {
        userService.editProfile(userDto);
        return "redirect:/profile";
    }

    @Override
    public String addContacts(Model model) {
        model.addAttribute("contactTypes", contactsService.getContactTypeList());
        model.addAttribute("businessCard", contactsService.getBusinessCard());
        return "users/add_contacts";
    }

    @Override
    public String accountDetails(Model model) {
        User user = userService.getCurrentUser().orElseThrow(() -> new NoSuchElementException("User not found"));
        var specialist = specialistRepository.findByUser_Id(user.getId());

        if (specialist.isPresent()){
            String qrCodeText = "http://localhost:8089/profile" + specialist.get().getId();
            ByteArrayOutputStream qrCodeStream = QRCode.from(qrCodeText).stream();

            byte[] qrCodeBytes = qrCodeStream.toByteArray();
            String qrCodeBase64 = Base64.getEncoder().encodeToString(qrCodeBytes);
            boolean isUserSpecialist = true;

            model.addAttribute("qrCodeBase64", qrCodeBase64);
            model.addAttribute("isUserSpecialist", isUserSpecialist);
            model.addAttribute("specialistId", specialist.get().getId());
        }

        model.addAttribute("businessCard", contactsService.getBusinessCard());
        model.addAttribute("details", userService.getAccountDetailsByUserId(user.getId()));

        return "users/details";
    }

}
