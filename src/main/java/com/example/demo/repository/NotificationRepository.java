package com.example.demo.repository;

import com.example.demo.entities.Notification;
import com.example.demo.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface NotificationRepository extends JpaRepository<Notification, Long> {
    List<Notification> findAllByUser(User user);
    List<Notification> findByNotificationTextContaining(String keyword);

    void deleteNotificationByIdAndUserId(long id,long userId);

    List<Notification> findAllByUser_Id(Long id);
}
