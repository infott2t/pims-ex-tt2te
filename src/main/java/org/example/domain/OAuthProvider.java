package org.example.domain;

public enum OAuthProvider {
    LOCAL("일반 로컬 계정"),
    NAVER("네이버 간편로그인"),
    KAKAO("카카오 간편로그인"),
    GOOGLE("구글 간편로그인");

    private final String description;

    OAuthProvider(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}
