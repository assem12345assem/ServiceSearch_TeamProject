package com.example.demo.service;

import com.example.demo.dto.ResumeDto;
import com.example.demo.dto.ResumeViewDto;
import com.example.demo.entities.Category;
import com.example.demo.entities.Resume;
import com.example.demo.entities.Specialist;
import com.example.demo.entities.User;
import com.example.demo.errors.exceptions.OnlyOneResumeInSameCategoryException;
import com.example.demo.repository.CategoryRepository;
import com.example.demo.repository.ResumeRepository;
import com.example.demo.repository.SpecialistRepository;
import com.example.demo.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Objects;

@Service
@Slf4j
@RequiredArgsConstructor
public class ResumeService {
    private final ResumeRepository resumeRepository;
    private final SpecialistRepository specialistRepository;
    private final CategoryRepository categoryRepository;
    private final UserService userService;

    public Page<ResumeDto> getAllResumes(int start, int end) {
        Sort sort = Sort.by(Sort.Order.desc("timeOfResume"));
        Pageable pageable = PageRequest.of(start, end, sort);
        Page<Resume> resumes = resumeRepository.findAll(pageable);
        return resumes.map(resume ->
                ResumeDto.builder()
                        .id(resume.getId())
                        .specialistId(resume.getSpecialist().getId())
                        .timeOfResume(resume.getTimeOfResume())
                        .resumeDescription(resume.getResumeDescription())
                        .build()
        );
    }

    public void saveResume(ResumeDto resumeDto) throws OnlyOneResumeInSameCategoryException {
        User user = userService.getCurrentUser().orElseThrow(() -> new NoSuchElementException("User not found"));
        Specialist specialist = specialistRepository.findByUser_Id(user.getId()).orElseThrow(() -> new NoSuchElementException("Specialist not found"));
        resumeDto.setSpecialistId(specialist.getId());

        if (checkNotAppearResumeInCategory(resumeDto)) {
            resumeRepository.save(Resume.builder()
                    .specialist(specialist)
                    .timeOfResume(Timestamp.valueOf(LocalDateTime.now()))
                    .resumeDescription(resumeDto.getResumeDescription())
                    .category(categoryRepository.findById(resumeDto.getCategoryId())
                            .orElseThrow(() -> new NoSuchElementException("Category not found")
                            )
                    )
                    .build());
        } else {
            throw new OnlyOneResumeInSameCategoryException("You have resume in selected category");
        }
    }

    private boolean checkNotAppearResumeInCategory(ResumeDto resumeDto) {
        List<Resume> resumesBySpecialistId = resumeRepository.findAllBySpecialist_Id(resumeDto.getSpecialistId());
        return checkDuplicateCategoryResumes(resumeDto.getCategoryId(), resumesBySpecialistId);
    }
    public boolean checkDuplicateCategoryResumes(Long categoryId, List<Resume> resumes) {
        for(Resume r: resumes) {
            if(r.getCategory().getId().equals(categoryId)) {
                return false;
            }
        }
        return true;
    }

    public void deleteResume(long specialistId, long resumeId) {
        if (resumeRepository.findResumeBySpecialistIdAndId(specialistId, resumeId)) {
            resumeRepository.deleteById(resumeId);
        } else {
            log.warn("Value does not exist or you do not have access to this value");
            throw new IllegalArgumentException("Value does not exist or you do not have access to this value");
        }
    }

    public List<ResumeDto> getResumesByCategory(Long categoryId) {
        List<Resume> resumes = resumeRepository.findByCategoryId(categoryId);
        return resumes.stream().map(this::makeDto).toList();
    }

    private ResumeDto makeDto(Resume resume) {
        String resumeName = (resume.getName() != null) ? resume.getName() : "";

        return ResumeDto.builder()
                .id(resume.getId())
                .header(resumeName)
                .specialistId(resume.getSpecialist().getId())
                .timeOfResume(resume.getTimeOfResume())
                .resumeDescription(resume.getResumeDescription())
                .build();
    }

    public List<ResumeDto> getResumesByUserId(Long userId) {
        Specialist specialist = specialistRepository.findByUser_Id(userId).orElseThrow(
                () -> new NoSuchElementException("Specialist not found")
        );
        List<Resume> resumes = resumeRepository.findAllBySpecialist_Id(specialist.getId());

        return resumes.stream().map(this::makeDto).toList();
    }

    public List<ResumeDto> getResumesBySpecialistId(Long specialistId) {
        List<Resume> resumes = resumeRepository.findAllBySpecialist_Id(specialistId);

        return resumes.stream().map(this::makeDto).toList();
    }

    public List<ResumeDto> getResumesSpecialistId(Long specialistId) {
        Specialist specialist = specialistRepository.findByUser_Id(specialistId).orElseThrow(
                () -> new NoSuchElementException("Specialist not found")
        );
        List<Resume> resumes = resumeRepository.findAllBySpecialist_Id(specialist.getId());

        return resumes.stream().map(this::makeDto).toList();
    }

    public ResumeViewDto getResumeById(Long resumeId) {
        Resume resume = resumeRepository.findById(resumeId).orElseThrow(() -> new NoSuchElementException("resume not found"));
        Category category = resume.getCategory();

        String phoneNumber = userService.getPhoneNumberBySpecialistId(resume.getSpecialist().getId());
        String resumeName = (resume.getName() != null) ? resume.getName() : "";

        return ResumeViewDto.builder()
                .id(resume.getId())
                .name(resumeName)
                .specialistId(resume.getSpecialist().getId())
                .timeOfResume(resume.getTimeOfResume())
                .resumeDescription(resume.getResumeDescription())
                .category(category.getCategoryName())
                .phoneNumber(phoneNumber)
                .build();
    }
}
