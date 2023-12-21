package com.example.demo.service;

import com.example.demo.dto.SpecialistDto;
import com.example.demo.entities.Authority;
import com.example.demo.entities.Specialist;
import com.example.demo.entities.SpecialistsAuthorities;
import com.example.demo.entities.User;
import com.example.demo.repository.AuthorityRepository;
import com.example.demo.repository.SpecialistRepository;
import com.example.demo.repository.SpecialistsAuthoritiesRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.Month;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

@Service
@Slf4j
@RequiredArgsConstructor
public class SpecialistService {
    private final SpecialistRepository repository;
    private final SpecialistsAuthoritiesRepository specialistsAuthoritiesRepository;
    private final AuthorityRepository authorityRepository;
    private final SpecialistRepository specialistRepository;

    public List<SpecialistDto> searchSpecialistByName(String name) {
        List<Specialist> specialists = repository.searchSpecialistByCompanyNameContainingIgnoreCase(name);
        log.info("Specialist:  {}", specialists.toString());
        List<Specialist> fullAuthoritySpecialists = filterFullAuthority(specialists);
        return fullAuthoritySpecialists.stream().map(this::makeDto).toList();
    }

    public List<Specialist> filterFullAuthority(List<Specialist> list) {
        List<Specialist> fullAuthoritySpecialists = new ArrayList<>();

        for (Specialist s : list) {
            if (isFullAuthority(s)) fullAuthoritySpecialists.add(s);
        }

        return fullAuthoritySpecialists;
    }

    public boolean isFullAuthority(Specialist s) {
        Authority limitedAuthority = authorityRepository.findByAuthorityName("LIMITED");
        LocalDateTime dateTime = LocalDateTime.of(3023, Month.DECEMBER, 31, 0, 0);

        Optional<SpecialistsAuthorities> specAuth = specialistsAuthoritiesRepository.findBySpecialistId(s.getId());
        if (specAuth.isEmpty()) {
            specialistsAuthoritiesRepository.save(SpecialistsAuthorities.builder()
                    .specialist(specialistRepository.findById(s.getId())
                            .orElseThrow(() -> new NoSuchElementException("Specialist not found")))
                    .authority(authorityRepository.findByAuthorityName("FULL"))
                    .dateStart(LocalDateTime.now())
                    .dateEnd(LocalDateTime.now().plusDays(30))
                    .build());
        }

        SpecialistsAuthorities sa = specialistsAuthoritiesRepository.findBySpecialistId(s.getId()).orElseThrow(() -> new NoSuchElementException("Authority not found"));
        if (sa.getAuthority().getAuthorityName().equalsIgnoreCase("FULL")) {
            if (sa.getDateEnd().isAfter(LocalDateTime.now())) {
                return true;
            } else {
                sa.setAuthority(limitedAuthority);
                sa.setDateStart(LocalDateTime.now());
                sa.setDateEnd(dateTime);
                specialistsAuthoritiesRepository.save(sa);
                return false;
            }
        } else {
            return false;
        }

    }

    public SpecialistDto getSpecialistByAuthentication(Authentication auth) {
        User user = (User) auth.getPrincipal();
        return makeDto(repository.findByUser_Id(user.getId()).orElseThrow(() -> new NoSuchElementException("Specialist not found")));
    }

    public long getSpecialistIdByUserId(long userId) {
        Specialist specialist = repository.findByUser_Id(userId).orElseThrow(() -> new NoSuchElementException("Specialist not found"));
        return specialist.getId();
    }


    private SpecialistDto makeDto(Specialist specialist) {
        return SpecialistDto.builder()
                .id(specialist.getId())
                .companyName(specialist.getCompanyName())
                .build();
    }

    public String findSpecialistName(Specialist specialist) {
        String name = specialist.getCompanyName();
        if (name == null) {
            name = specialist.getUser().getUserName();
            if (name == null) {
                name = specialist.getId().toString();
            }
        }
        return name;
    }
}
