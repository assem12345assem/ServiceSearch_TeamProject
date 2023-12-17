package com.example.demo.controller.impl;

import com.example.demo.controller.MainRestController;
import com.example.demo.dto.SpecialistDto;
import com.example.demo.service.SpecialistService;
import com.example.demo.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.List;

@Component
@RequiredArgsConstructor
public class MainRestControllerImpl implements MainRestController {
    private final SpecialistService service;
private final UserService userService;
    @Override
    public List<SpecialistDto> searchSpecialistByName(String name) {
        return service.searchSpecialistByName(name);
    }

    @Override
    public HttpStatus saveTheme(@RequestBody String theme) {
        // 0 light
        // 1 dark
        userService.saveTheme(theme);
        return HttpStatus.OK;
    }
    @Override
    public String getTheme() {
       return userService.getTheme();
    }

}
