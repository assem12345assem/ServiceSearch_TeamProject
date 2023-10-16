package com.example.demo.service;

import com.example.demo.dto.CategoryDto;
import com.example.demo.entities.Category;
import com.example.demo.repository.CategoryRepository;
import org.aspectj.lang.annotation.Before;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.testng.Assert;

import java.util.ArrayList;
import java.util.List;

import static org.mockito.Mockito.when;
class CategoryServiceTest {
    @Mock
    CategoryService categoryService;
    @InjectMocks
    CategoryRepository categoryRepository;

    @Before("")
    public void setUp() {
        MockitoAnnotations.openMocks(this);
        categoryRepository = Mockito.mock(CategoryRepository.class);
        categoryService = new CategoryService(categoryRepository);
    }

    @Test
    void getAllCategoriesShouldReturnListOfCategoriesDto() {
        Category firstCategory = new Category(1, "Сантехник", "Сантехнические работы");
        Category secondCategory = new Category(2, "Плотник", "Работы с деревом");
        List<Category> fakeCategories = new ArrayList<>();
        fakeCategories.add(firstCategory);
        fakeCategories.add(secondCategory);
        when(categoryRepository.findAll()).thenReturn(fakeCategories);
        List<CategoryDto> result = categoryService.getAllCategories();
        Assert.assertNotNull(result);
        Assert.assertEquals(2, result.size());
        List<CategoryDto> wishResult = fakeCategories.stream()
                .map(e -> CategoryDto.builder()
                        .id(e.getId())
                        .categoryName(e.getCategoryName())
                        .description(e.getDescription())
                        .build())
                .toList();
        Assert.assertEquals(wishResult, result);
    }
}
