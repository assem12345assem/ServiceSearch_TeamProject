package com.example.demo.repository;

import com.example.demo.entities.Geolocation;
import com.example.demo.entities.Resume;
import com.example.demo.entities.User;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.*;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByPhoneNumber(String username);

    Optional<User> getByEmail(String username);

    Optional<User> findByEmail(String username);

    List<User> findAllByUserNameContainingIgnoreCase(String viewer);

    @Transactional
    @Modifying
    @Query("UPDATE User u SET u.userName = :newName, u.phoneNumber = :newPhone, u.email = :newEmail, u.geolocation = :newGeolocation WHERE u.id = :userId")
    void updateUserInformationWithGeolocation(Long userId, String newName, String newPhone, String newEmail, Geolocation newGeolocation);

    Optional<User> findUserByEmail(String email);

    Optional<User> findUserByResetPasswordToken(String token);

    Optional<User> findBySpecialistId(Long specialistId);

}
