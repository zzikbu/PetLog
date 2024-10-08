import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pet_log/components/home_section_header.dart';
import 'package:pet_log/diary/diary_detail_page.dart';
import 'package:pet_log/medical/medical_detail_page.dart';
import 'package:pet_log/medical/medical_home_page.dart';
import 'package:pet_log/palette.dart';
import 'package:pet_log/walk/walk_home_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../diary/diary_home_page.dart';
import '../dummy.dart';
import '../walk/walk_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPetPageIndex = 0;

  final CarouselSliderController _myPetCarouselSliderController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 260,
              color: Palette.mainGreen,
              child: Column(
                children: [
                  SizedBox(height: 68),
                  CarouselSlider(
                    carouselController: _myPetCarouselSliderController,
                    items: dummyPets.map(
                      (pet) {
                        return Builder(
                          builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                print(this.currentPetPageIndex);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 24),
                                decoration: BoxDecoration(
                                  color: Palette.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Palette.lightGray,
                                            width: 0.4,
                                          ),
                                          image: DecorationImage(
                                            image: AssetImage(dummyPets[
                                                    this.currentPetPageIndex]
                                                ['image']!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 30),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'D+2100',
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 22,
                                              color: Palette.black,
                                              letterSpacing: -0.5,
                                            ),
                                          ),
                                          Text(
                                            dummyPets[this.currentPetPageIndex]
                                                ['name']!,
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                              color: Palette.black,
                                              letterSpacing: -0.5,
                                            ),
                                          ),
                                          Text(
                                            '5살 치와와',
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Palette.mediumGray,
                                              letterSpacing: -0.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ).toList(),
                    options: CarouselOptions(
                      initialPage: 0,
                      height: 150,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentPetPageIndex = index;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  AnimatedSmoothIndicator(
                    activeIndex: this.currentPetPageIndex,
                    count: dummyPets.length,
                    effect: JumpingDotEffect(
                      spacing: 6.0,
                      radius: 3.0,
                      dotWidth: 6.0,
                      dotHeight: 6.0,
                      paintStyle: PaintingStyle.fill,
                      strokeWidth: 0,
                      dotColor: Palette.white.withOpacity(0.5),
                      activeDotColor: Palette.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  HomeSectionHeader(
                    title: '산책',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WalkHomePage()),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  dummyPets.isEmpty
                      ? Container(
                          margin: EdgeInsets.only(bottom: 12),
                          height: 70,
                          decoration: BoxDecoration(
                            color: Palette.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Palette.black.withOpacity(0.05),
                                offset: Offset(8, 8),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "산책 기록이 없습니다",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Palette.mediumGray,
                                letterSpacing: -0.4,
                              ),
                            ),
                          ),
                        )
                      : Column(
                          children: List.generate(
                            dummyPets.length > 3
                                ? 3
                                : dummyPets.length, // 최대 3개
                            (index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WalkDetailPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Palette.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Palette.black.withOpacity(0.05),
                                        offset: Offset(8, 8),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 14),
                                      Text(
                                        "2024.08.16 금",
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: Palette.black,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: ListView.builder(
                                          padding: EdgeInsets.only(right: 14),
                                          scrollDirection:
                                              Axis.horizontal, // 수평 스크롤
                                          itemCount: dummyPets.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              width: 36,
                                              height: 36,
                                              margin: EdgeInsets.only(right: 4),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Palette.lightGray,
                                                  width: 0.4,
                                                ),
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    dummyPets[index]['image']!,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                  SizedBox(height: 28),
                  Column(
                    children: [
                      HomeSectionHeader(
                        title: '성장일기',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DiaryHomePage()),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      if (dummyPets.isEmpty)
                        Container(
                          margin: EdgeInsets.only(bottom: 12),
                          height: 70,
                          decoration: BoxDecoration(
                            color: Palette.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Palette.black.withOpacity(0.05),
                                offset: Offset(8, 8),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "성장일기가 없습니다",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Palette.mediumGray,
                                letterSpacing: -0.4,
                              ),
                            ),
                          ),
                        )
                      else
                        Column(
                          children: List.generate(
                            dummyPets.length > 3
                                ? 3
                                : dummyPets.length, // 최대 3개
                            (index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DiaryDetailPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  height: 70,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Palette.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Palette.black.withOpacity(0.05),
                                        offset: Offset(8, 8),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "다같이 애견카페 가서 놀은 날",
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: Palette.black,
                                            letterSpacing: -0.4,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          "2024.08.14",
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Palette.mediumGray,
                                            letterSpacing: -0.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 28),
                  Column(
                    children: [
                      HomeSectionHeader(
                        title: '진료기록',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MedicalHomePage()),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      if (dummyPets.isEmpty)
                        Container(
                          margin: EdgeInsets.only(bottom: 12),
                          height: 70,
                          decoration: BoxDecoration(
                            color: Palette.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Palette.black.withOpacity(0.05),
                                offset: Offset(8, 8),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "진료기록이 없습니다",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Palette.mediumGray,
                                letterSpacing: -0.4,
                              ),
                            ),
                          ),
                        )
                      else
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal, // 수평 스크롤 설정
                          child: Row(
                            children: List.generate(
                              dummyPets.length > 3
                                  ? 7
                                  : dummyPets.length, // 최대 7개
                              (index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MedicalDetailPage(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(right: 12, bottom: 10),
                                    height: 170,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: Palette.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Palette.black.withOpacity(0.05),
                                          offset: Offset(8, 8),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 36,
                                                height: 36,
                                                margin:
                                                    EdgeInsets.only(right: 4),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Palette.lightGray,
                                                    width: 0.4,
                                                  ),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                      dummyPets[index]
                                                          ['image']!,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                dummyPets[index]['name']!,
                                                style: TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: Palette.black,
                                                  letterSpacing: -0.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 18),
                                          Text(
                                            "이틀 째 숨을 거칠게 쉬어서 이틀 째 숨을 거칠게 쉬어서 이틀 째 숨을 거칠게 쉬어서",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                              color: Palette.black,
                                              letterSpacing: -0.5,
                                            ),
                                          ),
                                          SizedBox(height: 18),
                                          Text(
                                            "2024.08.13",
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: Palette.mediumGray,
                                              letterSpacing: -0.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
