import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/travel/travel_detail_viewmodel.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/travel_review_tab/widgets/blog_list_sort_option_view.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/travel_review_tab/widgets/blog_paged_list_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget travelBlogListView(TravelDetailViewModel viewmodel, String title) {
  return RefreshIndicator(
    onRefresh: () => Future.sync(
      () => viewmodel.blogPageController.refresh(),
    ),
    backgroundColor: Colors.white,
    color: orchid,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (viewmodel.travelBlogTotalCount != null &&
            viewmodel.travelBlogTotalCount!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '전체 (${NumberFormat('###,###,###,###').format(
                    int.parse(viewmodel.travelBlogTotalCount!),
                  )} 건)',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 5.0),
                BlogListSortOptionsView(
                  viewmodel: viewmodel,
                ),
              ],
            ),
          ),
        if (viewmodel.travelBlogTotalCount == null)
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '전체 (0 건)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 5.0),
              ],
            ),
          ),
        const Divider(),
        BlogPagedListView(
          viewmodel: viewmodel,
        ),
      ],
    ),
  );
}
