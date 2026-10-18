<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PIMS - Welcome</title>
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
            max-width: 680px;
            width: 100%;
            background: rgba(30, 41, 59, 0.85);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
        }
        .header {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 24px;
        }
        .icon {
            font-size: 40px;
            background: #3b82f6;
            width: 64px;
            height: 64px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
        }
        h1 {
            font-size: 26px;
            font-weight: 700;
            color: #ffffff;
        }
        .subtitle {
            color: #94a3b8;
            font-size: 14px;
            margin-top: 4px;
        }
        .greeting-card {
            background: rgba(59, 130, 246, 0.1);
            border: 1px solid rgba(59, 130, 246, 0.3);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 24px;
        }
        .greeting-card h2 {
            font-size: 18px;
            color: #60a5fa;
            margin-bottom: 8px;
        }
        .greeting-card p {
            color: #cbd5e1;
            font-size: 15px;
            line-height: 1.6;
        }

        /* 로그인 액션 카드 */
        .auth-card {
            background: rgba(15, 23, 42, 0.7);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 24px;
        }
        .auth-card-title {
            font-size: 14px;
            color: #94a3b8;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 14px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .btn-naver {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            width: 100%;
            height: 48px;
            background-color: #03C75A;
            color: #ffffff;
            font-size: 15px;
            font-weight: 700;
            text-decoration: none;
            border-radius: 8px;
            transition: background-color 0.2s, transform 0.1s;
            box-shadow: 0 4px 12px rgba(3, 199, 90, 0.3);
        }
        .btn-naver:hover {
            background-color: #02b350;
            transform: translateY(-1px);
        }
        .btn-naver svg {
            width: 18px;
            height: 18px;
            fill: #ffffff;
        }
        .logged-user-box {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .logged-user-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .logged-user-info img {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            border: 2px solid #03C75A;
        }
        .user-pill {
            font-weight: 600;
            color: #ffffff;
            font-size: 15px;
        }
        .user-email-pill {
            color: #94a3b8;
            font-size: 13px;
        }
        .auth-btns {
            display: flex;
            gap: 8px;
        }
        .btn-sm {
            padding: 8px 14px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
        }
        .btn-sm-profile {
            background: #3b82f6;
            color: #ffffff;
        }
        .btn-sm-profile:hover {
            background: #2563eb;
        }
        .btn-sm-logout {
            background: rgba(239, 68, 68, 0.2);
            color: #fca5a5;
            border: 1px solid rgba(239, 68, 68, 0.4);
        }
        .btn-sm-logout:hover {
            background: rgba(239, 68, 68, 0.3);
            color: #ffffff;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 28px;
        }
        .info-item {
            background: rgba(15, 23, 42, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.05);
            border-radius: 10px;
            padding: 16px;
        }
        .info-label {
            font-size: 12px;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
        }
        .info-value {
            font-size: 15px;
            font-weight: 600;
            color: #e2e8f0;
        }
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: #10b981;
            font-weight: 600;
        }
        .status-dot {
            width: 8px;
            height: 8px;
            background-color: #10b981;
            border-radius: 50%;
            box-shadow: 0 0 8px #10b981;
        }
        .footer {
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding-top: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: #64748b;
            font-size: 13px;
        }
        .badge {
            background: rgba(255, 255, 255, 0.1);
            color: #cbd5e1;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="icon">🛡️</div>
            <div>
                <h1>${projectName}</h1>
                <div class="subtitle">Personal Information Management System</div>
            </div>
        </div>

        <c:if test="${param.purged == 'true'}">
            <div style="background: rgba(239, 68, 68, 0.15); border: 1px solid rgba(239, 68, 68, 0.4); color: #fca5a5; padding: 14px; border-radius: 10px; margin-bottom: 20px; font-size: 14px;">
                ✅ 개인정보가 복구 불가능하도록 안전하게 영구 파기(탈퇴) 처리되었습니다.
            </div>
        </c:if>

        <div class="greeting-card">
            <h2>${greeting}</h2>
            <p>Spring Boot 와 JSP 뷰 템플릿 엔진 기반의 개인정보 관리 기초 뼈대(Scaffold)입니다.</p>
        </div>

        <!-- 네이버 간편로그인 연동 섹션 -->
        <div class="auth-card">
            <c:choose>
                <c:when test="${not empty loginUser}">
                    <div class="auth-card-title">
                        <span>👤 로그인 사용자 정보</span>
                        <a href="/admin/users" style="color: #60a5fa; font-size: 12px; text-decoration: none;">전체 DB 현황 대시보드 →</a>
                    </div>
                    <div class="logged-user-box">
                        <div class="logged-user-info">
                            <c:if test="${not empty loginUser.profileImage}">
                                <img src="${loginUser.profileImage}" alt="프로필" />
                            </c:if>
                            <div>
                                <div class="user-pill">${loginUser.name != null ? loginUser.name : loginUser.nickname}님</div>
                                <div class="user-email-pill">${loginUser.maskedEmail}</div>
                            </div>
                        </div>
                        <div class="auth-btns">
                            <a href="/user/profile" class="btn-sm btn-sm-profile">내 정보 관리</a>
                            <a href="/auth/logout" class="btn-sm btn-sm-logout">로그아웃</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="auth-card-title">
                        <span>🔐 소셜 계정 연동</span>
                        <a href="/login" style="color: #60a5fa; font-size: 12px; text-decoration: none;">로그인 설정 상세 →</a>
                    </div>
                    <a href="/login" class="btn-naver">
                        <svg viewBox="0 0 24 24">
                            <path d="M16.273 12.845L7.376 0H0v24h7.727V11.155L16.624 24H24V0h-7.727v12.845z"/>
                        </svg>
                        네이버 아이디로 로그인
                    </a>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="info-grid">
            <div class="info-item">
                <div class="info-label">서버 상태</div>
                <div class="info-value">
                    <span class="status-badge">
                        <span class="status-dot"></span> 정상 가동 중 (ONLINE)
                    </span>
                </div>
            </div>
            <div class="info-item">
                <div class="info-label">소셜 로그인 모듈</div>
                <div class="info-value">Naver OAuth 2.0</div>
            </div>
            <div class="info-item">
                <div class="info-label">서버 프레임워크</div>
                <div class="info-value">Spring Boot 2.6.6</div>
            </div>
            <div class="info-item">
                <div class="info-label">현재 서버 시각</div>
                <div class="info-value">${currentTime}</div>
            </div>
        </div>

        <div class="footer">
            <span>&copy; 2026 PIMS Project</span>
            <span class="badge">Root Project: pims-ex-tt2te</span>
        </div>
    </div>
</body>
</html>
