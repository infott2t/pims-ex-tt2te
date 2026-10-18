package org.example.repository;

import org.example.domain.OAuthProvider;
import org.example.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    // OAuth 공급자 및 식별자로 사용자 조회
    Optional<User> findByProviderAndProviderIdAndIsDeletedFalse(OAuthProvider provider, String providerId);

    // 로그인 아이디로 조회
    Optional<User> findByUsernameAndIsDeletedFalse(String username);

    // 이메일로 조회
    Optional<User> findByEmailAndIsDeletedFalse(String email);

    // 개인정보 보유기간이 경과하여 파기 대상인 사용자 조회 (스케줄러 자동 파기용)
    @Query("SELECT u FROM User u WHERE u.retentionExpireAt <= :now AND u.isDeleted = false")
    List<User> findExpiredUsersForPurge(@Param("now") LocalDateTime now);
}
