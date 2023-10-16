package com.example.demo.service;

import com.example.demo.dto.ResumeDto;
import com.example.demo.entities.Resume;
import com.example.demo.entities.User;
import com.example.demo.repository.CategoryRepository;
import com.example.demo.repository.ResumeRepository;
import com.example.demo.repository.SpecialistRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.NoSuchElementException;

@Service
@Slf4j
@RequiredArgsConstructor
public class ResumeService {
    private final ResumeRepository resumeRepository;
    private final SpecialistRepository specialistRepository;
    private final CategoryRepository categoryRepository;

    public Page<ResumeDto> getAllResumes(int start, int end) {
        Sort sort = Sort.by(Sort.Order.desc("timeOfResume"));
        Pageable pageable = PageRequest.of(start, end, sort);
        Page<Resume> resumes = resumeRepository.findAll(pageable);
        Page<ResumeDto> resumeDtoPages = resumes.map(resume -> {
            return ResumeDto.builder()
                    .id(resume.getId())
                    .specialistId(resume.getSpecialist().getId())
                    .timeOfResume(resume.getTimeOfResume())
                    .resumeDescription(resume.getResumeDescription())
                    .build();
        });
        return resumeDtoPages;
    }

    public void saveResume(ResumeDto resumeDto) {
        resumeRepository.save(Resume.builder()
                .specialist(specialistRepository.findById(
                        resumeDto.getSpecialistId())
                        .orElseThrow(() -> new NoSuchElementException("Specialist not found")
                        )
                )
                .timeOfResume(Timestamp.valueOf(LocalDateTime.now()))
                .resumeDescription(resumeDto.getResumeDescription())
                        .category(categoryRepository.findById(
                                resumeDto.getCategoryId())
                                .orElseThrow(() -> new NoSuchElementException("Category not found")
                                )
                        )
                .build());
    }

}
