package com.example.demo.controller;

import com.example.demo.service.*;
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
    private final PortfolioService portfolioService;
private final ContactsService contactsService;
    @GetMapping("/{specialistId}")
    public String viewSpecialistProfile(@PathVariable Long specialistId, Model model) {
        model.addAttribute("resumes", resumeService.getResumesBySpecialistId(specialistId));
        model.addAttribute("user", userService.getSpecialistUserById(specialistId));
        model.addAttribute("rating", ratingService.getSpecialistRatingById(specialistId));
        model.addAttribute("specialistId", specialistId);
        model.addAttribute("portfolios", portfolioService.getPortfolioListBySpecialistId(specialistId));
        model.addAttribute("businessCard", contactsService.getBusinessCardSpecialist(specialistId));
        return "specialist/view_profile";
    }
}
