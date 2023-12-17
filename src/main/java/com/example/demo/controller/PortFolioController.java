package com.example.demo.controller;

import com.example.demo.dto.UserDto;
import com.example.demo.service.PortfolioService;
import com.example.demo.service.SpecialistService;
import com.example.demo.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/portfolio")
@RequiredArgsConstructor
public class PortFolioController {
    private final UserService userService;
    private final PortfolioService portfolioService;
    private final SpecialistService specialistService;

    @DeleteMapping("/delete/{portfolioId}")
    public String deletePortfolio(@PathVariable long portfolioId) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        UserDto user = userService.getUserByPhone(auth.getName());
        portfolioService.deletePortfolio(specialistService.getSpecialistIdByUserId(user.getId()), portfolioId);
        return "redirect:/msg";
    }
    @GetMapping("/new")
    public String createNew() {
        return "portfolio/new_portfolio";
    }

    @GetMapping("/{portfolioId}")
    public String getPortfolioById(@PathVariable Long portfolioId) {
        return "";
    }


}
