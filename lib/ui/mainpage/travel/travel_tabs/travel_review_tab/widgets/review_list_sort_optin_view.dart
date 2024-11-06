import 'package:bus_way/ui/mainpage/travel/travel_detail_viewmodel.dart';
import 'package:flutter/material.dart';

class ReviewListSortOptinView extends StatelessWidget {
  const ReviewListSortOptinView({
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
            viewmodel.toggleTravelReviewSort(0);
          },
          child: Row(
            children: [
              Icon(
                Icons.circle,
                size: 5.0,
                color: viewmodel.travelReviewSortIndex == 0
                    ? Colors.black
                    : Colors.grey,
              ),
              const SizedBox(width: 5),
              Text(
                '별점순',
                style: TextStyle(
                  color: viewmodel.travelReviewSortIndex == 0
                      ? Colors.black
                      : Colors.grey,
                  fontWeight: viewmodel.travelReviewSortIndex == 0
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
            viewmodel.toggleTravelReviewSort(1);
          },
          child: Row(
            children: [
              Icon(
                Icons.circle,
                size: 5.0,
                color: viewmodel.travelReviewSortIndex == 1
                    ? Colors.black
                    : Colors.grey,
              ),
              const SizedBox(width: 5),
              Text(
                '최신순',
                style: TextStyle(
                  color: viewmodel.travelReviewSortIndex == 1
                      ? Colors.black
                      : Colors.grey,
                  fontWeight: viewmodel.travelReviewSortIndex == 1
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
