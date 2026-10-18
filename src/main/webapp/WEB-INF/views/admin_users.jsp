<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PIMS - 개인정보 관리 대시보드</title>
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
            padding: 40px 20px;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
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
        h1 {
            font-size: 22px;
            color: #ffffff;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .table-responsive {
            overflow-x: auto;
            margin-bottom: 24px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }
        th, td {
            padding: 12px 14px;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        }
        th {
            background: rgba(15, 23, 42, 0.6);
            color: #94a3b8;
            font-weight: 600;
        }
        tr:hover {
            background: rgba(255, 255, 255, 0.03);
        }
        .badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 6px;
            font-size: 11px;
            font-weight: bold;
        }
        .badge-naver {
            background-color: #03C75A;
            color: #ffffff;
        }
        .badge-purged {
            background-color: rgba(239, 68, 68, 0.2);
            color: #f87171;
            border: 1px solid rgba(239, 68, 68, 0.4);
        }
        .badge-active {
            background-color: rgba(16, 185, 129, 0.2);
            color: #34d399;
            border: 1px solid rgba(16, 185, 129, 0.4);
        }
        .btn-home {
            display: inline-block;
            padding: 10px 18px;
            background: #3b82f6;
            color: #ffffff;
            text-decoration: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🛡️ PIMS 전체 개인정보 관리 대시보드</h1>
            <a href="/" class="btn-home">홈으로</a>
        </div>

        <p style="color: #94a3b8; font-size: 14px; margin-bottom: 20px;">
            MySQL 데이터베이스(<code>pims_user</code>)에 영속화된 개인정보 현황 및 라이프사이클(동의, 만료, 파기) 상태입니다.
        </p>

        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>공급자</th>
                        <th>이름</th>
                        <th>이메일</th>
                        <th>동의여부</th>
                        <th>수집일시</th>
                        <th>보유만료일</th>
                        <th>파기상태</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${users}">
                        <tr>
                            <td># ${u.id}</td>
                            <td>
                                <span class="badge badge-naver">${u.provider}</span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.isDeleted}">
                                        <span style="color: #ef4444; font-weight: bold;">${u.name}</span>
                                    </c:when>
                                    <c:otherwise>${u.name}</c:otherwise>
                                </c:choose>
                            </td>
                            <td>${u.email}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.consentGiven}">
                                        <span style="color: #10b981;">● 동의함</span>
                                    </c:when>
                                    <c:otherwise>미동의</c:otherwise>
                                </c:choose>
                            </td>
                            <td>${u.consentDate != null ? u.consentDate : '-'}</td>
                            <td>${u.retentionExpireAt != null ? u.retentionExpireAt : '-'}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.isDeleted}">
                                        <span class="badge badge-purged">영구 파기됨</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-active">정상 보관</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty users}">
                        <tr>
                            <td colspan="8" style="text-align: center; color: #64748b; padding: 24px;">
                                등록된 사용자가 없습니다.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
