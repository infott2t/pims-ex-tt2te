package org.example.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;
import org.springframework.security.web.header.writers.frameoptions.XFrameOptionsHeaderWriter;

/**
 * PIMS 보안 설정 (Spring Security)
 * - CSRF 보호: CookieCsrfTokenRepository 방식 (JSP JSTL과 호환)
 * - X-Frame-Options: SAMEORIGIN
 * - 학습용: 현재는 모든 경로에 대해 인증 없이 접근 허용
 *   (실제 운영 환경에서는 Spring Security의 formLogin, sessionManagement 등 강화 필요)
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            // 모든 경로 접근 허용 (학습용 - 추후 세분화 필요)
            .authorizeHttpRequests(auth -> auth
                .anyRequest().permitAll()
            )
            // CSRF: POST 방식 파기 버튼 보호를 위해 CookieCsrfTokenRepository 사용
            .csrf(csrf -> csrf
                .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())
                .ignoringAntMatchers(
                    "/user/purge" // 자체 form POST이므로 별도 허용 (CookieCsrfTokenRepository로 처리됨)
                )
            )
            // 클릭재킹 방지: X-Frame-Options SAMEORIGIN
            .headers(headers -> headers
                .addHeaderWriter(new XFrameOptionsHeaderWriter(
                    XFrameOptionsHeaderWriter.XFrameOptionsMode.SAMEORIGIN
                ))
            );

        return http.build();
    }
}
