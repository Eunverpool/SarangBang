# 사랑방
#### 팀명 : 건어물
##### 팀원 : 박찬희, 김호식, 이창민, 이은우
기간 : 25.03.03 ~ 24.06.10
[Notion](https://scratch-helium-985.notion.site/131282d9286180f2b89ac82111e2d57d?pvs=4)

# 종합 프로젝트: 인지기능향상과 우울증 완화를 돕는 대화형 AI 앱

# 1. 프로젝트 주제 및 기획의도

#### 주제 ❗️
> 스마트 건물 관리 시스템은 최신 IoT와 데이터 분석 기술을 활용하여 건물 내 다양한 시설과 자원의 효율적인 운영과 관리를 목표로 합니다.   
> 주차, 에너지, 보안, 엘리베이터, 유지보수 등 건물 내 다양한 관리 요소를 통합하여 한 플랫폼에서 관리할 수 있도록 설계됩니다.   
> 이를 통해 입주자와 관리자 모두에게 편리하고 안전한 환경을 제공하며, 효율적인 자원 운영을 가능하게 합니다.

## 기획의도❗️

**1. 시간과 공간의 제약 없는 서비스 제공**  
본 서비스는 **비대면 기반의 시스템**으로, 시간과 장소에 구애받지 않고 언제 어디서나 접근이 가능합니다.  
이는 특히 거동이 불편한 노인이나 도서 산간 지역 거주자에게 큰 혜택을 줄 수 있으며, 서비스의 **접근성과 편의성**을 극대화합니다.   

**2. 사용자 친화적인 대화형 인터페이스 제공**  
**자연어 처리 기반의 대화형 인터페이스**를 통해 노년층에게 익숙하지 않은 디지털 환경에 대한 **진입 장벽을 낮춥니다**.  
단순 정보 제공을 넘어, 개인 맞춤형 피드백과 **상호작용 기반의 응답**을 제공함으로써 사용자에게 지속적인 동기 부여와 정서적 안정감을 전달합니다.  
이를 통해 **사용자와의 신뢰 형성** 및 서비스 지속 이용률 증가를 도모할 수 있습니다.  

**3. 인지 기능 활성화 및 정서 지원 효과**  
**일상 대화 기반의 상호작용**은 노인의 **기억력**, **주의력**, **언어 능력** 등을 자연스럽게 자극하여 **인지 훈련 효과**를 기대할 수 있습니다.  
또한 감정과 생각을 표현하는 과정을 통해 정서적 지지를 받을 수 있어 **정신 건강 유지**에 긍정적인 영향을 줍니다.  

**4. 감정 분석 기반 정신 건강 조기 대응**  
정신 건강을 세심하게 살필 수 있도록, 노인 우울증과 치매의 특징데이터를 학습한 AI 모델을 활용합니다.  
사용자의 음성 데이터를 **.wav 파일 형식**으로 전송하면, 모델이 이를 분석하여 **우울 및 인지 저하 가능성에 대한 결과**를 제공합니다.  
이를 통해 **감정 변화나 인지 기능 변화의 징후**를 조기에 파악하고, 필요 시 전문가 상담을 위한 참고 자료로 활용할 수 있습니다.  



---
# 2. 프로젝트 개요
## 🛠 기술 스택

### 개발 언어
> - Flutter 3.29.2

### ~~Frontend~~  
> - ~~JavaScript~~  
> - ~~HTML5 / CSS3~~  
> - ~~Bootstrap~~  
> - ~~AJAX~~  
> - ~~jQuery 3.7.1~~

### ~~Backend~~  
> - ~~Spring Boot 3.2.11~~  
> - ~~Gradle~~  
> - ~~Spring Security~~  
> - ~~WebSocket~~  
> - ~~HTTP~~
**이거 수정해야 함**

### Database
> - mongodb 6.16.0

### Development Tools
> - Visual Studio Code
> - Git/Github
> - Notion


📌 프로젝트 시나리오   
<img src="user/src/main/resources/static/img/senario_image.png"></img><br/>

📌 프로젝트 계획도   
<img src="user/src/main/resources/static/img/Project_Planning.png"></img><br/>

📌 시스템 아키텍처
<img src="user/src/main/resources/static/img/system_architecture.png">

📌 WBS  
<img src="user/src/main/resources/static/img/system_wbs.png">


---

# 사용자 페이지
## 핵심 기능
### 1) 챗봇 및 웹소켓 📫
<img src="user/src/main/resources/static/img/chatbot.gif"></img><br/>
<img src="user/src/main/resources/static/img/adminchat.gif"></img><br/>

- Naver Clova ChatBot API를 활용하여 사용자와 1:1 대화를 할 수 있는 챗봇 시스템 구현   


- 웹소켓(WebSocket) 기반의 양방향 실시간 통신을 통해 빠르고 안정적인 메시지 전송 환경을 제공 


- 사용자가 보낸 메시지는 웹소켓을 통해 서버로 전송되며, 서버는 NCP CLOVA ChatBot과 통신하여 적절한 응답을 리턴받음

### 2) 소셜 로그인 (카카오) 👀
<img src="user/src/main/resources/static/img/social_login.gif"></img><br/>

- Kakao Rest API를 활용하여 소셜 로그인 구현
  - 기존 사용자와 신규 사용자를 구분하여 처리

> 로그인 플로우
> 1. Authorization Code를 기반으로 Access Token 요청
> 2. Access Token으로 사용자 고유 ID와 이름, 이메일 등을 수신
> 3. 사용자가 소셜로그인을 처음 시도한 경우 추가정보를 입력받고 db에 추가

***
# 결제 시스템 (Payment Integration)

**포트원 API**를 활용하여 안정적이고 효율적인 결제 시스템을 구현했습니다. 직관적인 결제 플로우를 통해 사용자와 관리자의 편의성을 극대화하였습니다.
<img src="user/src/main/resources/static/img/park_payment.gif"></img><br/>

## 결제 플로우

1. 📝 **사용자 입력**
    - 사용자가 차량 번호를 입력.

2. 💰 **요금 계산**
    - 내부 로직에 따라 차량 정보와 이용 시간 등을 기반으로 요금을 자동 계산.

3. 📤 **결제 요청**
    - 포트원 API를 통해 PG사, 결제수단, 주문번호, 결제금액 등의 정보를 전달.

4. ✅ **결제 처리 및 검증**
    - PG사에서 결제를 처리.
    - 포트원 API가 처리 결과를 반환하면 서버에서 해당 결과를 검증하여 최종 결제 상태를 업데이트.
***

### 4) 에너지 관리
<img src="user/src/main/resources/static/img/energy_control.gif"></img><br/>

- HTTP 통신을 통한 센서 관리 시스템 구현

> ### 센서 데이터 모니터링 플로우
> 1. 센서가 값을 JSON 형식으로 서버로 보낸다.
> 2. 서버는 받아서 String,double등의 변수형으로 파싱해서 DB에 저장한다.
> 3. AJAX를 이용한 비동기 통신으로 DB의 값을 실시간으로 감지한다.
> ### 기기 제어 플로우
> 1. 사용자가 제어버튼 클릭이벤트를 통해 DB의 기기 status값을 변경한다.
> 2. AJAX로 DB status 값을 체크해서 화면 변경한다. 

### 5) 주차 관리

- AJAX를 이용한 비동기 통신으로 주차장 현황 실시간 모니터링

> ### 주차관리 플로우
> 1. DB의 각 주차칸 상태가 status로 저장되어있다.
> 2. AJXA 비동기 통신으로 주차장 DB를 주기적으로 감지한다.
> 3. 주차칸 status에 따른 이미지를 변경한다.

## 기본 기능 ⚡

### 메인 페이지
<img src="user/src/main/resources/static/img/Honeycam 2024-12-22 16-10-24.gif"></img><br/>


> - 지도
>   - 카카오맵 api를 사용하여 지도를 페이지에 통합 및 표시
> - Ajax
>   - 전력 사용량을 실시간 비동기통신으로 가져와 업데이트
>   - 주차 데이터를 실시간으로 가져와 업데이트
> - highcharts
>   - 전력 사용량을 highcharts 라이브러를 사용하여 시각화
>   - AJAX 요청을 통해 데이터를 주기적으로 가져와 차트에 실시간 추가
> - 웹캠
>   - WebRTC 기술을 사용하여 로컬 장치의 웹캠에 접근
>   - HTML5 <vidio> 태그를 활용해 실시간 스트림 출력
> - 날씨
>   - OpenWeather api를 사용하여 날씨 데이터를 비동기적으로 가져와 UI에 업데이트
> - Mybatis 
>   - SQL과 Java Dto 객체를 매핑해 데이터베이스 연동
>   - Mapper XML에서 작성된 SQL을 Repository 인터페이스 메서드에 매핑.
>   - Mapper 파일을 통해 CRUD 및 동적 쿼리 실행

### 분석, 공지사항 페이지, 마이페이지

> - Mybatis
>   - SQL과 Java Dto 객체를 매핑해 데이터베이스 연동
>   - Mapper XML에서 작성된 SQL을 Repository 인터페이스 메서드에 매핑.
>   - Mapper 파일을 통해 CRUD 및 동적 쿼리 실행
> - highcharts
  >   - 전력 사용량을 highcharts 라이브러를 사용하여 시각화
>   - AJAX 요청을 통해 데이터를 주기적으로 가져와 차트에 실시간 추가
---

# 관리자 페이지
## 핵심 기능
### 1) 웹소켓 통신 💬
<img src="user/src/main/resources/static/img/adminchat.gif"></img><br/>

- STOMP를 활용하여 메시지 브로커 방식으로 데이터 전송
- SockJS 및 STOMP 클라이언트를 사용해 서버에 연결

>**메시지 플로우**
> 1. 클라이언트 연결
>    1. 페이지 로드시 SockJS 연결 자동 생성
 >    2. STOMP 경로 /send/user 및 /send/admin 구독
> 2. 메시지 송신
>   1. 발신자가 메시지 입력 후 Enter 또는 send 버튼 클릭 → JSON 형식으로 메시지를 STOMP 경로로 전송
>3. 메시지 수신
>   1. 서버는 구독된 경로로 메시지를 수신
>   2. 수신된 메시지는 HTML DOM에 추가되어 채팅 UI에 표시.


### 2) 에너지 관리

<img src="user/src/main/resources/static/img/admin_energy.gif"></img><br/>

> ### 에너지 관리 플로우
> 1. 센서에서 올라오는 데이터들을 층별로 분류해 층별 전력량을 출력한다.
> 2. 설정한 범위값에 따라 층별 이미지를 filter값 변환을 주어 색상을 변경한다.
> 3. 건물전체의 전력 사용량은 하단 게이지 차트에 ajax로 실시간으로 확인 할 수 있다.
> 4. 우측 하단 막대 차트에는 로그에 찍힌 시간값을 월별 기준으로 분류해 월별 사용량을 확인 할 수있다.
***

### 3) 차량감지 시스템
<img src="user/src/main/resources/static/img/park_ocr.gif"></img><br/>

> ### 차량감지 플로우
> 1. 감지 버튼을 누르는순간 웹캠의 화면을 캡쳐해서 이미지를 생성한다.
> 2. 해당 이미지를 NCP Clova OCR key값,url값과 함께 OCR을 작동한다.
> 3. 글자는 정규식을 활용해 차량번호로 인식한 글자만 추출한다.
> 4. 인식된 차량번호와 DB 내부값을 비교해 확인되면 해당 차량의 입출차 기록을 출력한다.
***
## 4)📅 관리자 통합 일정 관리 시스템
<img src="user/src/main/resources/static/img/calander.gif"></img><br/>
> FullCalendar와 Google Calendar API를 연동하여 직관적이고 효율적인 일정 관리 시스템을 구현했습니다.
> FullCalendar의 세련된 UI를 활용하여 시각적 완성도를 높이고,
> Google Calendar의 강력한 기능을 통해 관리자들의 일정을 실시간으로 통합 관리할 수 있습니다.
## 🔧 주요 기능   
### 실시간 IoT 장애 모니터링
- IoT 기기 장애 발생 시 자동으로 일정에 등록    
- 장애 발생 시간 및 위치 정보 실시간 동기화   
- 신속한 대응을 위한 즉각적인 알림 시스템


### 통합 일정 관리

- Google Calendar 연동을 통한 일정 등록 및 관리   
- 모든 관리자 계정과 실시간 일정 공유   
- 직관적인 인터페이스로 손쉬운 일정 조회 및 관리   


### 사용자 편의성

- 원클릭으로 Google Calendar 연동   
- 통합된 대시보드에서 모든 일정 한눈에 확인   
- 부서간 효율적인 일정 공유 및 협업 가능

***
## 기본 기능
### 회원관리, 공지사항
~~이미지~~

> - Mybatis
>   - SQL과 Java Dto 객체를 매핑해 데이터베이스 연동
>   - Mapper XML에서 작성된 SQL을 Repository 인터페이스 메서드에 매핑.
>   - Mapper 파일을 통해 CRUD 및 동적 쿼리 실행
> - highcharts
  >   - 전력 사용량을 highcharts 라이브러를 사용하여 시각화
>   - AJAX 요청을 통해 데이터를 주기적으로 가져와 차트에 실시간 추가

---






# 5. Troubleshooting



# 6. 에필로그



