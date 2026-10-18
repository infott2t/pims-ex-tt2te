-- PIMS (개인정보 관리 시스템) 초기 스키마
-- V1__Init_schema.sql

CREATE TABLE IF NOT EXISTS pims_user (
    id                    BIGINT NOT NULL AUTO_INCREMENT,
    provider              VARCHAR(20) NOT NULL COMMENT '계정 공급자 (LOCAL, NAVER 등)',
    provider_id           VARCHAR(100) COMMENT 'OAuth 공급자 고유 식별자',
    username              VARCHAR(50) UNIQUE COMMENT '로그인 ID (로컬 로그인용)',
    password_hash         VARCHAR(255) COMMENT '단방향 해시 비밀번호',
    name                  VARCHAR(50) COMMENT '사용자 실명',
    nickname              VARCHAR(50) COMMENT '닉네임',
    email                 VARCHAR(100) COMMENT '이메일 주소',
    phone                 VARCHAR(30) COMMENT '휴대전화번호',
    encrypted_resident_id VARCHAR(255) COMMENT '민감정보 AES-256 암호화 (주민등록번호 등)',
    gender                VARCHAR(1) COMMENT '성별 (M/F/U)',
    birthyear             VARCHAR(10) COMMENT '출생연도',
    birthday              VARCHAR(10) COMMENT '생일 (MM-DD)',
    profile_image_url     VARCHAR(500) COMMENT '프로필 이미지 URL',
    role                  VARCHAR(20) NOT NULL DEFAULT 'ROLE_USER' COMMENT '권한',
    consent_given         BIT NOT NULL DEFAULT 0 COMMENT '개인정보 수집·이용 동의 여부',
    consent_date          DATETIME(6) COMMENT '동의 일시',
    retention_expire_at   DATETIME(6) COMMENT '개인정보 보유기간 만료일 (파기 예정일)',
    is_deleted            BIT NOT NULL DEFAULT 0 COMMENT '파기 및 탈퇴 여부',
    purged_at             DATETIME(6) COMMENT '영구 파기 처리 일시',
    created_at            DATETIME(6) COMMENT '생성 일시',
    updated_at            DATETIME(6) COMMENT '최종 수정 일시',
    PRIMARY KEY (id),
    INDEX idx_pims_user_provider_id (provider, provider_id),
    INDEX idx_pims_user_email (email),
    INDEX idx_pims_user_retention (retention_expire_at, is_deleted)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'PIMS 사용자 개인정보 관리';

CREATE TABLE IF NOT EXISTS privacy_consent_log (
    id           BIGINT NOT NULL AUTO_INCREMENT,
    user_id      BIGINT COMMENT '사용자 FK',
    consent_type VARCHAR(50) NOT NULL COMMENT '동의 유형 (REQUIRED/OPTIONAL/MARKETING)',
    agreed       BIT NOT NULL COMMENT '동의 여부',
    ip_address   VARCHAR(45) COMMENT '동의 시점 IP 주소',
    agreed_at    DATETIME(6) COMMENT '동의 일시',
    PRIMARY KEY (id),
    CONSTRAINT fk_consent_user FOREIGN KEY (user_id) REFERENCES pims_user (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '개인정보 수집·이용 동의 이력';

CREATE TABLE IF NOT EXISTS privacy_access_log (
    id             BIGINT NOT NULL AUTO_INCREMENT,
    accessor_id    BIGINT COMMENT '열람 수행자 ID',
    target_user_id BIGINT NOT NULL COMMENT '열람 대상 사용자 ID',
    action_type    VARCHAR(30) NOT NULL COMMENT '수행 작업 (READ/UPDATE/DOWNLOAD/PURGE)',
    reason         VARCHAR(200) COMMENT '열람 사유',
    ip_address     VARCHAR(45) COMMENT '접속 IP 주소',
    accessed_at    DATETIME(6) COMMENT '접근 일시',
    PRIMARY KEY (id),
    INDEX idx_access_target_user (target_user_id),
    INDEX idx_access_time (accessed_at)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '개인정보 열람 및 접근 감사 로그';
