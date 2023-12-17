package com.example.demo.controller;

import com.example.demo.dto.RatingDto;
import com.example.demo.service.RatingService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/rating")
@RequiredArgsConstructor
public class RatingRestController {
    private final RatingService service;

    @PostMapping("/new/{specialistId}")
    public ResponseEntity<String> newRating(@PathVariable Long specialistId, @Valid @RequestBody RatingDto dto) {
        dto.setSpecialistId(specialistId);
        return service.saveRating(dto);
    }

    @DeleteMapping("/delete/{ratingId}")
    public ResponseEntity<String> deleteRatingById(@PathVariable Long ratingId, Authentication auth) {
        return service.deleteRatingById(ratingId, auth);
    }
}
