package com.example.demo.controller;

import com.example.demo.dto.RoleDto;
import com.example.demo.dto.UserDto;
import com.example.demo.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {
    private final UserService userService;
    @GetMapping("/register")
    public String register(Model model) {
        model.addAttribute("userDto", new UserDto());
        List<RoleDto> roles = new ArrayList<>();
        roles.add(RoleDto.builder().role("specialist").build());
        roles.add(RoleDto.builder().role("customer").build());
        model.addAttribute("roles", roles);
        return "auth/register";
    }

    @PostMapping("/register")
    public String register(@Valid UserDto userDto, BindingResult bindingResult) {
        if (!bindingResult.hasErrors()) {
            userService.register(userDto);
            return "redirect:/auth/login";
        }
        return "auth/register";


    }

    @GetMapping("/login")
    public String login() {
        return "/auth/login";
    }
}
