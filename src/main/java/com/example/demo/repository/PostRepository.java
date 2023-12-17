package com.example.demo.repository;

import com.example.demo.entities.Post;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface PostRepository extends JpaRepository<Post, Long> {

@Query(nativeQuery = true, value = """
            SELECT p.*
            FROM posts p
            INNER JOIN users u ON p.user_id = u.id
            WHERE u.enabled = true AND u.id = :userId
        """)
    List<Post> findAllByUserId(Long userId);

    @Query(nativeQuery = true, value = """
            select *
            from posts
            where title like :title
              and work_required_time = :date
              and user_id in (select id
                              from users
                              where enabled = true);
            """)
    Optional<Post> findByTitleAndWorkRequiredTime(String title, LocalDateTime date);

    List<Post> getPostsByUser_Id(Long id);
}
