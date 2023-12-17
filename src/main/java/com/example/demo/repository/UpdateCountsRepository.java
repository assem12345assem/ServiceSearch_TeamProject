package com.example.demo.repository;

import com.example.demo.entities.UpdateCounts;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.*;

public interface UpdateCountsRepository extends JpaRepository<UpdateCounts,Integer> {
    @Transactional
    @Modifying
    @Query("UPDATE UpdateCounts uc SET uc.count = :newCount WHERE uc.userId = :userId")
    void setCountForUser(Long userId, int newCount);

    boolean existsByUserId(long useId);


    Optional<UpdateCounts> findByUserId(long userId);

    List<UpdateCounts> findAllByUserId(Long id);
}
