package com.example.demo.entities;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor(access = AccessLevel.PRIVATE)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Table(name = "tariffs")
public class Tariff {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "tariff_name")
    private String tariffName;

    @Column(name = "cost")
    private Double cost;

    @Column(name = "availability")
    private Boolean availability;

    @Column(name = "day_amount")
    private Integer dayAmount;
}
