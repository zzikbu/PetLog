import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_log/diary/diary_detail_page.dart';
import 'package:pet_log/palette.dart';
import 'package:pet_log/search/search_page.dart';

import '../dummy.dart';
import 'diary_write_page.dart';

class DiaryHomePage extends StatelessWidget {
  const DiaryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        backgroundColor: Palette.background,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          "성장일기",
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Palette.black,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
              child: SvgPicture.asset('assets/icons/ic_magnifier.svg'),
            ),
          ),
        ],
      ),
      body: Scrollbar(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          itemCount: dummyPets.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DiaryDetailPage()),
                );
              },
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    height: 220,
                    decoration: BoxDecoration(
                      // color: Pallete.mainGreen,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Palette.feedBorder,
                        width: 1,
                      ),
                      image: DecorationImage(
                        image: AssetImage(dummyPets[index]['image']!),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Palette.black.withOpacity(0.05),
                          offset: Offset(8, 8),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 20,
                    child: Container(
                      height: 88,
                      decoration: BoxDecoration(
                        color: Palette.white.withOpacity(0.9),
                        border: Border(
                          left: BorderSide(
                            color: Palette.feedBorder,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          right: BorderSide(
                            color: Palette.feedBorder,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          bottom: BorderSide(
                            color: Palette.feedBorder,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: Text(
                                '다같이 애견카페 가서 놀은 날 다같이 애견카페 가서 놀은 날 다같이 애견카페 가서 놀은 날 ',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Palette.black,
                                  letterSpacing: -0.4,
                                ),
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.pets,
                                  color: Palette.darkGray,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '123',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Palette.darkGray,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  width: 1,
                                  height: 10,
                                  color: Palette.mediumGray,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '2024.08.14',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Palette.mediumGray,
                                    letterSpacing: -0.35,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  width: 1,
                                  height: 10,
                                  color: Palette.mediumGray,
                                ),
                                SizedBox(width: 8),
                                SvgPicture.asset(
                                  'assets/icons/ic_unlock.svg',
                                  width: 14,
                                  height: 14,
                                  color: Palette.mediumGray,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DiaryWritePage()),
          );
        },
        backgroundColor: Palette.darkGray,
        elevation: 0, // 그림자 제거
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          Icons.edit,
          color: Palette.white,
        ),
      ),
    );
  }
}
