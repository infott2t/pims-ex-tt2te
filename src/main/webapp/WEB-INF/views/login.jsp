<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PIMS - 네이버 간편로그인</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }
        body {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            color: #f1f5f9;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .container {
            max-width: 500px;
            width: 100%;
            background: rgba(30, 41, 59, 0.9);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
            text-align: center;
        }
        .header {
            margin-bottom: 30px;
        }
        .logo-icon {
            font-size: 44px;
            margin-bottom: 12px;
        }
        h1 {
            font-size: 24px;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 8px;
        }
        .subtitle {
            font-size: 14px;
            color: #94a3b8;
        }
        .btn-naver {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            width: 100%;
            height: 52px;
            background-color: #03C75A;
            color: #ffffff;
            font-size: 16px;
            font-weight: 700;
            text-decoration: none;
            border-radius: 10px;
            transition: background-color 0.2s, transform 0.1s;
            box-shadow: 0 4px 14px rgba(3, 199, 90, 0.35);
            margin-bottom: 16px;
        }
        .btn-naver:hover {
            background-color: #02b350;
            transform: translateY(-1px);
        }
        .btn-naver svg {
            width: 20px;
            height: 20px;
            fill: #ffffff;
        }
        .btn-test {
            display: block;
            width: 100%;
            padding: 12px;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.15);
            color: #cbd5e1;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            border-radius: 10px;
            transition: all 0.2s;
            margin-bottom: 24px;
        }
        .btn-test:hover {
            background: rgba(255, 255, 255, 0.16);
            color: #ffffff;
        }
        .guide-box {
            background: rgba(15, 23, 42, 0.7);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 10px;
            padding: 18px;
            text-align: left;
            font-size: 13px;
            color: #94a3b8;
            line-height: 1.6;
        }
        .guide-title {
            font-weight: 700;
            color: #e2e8f0;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .guide-item {
            margin-bottom: 6px;
        }
        .guide-item code {
            background: rgba(255, 255, 255, 0.1);
            color: #60a5fa;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 12px;
        }
        .badge-status {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 6px;
            font-size: 11px;
            font-weight: bold;
        }
        .badge-ready {
            background: rgba(16, 185, 129, 0.2);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.4);
        }
        .badge-waiting {
            background: rgba(245, 158, 11, 0.2);
            color: #f59e0b;
            border: 1px solid rgba(245, 158, 11, 0.4);
        }
        .alert-error {
            background: rgba(239, 68, 68, 0.15);
            border: 1px solid rgba(239, 68, 68, 0.4);
            color: #fca5a5;
            padding: 12px;
            border-radius: 8px;
            font-size: 13px;
            margin-bottom: 16px;
            text-align: left;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #64748b;
            font-size: 13px;
            text-decoration: none;
        }
        .back-link:hover {
            color: #94a3b8;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo-icon">🛡️</div>
            <h1>PIMS 로그인</h1>
            <div class="subtitle">개인정보 보호 체계 안심 로그인</div>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert-error">
                ⚠️ ${errorMessage}
            </div>
        </c:if>

        <!-- 네이버 로그인 버튼 -->
        <a href="${naverAuthUrl}" class="btn-naver">
            <svg viewBox="0 0 24 24">
                <path d="M16.273 12.845L7.376 0H0v24h7.727V11.155L16.624 24H24V0h-7.727v12.845z"/>
            </svg>
            네이버 아이디로 로그인
        </a>

        <!-- 원클릭 테스트 모드 로그인 -->
        <a href="/auth/naver/test-login" class="btn-test">
            🧪 개발·시연용 네이버 간편로그인 (Mock Test)
        </a>

        <!-- 네이버 API 연동 상태 안내 -->
        <div class="guide-box">
            <div class="guide-title">
                ⚙️ 네이버 OAuth2 연동 상태:
                <c:choose>
                    <c:when test="${naverConfigured}">
                        <span class="badge-status badge-ready">연동 활성화됨</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge-status badge-waiting">키 등록 대기 중</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="guide-item">
                - 콜백 주소(Callback URL):<br>
                <code>${redirectUri}</code>
            </div>
            <div class="guide-item">
                - 클라이언트 ID:<br>
                <code>${clientId}</code>
            </div>
            <div class="guide-item" style="margin-top: 8px; font-size: 12px; color: #64748b;">
                * 네이버 개발자센터 등록 전에는 위의 <strong>개발·시연용 Mock 로그인</strong>을 통해 프로필 수집 및 마스킹 기능을 바로 체험하실 수 있습니다.
            </div>
        </div>

        <a href="/" class="back-link">← 홈으로 돌아가기</a>
    </div>
</body>
</html>
