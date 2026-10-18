# 🛡️ Let's study~. PIMS (Personal Information Management System).

> **서비스 제공자가 사용자를 위해 개인정보를 안전하게 관리하기 위한 기초 시스템 **

---

## 📌 1. 프로젝트 취지 및 목적 (Purpose)

본 프로젝트는 **서비스 제공자 입장에서 사용자의 개인정보를 어떻게 구조화하고, 안전하게 저장·조회·파기하는지 학습하고 연구하기 위해 만들어진 오픈소스 교육용 프로젝트**입니다.

- 🎓 **순수 학습 및 교육 목적**: 개인정보 관리 라이프사이클(수집, 암호화, 접근 제어, 마스킹, 파기)의 기본 개념을 실습할 수 있도록 설계되었습니다.
- ✍️ **개인 학습 기반 작성**: 본 프로젝트와 문서는 작성자가 직접 공부하면서 기록하고 구현한 결과물입니다. 따라서 **공식적인 PIMS(개인정보보호 관리체계) 표준 및 실무 원 내용과 다를 수 있으며, 미흡하거나 잘못된 정보가 포함될 수 있습니다.**
- 💡 **오픈소스 지향**: 누구나 자유롭게 코드를 살펴보고, 학습하며 개선 아이디어를 나눌 수 있습니다.
- 🤝 **공부 목적으로 사용해 주세요**: 본 리포지토리는 보안 및 개인정보 처리 프레임워크 학습용으로만 사용해 주시기를 강력히 권장합니다. **공부해보세요. 재미있네요.**

---

## ⚠️ 2. 면책 조항 (Disclaimer)

> **[중요] 악의적 용도 및 불법적 사용 금지**
>
> 1. 본 프로젝트의 모든 소스코드와 문서는 **순수 교육 및 개인 학습/연구 목적**으로만 제공됩니다.
> 2. 작성자가 공부하며 작성한 내용이므로 **실제 공식 PIMS 표준 내용과 다를 수 있고 부정확한 정보가 포함되어 있을 수 있습니다.** 정확한 기준은 관계 기관의 공식 지침을 참고하시기 바랍니다.
> 3. 본 소프트웨어를 **무단 개인정보 수집, 탈취, 침해, 악의적인 시스템 공격 등 어떠한 불법적이거나 악의적인 용도로 사용하는 것을 엄격히 금지**합니다.
> 4. 본 소프트웨어의 사용, 수정 또는 배포로 인해 발생하는 **모든 직·간접적인 손해, 법적 분쟁, 규제 위반 및 민·형사상 책임은 전적으로 사용자 본인에게 있으며, 프로젝트 제작자 및 기여자는 이에 대해 어떠한 법적 책임도 지지 않습니다.**
> 5. 본 리포지토리의 코드는 기본 아키텍처 이해를 돕기 위한 최소한의 뼈대(Skeleton)이므로, 실제 상용 서비스(Production) 환경에 그대로 적용하기에는 적합하지 않습니다. 상용 환경 적용 시에는 관계 법령(개인정보보호법, GDPR 등) 준수 및 전문적인 보안 감사가 필수적입니다.

---

## 📂 3. 디렉토리 구조 (Directory Structure)

> 💡 **안내: Spring Boot 전환 예정**
> 기존에 작성된 Node.js 기반 프로토타입 프로젝트는 **`before/`** 디렉터리로 이전하여 보관하고 있습니다.
> 아직 본격적인 Spring Boot 코드 작성은 시작하지 않았으나, 향후 본 프로젝트는 **Spring Boot**로 새롭게 생성하여 제작될 예정입니다.

```text
pims-ex-tt2te/
├── before/                           # [이전 프로토타입] Node.js 기반 PIMS 뼈대
│   ├── src/                          # Express 기반 아키텍처 및 서비스
│   ├── .env.example
│   └── package.json
├── src/
│   ├── main/
│   │   ├── java/org/example/         # Spring Boot 소스코드
│   │   │   ├── PimsApplication.java  # 진입점
│   │   │   ├── controller/           # WelcomeController, NaverLoginController
│   │   │   ├── domain/               # User, PrivacyConsentLog, PrivacyAccessLog 엔티티
│   │   │   ├── dto/                  # NaverUserDto
│   │   │   ├── repository/           # UserRepository (Spring Data JPA)
│   │   │   └── service/              # NaverLoginService (OAuth2 토큰 및 프로필 조회)
│   │   ├── resources/
│   │   │   └── application.properties.example # 설정 템플릿 (.gitignore 보호)
│   │   └── webapp/WEB-INF/views/     # JSP 뷰 페이지 (welcome.jsp, login.jsp, profile.jsp)
├── build.gradle                      # Spring Boot 2.6.6 및 의존성 설정
├── settings.gradle                   # 프로젝트명 (rootProject.name = 'pims-ex-tt2te')
├── gradlew, gradlew.bat, gradle/     # Gradle 7.6.4 Wrapper
├── .gitignore                        # Git 관리 제외 파일 목록 (application.properties 등 제외)
├── LICENSE                           # MIT 라이선스
└── README.md                         # 프로젝트 안내 문서
```

---

## 🔑 4. PIMS 핵심 개념 및 학습 내용

### 4-1. `before/` (Node.js 프로토타입) 학습 내용

아래 내용은 **`before/` 폴더에 작성된 Node.js 프로토타입에서 가볍게 다루어 본 학습 내용**입니다.

> 💭 **작성자 메모 (실무와의 차이 및 코드 출처)**  
> `before/`에 포함된 소스코드는 **Google Antigravity**를 활용하여 작성된 코드이며, 실제 기업 현업의 보안·개인정보보호 실무를 반영한 것이 아닙니다. **작성자가 실무를 떠나 순수하게 개인적인 상상과 공부 차원에서 구상하여 만들어 본 부분**이므로, 실제 실무 시스템 기준과는 많은 차이가 있을 수 있습니다.

1. **개인정보 최소 수집 원칙**: 목적 달성에 필요한 최소한의 정보만 관리
2. **양방향 / 단방향 암호화**:
   - 비밀번호 등 인증 정보: 복호화 불가능한 단방향 해시(Hash)
   - 민감 식별 정보: 안전한 암호화 알고리즘(AES-256 등) 적용
3. **개인정보 마스킹 (Masking)**: 화면 노출 시 이름, 이메일, 전화번호 등의 일부를 마스킹 처리하여 정보 유출 방지
4. **개인정보 파기 (Data Purge)**: 사용자 탈퇴 또는 보유 기간 만료 시 복구 불가능한 영구 삭제 절차

---

### 4-2. `Spring Boot` 프로그램 (따로 제작 중)

> 💭 **작성자 메모 (실무와의 차이)**  
> 이 프로그램 역시 실제 기업 현업의 보안·개인정보보호 실무를 반영하는 것이 아니며, **작성자가 실무를 떠나 순수하게 개인적인 상상과 공부 차원에서 구상하여 만들어 갈 부분**입니다. 실제 실무 시스템 기준과는 많은 차이가 있을 수 있습니다.

현재 **Spring Boot를 기반으로 한 PIMS 프로그램을 별도로 새롭게 제작하고 있는 중**입니다.  
Spring Boot 환경에서의 아키텍처, 계정/권한 제어, 데이터베이스 연동 및 개인정보 보호 로직 등은 프로그램 제작이 진행되는 대로 이곳에 학습 내용을 새롭게 업데이트할 예정입니다.

---

## 🚀 5. 빠른 시작 (Getting Started)

본 저장소는 **기존 프로토타입(`before/`)** 과 **새롭게 개발될 `Spring Boot` 프로젝트**, 2가지로 구분됩니다.

### 5-1. `before/` (기존 Node.js 프로토타입) 실행 방법

- **사전 요구사항**: Node.js 18.x 이상

```bash
# 1. 저장소 복제 및 before 디렉터리 이동
git clone https://github.com/infott2t/pims-ex-tt2te.git
cd pims-ex-tt2te/before

# 2. 환경 변수 설정
cp .env.example .env

# 3. 서버 실행
npm start
```

---

### 5-2. `Spring Boot` 프로젝트 실행 방법

- **사전 요구사항**: Java (JDK) 11 이상 (Gradle Wrapper 포함)

```bash
# 1. 저장소 복제 후 루트 디렉터리로 이동
git clone https://github.com/infott2t/pims-ex-tt2te.git
cd pims-ex-tt2te

# 2. 환경 설정 파일 생성 (템플릿 복사)
# Windows PowerShell:
Copy-Item src/main/resources/application.properties.example src/main/resources/application.properties
# Linux / macOS:
cp src/main/resources/application.properties.example src/main/resources/application.properties

# 3. application.properties 파일에 네이버 Client ID / Secret 입력 (아래 5-3 가이드 참고)

# 4. Spring Boot 애플리케이션 빌드 및 실행
# Windows:
.\gradlew.bat bootRun
# Linux / macOS:
./gradlew bootRun

# 5. 브라우저 접속
# 메인 웰컴 페이지: http://localhost:8080/
# 네이버 로그인 페이지: http://localhost:8080/login
```

---

### 5-3. 🔐 네이버 간편로그인(OAuth 2.0) 설정 가이드

본 프로젝트는 네이버 아이디로 간편로그인을 지원합니다. 실제 네이버 계정으로 연동하려면 [네이버 개발자 센터(Naver Developers)](https://developers.naver.com/)에서 애플리케이션을 등록하고 키를 발급받아야 합니다.

#### 1단계: 네이버 개발자 센터에서 Client ID & Secret 발급
1. [네이버 개발자 센터](https://developers.naver.com/)에 접속하여 로그인합니다.
2. 상단 메뉴에서 **Application > 애플리케이션 등록**을 클릭합니다.
3. 애플리케이션 정보를 입력합니다:
   - **애플리케이션 이름**: `PIMS 개인정보 관리` (자유롭게 입력 가능)
   - **사용 API**: `네이버 로그인` 선택
   - **로그인 권한 설정 (제공 항목)**:
     - **회원이름**: `필수` 체크
     - **전자우편주소**: `필수` 체크
     - **별명(닉네임)**: `선택` 체크
     - **프로필 사진**: `선택` 체크
     - **휴대전화번호**: `선택` 체크
   - **로그인 오픈 API 서비스 환경 (PC웹)**:
     - **서비스 URL**: `http://localhost:8080`
     - **네이버로그인 Callback URL**: `http://localhost:8080/auth/naver/callback`
4. **등록하기** 버튼을 누르면 발급된 **Client ID**와 **Client Secret**을 확인할 수 있습니다.

#### 2단계: `application.properties` 파일 위치 및 작성 방법
- 파일 생성 경로: **`src/main/resources/application.properties`**
- 저장소에 포함된 예시 파일(`src/main/resources/application.properties.example`)을 복사하여 `application.properties` 파일을 생성하고 아래와 같이 발급받은 키를 입력합니다:

```properties
server.port=8080

# View Resolver for JSP
spring.mvc.view.prefix=/WEB-INF/views/
spring.mvc.view.suffix=.jsp

# Naver OAuth2 Configuration (네이버 개발자 센터에서 발급받은 값)
naver.client-id=발급받은_네이버_Client_ID
naver.client-secret=발급받은_네이버_Client_Secret
naver.redirect-uri=http://localhost:8080/auth/naver/callback

# 초기 구동을 위한 미설정 모듈 자동설정 제외
spring.autoconfigure.exclude=\
  org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration,\
  org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration,\
  org.springframework.boot.autoconfigure.flyway.FlywayAutoConfiguration,\
  org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration,\
  org.springframework.boot.autoconfigure.security.oauth2.client.servlet.OAuth2ClientAutoConfiguration
```

> 🛡️ **[보안 안내] Git Ignore 처리**  
> `src/main/resources/application.properties` 파일에는 유출되면 안 되는 비밀키(`Client Secret`)가 포함되므로, 본 프로젝트의 **`.gitignore`에 등록되어 GitHub 원격 저장소에 절대 커밋/푸시되지 않도록 안전하게 보호**되고 있습니다. 키가 없는 템플릿 파일인 `application.properties.example`만 저장소에서 공유됩니다.

#### 3단계: 로컬 테스트 모드 (Mock Test Mode) 안내
- 네이버 개발자 센터 키를 아직 발급받지 않았더라도, 로그인 화면([http://localhost:8080/login](http://localhost:8080/login))에서 **`🧪 개발·시연용 네이버 간편로그인 (Mock Test)`** 버튼을 누르면 즉시 가상 네이버 사용자 정보로 로그인 및 마스킹 화면을 체험하실 수 있습니다.

---

## 📜 6. 라이선스 및 상업적 이용 안내 (License)

본 프로젝트는 [MIT License](LICENSE)에 따라 오픈소스로 배포되며, 자유로운 수정 및 **상업적인 활용이 가능**합니다.

다만, 다음 사항을 반드시 유의해 주시기 바랍니다:
- 본 프로젝트는 **공부를 목적으로 제작**되었습니다.
- MIT 라이선스에 따라 상업적 활용이 가능하지만, **안내된 보안 원칙이나 법령 등을 준수하지 않는 경우를 포함하여, 상업적 활용 및 서비스 배포 이후에 발생하는 모든 문제와 일들에 대해서는 제작자 및 기여자가 일체 책임을 지지 않습니다.**
- 상업적 용도로 활용 시 발생하는 모든 보안 사고, 규제 위반 및 법적 분쟁에 대한 책임은 전적으로 활용하는 당사자에게 있습니다.

---

## 📚 7. 관련 공부 안내

개인정보보호와 PIMS(개인정보 관리 시스템) 관련 내용을 더 체계적으로 공부해보고 싶으신 분들을 위해 유용한 자격과 사이트를 소개합니다.

### 🎓 개인정보관리 자격 소개
- **공식 사이트**: [cppf.or.kr (한국CPO포럼 개인정보보호 자격인증)](https://www.cppf.or.kr)
- **응시 자격**: **별도의 응시 자격 제한이 없습니다.** (학력, 연령, 전공, 경력 무관 누구나 응시 가능)
- **소개**: 개인정보보호법 등 법령의 원칙부터 기술적·관리적 보호조치, 개인정보의 수집·이용·파기 라이프사이클 전반을 체계적으로 다룰 수 있어 이론적 기반을 다지기에 좋습니다.

### 💡 다양한 관련 자격 및 공부 분야
개인정보 및 정보보호 분야에는 이 밖에도 함께 살펴볼 수 있는 여러 전문 자격이 있습니다:
- **CPPG (개인정보관리사)**: 개인정보보호 기획 및 실무 관리 역량 검정
- **ISMS-P 인증심사원**: 정보보호 및 개인정보보호 관리체계 국가 인증 심사원 자격
- **정보보안기사 / 산업기사**: 시스템, 네트워크, 애플리케이션 보안 및 법규 전반을 다루는 국가기술자격
- **국제 공인 보안 자격**: CISA, CISSP 등 글로벌 정보보안 및 감사 자격

> 💬 **"공부해보세요. 재미있네요."**  
> 개발과 법적 규제, 시스템 아키텍처가 맞닿아 있는 개인정보보호 영역은 직접 탐구해볼수록 배울 점이 많고 흥미로운 분야입니다. 관심 있는 분들은 한번 도전해 보세요!

---

## 🤖 작성 안내 (Credits)

본 README 문서 및 프로젝트 초기 뼈대는 **[Google Antigravity](https://antigravity.google)** 를 활용하여 작성되었습니다.
