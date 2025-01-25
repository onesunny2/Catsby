
/* 📌 작업 순서
 온보딩화면☑️ - API 확인 및 DTO 설계☑️ - NetworkingManager☑️ - UserDefaultsManager☑️ - ViewTransitionManager - (여기까지 하고 다시 생각)
 
 🌱< 필수 안내 사항 >
 1. LaunchScreen 제외 모두 VC 코드 기반
 2. 16 디바이스 시리즈에서는 문제 없도록
 
 🌱< 최근 검색어 기능 >
 1. 내역 유무에 따른 뷰 관리
 2. 앱 삭제 / x 버튼 / 전체 삭제 버튼이 아닌 이상 영구저장 (UserDefaults)
 
 🌱< 좋아요 추가/제거 기능 >
 1. 모든 화면에서 연동 되어 동작해야 함 (UserDefaults)
 
 🌱< 화면 전환 > - enum + Generic 활용해서 화면전환 구현
  1. push: navigationController.push~~
  2. present: 단순 모달화면 띄우기
  3. windowRoot: windowRootVC 교체
 
 🌱< UserDefault 사용 필요한 내용들 > - UserDefaults Manager 싱글톤 클래스 생성 후 extension으로 enum 만들어 관리?
  1. 초기 프로필 설정 완료 유무 (유: 메인화면, 무: 온보딩부터)
  2. 프로필 닉네임, 사진
  3. 설정 완료 누른 날짜
  4. 좋아요 누른 영화 - API의 영화 id랑 매치 예정
  5. 최근 검색어
  ✅ 탈퇴하기 누르면 위 정보 모두 초기화 되도록 + 온보딩 화면으로 전환 - reset 메서드 만들어 사용
 
 🌱< API 사용처 정리 >
  1. Trending API
     - 오늘의 영화: 포스터, 영화 제목, 영화 줄거리 / 영화 20개
  2. Search API
     - 영화 검색: 20개 기준 페이지네이션
  3. Image API
     - 영화 상세화면: 영화 백드롭(최대 5개까지), Poster(포스터 전부 보여주기)
  4. Credit API
     - 영화 상세화면: 줄거리(시놉시스), Cast(캐스트 전부 보여주기)
 
 🌱< API 링크 정리 >
 1. https://api.themoviedb.org/3/trending/movie/day?language=ko-KR&page=1
 2. https://api.themoviedb.org/3/search/movie?query=
 {keyword}&include_adult=false&language=ko-KR&page=1
 3. https://api.themoviedb.org/3/movie/{movieID}/images
 4. https://api.themoviedb.org/3/movie/{movieID}/credits?language=ko-KR
 
 🌱< 1차 완성 후 개선해보고 싶은 부분 >
 1. 현재 네트워크 통신의 statusCode가 중구난방인 것만 찾아서 정리가 안되어서 해당부분 찾아서 알럿창으로 반영
 
 🌱< 의문스러운, 질문하고싶은 부분 >
*/
