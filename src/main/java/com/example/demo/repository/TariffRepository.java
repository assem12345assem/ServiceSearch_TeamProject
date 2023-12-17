package com.example.demo.repository;

import com.example.demo.entities.Tariff;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface TariffRepository extends JpaRepository<Tariff, Long> {
    Optional<Tariff> findByTariffName(String tariffName);
}
