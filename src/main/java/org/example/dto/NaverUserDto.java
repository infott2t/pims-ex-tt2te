package org.example.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NaverUserDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private String id;           // 네이버 고유 식별자
    private String name;         // 이름
    private String email;        // 이메일
    private String nickname;     // 닉네임
    private String profileImage; // 프로필 이미지 URL
    private String mobile;       // 휴대전화번호
    private String gender;       // 성별 (M/F/U)
    private String birthyear;    // 출생연도
    private String birthday;     // 생일 (MM-DD)
    private String loginType;    // NAVER or NAVER_TEST

    // PIMS 보안 마스킹 편의 메서드
    public String getMaskedEmail() {
        if (email == null || !email.contains("@")) return email;
        String[] parts = email.split("@");
        String namePart = parts[0];
        if (namePart.length() <= 2) {
            return namePart.charAt(0) + "*@" + parts[1];
        }
        return namePart.substring(0, 2) + "*".repeat(namePart.length() - 2) + "@" + parts[1];
    }

    public String getMaskedMobile() {
        if (mobile == null || mobile.length() < 10) return mobile;
        return mobile.replaceAll("(\\d{3})-(\\d{3,4})-(\\d{4})", "$1-****-$3");
    }
}
