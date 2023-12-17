package com.example.demo.controller;

import com.example.demo.service.PostService;
import com.example.demo.service.ResumeService;
import com.example.demo.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping("/super")
@RequiredArgsConstructor
public class SuperUserController {
    private final UserService userService;
    private final ResumeService resumeService;
    private final PostService postService;

    @GetMapping("/profiles")
    public String getUsersProfileForSuperUser(Model model) {
        model.addAttribute("usersAndResumesId", userService.getAllUsersAndResumesIdsForAdmin());
        model.addAttribute("usersAndPostsId", userService.getAllUsersAndPostsIdsForAdmin());
        return "users/managment";
    }

    @GetMapping("/info/{userId}")
    public String getUserInfoForSuperUser(Model model, @PathVariable long userId) {
        model.addAttribute("user", userService.getUserById(userId));
        if (userService.getUserById(userId).getRole().equals("ROLE_SPECIALIST")) {
            model.addAttribute("resumes", resumeService.getResumesByUserId(userId));
        }
        if (userService.getUserById(userId).getRole().equals("ROLE_CUSTOMER")) {
            model.addAttribute("posts", postService.getPostByUserId(userId));

        }
        return "users/more";
    }
}
