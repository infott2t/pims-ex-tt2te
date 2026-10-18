package org.example.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.dto.NaverUserDto;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.math.BigInteger;
import java.security.SecureRandom;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class NaverLoginService {

    @Value("${naver.client-id:YOUR_NAVER_CLIENT_ID}")
    private String clientId;

    @Value("${naver.client-secret:YOUR_NAVER_CLIENT_SECRET}")
    private String clientSecret;

    @Value("${naver.redirect-uri:http://localhost:8080/auth/naver/callback}")
    private String redirectUri;

    private final ObjectMapper objectMapper = new ObjectMapper();
    private final RestTemplate restTemplate = new RestTemplate();

    public static final String SESSION_STATE_KEY = "NAVER_OAUTH_STATE";

    /**
     * 네이버 Client ID가 실제 값으로 설정되어 있는지 확인
     */
    public boolean isConfigured() {
        return clientId != null && !clientId.isBlank() 
                && !"YOUR_NAVER_CLIENT_ID".equals(clientId)
                && clientSecret != null && !clientSecret.isBlank() 
                && !"YOUR_NAVER_CLIENT_SECRET".equals(clientSecret);
    }

    public String getClientId() {
        return clientId;
    }

    public String getRedirectUri() {
        return redirectUri;
    }

    /**
     * 네이버 로그인 인증 요청 URL 생성
     */
    public String buildAuthorizeUrl(HttpSession session) {
        // CSRF 방지를 위한 상태 토큰(state) 생성
        String state = new BigInteger(130, new SecureRandom()).toString(32);
        session.setAttribute(SESSION_STATE_KEY, state);

        String encodedRedirectUri = URLEncoder.encode(redirectUri, StandardCharsets.UTF_8);

        return "https://nid.naver.com/oauth2.0/authorize"
                + "?response_type=code"
                + "&client_id=" + clientId
                + "&redirect_uri=" + encodedRedirectUri
                + "&state=" + state;
    }

    /**
     * 인가 코드(code)로 네이버 Access Token 요청
     */
    public String getAccessToken(String code, String state) {
        String tokenUrl = "https://nid.naver.com/oauth2.0/token";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("grant_type", "authorization_code");
        params.add("client_id", clientId);
        params.add("client_secret", clientSecret);
        params.add("code", code);
        params.add("state", state);

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);

        try {
            ResponseEntity<String> response = restTemplate.postForEntity(tokenUrl, request, String.class);
            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                JsonNode root = objectMapper.readTree(response.getBody());
                if (root.has("access_token")) {
                    return root.get("access_token").asText();
                } else if (root.has("error_description")) {
                    log.error("Naver token error: {}", root.get("error_description").asText());
                }
            }
        } catch (Exception e) {
            log.error("Failed to get Naver access token", e);
        }
        return null;
    }

    /**
     * Access Token으로 네이버 사용자 프로필 정보 조회
     */
    public NaverUserDto getUserProfile(String accessToken) {
        String profileUrl = "https://openapi.naver.com/v1/nid/me";

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + accessToken);

        HttpEntity<Void> request = new HttpEntity<>(headers);

        try {
            ResponseEntity<String> response = restTemplate.exchange(profileUrl, HttpMethod.GET, request, String.class);
            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                JsonNode root = objectMapper.readTree(response.getBody());
                String resultCode = root.path("resultcode").asText();
                if ("00".equals(resultCode)) {
                    JsonNode res = root.path("response");
                    return NaverUserDto.builder()
                            .id(res.path("id").asText(null))
                            .name(res.path("name").asText(null))
                            .email(res.path("email").asText(null))
                            .nickname(res.path("nickname").asText(null))
                            .profileImage(res.path("profile_image").asText(null))
                            .mobile(res.path("mobile").asText(null))
                            .gender(res.path("gender").asText(null))
                            .birthyear(res.path("birthyear").asText(null))
                            .birthday(res.path("birthday").asText(null))
                            .loginType("NAVER")
                            .build();
                }
            }
        } catch (Exception e) {
            log.error("Failed to fetch Naver user profile", e);
        }
        return null;
    }

    /**
     * 네이버 개발자 키 미등록 시 즉시 시연 및 테스트할 수 있는 가상 사용자 생성
     */
    public NaverUserDto createMockNaverUser() {
        return NaverUserDto.builder()
                .id("naver_" + UUID.randomUUID().toString().substring(0, 8))
                .name("네이버 테스트사용자")
                .nickname("그린네이버")
                .email("test_user@naver.com")
                .mobile("010-9876-5432")
                .gender("M")
                .birthyear("1995")
                .birthday("05-24")
                .profileImage("https://ssl.pstatic.net/static/pwe/address/img_profile.png")
                .loginType("NAVER_TEST")
                .build();
    }
}
