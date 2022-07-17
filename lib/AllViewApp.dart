import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:cupertino_lists/cupertino_lists.dart';
import './main.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

class AllViewApp extends StatefulWidget {
  const AllViewApp({Key? key}) : super(key: key);

  @override
  State<AllViewApp> createState() => _AllViewAppState();
}

class _AllViewAppState extends State<AllViewApp> {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        home: Scaffold(
            backgroundColor: Color(0xffF2F2F7),
            body: Container(
                child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 80),
                        child: ListView(
                          children: [
                            CupertinoListSection.insetGrouped(
                              children: [
                                CupertinoListTile.notched(
                                  title: Text('배지'),
                                  leading: Image.asset('assets/badgeicon.png', width: 20),
                                  additionalInfo: Text(badgeHave != null ? '${badgeHave}개' : '- 개'),
                                  trailing: CupertinoListTileChevron(),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => BadgeApp()));
                                  }
                                ),
                                CupertinoListTile.notched(
                                    title: Text('앱 제한'),
                                    leading: Image.asset('assets/stricticon.png', width: 30),
                                    additionalInfo: Text('제한된 앱 없음'),
                                    trailing: CupertinoListTileChevron(),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => StrictApp()));
                                    }
                                ),
                              ]
                            ),
                            CupertinoListSection.insetGrouped(
                              children: [
                                CupertinoListTile.notched(
                                    title: Text('설정'),
                                    leading: Image.asset('assets/settingsicon.png', width: 30),
                                    trailing: CupertinoListTileChevron(),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AllApp()));
                                    }
                                ),
                                CupertinoListTile.notched(
                                    title: Text('알림'),
                                    leading: _DummyIcon(Colors.green, Icon(Icons.notifications_rounded, size: 15, color: Colors.white)),
                                    additionalInfo: Text(notifyMe ? '켜짐' : '꺼짐'),
                                    trailing: CupertinoListTileChevron(),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AllApp()));
                                    }
                                ),
                                CupertinoListTile.notched(
                                    title: Text('알림 시간'),
                                    leading: _DummyIcon(Colors.teal, Icon(Icons.access_time_filled_rounded, size: 15, color: Colors.white)),
                                    additionalInfo: Text(notifyMe ? '${notifyHour}:${notifyMin}' : '꺼짐'),
                                    trailing: CupertinoListTileChevron(),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AllApp()));
                                    }
                                ),
                                CupertinoListTile.notched(
                                    title: Text('도전과제 형태'),
                                    leading: _DummyIcon(Colors.indigoAccent, Icon(Icons.check_circle_rounded, size: 15, color: Colors.white)),
                                    additionalInfo: Text('활동'),
                                    trailing: CupertinoListTileChevron(),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AllApp()));
                                    }
                                )
                              ]
                            ),
                            CupertinoListSection.insetGrouped(
                              children: [
                                CupertinoListTile.notched(
                                    title: Text('도전과제 진행'),
                                    leading: _DummyIcon(Color(0xff7497D4), Icon(Icons.run_circle_rounded, size: 15, color: Colors.white)),
                                    trailing: CupertinoListTileChevron(),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChallengeMode()));
                                    }
                                ),
                                CupertinoListTile.notched(
                                    title: Text('기록'),
                                    leading: _DummyIcon(Color(0xff83C7A9), Icon(Icons.edit_rounded, size: 15, color: Colors.white)),
                                    trailing: CupertinoListTileChevron(),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SecondApp()));
                                    }
                                ),
                              ]
                            ),
                            CupertinoListSection.insetGrouped(
                              children: [
                                CupertinoListTile.notched(
                                    title: Text('도전과제 설명'),
                                    leading: _DummyIcon(Colors.grey, Icon(Icons.description_rounded, size: 15, color: Colors.white)),
                                    trailing: CupertinoListTileChevron(),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => thirdInfo(index: dayWeek <= 4 ? dayWeek : 0)));
                                    }
                                ),
                              ]
                            ),
                            CupertinoListSection.insetGrouped(
                              children: [
                                CupertinoListTile.notched(
                                    title: Text('강원중'),
                                    leading: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Color(0xffEFEFEF),
                                      ),
                                      child: Center(child: Text('\u{1F4E2}', style: TextStyle(fontSize: 15))),
                                    ),
                                    trailing: CupertinoListTileChevron(),
                                    onTap: () {
                                    }
                                ),
                                CupertinoListTile.notched(
                                    title: Text('이기용'),
                                    leading: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Color(0xffEFEFEF),
                                      ),
                                      child: Center(child: Text('\u{1F4DD}', style: TextStyle(fontSize: 15))),
                                    ),
                                    additionalInfo: Text('네이버 블로그'),
                                    trailing: CupertinoListTileChevron(),
                                    onTap: () async {
                                      final url = Uri.parse(
                                        'https://blog.naver.com/rldyd0304',
                                      );
                                      if (await canLaunchUrl(url)) {
                                        launchUrl(url);
                                      }
                                      else {
                                        print('페이지를 열 수 없어요.');
                                      }
                                    }
                                ),
                                CupertinoListTile.notched(
                                    title: Text('김태윤'),
                                    leading: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Color(0xffEFEFEF),
                                      ),
                                      child: Center(child: Text('\u{1F528}', style: TextStyle(fontSize: 15))),
                                    ),
                                    additionalInfo: Text('인스타그램'),
                                    trailing: CupertinoListTileChevron(),
                                    onTap: () async {
                                      final url = Uri.parse(
                                        'https://www.instagram.com/kim__tune/',
                                      );
                                      if (await canLaunchUrl(url)) {
                                        launchUrl(url);
                                      }
                                      else {
                                        print('페이지를 열 수 없어요.');
                                      }
                                    }
                                ),
                              ]
                            )
                          ],
                        ),
                      ),
                      Container(
                          child: ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                              child: Row(
                                  children: [
                                    Bounce(
                                        duration: Duration(milliseconds: 100),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                            margin: EdgeInsets.fromLTRB(20, 60, 20, 20),
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: Icon(Icons.navigate_before_rounded, size: 30, color: Colors.black),
                                            )
                                        )
                                    ),
                                    Spacer(),
                                    Container(
                                      margin: EdgeInsets.only(top: 60),
                                        child: Text('모두', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                                    Spacer(),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(20, 60, 20, 0),
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Color(0xffF2F2F7).withOpacity(0),
                                      )
                                    )
                                  ]
                              ),
                            ),
                          )
                      ),
                    ]
                )
            )
        )
    );
  }
}

Widget _DummyIcon(Color _color, Icon _icon) {
  return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: _color,
      ),
      child: Center(child: _icon),
  );
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}