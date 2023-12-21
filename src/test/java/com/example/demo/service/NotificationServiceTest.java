package com.example.demo.service;

import com.example.demo.entities.Notification;
import com.example.demo.entities.User;
import io.cucumber.java.Before;
import org.junit.jupiter.api.Test;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringBootTest
class NotificationServiceTest {
    @Autowired
    private MessageService messageService;

    @MockBean
    private Notification notification;

    @Before
    public void init() {
        MockitoAnnotations.initMocks(this);
    }

    @Test
    void should_get_list_with_size_two() {
        List<Notification> actualResult = messageService.getAllNotificationsByUser(mockUser());
        assertEquals(2, actualResult.size());

    }

    private User mockUser() {
        User user = new User();
        user.setId(2L);
        user.setPhoneNumber("1234");
        user.setPassword("qwe");
        user.setEnabled(true);
        user.setUserType("CUSTOMER");
        return user;
    }
}
