package com.example.demo.dto;

import jakarta.validation.constraints.Past;
import jakarta.validation.constraints.Size;
import lombok.Builder;
import lombok.Data;

import java.sql.Timestamp;

@Builder
@Data
public class ResumeViewDto {private Long id;
    private Long specialistId;
    private String name;
    private Timestamp timeOfResume;
    private String resumeDescription;
    private String category;
    private String phoneNumber;
}
