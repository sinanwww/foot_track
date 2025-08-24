import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/view/match/select_page.dart';
import 'package:foot_track/view/player/add_player_page.dart';
import 'package:foot_track/view/team/new_team/team_name_page.dart';
import 'package:foot_track/view/tournament/create%20tournament/add_tour_page%20.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key});

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  ValueNotifier<int> pageIndexNotifier = ValueNotifier(0);
  late CarouselSliderController? carouselController;

  final List<AddItems> addList = [
    AddItems(
      imagePath: "assets/image/player.png",
      label: "Add New Player",
      innerPageBuilder: () => const AddPlayerPage(),
    ),
    AddItems(
      imagePath: "assets/image/team.png",
      label: "Add New Team",
      innerPageBuilder: () => const TeamNamePage(),
    ),
    AddItems(
      imagePath: "assets/image/match.jpg",
      label: "Add New Match",
      innerPageBuilder: () => const SelectPage(),
    ),
    AddItems(
      imagePath: "assets/image/tour.jpg",
      label: "Add New Tournament",
      innerPageBuilder: () => const AddTournamentPage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    carouselController = CarouselSliderController();
  }

  @override
  void dispose() {
    carouselController!.stopAutoPlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ValueListenableBuilder(
      valueListenable: pageIndexNotifier,
      builder: (context, currentIndex, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30.h),

            CarouselSlider(
              items:
                  addList
                      .map(
                        (e) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: GestureDetector(
                            onTap: () {
                              try {
                                Get.to(e.innerPageBuilder());
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Navigation error: $e'),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: AssetImage(e.imagePath),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,

                                      children: [
                                        Text(
                                          e.label,
                                          style: Fontstyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(width: 15.w),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                          size: 30.sp,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
              carouselController: carouselController,
              options: CarouselOptions(
                autoPlayInterval: Duration(seconds: 5),
                onPageChanged: (index, reason) {
                  pageIndexNotifier.value = index;
                },
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                aspectRatio: 2.0,
                initialPage: 0,
                height: screenWidth > 1024 ? 500.h : null,
              ),
            ),
            AnimatedSmoothIndicator(
              activeIndex: currentIndex,
              count: addList.length,
              effect: WormEffect(dotWidth: 10, dotHeight: 10),
              onDotClicked: (index) {
                pageIndexNotifier.value = index;
              },
            ),
          ],
        );
      },
    );
  }
}

class AddItems {
  final String label;
  final String imagePath;
  final Widget Function() innerPageBuilder;

  AddItems({
    required this.imagePath,
    required this.innerPageBuilder,
    required this.label,
  });
}
