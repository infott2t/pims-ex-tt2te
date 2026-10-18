package org.example.domain;

import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import javax.persistence.*;
import java.time.LocalDateTime;

/**
 * 개인정보 열람 및 접근 감사 로그
 * (개인정보보호법에 따른 접속기록 보관 및 위·변조 방지)
 */
@Entity
@Table(name = "privacy_access_log", indexes = {
        @Index(name = "idx_access_target_user", columnList = "targetUserId"),
        @Index(name = "idx_access_time", columnList = "accessedAt")
})
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class PrivacyAccessLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long accessorId; // 개인정보를 열람한 자의 ID (본인 또는 관리자)

    @Column(nullable = false)
    private Long targetUserId; // 열람 대상 사용자 ID

    @Column(nullable = false, length = 30)
    private String actionType; // READ(조회), UPDATE(수정), DOWNLOAD(다운로드), PURGE(파기)

    @Column(length = 200)
    private String reason; // 열람 사유 (예: 본인 정보 확인, 상담 처리 등)

    @Column(length = 45)
    private String ipAddress; // 접속 IP 주소

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime accessedAt; // 접속 및 열람 일시
}
