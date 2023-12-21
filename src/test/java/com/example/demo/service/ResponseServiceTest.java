package com.example.demo.service;

import com.example.demo.entities.*;
import io.cucumber.java.Before;
import org.junit.jupiter.api.Test;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.time.LocalDateTime;
import java.time.Month;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringBootTest
public class ResponseServiceTest {
    @Autowired
    private ResponseService responseService;

    @Before
    public void init() {
        MockitoAnnotations.initMocks(this);
    }

    @Test
    void should_get_set_with_size_one() {
        HashSet<Long> set = responseService.getUniquePostIds(all());
        assertEquals(1, set.size());
    }

    private List<Response> all() {
        List<Response> list = new ArrayList<>();
        Response r1 = new Response();
        r1.setId(1L);
        r1.setPost(mockPost());
        r1.setSpecialist(mockSpecialist());
        r1.setResponse("test");
        r1.setConversationId("1-1");
        list.add(r1);
        return list;
    }

//    @Test
//    void should_create_new_response() {
//        Response r = responseService.saveResponse(mockPost(), mockSpecialist(), "200-200", "test");
//        assertNotNull(r);
//    }

//    @Test
//    void should_delete_a_response() {
//        Response r = responseService.findAResponse(1L);
//        assertNotNull(r);
//        responseService.deleteAResponse(1L);
//        r = responseService.findAResponse(1L);
//        assertNull(r);
//    }


    private User mockUser() {
        User user = new User();
        user.setId(2L);
        user.setPhoneNumber("1234");
        user.setPassword("qwe");
        user.setEnabled(true);
        user.setUserType("CUSTOMER");
        return user;
    }

    private Category mockCategory() {
        Category c = new Category();
        c.setCategoryName("Test1");
        return c;
    }

    private Post mockPost() {
        Post p1 = new Post();
        p1.setId(1L);
        p1.setCategory(mockCategory());
        p1.setUser(mockUser());
        p1.setTitle("Test post 1");
        p1.setWorkRequiredTime(LocalDateTime.of(2023, Month.DECEMBER, 1, 12, 0));
        p1.setPublishedDate(LocalDateTime.of(2023, Month.NOVEMBER, 21, 21, 0));
        return p1;
    }

    private User mockAnotherUser() {
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

    private Specialist mockSpecialist() {
        Specialist s = new Specialist();
        s.setId(1L);
        s.setUser(mockAnotherUser());
        return s;
    }
}
