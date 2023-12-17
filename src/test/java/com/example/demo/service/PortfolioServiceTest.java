package com.example.demo.service;

import com.example.demo.dto.PortfolioDto;
import com.example.demo.entities.Portfolio;
import com.example.demo.entities.Specialist;
import com.example.demo.repository.PhotosRepository;
import com.example.demo.repository.PortfolioRepository;
import com.example.demo.repository.SpecialistRepository;
import org.junit.Before;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.*;

@SpringBootTest
public class PortfolioServiceTest {
    @InjectMocks
    private PortfolioService portfolioService;
    @Mock
    private PortfolioRepository portfolioRepository;
    @Mock
    private SpecialistRepository specialistRepository;
    @Mock
    private UserService userService;
    @Mock
    private StorageService storageService;
    @Mock
    private PhotosRepository photosRepository;
    @Before
    public void init() {
        MockitoAnnotations.openMocks(this);
    }
    @Test
    public void should_save_portfolio() {
        PortfolioDto dto = new PortfolioDto();
        dto.setSpecialistId(1L);
        dto.setTitle("Test Portfolio");

        Specialist specialist = new Specialist();

        when(specialistRepository.findById(1L)).thenReturn(Optional.of(specialist));

        portfolioService.savePortfolio(dto);
        verify(portfolioRepository, times(1)).save(any(Portfolio.class));
    }
@Test
public void should_delete_portfolio() {
        long specialistId = 1L;
        long portfolioId = 1L;
        when(portfolioRepository.findPortfolioByIdAndAndSpecialistId(portfolioId, specialistId)).thenReturn(true);
portfolioService.deletePortfolio(specialistId, portfolioId);
verify(portfolioRepository, times(1)).deleteById(portfolioId);
    }
    @Test
    public void should_return_error() {
        long specialistId = 1L;
        long portfolioId = 1L;
        when(portfolioRepository.findPortfolioByIdAndAndSpecialistId(portfolioId, specialistId)).thenReturn(false);
        assertThrows(IllegalArgumentException.class, () -> portfolioService.deletePortfolio(specialistId, portfolioId));
        verify(portfolioRepository, never()).deleteById(anyLong());

    }



}
