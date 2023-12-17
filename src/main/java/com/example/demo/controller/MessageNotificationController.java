package com.example.demo.controller;


import com.example.demo.dto.UserDto;
import com.example.demo.service.MessageService;
import com.example.demo.service.UserService;
import lombok.RequiredArgsConstructor;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/msg")
@RequiredArgsConstructor
public class MessageNotificationController {
    private final MessageService messageService;
    private final UserService userService;

    @GetMapping
    public String getAll(Model model) {
        model.addAttribute("messages", messageService.getAll());
        model.addAttribute("notifications", messageService.getAllNotifications());
        return "messages/message";
    }

    @GetMapping("/{id}")
    public String getConversation(@PathVariable String id, Model model) {
        model.addAttribute("messages", messageService.viewMessages(id));
        model.addAttribute("msgId", id);
        return "messages/conversation";
    }

    @GetMapping("/new")
    public String newMessage(Model model) {
        model.addAttribute("usernameList", userService.getUserNameList());
        return "messages/new";
    }

    @GetMapping("/delete/{notificationId}")
    public String deleteFavourites(@PathVariable long notificationId) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        UserDto user = userService.getUserByPhone(auth.getName());
        messageService.deleteNotification(notificationId, user.getId());
        return "redirect:/msg";
    }

}
