
/* 📌 작업 순서
 ( 나름의 사전 설계 )
 LaunchScreen☑️ - API 확인 및 DTO 설계☑️ - NetworkingManager☑️ - UserDefaultsManager☑️ - ViewTransitionManager☑️
 
 ( 본격적 뷰 작업 시작 )
 < 1페이즈 > 온보딩화면☑️ - 프로필 닉네임 설정 화면☑️ - UserDefaultsManager 정상 작동 확인☑️ - 프로필 이미지 설정 화면☑️
 < 2페이즈 > 탭바컨트롤러☑️ - 오늘의영화(최근검색어X)☑️ - 닉네임 수정화면☑️ - 영화 좋아요 기능☑️ -  오늘의영화(최근검색어O) - 검색결과화면 - 영화상세화면 - 설정화면 - 프로필 수정 모달
 < 3페이즈 >
 
 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
 
 ⚙️ 개발 시 고민되는 부분
 1. 프로토콜을 사용하고 싶은데 어떻게 할 수 있을까? (내가 생각하는 나의 약점 포인트 중 하나)
 - cell이나 viewcontroller에 configure을 강제하는 역할
 - 메서드 말고 프로퍼티적으로 사용 가능한 부분은 없을까?,,,
 
 2. 매번 extension으로 만들던 객체의 설정을 CustomView로 하면 어떻게 될까 -> 어차피 포장지가 다를 뿐 안에 내용은 같으니 해보자
 
 3. 이미지 이름도 직접 String으로 입력하는 것 보다 case 관리를 하는게 나으려나
 
 4. 각 화면에 보이는 Text 들은 보통 어떻게 관리할까 실제 서비스는?
 - 추후 변동 가능성 고려해서 따로 관리가 될까? (1차로 완성하고 나면 도전해보기)
 
 
 ⚙️< 1차 완성 후 개선해보고 싶은 부분 >
 1. 현재 네트워크 통신의 statusCode가 중구난방인 것만 찾아서 정리가 안되어서 해당부분 찾아서 알럿창으로 반영
 2. navigationBackbutton을 커스텀하면 제스쳐로 뒤로가기 적용되지 않는 점 적용시키기
 3. 각 화면에 보이는 고정된 Text들 열거형 내 static let으로 관리해보기
 ㄴ 어차피 앱 시작하면 메모리 내려갈 때까지 보일 애들이니까
 
 4. 텍스트필드에 특수문자 포함되는 영역 로직 변경해보기
 +) 키보드 사용성 개선필수! (탭하면 키보드 사라진다던지)
 
 5. 프로필 설정 중 카메라 symbol 사용 교체
 6. sheet의 인디케이터가 나중에 생기는 부분
 7. 오늘의 영화에서 좋아요 누르면 반짝하는 효과 없애기
 8. 영화 상세화면에서 컬렉션뷰가 위치가 밀려있는 것에 대해
 9. 현재는 고정높이를 주긴 했지만 시놉시스의 내용이 없어도 cast 컬렉션뷰의 높이자체는 고정 사이즈인데 왜 1줄로 나오는지
 
 ⚙️< 의문스러운, 질문하고싶은 부분 >
 1. 탭바가 있을 때 오늘의 영화 하단에 collectionView의 높이를 잡는법
 - layoutSubview로 해결
 2. 왜... 왜 컬렉션뷰 시작점이 밀리는걸까요...
 
 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
 
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
*/
