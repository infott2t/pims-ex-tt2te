package org.example.domain;

import lombok.*;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * 사용자 로그인 이력 엔티티
 * 로그인한 사용자가 언제 로그인했는지 DB에 기록 및 조회
 */
@Entity
@Table(name = "user_login_history", indexes = {
        @Index(name = "idx_login_history_user_time", columnList = "user_id, loginAt")
})
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class UserLoginHistory {

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false, length = 30)
    private String loginType; // NAVER, NAVER_TEST 등

    @Column(length = 45)
    private String ipAddress; // 접속 IP 주소

    @Column(nullable = false)
    private LocalDateTime loginAt; // 로그인 일시

    public String getFormattedLoginAt() {
        return loginAt != null ? loginAt.format(FORMATTER) : "-";
    }
}
