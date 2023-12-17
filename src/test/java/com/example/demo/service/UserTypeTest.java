package com.example.demo.service;

import com.example.demo.enums.UserType;
import io.cucumber.java.Before;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

@SpringBootTest
class UserTypeTest {
    @Autowired
    private UserService userService;

    @Mock
    private UserType userType;

    @Before
    public void init() {
        MockitoAnnotations.initMocks(this);
    }

    @Test
    void insertRoleSpecialistShouldReturnUserTypeSpecialist() {
        String insert = "ROLE_SPECIALIST";
        String userType = userService.defineUserType(insert);
        assertEquals("specialist", userType.toLowerCase());
    }

    @Test
    void insertRoleCustomerShouldReturnUserTypeCustomer() {
        String insert = "ROLE_CUSTOMER";
        String userType = userService.defineUserType(insert);
        assertEquals("customer", userType.toLowerCase());
    }

    @Test
    void insertNullReturnIllegalArgumentException() {
        String insert = null;
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, () -> userService.defineUserType(insert));
    }

    @Test
    void insertUserReturnIllegalArgumentException() {
        String insert = "User";
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, () -> {
            userService.defineUserType(insert);
        });
    }

}