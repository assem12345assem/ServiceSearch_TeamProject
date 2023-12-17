package com.example.demo.controller;

import com.example.demo.dto.FavoritesDto;
import com.example.demo.dto.UserDto;
import com.example.demo.service.FavouriteService;
import com.example.demo.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;

import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/favourites")
@RequiredArgsConstructor
public class FavouriteController {
    private final FavouriteService favouriteService;
    private final UserService userService;

    @GetMapping
    public String getFavourites(Authentication auth, Model model) {
        User authUser = (User) auth.getPrincipal();
        UserDto user = userService.getUserByPhone(authUser.getUsername());
        List<FavoritesDto> lists = favouriteService.getFavourites(user.getId());
        model.addAttribute("favourites", lists);
        return "favorites/favorites";

    }

    @GetMapping("/delete/{specialistId}")
    public String deleteFavourites(Authentication auth, Model model, @PathVariable long specialistId) {
        User authUser = (User) auth.getPrincipal();
        UserDto user = userService.getUserByPhone(authUser.getUsername());
        favouriteService.deleteFavourite(user.getId(), specialistId);
        return "redirect:/favourites";
    }
    @GetMapping("/add/{specialistId}")
    @ResponseStatus(HttpStatus.SEE_OTHER)
    public String saveFavoriteSpecialist(@PathVariable Long specialistId, Authentication auth){
        String userPhoneNumber = auth.getName();
        Long userId = userService.getUserByPhone(userPhoneNumber).getId();
        favouriteService.saveFavourite(userId, specialistId);
        return "redirect:/favourites";
    }




}
