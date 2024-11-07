class MypagaeUserModel {
  String? email; // 이메일
  String? nickName; // 닉네임

  MypagaeUserModel({
    this.email,
    this.nickName,
  });

  factory MypagaeUserModel.fromJson(dynamic json) {
    return MypagaeUserModel(
      email: json['email'],
      nickName: json['nickName'],
    );
  }
}
