package com.example.demo.controller;


import com.example.demo.dto.ResumeDto;
import com.example.demo.errors.exceptions.OnlyOneResumeInSameCategoryException;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/resume")
public interface ResumeController {

    @GetMapping("/category/{categoryId}")
    String getResumesByCategory(@PathVariable Long categoryId, Model model);

    @GetMapping("/create")
    String createResume(Model model);

    @PostMapping("/create")
    @ResponseStatus(HttpStatus.SEE_OTHER)
    String createResume(ResumeDto dto) throws OnlyOneResumeInSameCategoryException;

    @GetMapping("/{resumeId}")
    String getResumeById(@PathVariable Long resumeId, Model model);
    @GetMapping("/up/{id}")
    String upResume(@PathVariable Long id);
    @GetMapping("/delete/{id}")
    String delete(@PathVariable Long id);
}
