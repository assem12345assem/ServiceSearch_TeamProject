package com.example.demo.repository;

import com.example.demo.entities.Photo;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PhotosRepository extends JpaRepository<Photo, Long> {
}
