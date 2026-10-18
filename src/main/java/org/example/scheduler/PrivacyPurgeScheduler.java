package org.example.scheduler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.domain.PrivacyAccessLog;
import org.example.domain.User;
import org.example.repository.PrivacyAccessLogRepository;
import org.example.repository.UserRepository;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 개인정보 보유기간 만료 자동 파기 스케줄러
 * 개인정보보호법 제21조: 개인정보의 파기
 * - 보유기간이 경과한 개인정보는 지체 없이 파기하여야 함
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class PrivacyPurgeScheduler {

    private final UserRepository userRepository;
    private final PrivacyAccessLogRepository accessLogRepository;

    /**
     * 매일 새벽 2시에 만료된 개인정보를 자동 파기
     * cron: 초 분 시 일 월 요일
     */
    @Scheduled(cron = "0 0 2 * * *")
    @Transactional
    public void autoPurgeExpiredPersonalData() {
        LocalDateTime now = LocalDateTime.now();
        List<User> expiredUsers = userRepository.findExpiredUsersForPurge(now);

        if (expiredUsers.isEmpty()) {
            log.info("[PIMS 자동 파기 스케줄러] 파기 대상 없음. 실행 시각: {}", now);
            return;
        }

        log.info("[PIMS 자동 파기 스케줄러] 보유기간 만료 대상 {}명 파기 시작. 실행 시각: {}", expiredUsers.size(), now);

        for (User user : expiredUsers) {
            Long userId = user.getId();
            user.purge();
            userRepository.save(user);

            // 자동 파기 감사 로그 기록
            PrivacyAccessLog accessLog = PrivacyAccessLog.builder()
                    .accessorId(null)  // 시스템 자동 처리
                    .targetUserId(userId)
                    .actionType("PURGE")
                    .reason("개인정보 보유기간 만료로 인한 시스템 자동 파기 (개인정보보호법 제21조)")
                    .ipAddress("SYSTEM")
                    .build();
            accessLogRepository.save(accessLog);

            log.info("[PIMS 자동 파기] userId={} 파기 완료", userId);
        }

        log.info("[PIMS 자동 파기 스케줄러] 총 {}명 개인정보 자동 파기 완료.", expiredUsers.size());
    }
}
