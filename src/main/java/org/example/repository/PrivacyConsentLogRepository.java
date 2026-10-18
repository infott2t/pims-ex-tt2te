package org.example.repository;

import org.example.domain.PrivacyConsentLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PrivacyConsentLogRepository extends JpaRepository<PrivacyConsentLog, Long> {
    List<PrivacyConsentLog> findByUserIdOrderByAgreedAtDesc(Long userId);
}
