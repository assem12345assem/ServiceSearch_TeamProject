package com.example.demo.repository;

import com.example.demo.entities.Contacts;
import com.example.demo.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ContactsRepository extends JpaRepository<Contacts, Long> {
    List<Contacts> findAllByUser(User user);

    List<Contacts> findAllByContactTypeAndContactValue(String contactType, String contactValue);
}
