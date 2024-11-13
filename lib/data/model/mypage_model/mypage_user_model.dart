class MypageUserModel {
  String? email; // 이메일
  String? nickName; // 닉네임
  String? name; // 이름
  String? phoneNumber; // 전화번호

  MypageUserModel({
    this.email,
    this.nickName,
    this.name,
    this.phoneNumber,
  });

  factory MypageUserModel.fromJson(dynamic json) {
    return MypageUserModel(
      email: json['email'],
      nickName: json['nickName'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
