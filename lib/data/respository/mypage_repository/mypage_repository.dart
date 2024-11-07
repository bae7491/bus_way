import 'package:bus_way/data/datasource/mypage_datasource/mypage_local_datasource.dart';
import 'package:bus_way/data/model/mypage_model/mypagae_user_model.dart';

class MypageRepository {
  final MypageLocalDatasource mypageLocalDatasource = MypageLocalDatasource();

  // 로그인 회원 정보 조회
  Future<MypagaeUserModel> getUserInfo() async {
    final userInfo = await mypageLocalDatasource.getUserInfo();
    return userInfo;
  }
}
