-- 사용자 최근 로그인 시각 컬럼 및 로그인 이력 테이블 추가
-- V2__Add_user_login_history.sql

ALTER TABLE pims_user
    ADD COLUMN last_login_at DATETIME(6) COMMENT '최근 로그인 일시';

CREATE TABLE IF NOT EXISTS user_login_history (
    id          BIGINT NOT NULL AUTO_INCREMENT,
    user_id     BIGINT NOT NULL COMMENT '사용자 FK',
    login_type  VARCHAR(30) NOT NULL COMMENT '로그인 유형 (NAVER, NAVER_TEST 등)',
    ip_address  VARCHAR(45) COMMENT '접속 IP 주소',
    login_at    DATETIME(6) NOT NULL COMMENT '로그인 일시',
    PRIMARY KEY (id),
    INDEX idx_login_history_user_time (user_id, login_at),
    CONSTRAINT fk_login_history_user FOREIGN KEY (user_id) REFERENCES pims_user (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '사용자 로그인 기록';
