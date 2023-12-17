package com.example.demo.service;

import com.example.demo.dto.ResumeDto;
import com.example.demo.dto.ResumeViewDto;
import com.example.demo.entities.Category;
import com.example.demo.entities.Resume;
import com.example.demo.entities.Specialist;
import com.example.demo.entities.User;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.ArrayList;
import java.util.List;

import static org.hibernate.validator.internal.util.Contracts.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

@SpringBootTest
public class ResumeServiceTest {
    @Mock
    private ResumeService resumeService;

    @Before
    public void init() {
        MockitoAnnotations.initMocks(this);
    }

    @Test
    public void specialist_should_have_only_one_resume_in_one_category() {
        List<Resume> list = all();
        boolean checkDuplicates = resumeService.checkDuplicateCategoryResumes(3L, list);
        assertFalse(checkDuplicates);
    }

    @Test
   public void should_get_resumes_in_one_category() {
        List<ResumeDto> list = resumeService.getResumesByCategory(1L);
        assertTrue(list.stream().allMatch(resumeDto -> resumeDto.getCategoryId().equals(1L)));

    }
    @Test
    public void should_get_resumes_by_one_specialist() {
        List<ResumeDto> list = resumeService.getResumesBySpecialistId(1L);
        assertTrue(list.stream().allMatch(resumeDto -> resumeDto.getSpecialistId().equals(1L)));
    }
@Test
public void should_get_one_resume() {
        ResumeViewDto r = resumeService.getResumeById(1L);
    assertNotNull(r);
}
    private Category mockCategory() {
        Category c = new Category();
        c.setId(1L);
        c.setCategoryName("Test1");
        return c;
    }

    private Category mockAnotherCategory() {
        Category c = new Category();
        c.setId(2L);
        c.setCategoryName("Test2");
        return c;
    }

    private User mockUser() {
        User user = new User();
        user.setId(1L);
        user.setPhoneNumber("123");
        user.setPassword("qwe");
        user.setEnabled(true);
        user.setUserType("SPECIALIST");
        return user;
    }

    private Specialist mockSpecialist() {
        Specialist s = new Specialist();
        s.setId(1L);
        s.setUser(mockUser());
        return s;
    }

    private List<Resume> all() {
        List<Resume> list = new ArrayList<>();
        Resume r1 = new Resume();
        r1.setId(1L);
        r1.setCategory(mockCategory());
        r1.setSpecialist(mockSpecialist());
        Resume r2 = new Resume();
        r2.setId(2L);
        r2.setCategory(mockAnotherCategory());
        r2.setSpecialist(mockSpecialist());
        list.add(r1);
        list.add(r2);
        return list;
    }
}
