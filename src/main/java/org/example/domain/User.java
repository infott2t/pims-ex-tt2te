package org.example.domain;

import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import javax.persistence.*;
import java.time.LocalDateTime;

/**
 * PIMS 개인정보 관리 사용자 엔티티
 * 개인정보 라이프사이클(수집, 암호화, 마스킹, 보유기간, 파기) 준수 모델
 */
@Entity
@Table(name = "pims_user", indexes = {
        @Index(name = "idx_pims_user_provider_id", columnList = "provider, providerId"),
        @Index(name = "idx_pims_user_email", columnList = "email"),
        @Index(name = "idx_pims_user_retention", columnList = "retentionExpireAt, isDeleted")
})
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private OAuthProvider provider; // 계정 제공자 (LOCAL, NAVER 등)

    @Column(length = 100)
    private String providerId; // OAuth 공급자의 고유 회원 식별 번호

    @Column(length = 50, unique = true)
    private String username; // 로그인 ID (로컬 로그인 시 사용)

    @Column(length = 255)
    private String passwordHash; // 단방향 해시화된 비밀번호 (BCrypt / SCrypt)

    @Column(length = 50)
    private String name; // 사용자 실명

    @Column(length = 50)
    private String nickname; // 닉네임

    @Column(length = 100)
    private String email; // 이메일 주소

    @Column(length = 30)
    private String phone; // 휴대전화번호

    @Column(length = 255)
    private String encryptedResidentId; // 민감식별정보 (주민등록번호 등 - AES-256 양방향 암호화 보관)

    @Column(length = 1)
    private String gender; // M, F, U

    @Column(length = 10)
    private String birthyear; // 출생연도 (예: 1995)

    @Column(length = 10)
    private String birthday; // 생일 (예: 05-24)

    @Column(length = 500)
    private String profileImageUrl; // 프로필 이미지 URL

    @Column(length = 20, nullable = false)
    @Builder.Default
    private String role = "ROLE_USER";

    @Column(nullable = false)
    @Builder.Default
    private Boolean consentGiven = false; // 개인정보 수집 및 이용 동의 여부

    private LocalDateTime consentDate; // 동의 일시

    private LocalDateTime retentionExpireAt; // 개인정보 보유기간 만료일 (파기 예정일)

    @Column(nullable = false)
    @Builder.Default
    private Boolean isDeleted = false; // 개인정보 파기 및 탈퇴 플래그

    private LocalDateTime purgedAt; // 완전 파기(복구 불가 덮어쓰기) 일시

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

    /**
     * 개인정보 파기 (개인정보보호법 원칙: 복구 불가능하도록 데이터 덮어쓰기)
     */
    public void purge() {
        this.name = "[PURGED]";
        this.email = "[PURGED]";
        this.phone = "[PURGED]";
        this.nickname = "[PURGED]";
        this.encryptedResidentId = null;
        this.passwordHash = "";
        this.profileImageUrl = null;
        this.isDeleted = true;
        this.purgedAt = LocalDateTime.now();
    }

    /**
     * 네이버 OAuth 사용자 정보 기반 신규 생성 또는 업데이트
     */
    public static User createFromNaver(String naverId, String name, String nickname, String email, 
                                       String phone, String gender, String birthyear, String birthday, String profileImage) {
        LocalDateTime now = LocalDateTime.now();
        return User.builder()
                .provider(OAuthProvider.NAVER)
                .providerId(naverId)
                .name(name)
                .nickname(nickname)
                .email(email)
                .phone(phone)
                .gender(gender)
                .birthyear(birthyear)
                .birthday(birthday)
                .profileImageUrl(profileImage)
                .consentGiven(true)
                .consentDate(now)
                .retentionExpireAt(now.plusYears(1)) // 기본 보유기간 1년
                .isDeleted(false)
                .build();
    }
}
