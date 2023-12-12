package com.example.demo.controller.impl;

import com.example.demo.controller.ProfileController;
import com.example.demo.dto.UserDto;
import com.example.demo.entities.User;
import com.example.demo.repository.SpecialistRepository;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.glxn.qrgen.javase.QRCode;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;
import org.springframework.ui.Model;

import java.io.ByteArrayOutputStream;
import java.util.Base64;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Objects;

@RequiredArgsConstructor
@Component
@Slf4j
public class ProfileControllerImpl implements ProfileController {
    private final UserRepository userRepository;
    private final UserService userService;
    private final ResumeService resumeService;
    private final RatingService ratingService;
    private final PostService postService;
    private final SpecialistRepository specialistRepository;
    private final PortfolioService portfolioService;
    private final GeolocationService geolocationService;
private final ContactsService contactsService;

    @Override
    public String profile(Authentication auth, Model model) {
        UserDto currentUser = userService.getUserByAuthentication(auth);
        System.out.println("ROLE:"+currentUser.getRole());

        if (currentUser.getRole().equalsIgnoreCase("ROLE_SPECIALIST")) {
            Long specialistId = specialistRepository.findByUser_Id(currentUser.getId()).orElseThrow(() -> new NoSuchElementException("Specialist not found")).getId();
            String qrCodeText = "http://localhost:8089/profile" + specialistId;

            ByteArrayOutputStream qrCodeStream = QRCode.from(qrCodeText).stream();
            byte[] qrCodeBytes = qrCodeStream.toByteArray();
            String qrCodeBase64 = Base64.getEncoder().encodeToString(qrCodeBytes);

            model.addAttribute("resumes", resumeService.getResumesByUserId(currentUser.getId()));
            model.addAttribute("portfolios", portfolioService.getPortfolioListBySpecialistId(specialistId));
            model.addAttribute("rating", ratingService.getSpecialistRatingById(currentUser.getId()));
            model.addAttribute("qrCodeBase64", qrCodeBase64);
        }

        if (currentUser.getRole().equalsIgnoreCase("ROLE_CUSTOMER")) {
            model.addAttribute("stands", postService.getCustomerPostDtos(currentUser.getId()));
        }

        model.addAttribute("user", currentUser);
        model.addAttribute("businessCard", contactsService.getBusinessCard());
        System.out.println("ROLE:"+currentUser.getRole());
        return "users/profile";
    }

    @Override
    public String getProfileByUserId(Long userId, Model model, Authentication auth) {
        UserDto currentUser = userService.getUserByAuthentication(auth);
        if (Objects.equals(currentUser.getId(), userId)) {
            return "redirect:/profile";
        }
        User user = userRepository.findById(userId).orElseThrow(() -> new NoSuchElementException("User not found"));
        String userRole = user.getRole().getRole();
        if (userRole.equalsIgnoreCase("ROLE_SPECIALIST")) {
            model.addAttribute("resumes", resumeService.getResumesByUserId(user.getId()));
            model.addAttribute("rating", ratingService.getSpecialistRatingById(user.getSpecialist().getId()));
            model.addAttribute("specialistId", user.getSpecialist().getId());
        }
        if (userRole.equalsIgnoreCase("ROLE_CUSTOMER")) {
            model.addAttribute("stands", postService.getCustomerPostDtos(user.getId()));
        }
        model.addAttribute("user", user);
        return "users/profileForAnother";
    }

    @Override
    public String getProfileEdit(Model model, Authentication auth) {
        UserDto currentUser = userService.getUserByAuthentication(auth);
        /*
         я закомментировала эту часть кода, т.к. up'ать профиль - в нашей интерпретации - это про резюме
         */
//        if (updateCountsRepository.existsByUserId(currentUser.getId())) {
//            UpdateCounts currentCount = updateCountsRepository.findByUserId(currentUser.getId()).
//                    orElseThrow(() -> new NoSuchElementException("No such count!"));
//            if (currentCount.getCount() == 5) {
//                if (updateCountsService.hasThirtyDaysPassed(currentCount.getUpdateTime())) {
//                    updateCountsService.deleteCount(currentCount.getId());
//                } else {
//                    model.addAttribute("restricted", "restricted");
//                }
//            }
//        }
        model.addAttribute("countries", geolocationService.getCountries());
        model.addAttribute("user", currentUser);
        return "users/edit";
    }

    @Override
    public String updateProfile(UserDto userDto, Authentication auth) {
        userService.editProfile(userDto);
        return "redirect:/profile";
    }

    @Override
    public String addContacts(Model model) {
        model.addAttribute("contactTypes", contactsService.getContactTypeList());
        model.addAttribute("businessCard", contactsService.getBusinessCard());
        return "users/add_contacts";
    }

}
