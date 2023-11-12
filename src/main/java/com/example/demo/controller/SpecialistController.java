package com.example.demo.controller;

import com.example.demo.service.RatingService;
import com.example.demo.service.ResumeService;
import com.example.demo.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/specialist")
public class SpecialistController {
    private final UserService userService;
    private final RatingService ratingService;
    private final ResumeService resumeService;

    @GetMapping("/{specialistId}")
    public String viewSpecialistProfile(@PathVariable Long specialistId, Model model) {
        model.addAttribute("resumes", resumeService.getResumesBySpecialistId(specialistId));
        model.addAttribute("user", userService.getSpecialistUserById(specialistId));
        model.addAttribute("rating", ratingService.getSpecialistRatingById(specialistId));

        return "specialist/view_profile";
    }
}
