package org.example.domain;

import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import javax.persistence.*;
import java.time.LocalDateTime;

/**
 * 개인정보 수집·이용 동의 이력 감사 로그
 */
@Entity
@Table(name = "privacy_consent_log")
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class PrivacyConsentLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @Column(nullable = false, length = 50)
    private String consentType; // 필수동의(REQUIRED), 선택동의(OPTIONAL), 마케팅(MARKETING)

    @Column(nullable = false)
    private Boolean agreed; // 동의 여부

    @Column(length = 45)
    private String ipAddress; // 동의 시점 IP 주소

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime agreedAt; // 동의 일시
}
