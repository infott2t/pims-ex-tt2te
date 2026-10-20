package org.example.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.dto.NaverUserDto;
import org.example.service.NaverLoginService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Slf4j
@Controller
@RequiredArgsConstructor
public class NaverLoginController {

    private final NaverLoginService naverLoginService;
    private final org.example.service.UserService userService;

    public static final String SESSION_USER_KEY = "loginUser";

    /**
     * 로그인 메인 화면
     */
    @GetMapping("/login")
    public String loginPage(HttpSession session, Model model) {
        boolean configured = naverLoginService.isConfigured();
        model.addAttribute("naverConfigured", configured);
        model.addAttribute("redirectUri", naverLoginService.getRedirectUri());
        
        if (configured) {
            model.addAttribute("naverAuthUrl", "/auth/naver/login");
        } else {
            model.addAttribute("naverAuthUrl", "/auth/naver/test-login");
        }
        return "login";
    }

    /**
     * 네이버 로그인 시작 (네이버 로그인 인증 페이지로 리다이렉트)
     */
    @GetMapping("/auth/naver/login")
    public String naverLogin(HttpSession session) {
        if (!naverLoginService.isConfigured()) {
            log.info("Naver client key is not configured. Redirecting to test login.");
            return "redirect:/auth/naver/test-login";
        }
        String authorizeUrl = naverLoginService.buildAuthorizeUrl(session);
        return "redirect:" + authorizeUrl;
    }

    /**
     * 네이버 OAuth2 Callback 수신
     */
    @GetMapping("/auth/naver/callback")
    public String naverCallback(
            @RequestParam(value = "code", required = false) String code,
            @RequestParam(value = "state", required = false) String state,
            @RequestParam(value = "error", required = false) String error,
            @RequestParam(value = "error_description", required = false) String errorDescription,
            javax.servlet.http.HttpServletRequest request,
            HttpSession session,
            Model model) {

        if (error != null) {
            log.error("Naver login error: {}, description: {}", error, errorDescription);
            model.addAttribute("errorMessage", "네이버 로그인 인증 취소 또는 오류: " + errorDescription);
            return "login";
        }

        // 세션의 state와 일치하는지 CSRF 검증
        String savedState = (String) session.getAttribute(NaverLoginService.SESSION_STATE_KEY);
        if (savedState == null || !savedState.equals(state)) {
            log.warn("Invalid OAuth2 state. saved={}, received={}", savedState, state);
            model.addAttribute("errorMessage", "유효하지 않은 요청 세션(CSRF 토큰 불일치)입니다.");
            return "login";
        }

        // Access Token 발급 요청
        String accessToken = naverLoginService.getAccessToken(code, state);
        if (accessToken == null) {
            model.addAttribute("errorMessage", "네이버 접근 토큰(Access Token) 발급에 실패하였습니다.");
            return "login";
        }

        // 사용자 프로필 정보 조회
        NaverUserDto userProfile = naverLoginService.getUserProfile(accessToken);
        if (userProfile == null) {
            model.addAttribute("errorMessage", "네이버 사용자 프로필 정보를 불러오지 못했습니다.");
            return "login";
        }

        // 데이터베이스 영속화 (회원 저장/갱신 및 감사 로그 기록)
        userProfile = userService.processNaverLogin(userProfile, request.getRemoteAddr());

        // 세션에 로그인 사용자 저장
        session.setAttribute(SESSION_USER_KEY, userProfile);
        session.removeAttribute(NaverLoginService.SESSION_STATE_KEY);

        log.info("Naver user login success: email={}, name={}, dbId={}", userProfile.getEmail(), userProfile.getName(), userProfile.getDbId());
        return "redirect:/user/profile";
    }

    /**
     * 개발 및 테스트용 네이버 간편로그인 시뮬레이션 (DB 연동 포함)
     */
    @GetMapping("/auth/naver/test-login")
    public String naverTestLogin(javax.servlet.http.HttpServletRequest request, HttpSession session) {
        NaverUserDto mockUser = naverLoginService.createMockNaverUser();
        mockUser = userService.processNaverLogin(mockUser, request.getRemoteAddr());
        session.setAttribute(SESSION_USER_KEY, mockUser);
        log.info("Mock Naver user login: dbId={}, email={}", mockUser.getDbId(), mockUser.getEmail());
        return "redirect:/user/profile";
    }

    /**
     * 사용자 프로필 / 개인정보 대시보드 화면
     */
    @GetMapping("/user/profile")
    public String userProfile(HttpSession session, Model model) {
        NaverUserDto user = (NaverUserDto) session.getAttribute(SESSION_USER_KEY);
        if (user == null) {
            return "redirect:/login";
        }
        model.addAttribute("user", user);
        return "profile";
    }

    /**
     * 로그아웃 처리
     */
    @GetMapping("/auth/logout")
    public String logout(HttpSession session) {
        session.removeAttribute(SESSION_USER_KEY);
        session.invalidate();
        return "redirect:/";
    }

    /**
     * 개인정보 즉시 파기 (회원 탈퇴)
     */
    @org.springframework.web.bind.annotation.PostMapping("/user/purge")
    public String purgeUser(javax.servlet.http.HttpServletRequest request, HttpSession session) {
        NaverUserDto user = (NaverUserDto) session.getAttribute(SESSION_USER_KEY);
        if (user != null && user.getDbId() != null) {
            userService.purgeUser(user.getDbId(), request.getRemoteAddr());
        }
        session.removeAttribute(SESSION_USER_KEY);
        session.invalidate();
        return "redirect:/?purged=true";
    }

    /**
     * PIMS 학습용 전체 사용자 및 개인정보 보호 현황 목록
     */
    @GetMapping("/admin/users")
    public String adminUsers(Model model) {
        model.addAttribute("users", userService.findAllUsers());
        return "admin_users";
    }
}
