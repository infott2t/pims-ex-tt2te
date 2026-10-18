package org.example.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.domain.OAuthProvider;
import org.example.domain.PrivacyAccessLog;
import org.example.domain.PrivacyConsentLog;
import org.example.domain.User;
import org.example.dto.NaverUserDto;
import org.example.repository.PrivacyAccessLogRepository;
import org.example.repository.PrivacyConsentLogRepository;
import org.example.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.format.DateTimeFormatter;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PrivacyConsentLogRepository consentLogRepository;
    private final PrivacyAccessLogRepository accessLogRepository;

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    /**
     * 네이버 로그인 사용자 정보 DB 영속화 (저장, 갱신 및 개인정보 감사 로그 기록)
     */
    @Transactional
    public NaverUserDto processNaverLogin(NaverUserDto dto, String ipAddress) {
        OAuthProvider provider = "NAVER_TEST".equals(dto.getLoginType()) ? OAuthProvider.LOCAL : OAuthProvider.NAVER;
        
        Optional<User> existingUserOpt = userRepository.findByProviderAndProviderIdAndIsDeletedFalse(provider, dto.getId());
        User user;

        if (existingUserOpt.isPresent()) {
            user = existingUserOpt.get();
            // 프로필 정보 업데이트
            user.setName(dto.getName());
            user.setNickname(dto.getNickname());
            user.setEmail(dto.getEmail());
            user.setPhone(dto.getMobile());
            user.setProfileImageUrl(dto.getProfileImage());
            log.info("Existing user logged in via Naver. DB ID: {}, Email: {}", user.getId(), user.getEmail());
        } else {
            // 신규 사용자 등록
            user = User.createFromNaver(
                    dto.getId(),
                    dto.getName(),
                    dto.getNickname(),
                    dto.getEmail(),
                    dto.getMobile(),
                    dto.getGender(),
                    dto.getBirthyear(),
                    dto.getBirthday(),
                    dto.getProfileImage()
            );
            user.setProvider(provider);
            user = userRepository.save(user);
            log.info("New user registered via Naver. DB ID: {}, Email: {}", user.getId(), user.getEmail());

            // 1. 개인정보 수집·이용 동의 감사 이력 저장 (법적 필수)
            PrivacyConsentLog consentLog = PrivacyConsentLog.builder()
                    .user(user)
                    .consentType("REQUIRED")
                    .agreed(true)
                    .ipAddress(ipAddress)
                    .build();
            consentLogRepository.save(consentLog);
        }

        // 2. 개인정보 열람 및 접속 감사 로그 기록
        PrivacyAccessLog accessLog = PrivacyAccessLog.builder()
                .accessorId(user.getId())
                .targetUserId(user.getId())
                .actionType("READ")
                .reason("네이버 간편로그인 본인 프로필 조회")
                .ipAddress(ipAddress)
                .build();
        accessLogRepository.save(accessLog);

        // DTO에 DB 정보 매핑
        dto.setDbId(user.getId());
        if (user.getConsentDate() != null) {
            dto.setConsentDate(user.getConsentDate().format(DATE_FORMATTER));
        }
        if (user.getRetentionExpireAt() != null) {
            dto.setRetentionExpireAt(user.getRetentionExpireAt().format(DATE_FORMATTER));
        }

        return dto;
    }

    /**
     * 개인정보 파기 (회원 탈퇴 및 개인정보보호법 상 영구 삭제)
     */
    @Transactional
    public boolean purgeUser(Long dbId, String ipAddress) {
        Optional<User> userOpt = userRepository.findById(dbId);
        if (userOpt.isEmpty()) {
            return false;
        }

        User user = userOpt.get();
        user.purge();
        userRepository.save(user);

        // 파기 감사 로그 기록
        PrivacyAccessLog accessLog = PrivacyAccessLog.builder()
                .accessorId(dbId)
                .targetUserId(dbId)
                .actionType("PURGE")
                .reason("사용자 본인 요청에 의한 개인정보 영구 파기(탈퇴)")
                .ipAddress(ipAddress)
                .build();
        accessLogRepository.save(accessLog);

        log.info("User personal data purged completely. DB ID: {}", dbId);
        return true;
    }

    /**
     * 전체 사용자 목록 조회 (학습/관리자 대시보드용)
     */
    @Transactional(readOnly = true)
    public java.util.List<User> findAllUsers() {
        return userRepository.findAll();
    }
}
