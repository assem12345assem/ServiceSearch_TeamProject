package com.example.demo.service;

import com.example.demo.dto.PortfolioDto;
import com.example.demo.dto.PortfolioListDto;
import com.example.demo.entities.Photo;
import com.example.demo.entities.Portfolio;
import com.example.demo.entities.User;
import com.example.demo.repository.PhotosRepository;
import com.example.demo.repository.PortfolioRepository;
import com.example.demo.repository.SpecialistRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
public class PortfolioService {
    private final PortfolioRepository portfolioRepository;
    private final SpecialistRepository specialistRepository;
    private final UserService userService;
    private final StorageService storageService;
    private final PhotosRepository photosRepository;

    public Page<PortfolioDto> getAllPortfolios(int start, int end) {
        Pageable pageable = PageRequest.of(start, end);
        Page<Portfolio> portfolios = portfolioRepository.findAll(pageable);
        return portfolios.map(portfolio ->
                PortfolioDto.builder()
                        .id(portfolio.getId())
                        .specialistId(portfolio.getSpecialist().getId())
                        .title(portfolio.getTitle())
                        .build()
        );
    }


    public void savePortfolio(PortfolioDto portfolioDto) {
        portfolioRepository.save(Portfolio.builder()
                .specialist(specialistRepository.findById(
                                portfolioDto.getSpecialistId())
                        .orElseThrow(() -> new NoSuchElementException("Specialist not found")
                        )
                )
                .title(portfolioDto.getTitle())
                .build());
    }

    public void deletePortfolio(long specialistId, long portfolioId) {
        if (portfolioRepository.findPortfolioByIdAndAndSpecialistId(portfolioId, specialistId)) {
            portfolioRepository.deleteById((int) portfolioId);
        } else {
            log.warn("Value does not exist or you do not have access to this value");
            throw new IllegalArgumentException("Value does not exist or you do not have access to this value");

        }
    }

    public void updatePortfolio(PortfolioDto portfolioDto) {
        Portfolio existingPortfolio = portfolioRepository.findPortfolioById(portfolioDto.getId()).orElse(null);
        if (existingPortfolio != null) {
            existingPortfolio.setTitle(portfolioDto.getTitle());
        } else {
            log.warn("Value does not exist ");
            throw new IllegalArgumentException("Value does not exist");
        }
    }

    public void createNew(String title, MultipartFile[] photos) {
        User u = userService.getUserFromSecurityContextHolder();
        if (u != null) {
            var specialist = specialistRepository.findByUser(u);
            if (specialist.isPresent()) {
                Portfolio portfolio = portfolioRepository.saveAndFlush(Portfolio.builder()
                        .specialist(specialist.get())
                        .title(title)
                        .timeOfPortfolio(LocalDateTime.now())
                        .build());

                for (MultipartFile photo : photos) {
                    storageService.uploadFile(photo, portfolio);
                }
            }
        }

    }

    public List<PortfolioListDto> getPortfolioListBySpecialistId(Long specialistId) {
        List<PortfolioListDto> list = portfolioRepository.findAllBySpecialist_Id(specialistId).stream()
                .map(e -> PortfolioListDto.builder()
                        .id(e.getId())
                        .timeOfPortfolio(e.getTimeOfPortfolio() != null ? Timestamp.valueOf(e.getTimeOfPortfolio()) : null)
                        .title(e.getTitle())
                        .coverPhotoLink(getCoverPhotoLink(e.getId()))
                        .build())
                .toList();

        return list;
    }


    private String getCoverPhotoLink(Long portfolioId) {
        Optional<Photo> coverPhoto = photosRepository.findAllByPortfolio_Id(portfolioId)
                .stream()
                .sorted(Comparator.comparing(Photo::getTimeOfSavingPhoto))
                .findFirst();

        return coverPhoto.orElse(null).getPhotoLink();
    }
}
