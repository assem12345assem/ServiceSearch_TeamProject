package com.example.demo.controller;

import com.example.demo.dto.PostInputDto;
import com.example.demo.dto.ViewerDto;
import com.example.demo.errors.exceptions.InvalidPostOwnerException;
import com.example.demo.service.CategoryService;
import com.example.demo.service.PostService;
import com.example.demo.service.ResponseService;
import com.example.demo.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/stand")
@RequiredArgsConstructor
public class StandController {
    private static final String POSTS = "posts";
    private static final String VIEWER = "viewer";
    private final PostService postService;
    private final UserService userService;
    private final CategoryService categoryService;
    private final ResponseService responseService;

    @GetMapping()
    public String getStand(Model model) {
        ViewerDto v = userService.defineViewer();
        model.addAttribute(VIEWER, v);

        if (v != null) {
            if (v.getSpecialistId() != null) {
                model.addAttribute("myPosts", postService.getMySubscriptions(v));
                model.addAttribute(POSTS, postService.getOtherPosts(v));
                model.addAttribute("myResponses", responseService.getSpecialistResponses(v.getSpecialistId()));
            } else {
                model.addAttribute("myRequests", postService.getCustomerPosts(v.getUserId()));
                model.addAttribute(POSTS, postService.getAll());
            }
        } else {
            model.addAttribute(POSTS, postService.getAll());
        }
        return "stand/stand";
    }

    @GetMapping("/respond/{postId}")
    public String respondPage(@PathVariable Long postId, Model model) {
        model.addAttribute("post", postService.getPostDto(postId));
        ViewerDto v = userService.defineViewer();
        model.addAttribute(VIEWER, v);
        if (v.getSpecialistId() != null) {
            model.addAttribute("pastMessages", responseService.getSpecialistConversation(postId, v));
        }
        return "stand/respond";
    }

    @GetMapping("/request/{postId}")
    public String requestPage(@PathVariable Long postId, Model model) {
        model.addAttribute("post", postService.getPostDto(postId));
        ViewerDto v = userService.defineViewer();
        model.addAttribute(VIEWER, v);
        if (v.getSpecialistId() == null) {
            model.addAttribute("conversations", postService.getListOfApplicants(postId));
        }
        return "stand/request";
    }

    @GetMapping("/new")
    public String createNewPost(Model model) {
        model.addAttribute("categories", categoryService.getAllCategories());
        return "stand/new";
    }

    @PostMapping("/new")
    public String createNewPost(@ModelAttribute PostInputDto dto) {
        postService.createNewPost(dto);
        return "redirect:/profile";
    }

    @GetMapping("/show/{conversationId}")
    public String getConversation(@PathVariable String conversationId) {
        ViewerDto v = userService.defineViewer();
        String id = postService.extractStringAfterDash(conversationId);
        Long postId = postService.getPostByConversationId(id);
        if (v.getSpecialistId() != null) {
            if (postId != null) {
                return "redirect:/stand/respond/" + postId;
            }
        } else {
            return "redirect:/stand/request_detail/" + id;
        }
        return "redirect:/msg";
    }

    @GetMapping("/request_detail/{conversationId}")
    public String customerRequestDetail(@PathVariable String conversationId, Model model) {
        model.addAttribute("conversationId", conversationId);
        Long postId = postService.getPostByConversationId(conversationId);
        if (postId != null) {
            model.addAttribute("post", postService.getPostDto(postId));
        }
        model.addAttribute("pastMessages", responseService.getCustomerMsgByConversation(conversationId));
        return "stand/request_detail";
    }

    @GetMapping("/select/{conversationId}")
    public String select(@PathVariable String conversationId) {
        postService.selectSpecialist(conversationId);
        return "redirect:/stand";
    }
    @GetMapping("/delete/{postId}")
    public String deletePost(@PathVariable Long postId) throws InvalidPostOwnerException {
        postService.deletePost(postId);
        return "redirect:/profile";
    }

}
