package com.example.demo.repository;

import com.example.demo.entities.Portfolio;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.support.JpaRepositoryImplementation;

import java.util.List;
import java.util.Optional;

public interface PortfolioRepository extends JpaRepositoryImplementation<Portfolio,Integer> {
    @Query(nativeQuery = true, value = """
            select *
            from portfolios
            where specialist_id in (SELECT specialists.id
                                    from specialists
                                    where user_id in (select users.id
                                                      FROM users
                                                      WHERE enabled = true));
            """)
    Page<Portfolio> findAll(Pageable pageable);

    @Query(nativeQuery = true, value = """
            select exists(
            select * from portfolios
            where id = :portfolioId and specialist_id = :specialistId and specialist_id in (
                                    SELECT specialists.id
                                    from specialists
                                    where user_id in (select users.id
                                                      FROM users
                                                      WHERE enabled = true)));
            """)
    Boolean findPortfolioByIdAndAndSpecialistId(long portfolioId,long specialistId);

    @Query(nativeQuery = true, value = """
            select *
            from portfolios
            where id = :id and specialist_id in (SELECT specialists.id
                                    from specialists
                                    where user_id in (select users.id
                                                      FROM users
                                                      WHERE enabled = true));
            """)
    Optional<Portfolio> findPortfolioById(long id);

    @Query(nativeQuery = true, value = """
            select *
            from portfolios
            where portfolios.specialist_id = :id and specialist_id in (SELECT specialists.id
                                    from specialists
                                    where user_id in (select users.id
                                                      FROM users
                                                      WHERE enabled = true));
            """)
    List<Portfolio> findAllBySpecialist_Id(Long id);

    void deleteById(long id);
}
