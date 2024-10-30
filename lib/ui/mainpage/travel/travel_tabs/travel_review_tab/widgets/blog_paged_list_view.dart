import 'package:bus_way/data/model/travel_model/travel_blog_info_model.dart';
import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/travel/travel_detail_viewmodel.dart';
import 'package:bus_way/widget/custom_html_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

class BlogPagedListView extends StatelessWidget {
  const BlogPagedListView({
    super.key,
    required this.viewmodel,
  });

  final TravelDetailViewModel viewmodel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PagedListView<int, TravelBlogInfoModel>(
        pagingController: viewmodel.blogPageController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) => Padding(
            padding: const EdgeInsets.symmetric(
                // horizontal: 15.0,
                ),
            child: Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      viewmodel.launchBlogUrl(item.blogUrl!);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customHtmlWidget(item.blogTitle!),
                          if (item.blogDescription != null &&
                              item.blogDescription != '')
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                padding: const EdgeInsets.all(8.0), // 내부 여백 설정
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey), // 테두리 색상 및 굵기 설정
                                  borderRadius:
                                      BorderRadius.circular(8.0), // 모서리 둥글게 설정
                                  color: Colors.transparent, // 배경색 설정
                                ),
                                child: customHtmlWidget(item.blogDescription!),
                              ),
                            ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Text(
                                  DateFormat("yyyy.MM.dd").format(
                                    DateTime.parse(item.blogPostDate!),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 10.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Icon(
                                  Icons.circle,
                                  size: 3.0,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    item.blogName!,
                                    style: const TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
          noItemsFoundIndicatorBuilder: (context) => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_rounded, // 경고 아이콘
                  size: 50.0, // 아이콘 크기
                  color: Colors.orange, // 아이콘 색상
                ),
                SizedBox(height: 16), // 텍스트와 아이콘 사이 간격
                Text(
                  '여행지의 블로그 글이 없습니다!',
                  style: TextStyle(
                    fontSize: 18, // 텍스트 크기
                    fontWeight: FontWeight.bold, // 텍스트 굵기
                    color: Colors.black, // 텍스트 색상
                  ),
                ),
              ],
            ),
          ),
          firstPageProgressIndicatorBuilder: (context) => const Center(
            child: SpinKitRing(
              color: orchid, // 원하는 색상
              size: 100.0, // 크기 설정
            ),
          ),
          newPageProgressIndicatorBuilder: (context) => const Center(
            child: SpinKitRing(
              color: orchid, // 원하는 색상
              size: 30.0, // 크기 설정
              lineWidth: 5.0,
            ),
          ),
        ),
      ),
    );
  }
}
