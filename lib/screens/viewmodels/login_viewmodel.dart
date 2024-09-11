/* 
  ViewModel -> Model과 View를 연결하는 역할.
  
  - 역할
    1. 상태 관리 / Model의 메서드 호출 -> 데이터 가져옴.
      (login_repository.dart(이름 미정)로 연결.)
    2. notifyListeners 추가 후, 이를 통해 데이터에 업데이트가 있다는 것을 ViewModel이 참조하고 있는 View에 알림.
*/