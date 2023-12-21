package com.example.demo.service;

import com.example.demo.dto.MessageBundleDto;
import com.example.demo.entities.Message;
import com.example.demo.entities.User;
import io.cucumber.java.Before;
import org.junit.jupiter.api.Test;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;

import java.time.LocalDateTime;
import java.time.Month;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static org.assertj.core.api.AssertionsForInterfaceTypes.assertThat;
import static org.hibernate.validator.internal.util.Contracts.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringBootTest
class MessageServiceTest {
    @Autowired
    private MessageService messageService;

    @MockBean
    private Message message;
    @MockBean
    private MessageBundleDto messageBundleDto;

    @Before
    public void init() {
        MockitoAnnotations.initMocks(this);
    }


    @Test
    void testIAmReceiver() {
        User user = mockUser();
        List<Message> allMessages = allMessages();

        List<Message> receivedMessages = messageService.iAmReceiver(allMessages, user);

        assertEquals(1, receivedMessages.size());
        assertEquals("xyz1", receivedMessages.get(0).getMessageText());
    }

    @Test
    void testIAmSender() {
        User user = mockUser();
        List<Message> allMessages = allMessages();

        List<Message> sentMessages = messageService.iAmSender(allMessages, user);

        assertEquals(2, sentMessages.size());
        assertEquals("abc1", sentMessages.get(0).getMessageText());
        assertEquals("abc2", sentMessages.get(1).getMessageText());
    }

    @Test
    void formatMatchTest_LocalDateTime_conversionToString() {
        LocalDateTime time = LocalDateTime.of(2023, Month.NOVEMBER, 21, 21, 0);
        String expectedResult = "11/21 21:00";
        String actualResult = messageService.formatDateTime(time);
        assertEquals(actualResult, expectedResult);
    }

    @Test
    void shouldReturnSetOfUniqueUserIdsExceptGivenUserId() {
        Set<Long> expectedResult = new HashSet<>();
        expectedResult.add(2L);
        Set<Long> actualResult = messageService.uniqueIds(allMessages(), mockUser());
        assertThat(expectedResult).containsExactlyInAnyOrderElementsOf(actualResult);

    }

    @Test
    void testFilterBundleMethod() {
        Set<Long> exampleUserIds = new HashSet<>();
        exampleUserIds.add(2L);

        List<Message> exampleMessages = allMessages();
        List<MessageBundleDto> actualList = messageService.filterBundle(exampleMessages, exampleUserIds);
        assertEquals(1, actualList.size());
        assertEquals("abc1", actualList.get(0).getLastMessageText());
        assertEquals("2.jpg", actualList.get(0).getSenderPhoto());
    }
    @Test
    void should_create_new_message() {

        Message message1 = new Message();
        message1.setMessageText("abc1");
        message1.setSender(mockUser());
        message1.setReceiver(mockAnotherUser());
        message1.setDateTime(LocalDateTime.of(2023, Month.NOVEMBER, 21, 19, 0));

        Message m = messageService.saveANewMessage(message1);

        assertNotNull(m);
    }
//    @Test
//    void should_delete_a_message() {
//        Message m = messageService.findAMessage((long)10);
//        assertNotNull(m);
//
//        messageService.deleteAMessage(m);
//
//        m = messageService.findAMessage(10L);
//        assertNull(m);
//    }

    private User mockUser() {
        User user = new User();
        user.setId(1L);
        user.setPhoneNumber("123");
        user.setPassword("qwe");
        user.setEnabled(true);
        user.setPhoto("1.jpg");
        user.setUserName("user1");
        user.setUserType("SPECIALIST");
        return user;
    }

    private User mockAnotherUser() {
        User user = new User();
        user.setId(2L);
        user.setPhoneNumber("1234");
        user.setPassword("qwe");
        user.setEnabled(true);
        user.setPhoto("2.jpg");
        user.setUserName("user2");
        user.setUserType("CUSTOMER");
        return user;
    }

    private List<Message> allMessages() {
        Message message1 = new Message();
        message1.setMessageText("abc1");
        message1.setSender(mockUser());
        message1.setReceiver(mockAnotherUser());
        message1.setDateTime(LocalDateTime.of(2023, Month.NOVEMBER, 21, 19, 0));

        Message message2 = new Message();
        message2.setMessageText("xyz1");
        message2.setSender(mockAnotherUser());
        message2.setReceiver(mockUser());
        message2.setDateTime(LocalDateTime.of(2023, Month.NOVEMBER, 21, 20, 0));

        Message message3 = new Message();
        message3.setMessageText("abc2");
        message3.setSender(mockUser());
        message3.setReceiver(mockAnotherUser());
        message3.setDateTime(LocalDateTime.of(2023, Month.NOVEMBER, 21, 21, 0));

        List<Message> messages = new ArrayList<>();
        messages.add(message1);
        messages.add(message2);
        messages.add(message3);

        return messages;
    }


}
