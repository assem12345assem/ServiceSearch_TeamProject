package com.example.demo.repository;

import com.example.demo.entities.SubscriptionsOnTariffs;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.*;

public interface SubscriptionsOnTariffsRepository extends JpaRepository<SubscriptionsOnTariffs, Long> {

    List<SubscriptionsOnTariffs> findAllByUserId(Long id);
}
