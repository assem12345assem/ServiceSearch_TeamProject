package com.example.demo.service;

import com.example.demo.dto.UserDto;
import com.example.demo.entities.Role;
import com.example.demo.entities.User;
import com.example.demo.repository.GeolocationRepository;
import com.example.demo.repository.RoleRepository;
import com.example.demo.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.ArrayList;
import java.util.InvalidPropertiesFormatException;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.when;

@SpringBootTest
class UserServiceTest {

    @InjectMocks
    private UserService userService;
    @Mock
    private UserRepository userRepository;
    @Mock
    private RoleRepository roleRepository;
    @Mock
    private PasswordEncoder encoder;
    @Mock
    private AuthUserDetailsService service;
    @Mock
    private GeolocationRepository geolocationRepository;

    @Test
    void testGetAllUsers_ReturnListUsers() {
        List<User> fakeUsers = new ArrayList<>();
        fakeUsers.add(new User());
        fakeUsers.add(new User());
        fakeUsers.add(new User());
        fakeUsers.add(new User());
        fakeUsers.add(new User());
        Mockito.when(userRepository.findAll()).thenReturn(fakeUsers);

        List<User> result = userService.getAllUsers();

        assertEquals(fakeUsers, result);

        Mockito.verify(userRepository, Mockito.times(1)).findAll();
    }

    @Test
    void testRegisterExistingUser() {
        UserDto userDto = new UserDto();
        userDto.setPhoneNumber("123");
        userDto.setCountry("Кыргызстан");
        userDto.setCity("Бишкек");
        when(userRepository.findByPhoneNumber(userDto.getPhoneNumber())).thenReturn(Optional.of(new User()));

        assertThrows(InvalidPropertiesFormatException.class, () -> userService.register(userDto));
    }


    @Test
    void testGetRoles() {
        List<Role> testRoles = List.of(
                new Role(1L, "ROLE_SPECIALIST", new ArrayList<>()),
                new Role(2L, "ROLE_CUSTOMER", new ArrayList<>())
        );
        Mockito.when(roleRepository.findAll()).thenReturn(testRoles);
        List<String> result = userService.getRoles();
        List<String> expectedRoles = List.of("ROLE_SPECIALIST", "ROLE_CUSTOMER");
        assertEquals(expectedRoles, result);
        Mockito.verify(roleRepository, Mockito.times(1)).findAll();
    }
}