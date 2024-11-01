import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/travel/travel_detail_viewmodel.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/travel_review_tab/travel_blog_list_view.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/travel_review_tab/travel_review_List_view.dart';
import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

class TravelReviewTab extends StatelessWidget {
  const TravelReviewTab({
    super.key,
    required this.viewmodel,
    required this.title,
  });

  final TravelDetailViewModel viewmodel;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: MaterialSegmentedControl(
                  onSegmentTapped: (value) {
                    viewmodel.checkReviewSegmentIndex(value);
                  },
                  children: const {
                    0: Text(
                      "후기",
                      style: TextStyle(fontSize: 16),
                    ),
                    1: Text(
                      "블로그",
                      style: TextStyle(fontSize: 16),
                    ),
                  },
                  verticalOffset: 5.0,
                  horizontalPadding: const EdgeInsets.all(1.0),
                  selectionIndex: viewmodel.reviewCurrentIndex,
                  borderColor: Colors.grey,
                  selectedColor: orchid,
                  unselectedColor: Colors.white,
                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  unselectedTextStyle: const TextStyle(
                    color: orchid,
                  ),
                  borderWidth: 0.7,
                  borderRadius: 32.0,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: IndexedStack(
            index: viewmodel.reviewCurrentIndex,
            children: [
              // 후기 뷰
              travelReviewListView(context, viewmodel),

              // 블로그 뷰
              travelBlogListView(viewmodel, title),
            ],
          ),
        ),
      ],
    );
  }
}
