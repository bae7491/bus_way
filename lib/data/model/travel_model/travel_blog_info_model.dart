// 관광지 이름에 대한 네이버 블로그 API 검색 결과 데이터를 담을 모델

class TravelBlogInfoModel {
  String? blogTotalCount; // 총 검색 결과 개수
  String? blogTitle; // 글 제목
  String? blogDescription; // 글 내용
  String? blogUrl; // 블로그 Url 주소
  String? blogName; // 블로그 작성자 이름
  String? blogPostDate; // 블로그 작성일

  TravelBlogInfoModel({
    this.blogTotalCount,
    this.blogTitle,
    this.blogDescription,
    this.blogUrl,
    this.blogName,
    this.blogPostDate,
  });

  factory TravelBlogInfoModel.fromJson(Map<String, dynamic> json) {
    return TravelBlogInfoModel(
      blogTitle: json['title'] as String?,
      blogDescription: json['description'] as String?,
      blogUrl: json['link'] as String?,
      blogName: json['bloggername'] as String?,
      blogPostDate: json['postdate'] as String?,
    );
  }

  static List<TravelBlogInfoModel> fromJsonList(Map<String, dynamic> json) {
    List<TravelBlogInfoModel> blogList = [];

    String? totalCount = json['total']?.toString();

    if (json['items'] != null) {
      for (var item in json['items']) {
        blogList.add(TravelBlogInfoModel.fromJson(item));
      }
    }

    if (blogList.isNotEmpty) {
      blogList.first.blogTotalCount = totalCount;
    }

    return blogList;
  }
}
