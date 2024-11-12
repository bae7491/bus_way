// 첫 글자와 마지막 글자를 제외한 나머지 *로 마스킹.
String maskNickName(String nickName) {
  final length = nickName.length;

  if (length <= 2) {
    // 닉네임 길이가 2 이하인 경우, 첫 글자만 남기고 '*'로 대체
    return '${nickName[0]}*';
  }

  // 첫 글자와 마지막 글자를 유지하고, 중간 글자를 '*'로 대체
  return '${nickName[0]}${'*' * (length - 2)}${nickName[length - 1]}';
}
