package org.example.repository;

import org.example.domain.PrivacyAccessLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PrivacyAccessLogRepository extends JpaRepository<PrivacyAccessLog, Long> {
    List<PrivacyAccessLog> findByTargetUserIdOrderByAccessedAtDesc(Long targetUserId);
}
