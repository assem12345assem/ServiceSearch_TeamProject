package com.example.demo.controller;

import com.example.demo.dto.UserDto;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public interface ProfileController {

    @GetMapping("/profile")
    String profile(Authentication auth, Model model);

    @GetMapping("/profile/{userId}")
    String getProfileByUserId(@PathVariable Long userId, Model model, Authentication auth);

    @GetMapping("/profile/edit")
    String getProfileEdit(Model model, Authentication auth);

    @PostMapping("/profile/edit")
    String updateProfile(UserDto userDto, Authentication auth);

    @GetMapping("/profile/add_contacts")
    String addContacts(Model model);

    @GetMapping("/profile/details")
    String accountDetails(Model model);
}
