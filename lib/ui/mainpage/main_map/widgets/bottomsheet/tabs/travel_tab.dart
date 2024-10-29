import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:bus_way/constant/travel_category_constant.dart';
import 'package:bus_way/constant/travel_filter_constant.dart';
import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/main_map/main_map_travel_viewmodel.dart';
import 'package:bus_way/ui/mainpage/main_map/main_map_bus_viewmodel.dart';
import 'package:bus_way/ui/mainpage/main_map/widgets/bottomsheet/tabs/travel_info_card/travel_info_card.dart';
import 'package:chip_list/chip_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TravelTab extends StatelessWidget {
  const TravelTab({
    super.key,
    required this.viewModel,
    required this.scrollController,
  });

  final MainMapViewModel viewModel;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Consumer<MainMapTravelViewModel>(
      builder: (context, travelViewModel, child) {
        return Column(
          children: [
            const SizedBox(height: 20),
            // 관광지 카테고리 설정
            SingleChildScrollView(
              child: ChipList(
                listOfChipIndicesCurrentlySelected: [
                  travelCategory.keys
                      .toList()
                      .indexOf(travelViewModel.setCategoryType!),
                ],
                listOfChipNames: travelCategory.values.toList(), // 항목 리스트
                activeBgColorList: const [orchid], // 선택된 Chip의 배경 색상
                inactiveBgColorList: [
                  Colors.grey.shade300
                ], // 선택되지 않은 Chip의 배경 색상
                activeTextColorList: const [Colors.white], // 선택된 Chip의 텍스트 색상
                inactiveTextColorList: const [
                  Colors.black
                ], // 선택되지 않은 Chip의 텍스트 색상
                style: const TextStyle(fontSize: 16), // 텍스트 스타일
                extraOnToggle: (index) {
                  if (!travelViewModel.isLoading) {
                    travelViewModel.setCategoryIndex(index);
                  }
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // 관광지 총 개수 & 관광지 정렬 드롭다운
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 관광지 총 개수
                  Text(
                    '총 ${travelViewModel.travelTotalCount ?? 0} 개',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  // 관광지 정렬 드롭다운
                  SizedBox(
                    width: 150,
                    child: CustomDropdown<String>(
                      onChanged: (value) {
                        if (!travelViewModel.isLoading) {
                          travelViewModel.setTravelFilterValue(value);
                        }
                      },
                      enabled: !travelViewModel.isLoading ? true : false,
                      items: travelFilter.values.toList(),
                      // 마커를 클릭하면 정렬 값 초기 값으로 설정 / 칩 리스트의 항목을 바꾸면 정렬 값 유지
                      initialItem: travelFilter.values.toList()[travelFilter
                          .keys
                          .toList()
                          .indexOf(travelViewModel.setTravelFilter!)],
                      excludeSelected: false,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(height: 0, thickness: 5, color: paleBlueGray),
            // 관광지 정보 뷰
            TravelInfoCard(
              travelViewModel: travelViewModel,
            ),
          ],
        );
      },
    );
  }
}
