package com.example.demo.dto;

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
