import 'package:bus_way/ui/mainpage/travel/travel_detail_viewmodel.dart';
import 'package:flutter/material.dart';

class BlogListSortOptionsView extends StatelessWidget {
  const BlogListSortOptionsView({
    super.key,
    required this.viewmodel,
  });

  final TravelDetailViewModel viewmodel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            viewmodel.toggleTravelBlogSort(0);
          },
          child: Row(
            children: [
              Icon(
                Icons.circle,
                size: 5.0,
                color: viewmodel.travelBlogSortIndex == 0
                    ? Colors.black
                    : Colors.grey,
              ),
              const SizedBox(width: 5),
              Text(
                '정확도순',
                style: TextStyle(
                  color: viewmodel.travelBlogSortIndex == 0
                      ? Colors.black
                      : Colors.grey,
                  fontWeight: viewmodel.travelBlogSortIndex == 0
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 15),
        GestureDetector(
          onTap: () {
            viewmodel.toggleTravelBlogSort(1);
          },
          child: Row(
            children: [
              Icon(
                Icons.circle,
                size: 5.0,
                color: viewmodel.travelBlogSortIndex == 1
                    ? Colors.black
                    : Colors.grey,
              ),
              const SizedBox(width: 5),
              Text(
                '최신순',
                style: TextStyle(
                  color: viewmodel.travelBlogSortIndex == 1
                      ? Colors.black
                      : Colors.grey,
                  fontWeight: viewmodel.travelBlogSortIndex == 1
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
