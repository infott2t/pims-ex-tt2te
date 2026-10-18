<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PIMS - 사용자 프로필 (개인정보 관리)</title>
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
            padding: 24px;
        }
        .container {
            max-width: 650px;
            width: 100%;
            background: rgba(30, 41, 59, 0.9);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 36px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            padding-bottom: 16px;
        }
        .title-group {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .logo-icon {
            font-size: 32px;
        }
        h1 {
            font-size: 22px;
            font-weight: 700;
            color: #ffffff;
        }
        .user-card {
            display: flex;
            align-items: center;
            gap: 20px;
            background: rgba(15, 23, 42, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 24px;
        }
        .avatar {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #03C75A;
            background-color: #334155;
        }
        .avatar-placeholder {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            background: #03C75A;
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            font-weight: bold;
        }
        .user-meta h2 {
            font-size: 20px;
            font-weight: 700;
            color: #ffffff;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .badge-naver {
            background-color: #03C75A;
            color: #ffffff;
            font-size: 11px;
            padding: 2px 8px;
            border-radius: 12px;
            font-weight: 600;
        }
        .user-meta p {
            color: #94a3b8;
            font-size: 14px;
            margin-top: 4px;
        }
        .section-title {
            font-size: 15px;
            font-weight: 600;
            color: #60a5fa;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 28px;
        }
        .data-table th, .data-table td {
            padding: 12px 14px;
            text-align: left;
            font-size: 14px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }
        .data-table th {
            width: 30%;
            color: #94a3b8;
            font-weight: 500;
            background: rgba(15, 23, 42, 0.3);
        }
        .data-table td {
            color: #f1f5f9;
        }
        .mask-text {
            color: #34d399;
            font-weight: 600;
            background: rgba(52, 211, 153, 0.1);
            padding: 2px 6px;
            border-radius: 4px;
        }
        .button-group {
            display: flex;
            gap: 12px;
        }
        .btn {
            flex: 1;
            padding: 12px 20px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            transition: all 0.2s;
        }
        .btn-primary {
            background: #3b82f6;
            color: #ffffff;
        }
        .btn-primary:hover {
            background: #2563eb;
        }
        .btn-logout {
            background: rgba(239, 68, 68, 0.15);
            border: 1px solid rgba(239, 68, 68, 0.4);
            color: #fca5a5;
        }
        .btn-logout:hover {
            background: rgba(239, 68, 68, 0.25);
            color: #ffffff;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="title-group">
                <span class="logo-icon">🛡️</span>
                <h1>PIMS 개인정보 관리</h1>
            </div>
            <a href="/" style="color: #94a3b8; font-size: 13px; text-decoration: none;">메인 홈</a>
        </div>

        <!-- 사용자 프로필 요약 카드 -->
        <div class="user-card">
            <c:choose>
                <c:when test="${not empty user.profileImage}">
                    <img src="${user.profileImage}" alt="프로필" class="avatar" />
                </c:when>
                <c:otherwise>
                    <div class="avatar-placeholder">N</div>
                </c:otherwise>
            </c:choose>
            <div class="user-meta">
                <h2>
                    ${user.name != null ? user.name : user.nickname}
                    <span class="badge-naver">
                        ${user.loginType == 'NAVER' ? '네이버 연동' : '네이버 테스트 연동'}
                    </span>
                </h2>
                <p>닉네임: ${user.nickname != null ? user.nickname : '-'}</p>
                <p>고유식별자: <span style="font-family: monospace; color: #64748b;">${user.id}</span></p>
            </div>
        </div>

        <!-- 수집 및 마스킹된 개인정보 표 -->
        <div class="section-title">🔒 수집된 개인정보 및 마스킹(보호) 상태</div>
        <table class="data-table">
            <tr>
                <th>이메일 주소</th>
                <td>
                    <span class="mask-text">${user.maskedEmail}</span>
                    <span style="color: #64748b; font-size: 12px; margin-left: 6px;">(원본: ${user.email})</span>
                </td>
            </tr>
            <tr>
                <th>휴대전화번호</th>
                <td>
                    <span class="mask-text">${user.maskedMobile}</span>
                    <span style="color: #64748b; font-size: 12px; margin-left: 6px;">(원본: ${user.mobile})</span>
                </td>
            </tr>
            <tr>
                <th>성별</th>
                <td>
                    <c:choose>
                        <c:when test="${user.gender == 'M'}">남성 (M)</c:when>
                        <c:when test="${user.gender == 'F'}">여성 (F)</c:when>
                        <c:otherwise>미확인/비공개</c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <th>출생연도 / 생일</th>
                <td>${user.birthyear != null ? user.birthyear : '-'}년 ${user.birthday != null ? user.birthday : '-'}</td>
            </tr>
            <tr>
                <th>DB 회원 고유번호</th>
                <td>
                    <span style="font-weight: 700; color: #60a5fa;"># ${user.dbId}</span>
                    <span style="color: #64748b; font-size: 12px; margin-left: 6px;">(MySQL pims_user 테이블 PK)</span>
                </td>
            </tr>
            <tr>
                <th>개인정보 수집 경로</th>
                <td>네이버 간편로그인 (OAuth 2.0 API)</td>
            </tr>
            <tr>
                <th>개인정보 수집·동의 일시</th>
                <td>${user.consentDate != null ? user.consentDate : '-'}</td>
            </tr>
            <tr>
                <th>개인정보 파기 예정일</th>
                <td>
                    <span style="color: #f59e0b; font-weight: 600;">${user.retentionExpireAt != null ? user.retentionExpireAt : '-'}</span>
                    <span style="color: #64748b; font-size: 12px; margin-left: 6px;">(수집 후 1년 보유 만료 원칙)</span>
                </td>
            </tr>
        </table>

        <!-- 하단 액션 버튼 -->
        <div class="button-group">
            <a href="/" class="btn btn-primary">홈으로 이동</a>
            <a href="/auth/logout" class="btn btn-logout">로그아웃</a>
            <form action="/user/purge" method="post" style="display: inline; flex: 1;" onsubmit="return confirm('정말로 개인정보를 복구 불가능하도록 영구 파기(탈퇴)하시겠습니까?');">
                <button type="submit" class="btn btn-logout" style="width: 100%; cursor: pointer; border-color: rgba(239, 68, 68, 0.7); background: rgba(239, 68, 68, 0.3);">
                    🗑️ 개인정보 즉시 파기 (탈퇴)
                </button>
            </form>
        </div>
    </div>
</body>
</html>
