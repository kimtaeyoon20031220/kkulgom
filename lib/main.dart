import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './model.dart';
import './db_test.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';


var AllFontColor = Color(0xff565445);
var AllWidgetRadius = 30.0;
var AllWidgetColor = Color(0xffFFFFF7);
var AllBackgroundColor = Color(0xffF1F1E9);
var AllTonedownColor = Color(0xffE3E3D3);
var backgroundColor = Colors.amber;

var newBadge = false;

var dayList;
var dayListToday;
var dayListAll;
var firstTime = true;

var timeAttack = false;

var todayListCheck = false;
var todayCheck = false; //오늘 기록을 했는지

var todayList = [false, false, false, false, false, false, false, false, false];
var todayListUp = '';
var todayListUpTime = 0;
var todayListName = ['유튜브', '인스타그램', '페이스북', '에브리타임', '낮잠', '늦잠', '멍때림', '딴짓', '야식'];
var todayListNow = false;
var addPoint = false;

var categorylist = [['목 건강 챙기기', true], ['상체 운동', false], ['하체 운동', false]];


var notifyMe = false;
var notifyHour = 8;
var notifyMin = 13;

var time = 0;

var dayWeek = 0;

var todayMemo = [false, false, false];
var emotion = [false, false, false];
var nowemotion = 2;
var todaySame = false;
var badge = 5;
var badgeListIcon = ['badge1.png','badge2.png','badge3.png', 'badge4.png', 'badge5.png', 'badge6.png'];
var badgelist = ['첫 만남', '두 번째 꿀곰', '세 번째 꿀곰', '네 번째 꿀곰', '다섯 번째 꿀곰', '여섯 번째 꿀곰']; //badge title badgelistText = ['첫 꿀곰 기록', '챌린지 첫 경험', '처음으로 돌아본 나', '네번째', '5']; //badge 설명
var badgeHave = 2; //badge를 가지고 있는지
var mytext = '';
bool challengeHow = true;
var challengelistHow = [['7마디 목 관절 마디마디의 유연성을 길러주고 목 주변의 경직된 근육과 안대, 근막을 풀어주며 뇌와 몸 간의 통로를 소통시켜 줍니다.', '가슴과 어깨를 펴고 손을 가슴뼈에 올려 상체를 고정합니다.', '고개를 천천히 한바퀴 돌립니다.', '고개를 옆으로 늘릴 때 꺾지 않고 주먹이 들어갈 정도의 공간을 유지하며 길게 늘려줍니다.'], ['현대인들은 각종 전자기기로 인해 대부분 거북목을 가지고 있습니다. 장기간 거북목을 가진 사람은 목 앞쪽 근육이 짧아져 있습니다. 짧아진 근육이 목을 당겨 자세가 망가지는 악순환을 끊는 데 목 돌리기 운동은 큰 도움을 줍니다.', '가슴과 어깨를 펴고 손을 가슴뼈에 올려 상체를 고정합니다.', '고개를 천천히 동서남북 방향으로 숙여줍니다.', '숙이는 방향의 반대편 목 근육을 이완시킨다는 느낌으로 천천히 늘려줍니다.'], ['Chin tuck 이라고 불리는 이 운동은 목의 아랫부분을 신전시키고 윗부분을 굽히게 만들어 거북목, 일자목으로 인한 통증을 완화하고 자세를 교정하는 데 도움이 됩니다.', '허리를 펴고 어깨를 벌려 양쪽 견갑골을 가볍게 모아줍니다.', '그 상태에서 손가락으로 턱을 가볍게 밀어줍니다.', '턱을 밀 때는 너무 강한 힘을 사용하지 않고 천천히 밀어주어야 하며, 이 자세를 유지합니다.'],
  ['후두하근은 뒤통수 아랫쪽에 4개의 근육으로, 뇌와 가장 가까운 근육이자 머리와 목, 어깨의 연결 근육으로 후두하근이 긴장된다면 자주 두통을 느낄 수 있습니다. 전자기기 이용이 잦은 학생, 직장인이라면 후두하근 마사지를 통해 눈의 피로와 두통을 완화할 수 있습니다.', '올바른 자세로 앉아 턱을 살짝 숙이고 깍지를 껴 엄지 손가락을 뒤통수로 위치시킵니다.', '엄지 손가락으로 뒤통수 아래에서 움푹 들어간 후두하근의 위치를 찾아줍니다.', '눈을 감고 오목한 부위를 20초 간 지긋이 눌러줍니다. 눌러줄 때 턱이 들리지 않아야 합니다.'], ['일반적으로 거북목을 가지고 있는 사람은 가슴 근육이 짧아지고 등 뒤쪽의 근육이 늘어납니다. 목과 등 뒤에 불편감이 느껴질 때 가슴 근육 스트레칭의 효과가 드러납니다.','벽 모서리 공간을 확보합니다.', '벽 모서리에 손을 올리고 어깨와 팔꿈치가 수직이 되도록 손을 올립니다.', '몸을 천천히 앞으로 기울입니다.']];
var challengelist = ['목 돌리기', '목 늘리기', '턱 당기기', '후두하근 마사지', '가슴 근육 스트레칭']; //각 챌린지 별 내용
var challengelistVideo = ['ZC6tKig89nY', 'WXx4960A6CM', 'WXx4960A6CM', 'WXx4960A6CM', 'WXx4960A6CM'];
var challengelistPoint = [10, 20, 40, 30, 50]; //각 챌린지 별 포인트 지급
var challengeListIcon = [Icons.run_circle_rounded, Icons.run_circle_rounded, Icons.run_circle_rounded, Icons.run_circle_rounded, Icons.run_circle_rounded];
var challengeListIconColor = [Colors.green, Colors.green, Colors.green, Colors.green, Colors.green];
var sum = 0;
var successChallenge = []; //완료한 챌린지 인덱스
var successChallengePoint = [];
var answer = Random().nextInt(4);
bool _isChallenge = true; //챌린지 위젯을 메인에 보여줄건지?
bool _nowChallenge = false; //지금 챌린지를 하고 있는지?
bool todayChallenge = false; //오늘의 챌린지를 수행했는지?
bool completeChallenge = false; //오늘의 챌린지를 완료했는지?
var question = ['Google의 첫 CEO는?', 'Linux는 어떤 OS를 뿌리로 두고 있을까요?', 'B2B의 뜻은?', '테스트', '테스트2', '테스트3'];
var questionAnswer = ['래리 페이지', 'Unix', '비지니스 투 비지니스', '테스트', '테스트2', '테스트3'];
var questionChooser = [['아아아', '이이이', 'dkdkdk', '우우우'],['아아아', '이이이', 'dkdkdk', 'shshsh'],['아아아', '이이이', 'wkjfkwj', '우우우'],['아아아', '이이이', 'wkjefle', '우우우'],['아아아', 'fajf', 'ajklfjdl', '우우우'],['sfkalf', '이이이', 'kajljf', '우우우']];
var questionPoint = [10, 20, 30, 20, 10, 20];

var AllTop = [false, false, false];

var CalendarBorder = [Colors.transparent, Color(0xffEFEFEF), AllFontColor];
var CalendarText = [AllFontColor, AllFontColor, AllWidgetColor];
var CalendarFontWeight = [FontWeight.normal, FontWeight.normal, FontWeight.bold];
var BackColor = [Color(0xffF2F2F7), Color(0xffF2F2F7), Color(0xffF2F2F7), Colors.white];
var savedDate = '';
var todayEnter = 1;

var nowHour = 0;

String getToday() {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  var strToday = formatter.format(now);
  return strToday;
}
String getTime() {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('HH:mm');
  var strTime = formatter.format(now);
  return strTime;
}

var year = int.parse(getToday().split('-')[0]);
var month = int.parse(getToday().split('-')[1]);
var day = int.parse(getToday().split('-')[2]);

var challengeNumber = [];
var challengeLen;

var hour = 0;
var timeBlock = 3;
var timeBlockEnter = 0;
var savedTimeBlock = 0;

var timeTitle = [['오늘도 반가워요!\n상쾌한 아침이에요.'], ['새로운 마음으로 도전과제를 해볼까요?'], ['피곤하지는 않나요?\n건강한 하루을 보내보아요.'], ['피곤할 때는 도전과제 한 판!'], ['좋은 저녁이에요.\n좋은 하루 보내셨나요?'], ['하루를 마무리하며 도전해봅시다!'], ['오늘 하루는 어떤가요?\n꿀곰 첫 방문 멘트'], ['도전 과제 한 판 해볼래요?']];
var cardView = [false, false, false, false, false];

Future<void> main() async {
  bool data = await fetchData();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    checkTime();
    loadTime();
    loadChallengeHow();
    loadNotifyMe();
    loadSavedDate();
    loadIsChallenge();
    loadBadgeHave();
    print('저장된 날짜 savedDate: ${savedDate}');
    if (savedDate == getToday()){ //당일 재접속
      setSavedDate();
      print('당일 재접속');
      todaySame = true;
    }
    else { //당일 첫 접속
      setSavedDate();
      print('당일 첫접속');
      todaySame = false;
    }
    if(hour >= 6 && hour < 12)
      timeBlock = 0;
    else if(hour >= 12 && hour < 17)
      timeBlock = 1;
    else
      timeBlock = 2;
    Duration duration = new Duration(seconds: 2);
    Future.delayed(duration, () {
      print('Challenge savedDate: $savedDate');
      if (savedDate == getToday()){ //당일 재접속
        print('당일 재접속-Challenge if');
        loadTodayCheck();
        setChallenge();
      }
      else { //당일 첫접속
        print('당일 첫접속-Challenge else');
        setTodayCheck();
        setChallenge();
        time = 0;
      }
      challengeLen = challengeNumber;
      if(hour >= 6 && hour < 12){
        if (savedTimeBlock == timeBlock) { //시간이 같다면
          if(savedDate != getToday()){ //날짜가 바뀐다면
            _isChallenge = true;
            setIsChallenge();
            timeBlockEnter = 0;
            print('time0 날짜 바뀜');
          }
          timeBlockEnter += 1;
          print('time0 if');
        }
        else { //시간이 다르다면
          timeBlockEnter = 1;
          _isChallenge = true;
          setIsChallenge();
          print('time0 else');
        }
      }
      else if(hour >= 12 && hour < 17) {
        if (savedTimeBlock == timeBlock) {
          if(savedDate != getToday()){ //날짜가 바뀐다면
            _isChallenge = true;
            setIsChallenge();
            timeBlockEnter = 0;
            print('time1 날짜 바뀜');
          }
          timeBlockEnter += 1;
          print('time1 if: $timeBlockEnter');
        } else { //날짜가 안바뀐다면
          timeBlockEnter = 1;
          _isChallenge = true;
          setIsChallenge();
          print('time1 else');
        }
      }
      else {
        if (savedTimeBlock == timeBlock) {
          if(savedDate != getToday()){ //날짜가 바뀐다면
            _isChallenge = true;
            setIsChallenge();
            timeBlockEnter = 0;
            print('time2 날짜 바뀜');
          }
          timeBlockEnter += 1;
          print('time2 if');
        } else {
          _isChallenge = true;
          setIsChallenge();
          timeBlockEnter = 1;
          print('time2 else');
        }
      }
      setTimeBlock();
      setTimeBlockEnter();
      loadIsChallenge();
      Future.delayed(Duration(milliseconds: 400), () {
        print('future checker 실행');
        if(challengeNumber[2] != null){
          FlutterNativeSplash.remove();
        }
      });
      firstTime = false;
    });
  }
  @override
  loadBadgeHave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      badgeHave = prefs.getInt('badgeHave') ?? 0;
    });
    print('loadBadgeHave: ${badgeHave}');
  }
  @override
  setTodayCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      prefs.setBool('todayCheck', false);
      dayWeek = prefs.getInt('dayWeek') ?? 0;
    });
    todayCheck = false;
    print('setTodayCheck-todayCheck: ${todayCheck}');
    print('setTodayCheck-dayWeek: ${dayWeek}');
  }
  @override
  loadTodayCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      todayCheck = prefs.getBool('todayCheck') ?? true;
    });
    print('loadTodayCheck 실행');
    if(todayCheck == false){ //기록 안했다면
      setState((){
        dayWeek = prefs.getInt('dayWeek') ?? 0;
      });
      print('loadTodayCheck>todayCheck==false');
    }
    else { //기록 했다면
      setState((){
        dayWeek = prefs.getInt('dayWeek') ?? 1;
        dayWeek -= 1;
      });
      print('loadTodayCheck>todayCheck==true');
    }
    print('loadTodayCheck: ${todayCheck}');
    print('loadtodayCheck-dayWeek: ${dayWeek}');
  }
  @override
  loadIsChallenge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      _isChallenge = prefs.getBool('isChallenge') ?? _isChallenge;
    });
    print('loadIsChallenge: ${_isChallenge}');
  }
  @override
  loadTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    time = prefs.getInt('time') ?? time;
  }
  @override
  checkTime() {
    hour = int.parse(getTime().split(':')[0]);
    print('hour: $hour');
    loadTimeBlock();
    loadTimeBlockEnter();
  }
  @override
  setIsChallenge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      prefs.setBool('isChallenge', _isChallenge);
      print('setIsChallenge: $_isChallenge');
    });
  }
  @override
  loadTimeBlockEnter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      timeBlockEnter = prefs.getInt('timeBlockEnter') ?? timeBlockEnter;
      print('loadTimeBlockEnter: $timeBlockEnter');
    });
  }
  setTimeBlockEnter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      prefs.setInt('timeBlockEnter', timeBlockEnter);
      print('setTimeBlockEnter: $timeBlockEnter');
    });
  }
  @override
  loadTimeBlock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      savedTimeBlock = prefs.getInt('timeBlock') ?? timeBlock;
      print('loadTimeBlock: $savedTimeBlock');
    });
  }
  @override
  setTimeBlock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      prefs.setInt('timeBlock', timeBlock);
      print('setTimeBlock: $timeBlock');
    });
  }
  @override
  setChallenge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      print('setChallenge Execute');
      print('setChallenge: $savedDate');
      print('setChallenge-todayEnter: ${todayEnter}');
      if (todayEnter > 1) {
        print('setChallenge>todayEnter==${todayEnter}-if.기존 도전과제 불러오기');
        for (var i = 0; i < 3; i++) {
          challengeNumber.add(prefs.getInt('challengeNumber$i'));
          print('setChallenge challengeNumber: ${challengeNumber}');
        }
      }
      else {
        print('setChallenge>todayEnter==${todayEnter}-else.새로운 도전과제 추가');

        if(dayWeek < 5){
          print('setChallenge>dayWeek==${dayWeek}일차 도전과제');
          for(var i = 0; i < 3; i++){
            challengeNumber.add(dayWeek);
          }
        }
        else {
          while (true) {
            // 랜덤으로 번호를 생성해준다.
            var rnd = Random().nextInt(challengelist.length);

            // 만약 리스트에 생성된 번호가 없다면
            if (!challengeNumber.contains(rnd)) {
              challengeNumber.add(rnd);
            }

            // 리스트의 길이가 6이면 while문을 종료한다.
            if (challengeNumber.length == 3) break;
          }
        }
        for(var j = 0; j < 3; j++){
          prefs.setInt('challengeNumber$j', challengeNumber[j]);
        }
        print('setChallenge: ${challengeNumber}');
        print('setChallenge: ${prefs.getInt('challengeNumber1')}');
      }
    });
  }
  @override
  loadChallenge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      for(var i = 0; i < 3; i++){
        challengeNumber[i] = prefs.getInt('challengeNumber$i');
      }
    });
  }
  @override
  setSavedDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      prefs.setString('savedDate', getToday());
      if (savedDate == getToday()){
        todayEnter += 1;
        print('setSavedDate with if: $savedDate');
      }
      else if (savedDate == false){
        todayEnter = 1;
      }
      else {
        todayEnter = 1;
        print('setSavedDate with else: $savedDate');
      }
      prefs.setInt('todayEnter', todayEnter);
    });
  }
  @override
  loadSavedDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      savedDate = prefs.getString('savedDate') ?? 'hello';
      todayEnter = prefs.getInt('todayEnter') ?? 0;
      print('firstapp-loadSavedDate: $savedDate');
    });
  }
  @override
  loadChallengeHow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      challengeHow = prefs.getBool('challengeHow') ?? challengeHow;
      print('loadChallengeHow');
      print('loadchallengeHow: $challengeHow');
    });
  }
  @override
  loadNotifyMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      notifyMe = prefs.getBool('notifyMe') ?? notifyMe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstApp(),
    );
  }
}


Future<bool> fetchData() async {
  bool data = false;
  // Change to API call
  await Future.delayed(Duration(milliseconds: 3000), () {
    data = true;
  });

  return data;
}

class FirstApp extends StatefulWidget {
  const FirstApp({Key? key}) : super(key: key);

  @override
  State<FirstApp> createState() => _FirstAppState();
}





class _FirstAppState extends State<FirstApp> {

  int _currentIndex = 0;
  final List<Widget> _children = [FirstPage(), SecondPage(), ThirdPage(), AboutUs()];

  void _onTap(int index) {
    setState((){
      _currentIndex = index;
      print(_currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Noto_Serif_KR',
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: Scaffold(
        backgroundColor: BackColor[_currentIndex],
        body: _children[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xffEFEFEF), width: 1.0),
              )
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color(0xffFAFAFA),
            selectedItemColor: Colors.black.withOpacity(0.7),
            unselectedItemColor: Color(0xffB1B1B1).withOpacity(0.7),
            selectedFontSize: 13,
            unselectedFontSize: 13,
            currentIndex: _currentIndex,
            onTap: _onTap,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded, size: 25), label: '홈'),
              BottomNavigationBarItem(icon: Icon(Icons.article_rounded, size: 25), label: '기록'),
              BottomNavigationBarItem(icon: Icon(Icons.pending_rounded, size: 25), label: '단계'),
              BottomNavigationBarItem(icon: Icon(Icons.info_rounded, size: 25), label: '우리'),
            ],
          ),
        ),
      ),
    );
  }
}



class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);


  @override
  State<FirstPage> createState() => _FirstPageState();
}


class _FirstPageState extends State<FirstPage> with WidgetsBindingObserver {

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


  @override
  void initState() {
    super.initState();
    print('first page 입장!');
    WidgetsBinding.instance!.addObserver(this);
    _init();
    loadNotifyMe();
    loadIsChallenge();
  }
  @override
  setIsChallenge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      prefs.setBool('isChallenge', _isChallenge);
    });
  }
  @override
  loadIsChallenge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      _isChallenge = prefs.getBool('isChallenge') ?? _isChallenge;
    });
  }

  @override
  loadSavedDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedDate = prefs.getString('savedDate') ?? 'hello, loadSavedDate';
      todayEnter = prefs.getInt('todayEnter') ?? 0;
      print('firstpage-loadSavedDate: ${savedDate}');
    });
  }

  @override
  loadNotifyMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notifyMe = prefs.getBool('notifyMe') ?? notifyMe;
    });
  }

  setNotifyMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print('setNotifyMe: $notifyMe');
      notifyMe ? notifyMe = false : notifyMe = true;
      prefs.setBool('notifyMe', notifyMe);
      print('setNotifyMe');
      print('setNotifyMe: $notifyMe');
    });
  }


  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FlutterAppBadger.removeBadge();
    }
  }

  Future<void> _init() async {
    await _configureLocalTimeZone();
    await _initializeNotification();
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  Future<void> _initializeNotification() async {
    const IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _requestPermissions() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _registerMessage({
    required int hour,
    required int minutes,
    required message,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      '꿀곰',
      message,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          importance: Importance.max,
          priority: Priority.high,
          ongoing: true,
          styleInformation: BigTextStyleInformation(message),
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const IOSNotificationDetails(
          badgeNumber: 1,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  setSavedDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('todayEnter', 1);
      todayEnter = prefs.getInt('todayEnter') ?? 1;
    });
  }
  Future _future() async {
    if(firstTime == true) {
      await Future.delayed(Duration(milliseconds: 2000));
    } // 5초를 강제적으로 딜레이 시킨다.
    else {
      await Future.delayed(Duration(milliseconds: 0));
    }
    return '짜잔!'; // 5초 후 '짜잔!' 리턴
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: ListView(children: [
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(dayWeek < 5 ? 'assets/neck${dayWeek}.jpeg' : 'assets/thirdbackground.jpg'),
                  fit: BoxFit.cover,
                )
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                )
              )
            ),
            Column(
              children: [
                Container(
                    child: Column(children: [
                      Container(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(30, MediaQuery.of(context).size.height*0.13, 30, 0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${timeTitle[timeBlock*2][0]}', style: TextStyle(
                                                color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold)),
                                            Text('', style: TextStyle(fontSize: 6)),
                                            Text('${timeTitle[timeBlock*2+1][0]}',
                                                style: TextStyle(
                                                    color: Colors.white.withOpacity(0.5), fontSize: 15)),
                                            Text('', style: TextStyle(fontSize: 10)),
                                          ],
                                        ),
                                      ]
                                  )
                                ]),
                          )
                      )
                    ])
                ),
                FutureBuilder(
                    future: _future(),
                    builder: (BuildContext context, AsyncSnapshot challengeLen) {
                      if (challengeLen.hasData == false) {
                        return Container(
                            margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(margin:EdgeInsets.only(top: 40, left: 40, right: 40),child: Row(
                                    children: [
                                      Text('오늘의 도전 과제', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AllFontColor)),
                                      Spacer(),
                                      Text('불러오는 중', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AllFontColor)),
                                    ],
                                  )),
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Color(0xffF7F7F7),
                                      ),
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                                      child: Row(children: [
                                        Container(
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: Colors.white,
                                                border: Border.all(width: 1, color: Color(0xffDFDFDF))
                                            ),
                                            child: Center(child: Icon(Icons.wb_twilight_rounded, size: 17, color: Colors.deepOrange))),
                                        SizedBox(width: MediaQuery.of(context).size.width*0.3, child: Text('', style: TextStyle(fontSize: 15, color: timeBlock == 0 ? Colors.blueAccent : Colors.black, fontWeight: timeBlock == 0 ? FontWeight.bold : FontWeight.normal), overflow: TextOverflow.ellipsis, maxLines: 1,)),
                                        Spacer(),
                                        Text('06:00~12:00', style: TextStyle(fontSize: 13, color: Colors.grey)),
                                      ])
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white,
                                      ),
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(top: 5, left: 30, right: 30),
                                      child: Row(children: [
                                        Container(
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: Colors.white,
                                                border: Border.all(width: 1, color: Color(0xffDFDFDF))
                                            ),
                                            child: Icon(Icons.light_mode_rounded, size: 17, color: Colors.amber)),
                                        SizedBox(width: MediaQuery.of(context).size.width*0.3, child: Text('', style: TextStyle(fontSize: 15, color: timeBlock == 1 ? Colors.blueAccent : Colors.black, fontWeight: timeBlock == 1 ? FontWeight.bold : FontWeight.normal), overflow: TextOverflow.ellipsis, maxLines: 1,)),
                                        Spacer(),
                                        Text('12:00~17:00', style: TextStyle(fontSize: 13, color: Colors.grey)),
                                      ])
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Color(0xffF2F2F2),
                                      ),
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(top: 5, left: 30, right: 30, bottom: 40),
                                      child: Row(children: [
                                        Container(
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: Colors.white,
                                                border: Border.all(width: 1, color: Color(0xffDFDFDF))
                                            ),
                                            child: Icon(Icons.dark_mode_rounded, size: 17, color: Colors.indigo)),
                                        SizedBox(width: MediaQuery.of(context).size.width*0.3, child: Text('', style: TextStyle(fontSize: 15, color: timeBlock == 2 ? Colors.blueAccent : Colors.black, fontWeight: timeBlock == 2 ? FontWeight.bold : FontWeight.normal), overflow: TextOverflow.ellipsis, maxLines: 1,)),
                                        Spacer(),
                                        Text('17:00~06:00', style: TextStyle(fontSize: 13, color: Colors.grey,)),
                                      ])
                                  ),
                                ])
                        );
                      }
                      else if (challengeLen.hasError) {
                        return Text('에러');
                      }
                      else {
                        return Column(
                          children: [
                            WidgetChallenge(),
                            Bounce(
                              duration: Duration(milliseconds: 100),
                              child: Container(
                                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Colors.white,
                                          Colors.grey,
                                          Colors.white,
                                        ]
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0XFF000066).withOpacity(0.03),
                                        blurRadius: 15,
                                        spreadRadius: 10,
                                        offset: const Offset(0, 10),
                                      ),
                                      BoxShadow(
                                        color: Color(0XFF000066).withOpacity(0.0165),
                                        blurRadius: 7.5,
                                        spreadRadius: 5,
                                        offset: const Offset(0, 5),
                                      ),
                                      BoxShadow(
                                        color: Color(0XFF000066).withOpacity(0.0095),
                                        blurRadius: 5,
                                        spreadRadius: 2.5,
                                        offset: const Offset(0, 2.5),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                                          child: Stack(
                                            children: [
                                              Container(
                                                  color: Colors.black.withOpacity(0.3),
                                                  padding: EdgeInsets.fromLTRB(30, 25, 30, 25),
                                                  child: Row(children: [
                                                    Text('${challengelist[challengeNumber[timeBlock]]}', style: TextStyle(color: Colors.white.withOpacity(0), fontWeight: FontWeight.bold, fontSize: 20),),
                                                    Spacer(),
                                                    Text('지금 도전하기', style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0), fontWeight: FontWeight.bold)),
                                                    Icon(Icons.navigate_next_rounded, color: Colors.white.withOpacity(0)),
                                                  ])
                                              ),
                                              Container(
                                                  color: Colors.blueAccent.withOpacity(0.5),
                                                  padding: EdgeInsets.fromLTRB(30, 25, 30, 25),
                                                  child: Row(children: [
                                                    Text('${challengelist[challengeNumber[timeBlock]]}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                                                    Spacer(),
                                                    Text('지금 도전하기', style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.bold)),
                                                    Icon(Icons.navigate_next_rounded, color: Colors.white.withOpacity(0.3)),
                                                  ])
                                              ),
                                            ],
                                          )
                                      )
                                  )
                              ),
                              onPressed: () {
                                if(dayWeek == challengeNumber[0] && dayWeek < 5) {
                                  print('도전과제 오류 없음');
                                  print(answer);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ChallengeMode()),).then((value) {setState(() {});});
                                }
                                else if(dayWeek >= 5) {
                                  print('도전과제 오류 없음, 6주차 이상');
                                  print(answer);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ChallengeMode()),).then((value) {setState(() {});});
                                }
                                else {
                                  print('setChallenge>dayWeek==${dayWeek}일차 도전과제');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ChallengeError())
                                  );
                                }
                              },
                            ),
                            Bounce(
                              duration: Duration(milliseconds: 100),
                              child: Container(
                                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Colors.white,
                                          Colors.grey,
                                          Colors.white,
                                        ]
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0XFF000066).withOpacity(0.03),
                                        blurRadius: 15,
                                        spreadRadius: 10,
                                        offset: const Offset(0, 10),
                                      ),
                                      BoxShadow(
                                        color: Color(0XFF000066).withOpacity(0.0165),
                                        blurRadius: 7.5,
                                        spreadRadius: 5,
                                        offset: const Offset(0, 5),
                                      ),
                                      BoxShadow(
                                        color: Color(0XFF000066).withOpacity(0.0095),
                                        blurRadius: 5,
                                        spreadRadius: 2.5,
                                        offset: const Offset(0, 2.5),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                                          child: Stack(
                                            children: [
                                              Container(
                                                  color: Colors.black.withOpacity(0.3),
                                                  padding: EdgeInsets.fromLTRB(30, 25, 30, 25),
                                                  child: Row(children: [
                                                    Text('${challengelist[challengeNumber[timeBlock]]}', style: TextStyle(color: Colors.white.withOpacity(0), fontWeight: FontWeight.bold, fontSize: 20),),
                                                    Spacer(),
                                                    Text('지금 도전하기', style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0), fontWeight: FontWeight.bold)),
                                                    Icon(Icons.navigate_next_rounded, color: Colors.white.withOpacity(0)),
                                                  ])
                                              ),
                                              Container(
                                                  color: Colors.greenAccent.withOpacity(0.5),
                                                  padding: EdgeInsets.fromLTRB(30, 25, 30, 25),
                                                  child: Row(children: [
                                                    Text('기록하기', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                                                    Spacer(),
                                                    Icon(Icons.navigate_next_rounded, color: Colors.white.withOpacity(0.3)),
                                                  ])
                                              ),
                                            ],
                                          )
                                      )
                                  )
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SecondApp()),
                                );
                                todayListNow = false;
                              },
                            ),
                            Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Column(children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height*0.2,
                                    child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          WidgetBadge(),
                                          WidgetPoint(),
                                          WidgetAll(),
                                        ]),
                                  ),
                                ])
                            ),
                          ],
                        );
                      }
                    }
                ),
              ],
            ),
          ]
        ),

        Container(
          margin: EdgeInsets.only(top: 50),
          padding: EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: AllFontColor, width: 1)),
            color: AllBackgroundColor,
          ),
          child: Column(
            children: [
              Text('테스트 화면\n', style: TextStyle(fontSize: 40, color: AllFontColor, fontWeight: FontWeight.bold),),
              Bounce(
                duration: Duration(milliseconds: 100),
                child: Container(
                    color: AllTonedownColor,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Spacer(),
                        Text('도전과제 에러 발생'),
                        Spacer(),
                      ],
                    )),
                onPressed: () {
                  setState((){
                    if(challengeNumber != null){
                      print('에러 발생!');
                      for(var i = 0; i < 3; i++){
                        challengeNumber[i] = null;
                        challengeNumber[i] = 3;
                      }
                    }
                  });
                },
              ),
              Bounce(
                duration: Duration(milliseconds: 100),
                child: Container(
                    color: AllTonedownColor,
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Spacer(),
                        Text('today'),
                        Spacer(),
                      ],
                    )),
                onPressed: () {
                  setState((){
                    todayEnter = 2;
                  });
                },
              ),
              Bounce(
                duration: Duration(milliseconds: 100),
                child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    padding: EdgeInsets.all(20),
                    color: AllTonedownColor,
                    child: Row(
                      children: [
                        Spacer(),
                        Text('시간 당 Enter 초기화'),
                        Spacer(),
                      ],
                    )),
                onPressed: () {
                  setState((){
                    todayEnter = 1;
                  });
                },
              ),
              Bounce(
                duration: Duration(milliseconds: 100),
                child: Container(
                  padding: EdgeInsets.all(20),
                  color: AllTonedownColor,
                  child: Row(
                    children: [
                      Spacer(),
                      Text('todayMemo'),
                      Spacer(),
                    ],
                  ),
                ),
                onPressed: () {
                  setState((){
                    todayMemo[timeBlock] = false;
                  });
                },
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 30, top: 20, left: 10),
                  child: Row(
                    children: [
                      Image.asset('assets/logo.png', height: 30),
                      Text('$todayEnter'),
                      Spacer(),
                      Text('시간 당 Enter:$timeBlockEnter, '),
                      Text('savedTimeBlock:$savedTimeBlock ?= '),
                      Text('$timeBlock'),
                      Spacer(),
                      Text('time: $time  '),
                    ],
                  )
              ),
              Bounce(
                  duration: Duration(milliseconds: 100),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AllWidgetColor,
                      ),
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Center(
                          child: Text('날짜 재지정', style: TextStyle(fontSize: 20)))
                  ),
                  onPressed: () {
                    setState(() {
                      setSavedDate();
                    });
                  }
              ),
              Bounce(
                  duration: Duration(milliseconds: 100),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AllWidgetColor,
                      ),
                      margin: EdgeInsets.only(top: 15, bottom: 15),
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Center(
                          child: Text('챌린지 생성', style: TextStyle(fontSize: 20)))
                  ),
                  onPressed: () {
                    setState(() {
                      _isChallenge = true;
                      _nowChallenge = false;
                      todayChallenge = false;
                      setIsChallenge();
                    });
                  }
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class WidgetChallenge extends StatefulWidget {
  const WidgetChallenge({Key? key}) : super(key: key);

  @override
  State<WidgetChallenge> createState() => _WidgetChallengeState();
}

class _WidgetChallengeState extends State<WidgetChallenge> {

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(margin:EdgeInsets.only(top: 40, left: 40, right: 40),child: Row(
                children: [
                  Text('오늘의 도전 과제', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AllFontColor)),
                  Spacer(),
                  Text('${dayWeek+1}일차', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AllFontColor)),
                ],
              )),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xffF7F7F7),
              ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: Row(children: [
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    color: Colors.white,
                        border: Border.all(width: 1, color: Color(0xffDFDFDF))
    ),
                        child: Center(child: Icon(Icons.wb_twilight_rounded, size: 17, color: Colors.deepOrange))),
                    SizedBox(width: MediaQuery.of(context).size.width*0.3, child: Text(challengeHow ? '   '+ '${challengelist[challengeNumber[0]]}' : '   '+ '${question[challengeNumber[0]]}', style: TextStyle(fontSize: 15, color: timeBlock == 0 ? Colors.blueAccent : Colors.black, fontWeight: timeBlock == 0 ? FontWeight.bold : FontWeight.normal), overflow: TextOverflow.ellipsis, maxLines: 1,)),
                    Spacer(),
                    Text('06:00~12:00', style: TextStyle(fontSize: 13, color: timeBlock == 0 ? Colors.blueAccent : Colors.grey)),
                  ])
              ),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 5, left: 30, right: 30),
                  child: Row(children: [
                    Container(
                      width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          border: Border.all(width: 1, color: Color(0xffDFDFDF))
                        ),
                        child: Icon(Icons.light_mode_rounded, size: 17, color: Colors.amber)),
                    SizedBox(width: MediaQuery.of(context).size.width*0.3, child: Text(challengeHow ? '   '+ '${challengelist[challengeNumber[1]]}' : '   '+ '${question[challengeNumber[1]]}', style: TextStyle(fontSize: 15, color: timeBlock == 1 ? Colors.blueAccent : Colors.black, fontWeight: timeBlock == 1 ? FontWeight.bold : FontWeight.normal), overflow: TextOverflow.ellipsis, maxLines: 1,)),
                    Spacer(),
                    Text('12:00~17:00', style: TextStyle(fontSize: 13, color: timeBlock == 1 ? Colors.blueAccent : Colors.grey)),
                  ])
              ),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xffF2F2F2),
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 5, left: 30, right: 30, bottom: 40),
                  child: Row(children: [
                    Container(
                      width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          border: Border.all(width: 1, color: Color(0xffDFDFDF))
                        ),
                        child: Icon(Icons.dark_mode_rounded, size: 17, color: Colors.indigo)),
                    SizedBox(width: MediaQuery.of(context).size.width*0.3, child: Text(challengeHow ? '   '+ '${challengelist[challengeNumber[2]]}' : '   '+ '${question[challengeNumber[2]]}', style: TextStyle(fontSize: 15, color: timeBlock == 2 ? Colors.blueAccent : Colors.black, fontWeight: timeBlock == 2 ? FontWeight.bold : FontWeight.normal), overflow: TextOverflow.ellipsis, maxLines: 1,)),
                    Spacer(),
                    Text('17:00~06:00', style: TextStyle(fontSize: 13, color: timeBlock == 2 ? Colors.blueAccent : Colors.grey,)),
                  ])
              ),
            ])
    );
  }
}

class ChallengeError extends StatefulWidget {
  const ChallengeError({Key? key}) : super(key: key);

  @override
  State<ChallengeError> createState() => _ChallengeErrorState();
}

class _ChallengeErrorState extends State<ChallengeError> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
            centerTitle: true,
            leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.pop(context),
                  },
                  child: Icon(Icons.navigate_before, color: AllFontColor, size: 40),
                )
            )
        ),
        body: Row(
          children: [
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Container(
                  width: 130,
                  height: 130,
                  margin: EdgeInsets.only(bottom: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    color: Color(0xffF2F2F2),
                  ),
                  child: Icon(Icons.priority_high_rounded, color: Colors.redAccent, size: 80),
                ),
                Text('도전 과제에 문제가 발생했어요.', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                Text('\n문제를 해결한 후 도전할 수 있어요.', style: TextStyle(color: Colors.grey, fontSize: 17)),
                Spacer(),
                Bounce(
                  duration: Duration(milliseconds: 100),
                  child: Container(
                    padding: EdgeInsets.all(20),
                      margin: EdgeInsets.fromLTRB(50, 0, 50, 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xffF2F2F2),
                      ),
                      child: Text('문제 해결하기', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    for(var i = 0; i < 3; i++){
                      challengeNumber[i] = dayWeek;
                    }
                    for(var j = 0; j < 3; j++){
                      prefs.setInt('challengeNumber$j', challengeNumber[j]);
                    }
                    print(prefs.getInt('challengeNumber1'));
                    print(challengeNumber);
                    Navigator.pop(context);
                  },
                )
              ]
            ),
            Spacer(),
          ],
        )
      ),
    );
  }
}




class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  void initState() {
    super.initState();
    dayListToday = [];
    dayList = [];
    dayListAll = [];
    printMe();
    printMeToday();
  }
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }
  Future<void>printMe() async {
    dayList = await DBHelper().getMemoDate(getToday());
    print("printMe");
    print('daylist: $dayList');
    print(_selectedDay);
  }
  Future<void>printMeToday() async {
    print('printMeToday');
    dayListToday = await DBTMHelper().getMemoDate(getToday());
    print(await 'daylistToday: $dayListToday');
    dayListAll = await DBTHelper().getMemoDate(getToday());
    print(await 'daylistall: $dayListAll');
  }
  Future<void>printMeNext() async {
    dayList = await DBHelper().getMemoDate(_selectedDay);
    print("printMeNext");
  }


  var _selectedDay;
  var _focusedDay = DateTime.now();
  var _calendarFormat = CalendarFormat.week;
  var dayLen;
  var dayTLen;
  var dayALen;



  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child:
        Column(children: [
          Container(
              padding: EdgeInsets.only(bottom: 20, right: 30, left: 30, top: 60),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border(
                  bottom: BorderSide(
                    color: AllFontColor.withOpacity(0.2),
                    width: 1.0,
                  ),
                ),
                color: Colors.white,
              ),
              margin: EdgeInsets.only(bottom: 0, top: 0, left: 0, right: 0),
              child: Column(children: [
                TableCalendar(
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    leftChevronVisible: false,
                    rightChevronVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    headerMargin: EdgeInsets.only(bottom: 30),
                  ),
                  locale: 'ko-KR',
                  focusedDay: _focusedDay,
                  firstDay: DateTime.now().subtract(Duration(days:365*10+2)),
                  lastDay: DateTime.now().add(Duration(days: 365*10+2)),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    setState(() async {
                      dayList = await DBHelper().getMemoDate(_selectedDay.toString().split(' ')[0]);
                      dayListToday = await DBTMHelper().getMemoDate(_selectedDay.toString().split(' ')[0]);
                      dayListAll = await DBTHelper().getMemoDate(_selectedDay.toString().split(' ')[0]);
                      dayLen = dayList;
                      dayTLen = dayListToday;
                      dayALen = dayListAll;
                    });
                  },
                  onPageChanged: (focusedDay){
                    _focusedDay = focusedDay;
                  },
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format){
                    setState((){
                      _calendarFormat = format;
                    });
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, dateTime, _) {
                      return CalendarCellBuilder(context, dateTime, _, 0);
                    },
                    todayBuilder: (context, dateTime, _) {
                      return CalendarCellBuilder(context, dateTime, _, 1);
                    },
                    selectedBuilder: (context, dateTime, _) {
                      return CalendarCellBuilder(context, dateTime, _, 2);
                    },
                  ),
                ),
              ])
          ),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
                      children: [
                        FutureBuilder(
                            future: _future(),
                            builder: (BuildContext context, AsyncSnapshot dayLen) {
                              if (dayLen.hasData == false || dayTLen == null || dayALen == null || dayListToday.length == 0 && dayLen.hasData == false) {
                                return Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.transparent,
                                    ),
                                    child: Column(children: [
                                      Stack(
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                  height: 100,
                                                  margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: Colors.white,
                                                  ),
                                                  child: Row(
                                                      children: [
                                                        Spacer(),
                                                        Text(''),
                                                        Spacer(),
                                                      ]
                                                  )
                                              ),
                                              Container(
                                                  height: 100,
                                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: Colors.white.withOpacity(0.7),
                                                  ),
                                                  child: Row(
                                                      children: [
                                                        Spacer(),
                                                        Text(''),
                                                        Spacer(),
                                                      ]
                                                  )
                                              ),
                                              Container(
                                                  height: 100,
                                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: Colors.white.withOpacity(0.4),
                                                  ),
                                                  child: Row(
                                                      children: [
                                                        Spacer(),
                                                        Text(''),
                                                        Spacer(),
                                                      ]
                                                  )
                                              ),
                                            ],
                                          ),
                                          Center(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: Color(0xffe6eef7).withOpacity(1),
                                              ),
                                              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.2),
                                              padding: EdgeInsets.all(30),
                                              width: MediaQuery.of(context).size.width*0.6,
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        width: 70,
                                                        height: 70,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(75),
                                                          color: Color(0xffFFFFFF),
                                                        ),
                                                        child: Center(child: Icon(Icons.calendar_today_rounded, size: 30, color: Colors.blueAccent))),
                                                    Text(' ', style: TextStyle(fontSize: 20)),
                                                    Text('날짜를 선택해주세요', style: TextStyle(color: Color(0xff4c4e52), fontSize: 15, fontWeight: FontWeight.bold)),
                                                  ]
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ])
                                );
                              }
                              else if (dayLen.hasError) {
                                return Text('에러');
                              }
                              else {
                                return Container(
                                    child: Column(children: [
                                      if(dayListToday.length != 0)
                                        Container(
                                          margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.doorbell_rounded, color: Colors.blueAccent, size: 20),
                                                  Text(' 오늘 기록', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 15)),
                                                  Spacer(),
                                                ],
                                              ),
                                              Text('', style: TextStyle(fontSize: 15)),
                                              Text(dayListToday[0].memo, style: TextStyle(fontSize: 17, letterSpacing:1, wordSpacing: 1, height: 1.2)),
                                              Container(
                                                  margin: EdgeInsets.only(top: 20),
                                                  child: Wrap(
                                                      children: [
                                                        if(dayListAll.length != 0)
                                                          if(dayListAll[0].memo.toString().length > 1)
                                                            for(var i = dayListAll[0].memo.toString().length - 1; i > 0; i--)
                                                              Container(
                                                                padding: EdgeInsets.all(5),
                                                                margin: EdgeInsets.all(5),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(7),
                                                                  color: Colors.blueAccent.withOpacity(0.1),
                                                                ),
                                                                child: Text('# ' + todayListName[int.parse(dayListAll[0].memo.toString().substring(i-1, i))], style: TextStyle(color: Colors.blueAccent, fontSize: 14)),
                                                              )
                                                        else if(dayListAll[0].memo.toString().length == 1)
                                                          Container(
                                                            padding: EdgeInsets.all(5),
                                                            margin: EdgeInsets.all(5),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(7),
                                                              color: Colors.blueAccent.withOpacity(0.1),
                                                            ),
                                                            child: Text('# ' + todayListName[0], style: TextStyle(color: Colors.blueAccent, fontSize: 14)),
                                                          )
                                                      ]
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                      if(dayList.length != 0)
                                        for(var i = 0; i < dayList.length; i++)
                                          if (dayList[i].memo != null)
                                            Container(
                                                margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                                                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.rectangle,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(children: [
                                                      Container(
                                                          width: 10,
                                                          height: 10,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            color: dayList[i].emotion == 0 ? Colors.redAccent : dayList[i].emotion == 1 ? Colors.amber : dayList[i].emotion == 2 ? Colors.green : Colors.grey,
                                                          )
                                                      ),
                                                      Container(
                                                          width: MediaQuery.of(context).size.width*0.5,
                                                          child: Text('  '+dayList[i].title + ' ', style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis))),
                                                      Spacer(),
                                                      Text(' ' + '${dayList[i].time}', style: TextStyle(color: Colors.grey, fontSize: 15)),
                                                    ]),
                                                    Container(
                                                        margin: EdgeInsets.only(top: 20),
                                                        child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text('소감', style: TextStyle(color: Colors.grey, fontSize: 15)),
                                                              Text('', style: TextStyle(fontSize: 5)),
                                                              Text('${dayList[i].memo}', style: TextStyle(color: Colors.black, fontSize: 17)),
                                                            ])
                                                    )
                                                  ],
                                                ))
                                          else
                                            Container(
                                                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                                margin: EdgeInsets.only(top: 15, right: 20, left: 20),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.rectangle,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Row(children: [
                                                  Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Container(
                                                      width: MediaQuery.of(context).size.width*0.5,
                                                      child: Text('  '+dayList[i].title + ' ', style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis))),                                    Spacer(),
                                                  Text(' ' + '${dayList[i].time}', style: TextStyle(color: Colors.grey, fontSize: 15)),
                                                ]))
                                      else
                                        Container(
                                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              color: Colors.transparent,
                                            ),
                                            child: Column(children: [
                                              Stack(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        height: 100,
                                                        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(10),
                                                          color: Colors.white,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Spacer(),
                                                            Text(''),
                                                            Spacer(),
                                                          ]
                                                        )
                                                      ),
                                                      Container(
                                                          height: 100,
                                                          margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            color: Colors.white.withOpacity(0.7),
                                                          ),
                                                          child: Row(
                                                              children: [
                                                                Spacer(),
                                                                Text(''),
                                                                Spacer(),
                                                              ]
                                                          )
                                                      ),
                                                      Container(
                                                          height: 100,
                                                          margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            color: Colors.white.withOpacity(0.4),
                                                          ),
                                                          child: Row(
                                                              children: [
                                                                Spacer(),
                                                                Text(''),
                                                                Spacer(),
                                                              ]
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                  Center(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        color: Color(0xfff5eae9).withOpacity(1),
                                                      ),
                                                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.2),
                                                      padding: EdgeInsets.all(30),
                                                      width: MediaQuery.of(context).size.width*0.6,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                              width: 70,
                                                              height: 70,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(75),
                                                                color: Color(0xffFFFFFF),
                                                              ),
                                                              child: Center(child: Icon(Icons.close_rounded, size: 40, color: Colors.redAccent))),
                                                          Text(' ', style: TextStyle(fontSize: 20)),
                                                          Text('도전과제 기록이 없어요', style: TextStyle(color: Color(0xff523A27), fontSize: 15, fontWeight: FontWeight.bold)),
                                                        ]
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ])
                                        )
                                    ])
                                );
                              }
                            }
                        ),
                      ]
                  )
              )
          )
        ])
    );
  }
  Future _future() async {
    await Future.delayed(Duration(milliseconds: 70));
    return "짜잔!";
  }
}


class printChallengeWidget extends StatefulWidget {
  const printChallengeWidget({Key? key}) : super(key: key);

  @override
  State<printChallengeWidget> createState() => _printChallengeWidgetState();
}

class _printChallengeWidgetState extends State<printChallengeWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          if (dayList.length > 0)
            for(var i = 0; i < dayList.length; i++)
              Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xffF7F7F7),
                  ),
                  child: Row(children: [
                    Text(dayList[i].title, style: TextStyle(color: Colors.black, fontSize: 17)),
                    Spacer(),
                    Icon(Icons.monetization_on_rounded, color: Colors.grey, size: 20),
                    Text(' ' + '${dayList[i].point}P', style: TextStyle(color: Colors.grey, fontSize: 15)),
                  ]))
        ]
    );
  }
}




Widget CalendarCellBuilder(BuildContext context, DateTime dateTime, _, int type) {
  String date = DateFormat('dd').format(dateTime);
  return Container(
      padding: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: CalendarBorder[type],
        ),
        child: Center(child: Text('$date', style: TextStyle(color: CalendarText[type], fontSize: 17, fontWeight: CalendarFontWeight[type]))),
      )
  );
}



class ThirdPage extends StatefulWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {

  Future<dynamic> notifyDialog(BuildContext context, int me) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              elevation: 0.0,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Text(challengelist[me], style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),),
                  Spacer(),
                  Bounce(
                    duration: Duration(milliseconds: 100),
                    child: Icon(Icons.close, color: Colors.grey, size: 20),
                    onPressed: () {
                      setState((){
                        Navigator.pop(context);
                      });
                    },
                  )
                ],
              ),
              content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('설명\n', style: TextStyle(color: Colors.grey, fontSize: 15)),
                      Text(challengelistHow[me][0], style: TextStyle(fontSize: 15, height: 1.7)),
                    ]
                  )
              )
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: Column(children: [
            Expanded(
              child: ListView(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height*0.3,
                          decoration: BoxDecoration(
                            color: Color(0xffEFEFEF),
                            image: DecorationImage(
                              image: AssetImage('assets/thirdbackground.jpg'),
                              fit: BoxFit.cover,
                            )
                          ),
                          child: Container(color: Colors.black.withOpacity(0.3)),
                        ),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0XFF000066).withOpacity(0.03),
                                  blurRadius: 15,
                                  spreadRadius: 10,
                                  offset: const Offset(0, 10),
                                ),
                                BoxShadow(
                                  color: Color(0XFF000066).withOpacity(0.0165),
                                  blurRadius: 7.5,
                                  spreadRadius: 5,
                                  offset: const Offset(0, 5),
                                ),
                                BoxShadow(
                                  color: Color(0XFF000066).withOpacity(0.0095),
                                  blurRadius: 5,
                                  spreadRadius: 2.5,
                                  offset: const Offset(0, 2.5),
                                ),
                              ],
    ),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.17, /*left: MediaQuery.of(context).size.width*0.05+40*/),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('${dayWeek + 1}일차', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                                        Text('${getToday().split('-')[0]}년 ${getToday().split('-')[1]}월 ${getToday().split('-')[2]}일', style: TextStyle(color: Colors.white.withOpacity(0.7
                                        ), fontSize: 17))
                                      ],
                                    )),
                                Container(
                                  margin: EdgeInsets.only(top: 30),
                                  width: MediaQuery.of(context).size.width*0.9,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20),
                                      ),
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.fromLTRB(40, 0, 0, 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('\n\n모든 도전과제', style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 17, fontWeight: FontWeight.bold)),
                                      ],
                                    )
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.9,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                    padding: EdgeInsets.only(bottom:50),
                                    child: Column(
                                        children: [
                                          for(var i = 0; i < challengelist.length; i++)
                                            Bounce(
                                              duration: Duration(milliseconds: 100),
                                              child: Container(
                                                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15),
                                                    color: (i+1)%2 == 0 ? Colors.white : Color(0xffF7F7F7),
                                                  ),
                                                  child: Row(
                                                      children: [
                                                        Icon(dayWeek >= i ? dayWeek == i ? Icons.lens : Icons.lock_open : Icons.lock, color: dayWeek >= i ? dayWeek == i ? Colors.indigoAccent.withOpacity(0.5) : Colors.indigoAccent : Colors.grey, size: 13),
                                                        Text('   '),
                                                        Container(
                                                            width: 25,
                                                            height: 25,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5),
                                                              color: dayWeek >= i ? dayWeek == i ? Colors.white : Colors.white : Colors.white,
                                                              border: Border.all(width: 1, color: dayWeek >= i ? dayWeek == i ? Color(0xffDFDFDF) : Color(0xffDFDFDF) : Color(0xffDFDFDF)),
                                                            ),
                                                            child: Center(child: Icon(challengeListIcon[i], color: dayWeek >= i ? dayWeek == i ? Colors.indigoAccent : Colors.indigoAccent : Color(0xffBFBFBF), size: 17))),
                                                        Text('  '+challengelist[i], style: TextStyle(color: dayWeek >= i ? dayWeek == i ? Colors.indigoAccent : Colors.black : Colors.grey, fontSize: 15, fontWeight: dayWeek == i ? FontWeight.bold : FontWeight.normal)),
                                                        Spacer(),
                                                        Text('${i+1}일차', style: TextStyle(color: dayWeek >= i ? dayWeek == i ? Colors.indigoAccent : Colors.black : Colors.grey, fontSize: 13)),
                                                      ]
                                                  )
                                              ),
                                              onPressed: () {
                                                notifyDialog(context, i);
                                              },
                                            ),
                                          Text('\n\n6일차 이후에는 도전과제가 랜덤으로 지정돼요.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                                        ]
                                    )
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 0, bottom: 0),
                                  height:MediaQuery.of(context).size.height*0.4,
                                  color: Colors.transparent,
                                  padding: EdgeInsets.only(),
                                  // 리스트뷰 추가
                                  child: ListView.builder(
                                    // 스크롤 방향 설정. 수평적으로 스크롤되도록 설정
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 5,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Bounce(
                                          duration: Duration(milliseconds: 100),
                                          onPressed: () {
                                            setState((){
                                              cardView[index] ? cardView[index] = false : cardView[index] = true;
                                            });
                                            print(cardView[index]);
                                          },
                                          child: Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.7,
                                            margin: EdgeInsets.fromLTRB(index == 0 ? MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.05 : 10, 20, index == 4 ? MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.15 : 10, 20),
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage('assets/neck${index}.jpeg'),
                                                fit: BoxFit.cover,
                                              ),
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0XFF000066).withOpacity(0.03),
                                                  blurRadius: 15,
                                                  spreadRadius: 10,
                                                  offset: const Offset(0, 10),
                                                ),
                                                BoxShadow(
                                                  color: Color(0XFF000066).withOpacity(0.0165),
                                                  blurRadius: 7.5,
                                                  spreadRadius: 5,
                                                  offset: const Offset(0, 5),
                                                ),
                                                BoxShadow(
                                                  color: Color(0XFF000066).withOpacity(0.0095),
                                                  blurRadius: 5,
                                                  spreadRadius: 2.5,
                                                  offset: const Offset(0, 2.5),
                                                ),
                                              ],
                                            ),
                                            child: cardView[index] ?
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                                                  child: Container(
                                                      padding: EdgeInsets.all(20),
                                                      decoration: BoxDecoration(
                                                        color: Colors.black.withOpacity(0.5),
                                                      ),
                                                      child: AnimatedOpacity(
                                                        duration: Duration(milliseconds: 50),
                                                        opacity: cardView[index] ? 1.0 : 0.0,
                                                        child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Center(
                                                                child: Text(challengelist[index], style: TextStyle(
                                                                    color: Colors.white.withOpacity(0.7),
                                                                    fontSize: 20,
                                                                    fontWeight: FontWeight.bold)),
                                                              ),
                                                              Text('', style: TextStyle(fontSize: 10)),
                                                              Text(challengelistHow[index][0], style: TextStyle(color: Colors.white, fontSize: 15, height: 1.7,),),
                                                            ]
                                                        ),
                                                      ))
                                              ),
                                            ):
                                            Container(
                                              padding: EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                      colors: [
                                                        Colors.black.withOpacity(0.3),
                                                        Colors.black.withOpacity(0.7),
                                                      ]
                                                  )
                                              ),
                                              child:
                                              AnimatedOpacity(
                                                duration: Duration(milliseconds: 50),
                                                opacity: cardView[index] ? 0.0 : 1.0,
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Spacer(),
                                                      Text(challengelist[index], style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold)),
                                                      Text('', style: TextStyle(fontSize: 6)),
                                                      Text(challengelistHow[index][0], style: TextStyle(color: Colors.white, fontSize: 15, height: 1.7,), overflow: TextOverflow.ellipsis, maxLines: 3),
                                                    ]
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05, right: MediaQuery.of(context).size.width*0.05, bottom: 20),
                                    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Colors.white,
    ),
                                    padding: EdgeInsets.only(top: 40, right: 30, left: 30, bottom: 40),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text('카테고리', style: TextStyle(color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.bold, fontSize: 17))),
                                          Text('', style: TextStyle(fontSize: 30)),
                                          for(var i = 0; i < categorylist.length; i++)
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: i % 2 == 0 ? Color(0xffF2F2F2) : Colors.white,
                                              ),
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Text('${i+1}', style: TextStyle(color: Colors.grey, fontSize: 17)),
                                                  Text('  ${categorylist[i][0]}', style: TextStyle(color: Colors.black, fontSize: 15)),
                                                  Spacer(),
                                                  Icon(categorylist[i][1] == true ? Icons.check_circle_rounded : Icons.cancel_rounded, size: 18, color: categorylist[i][1] == true ? Colors.blueAccent : Color(0xffCFCFCF)),
                                                  Text(categorylist[i][1] == true ? '  이용 중   ' : '  추후 오픈', style: TextStyle(color: categorylist[i][1] == true ? Colors.blueAccent : Colors.grey, fontSize: 13)),
                                                ],
                                              ),
                                            )
                                        ]
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                      ]
                    ),
                  ]
              ),
            ),
          ],
        )
    );
  }
}


class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Center(
              child:
              Container(
                  margin: EdgeInsets.only(top: 30),
                  child: ListView(children: [
                    Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('', style: TextStyle(fontSize: 30)),
                              Text('    \u{1F36F} about 꿀곰', style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold)),
                              Container(
                                margin: EdgeInsets.only(top: 70, right: 40, left: 40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('꿀곰의 시작', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                                    Text('', style: TextStyle(fontSize: 15)),
                                    Text('안녕하세요, 꿀곰 프로젝트 팀 입니다! 요즘 거의 대부분의 사람들은 휴대폰 사용으로 본인의 할 일을 못하고 미룬 경험이 몇 번 있을 거예요. 물론 저희 팀원들도 그런 경험이 있었죠.', style: TextStyle(fontSize: 15, height: 2, letterSpacing: 1, wordSpacing: 1.2)),
                                    Text('', style: TextStyle(fontSize: 15)),
                                    Text('꿀곰 팀은 장기간의 코로나 사태로 인해 늘어난 휴대폰 사용시간, 할 일을 못하면서 생기는 무기력증과 우울증 등이 중요한 사회적 문제라고 인식했어요. 그래서 저희 팀은 휴대폰 때문에 생기는 게으름을 방지하기 위한 앱을 만들기로 했답니다.', style: TextStyle(fontSize: 15, height: 2, letterSpacing: 1, wordSpacing: 1.2)),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 50, right: 40, left: 40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('꿀곰은 어떤 서비스를 하나요?', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                                    Text('', style: TextStyle(fontSize: 15)),
                                    Text('꿀곰은 휴대폰 제한 사용 시간 도달 시 알람을 통해 자신이 수행할 도전 과제를 제공해 중독을 방지하고 게으름 악순환의 과정을 끊을 수 있도록 도움을 주는 서비스를 제공해요. 지속적으로 업데이트를 진행하여 더 많은 도전 과제와 다양한 기능을 추가할 예정입니다!', style: TextStyle(fontSize: 15, height: 2, letterSpacing: 1, wordSpacing: 1.2)),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 50, right: 40, left: 40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('캐릭터 소개', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                                    Text('', style: TextStyle(fontSize: 15)),
                                    Container(
                                      width: 261,
                                      height: 131,
                                      decoration:BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(width: 0.5, color: Colors.black.withOpacity(0.1)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 130,
                                            height: 130,
                                            decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                          ),
                                border: Border.all(width: 0.5, color: Colors.black.withOpacity(0.1)),
                                      ),
                                              child: Center(child: Image.asset('assets/character.png', height: 100))),
                                          Container(
                                            width: 130,
                                              height: 130,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(20),
                                                  bottomRight: Radius.circular(20),
                                                ),
                                                border: Border.all(width: 0.5, color: Colors.black.withOpacity(0.1)),
                                              ),
                                              child: Image.asset('assets/CharacterTime.png', height: 70)),
                                        ],
                                      ),
                                    ),
                                    Text('\n꿀곰이', style: TextStyle(fontSize: 20, height: 1.7, letterSpacing: 1.2, wordSpacing: 1.2, fontWeight: FontWeight.bold)),
                                    Text('\n꿀곰이는 누워서 꿀 먹는 것을 좋아하는 게으른 곰이에요. 꿀곰이도 게으르게 누워서 꿀만 먹어 살이 많이 찐 탓인지, 자신의 게으름을 고치고 싶다고 하네요! 꿀곰이와 함께 차근차근 도전 과제를 깨며 게으름을 이겨내 볼까요?', style: TextStyle(fontSize: 15, height: 2, letterSpacing: 1, wordSpacing: 1.2)),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 50, bottom: 30, right: 30, left: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('  팀원', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                                    Text('', style: TextStyle(fontSize: 15)),
                                    Bounce(
                                      duration: Duration(milliseconds: 100),
                                      onPressed: () {},
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0XFF000066).withOpacity(0.03),
                                                blurRadius: 15,
                                                spreadRadius: 10,
                                                offset: const Offset(0, 10),
                                              ),
                                              BoxShadow(
                                                color: Color(0XFF000066).withOpacity(0.0165),
                                                blurRadius: 7.5,
                                                spreadRadius: 5,
                                                offset: const Offset(0, 5),
                                              ),
                                              BoxShadow(
                                                color: Color(0XFF000066).withOpacity(0.0095),
                                                blurRadius: 5,
                                                spreadRadius: 2.5,
                                                offset: const Offset(0, 2.5),
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.all(20),
                                          margin: EdgeInsets.only(top: 20),
                                          child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      child: Column(
                                                        children: [
                                                          Text('\u{1F4E2}', style: TextStyle(fontSize: 30)),
                                                          Text('', style: TextStyle(fontSize: 10)),
                                                          Text('강원중', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                                                          Text('', style: TextStyle(fontSize: 10)),
                                                          Text('가천대학교\n경영학과', style: TextStyle(fontSize: 13, color: Colors.grey)),
                                                        ],
                                                      ),
                                                      width: MediaQuery.of(context).size.width*0.25,
                                                    ),
                                                    SizedBox(
                                                        width: MediaQuery.of(context).size.width*0.5,
                                                        child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text('PM', style: TextStyle(fontSize: 20)),
                                                              Text('_____\n', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                                              Text('하고 싶은 말', style: TextStyle(fontSize: 17))
                                                            ]
                                                        )
                                                    )
                                                  ],
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                )
                                              ]
                                          )
                                      ),
                                    ),
                                    Bounce(
                                      duration: Duration(milliseconds: 100),
                                      onPressed: () {},
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0XFF000066).withOpacity(0.03),
                                                blurRadius: 15,
                                                spreadRadius: 10,
                                                offset: const Offset(0, 10),
                                              ),
                                              BoxShadow(
                                                color: Color(0XFF000066).withOpacity(0.0165),
                                                blurRadius: 7.5,
                                                spreadRadius: 5,
                                                offset: const Offset(0, 5),
                                              ),
                                              BoxShadow(
                                                color: Color(0XFF000066).withOpacity(0.0095),
                                                blurRadius: 5,
                                                spreadRadius: 2.5,
                                                offset: const Offset(0, 2.5),
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.all(20),
                                          margin: EdgeInsets.only(top: 20),
                                          child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      child: Column(
                                                        children: [
                                                          Text('\u{1F4DD}', style: TextStyle(fontSize: 30)),
                                                          Text('', style: TextStyle(fontSize: 10)),
                                                          Text('이기용', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                                                          Text('', style: TextStyle(fontSize: 10)),
                                                          Text('가천대학교\n경영학과', style: TextStyle(fontSize: 13, color: Colors.grey)),
                                                        ],
                                                      ),
                                                      width: MediaQuery.of(context).size.width*0.25,
                                                    ),
                                                    SizedBox(
                                                        width: MediaQuery.of(context).size.width*0.5,
                                                        child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text('기획, 마케팅', style: TextStyle(fontSize: 20)),
                                                              Text('_____\n', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                                              Text('하고 싶은 말', style: TextStyle(fontSize: 17))
                                                            ]
                                                        )
                                                    )
                                                  ],
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                )
                                              ]
                                          )
                                      ),
                                    ),
                                    Bounce(
                                      duration: Duration(milliseconds: 100),
                                      onPressed: () {},
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0XFF000066).withOpacity(0.03),
                                                blurRadius: 15,
                                                spreadRadius: 10,
                                                offset: const Offset(0, 10),
                                              ),
                                              BoxShadow(
                                                color: Color(0XFF000066).withOpacity(0.0165),
                                                blurRadius: 7.5,
                                                spreadRadius: 5,
                                                offset: const Offset(0, 5),
                                              ),
                                              BoxShadow(
                                                color: Color(0XFF000066).withOpacity(0.0095),
                                                blurRadius: 5,
                                                spreadRadius: 2.5,
                                                offset: const Offset(0, 2.5),
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.all(20),
                                          margin: EdgeInsets.only(top: 20),
                                          child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      child: Column(
                                                        children: [
                                                          Text('\u{1F528}', style: TextStyle(fontSize: 30)),
                                                          Text('', style: TextStyle(fontSize: 10)),
                                                          Text('김태윤', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                                                          Text('', style: TextStyle(fontSize: 10)),
                                                          Text('가천대학교\n컴퓨터공학과', style: TextStyle(fontSize: 13, color: Colors.grey)),
                                                        ],
                                                      ),
                                                      width: MediaQuery.of(context).size.width*0.25,
                                                    ),
                                                    SizedBox(
                                                        width: MediaQuery.of(context).size.width*0.5,
                                                        child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text('개발, 디자인', style: TextStyle(fontSize: 20)),
                                                              Text('_____\n', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                                              Text('하고 싶은 말', style: TextStyle(fontSize: 17))
                                                            ]
                                                        )
                                                    )
                                                  ],
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                )
                                              ]
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 50, right: 40, left: 40, bottom: 100),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('팀 블로그', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                                        Spacer(),
                                        Bounce(
                                            duration: Duration(milliseconds: 100),
                                            onPressed: () async {
                                              final url = Uri.parse(
                                                'https://waytogo2.tistory.com/',
                                              );
                                              if (await canLaunchUrl(url)) {
                                                launchUrl(url);
                                              }
                                              else {
                                                print('페이지를 열 수 없어요.');
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Color(0xffF2F2F2),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text('팀 블로그 구경가기', style: TextStyle(color: Colors.black, fontSize: 15)),
                                                  Icon(Icons.navigate_next_rounded, color: Colors.grey, size: 20),
                                                ],
                                              ),
                                            )
                                        )
                                      ],
                                    ),
                                    Text('', style: TextStyle(fontSize: 15)),
                                    Text('꿀곰 프로젝트의 팀 블로그예요. 꿀곰이 만들어지는 과정과 꿀곰에 들어간 생각이 궁금하시다면 한번 방문해봐요.', style: TextStyle(fontSize: 15, height: 1.7, letterSpacing: 1.1, wordSpacing: 1.2)),
                                  ],
                                ),
                              ),
                              Center(
                                  child: Column(children: [
                                    Text('꿀곰 프로젝트', style: TextStyle(color: Colors.grey, fontSize: 20)),
                                    Text('', style: TextStyle(fontSize: 10)),
                                    Text('가천대학교 TMI 프로젝트 2022', style: TextStyle(color: Colors.grey, fontSize: 15)),
                                    Text('', style: TextStyle(fontSize: 60)),
                                  ])
                              )
                            ])
                    ),
                  ])
              )
          )
      ),
    );
  }
}
class SecondApp extends StatefulWidget {
  const SecondApp({Key? key}) : super(key: key);

  @override
  State<SecondApp> createState() => _SecondAppState();
}

class _SecondAppState extends State<SecondApp> {
  final memoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.grey,
              ),
              backgroundColor: Colors.white,
              elevation: 0.0,
              centerTitle: true,
              leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => {
                      Navigator.pop(context),
                    },
                    child: Icon(Icons.navigate_before, color: AllFontColor, size: 40),
                  )
              )
          ),
          body:
          Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(25),
                  child:
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.blueAccent,
                                ),
                                child: Icon(Icons.spoke_rounded, color: Colors.white, size: 30)),
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child:
                              Text('오늘의 게으름을\n선택해주세요.', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        Text('', style: TextStyle(color: Colors.grey, fontSize: 30)),
                        Container(
                          margin: EdgeInsets.only(top: 40),
                          child: Column(
                            children: [
                              GridView.builder(
                                itemCount: 9,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemBuilder: (context, index){
                                  return Bounce(
                                      duration: Duration(milliseconds: 100),
                                      onPressed: () {
                                        setState(() {
                                          todayList[index] ? todayList[index] = false : todayList[index] = true;
                                          print(todayList);
                                        });
                                      },
                                      child: Container(
                                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: todayList[index] ? AllFontColor : Color(0xffF2F2F2),
                                          ),
                                          child: Center(
                                            child: Text(todayListName[index], style: TextStyle(color: todayList[index] ? AllWidgetColor : AllFontColor, fontSize: 17, fontWeight: todayList[index] ? FontWeight.bold : FontWeight.normal),
                                            ),
                                          )
                                      )
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                ),
                Spacer(),
                Container(
                    margin: EdgeInsets.fromLTRB(50, 0, 50, 50),
                    child: Bounce(
                        duration: Duration(milliseconds: 100),
                        onPressed: () {
                          setState((){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => RememberToday()));
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blueAccent,
                          ),
                          padding: EdgeInsets.all(20),
                          child: Row(children:[
                            Text(''),
                            Spacer(),
                            Text('기록하기', style: TextStyle(color: Colors.white, fontSize: 15)),
                            Spacer(),
                            Text(''),
                          ]),
                        )
                    )
                )
              ],
            ),
          ),
        )
    );
  }
}

class RememberToday extends StatefulWidget {
  const RememberToday({Key? key}) : super(key: key);

  @override
  State<RememberToday> createState() => _RememberTodayState();
}

class _RememberTodayState extends State<RememberToday> {
  final memoController = TextEditingController();
  var nowCheck = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                iconTheme: IconThemeData(
                  color: Colors.grey,
                ),
                backgroundColor: Colors.white,
                elevation: 0.0,
                centerTitle: true,
                leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => {
                        Navigator.pop(context),
                      },
                      child: Icon(Icons.navigate_before, color: AllFontColor, size: 30),
                    )
                )
            ),
            body:
            ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: Container(
                  padding: EdgeInsets.all(25),
                  child: ListView(children: [
                    Container(
                        margin: EdgeInsets.only(top: 20, bottom: 40, left: 10),
                        child: Text('오늘 하루를 표현해주세요.', style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold))),
                    Container(
                      height: MediaQuery.of(context).size.height*0.4,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: 20, left: 5, right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Colors.black.withOpacity(0.1)),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '오늘 하루를 기록해주세요.',
                            hintStyle: TextStyle(color: Colors.grey)
                        ),
                        maxLines: null,
                        controller: memoController,
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Wrap(
                            children: <Widget>[
                              for(var i = 0; i < todayList.length; i++)
                                if(todayList[i] == true)
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xffF2F2F2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                                      padding: EdgeInsets.all(10),
                                      child: Text('# ' +todayListName[i], style: TextStyle(color: Colors.grey, fontSize: 15))
                                  )
                            ]),
                      ),
                    ),
                  ])
              ),
            ),
            bottomNavigationBar: Container(
                margin: const EdgeInsets.fromLTRB(50, 0, 50, 50),
                child: Bounce(
                    duration: const Duration(milliseconds: 100),
                    onPressed: () async {
                      var nowTodayList = 0;
                      if(nowCheck == true) {
                        var j = 0;
                        if(memoController.text.length > 0) {
                          for (var i = 0; i < todayList.length; i++) {
                            var equation = 10;
                            if (todayList[i] == true) {
                              for(var t = 0; t < j; t++){
                                equation *= 10;
                                print(equation);
                              }
                              nowTodayList += equation*(i);
                              print(nowTodayList);
                              j++;
                              var getTodays = await DBTHelper().getMemoDate(getToday());
                              print(getTodays);
                            }
                          }
                          DBTHelper().insertToday(Today(
                              id: year * 1000000 +
                                  month * 10000 +
                                  day * 100,
                              memo: nowTodayList,
                              createTime: getToday()));
                          print(await DBTHelper().todays());
                          j = 0;
                          DBTMHelper().insertTodayMemo(TodayMemo(
                            id: year * 1000000 + month * 10000 + day * 100 + j,
                            memo: memoController.text,
                            createTime: getToday(),
                          ));
                          Navigator.popUntil(context, ModalRoute.withName('/'));}
                        else {
                          Duration duration = new Duration(seconds: 3);
                          nowCheck = false;
                          Future.delayed(duration, (){
                            setState((){
                              nowCheck = true;
                            });
                          });
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: nowCheck ? Colors.blueAccent : Color(0xffF2F2F2),
                      ),
                      child: Row(children: [
                        Text(' '),
                        Spacer(),
                        Text(nowCheck ? '기록하기' : '기록해 주세요', style: TextStyle(color: nowCheck ? Colors.white : Colors.grey, fontSize: 17)),
                        Spacer(),
                        Text(' '),
                      ]),
                    )
                )
            )
        )
    );
  }
}


class BadgeApp extends StatelessWidget {
  const BadgeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                leading: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => {
                        Navigator.pop(context),
                      },
                      child: Icon(Icons.navigate_before_rounded, color: AllFontColor, size: 40),
                    )
                )
            ),
            body: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.grey.withOpacity(0),
                          Colors.grey.withOpacity(0.2),
                        ]
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: ListView(children: [
                    Column(children:[
                      Text('', style: TextStyle(fontSize: 30)),
                      Text('활동 배지', style: TextStyle(color: Color(0xff0f1f42), fontSize: 25, fontWeight: FontWeight.bold)),
                      Text('\n도전과제를 통해 배지를 얻을 수 있어요.', style: TextStyle(color: Color(0xff0f1f42).withOpacity(0.5), fontSize: 17)),
                    ]),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: EdgeInsets.only(top: 60),
                      child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 2/3,
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: badgelist.length,
                          itemBuilder: (context, index) {
                            return Container(
                                color: Colors.transparent,
                                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                child: Column(children: <Widget>[
                                  if (badgeHave > index)
                                    Container(
                                      child: Stack(
                                          children: [
                                            Container(
                                                width: 100,
                                                height: 100,
                                                margin: EdgeInsets.only(bottom: 0),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(130),
                                                    gradient: RadialGradient(
                                                      colors: [
                                                        Colors.amber.withOpacity(0.7),
                                                        Colors.amber.withOpacity(0),
                                                      ],
                                                    )
                                                )
                                            ),
                                            Container(
                                                width: 80,
                                                height: 80,
                                                margin: EdgeInsets.only(bottom: 0, left: 10, top: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                        colors: [
                                                          Colors.amber.withOpacity(0.4),
                                                          Colors.amber.withOpacity(0.9),
                                                        ]
                                                    )
                                                )
                                            ),
                                            Container(
                                                width: 70,
                                                height: 70,
                                                margin: EdgeInsets.only(bottom: 0, left: 15, top: 15),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                        colors: [
                                                          Colors.amber.withOpacity(0.4),
                                                          Colors.amber.withOpacity(0.9),
                                                        ]
                                                    ),
                                                    border: Border.all(width: 3, color: Colors.white.withOpacity(0.25))
                                                )
                                            ),
                                            Container(
                                                width: 70,
                                                height: 70,
                                                margin: EdgeInsets.only(bottom: 0, left: 15, top: 15),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    color: Colors.white.withOpacity(0.9),
                                                    border: Border.all(width: 3, color: Colors.amber.withOpacity(0.8))
                                                ),
                                                child: Center(
                                                  child: Image.asset('assets/badge/badge${index+1}.png', width: 50),
                                                )
                                            ),
                                          ]
                                      ),)
                                  else
                                    Container(
                                      child: Stack(
                                          children: [
                                            Container(
                                                width: 100,
                                                height: 100,
                                                margin: EdgeInsets.only(bottom: 0),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(130),
                                                    gradient: RadialGradient(
                                                      colors: [
                                                        Colors.amber.withOpacity(0),
                                                        Colors.amber.withOpacity(0),
                                                      ],
                                                    )
                                                )
                                            ),
                                            Container(
                                                width: 80,
                                                height: 80,
                                                margin: EdgeInsets.only(bottom: 0, left: 10, top: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                        colors: [
                                                          Colors.amber.withOpacity(0.1),
                                                          Colors.amber.withOpacity(0.3),
                                                        ]
                                                    )
                                                )
                                            ),
                                            Container(
                                                width: 70,
                                                height: 70,
                                                margin: EdgeInsets.only(bottom: 0, left: 15, top: 15),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                        colors: [
                                                          Colors.amber.withOpacity(0.1),
                                                          Colors.amber.withOpacity(0.3),
                                                        ]
                                                    ),
                                                    border: Border.all(width: 3, color: Colors.white.withOpacity(0.25))
                                                )
                                            ),
                                            Container(
                                                width: 70,
                                                height: 70,
                                                margin: EdgeInsets.only(bottom: 0, left: 15, top: 15),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    color: Colors.white.withOpacity(0.9),
                                                    border: Border.all(width: 3, color: Colors.amber.withOpacity(0.3))
                                                ),
                                                child: Center(
                                                  child: Image.asset('assets/badge/badge${index+1}.png', width: 50, color: const Color.fromRGBO(255, 255, 255, 0.2),colorBlendMode: BlendMode.modulate),
                                                )
                                            ),
                                          ]
                                      ),),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(badgelist[index], style: TextStyle(color: Color(0xff0f1f42), fontSize: 15, fontWeight: FontWeight.bold)),
                                  )
                                ])
                            );
                          }
                      ),
                    )
                  ],)
              ),
            )
        )
    );
  }
}

//

class StrictApp extends StatefulWidget {
  const StrictApp({Key? key}) : super(key: key);

  @override
  State<StrictApp> createState() => _StrictAppState();
}

class _StrictAppState extends State<StrictApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              leading: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => {
                      Navigator.pop(context),
                    },
                    child: Row(
                      children: [
                        Icon(Icons.navigate_before_rounded, color: AllFontColor, size: 40),
                      ],
                    ),
                  )
              )
          ),
          body: ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: 30),
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ListView(children: [
                  Column(children:[
                    Text('시간 제한', style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold)),
                    Text('\n특정 앱의 사용 시간을 제한할 수 있어요.\n\n\n\n', style: TextStyle(color: Colors.grey, fontSize: 17)),
                  ]),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Color(0xffF2F2F2),
                                ),
                                child: Icon(Icons.priority_high_rounded, color: Colors.redAccent, size: 30)),
                            Text('\n나중에 추가될 기능이에요.', style: TextStyle(fontSize: 15)),
                          ],
                        )),
                  )
                ],)
            ),
          ),
          bottomNavigationBar:Container(
              child: Bounce(
                  duration: Duration(milliseconds: 100),
                  onPressed: () {
                    setState((){
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(50, 0, 50, 50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xffF2F2F2),
                    ),
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Row(children: [
                      Text(' '),
                      Spacer(),
                      Text('제한 시작', style: TextStyle(color: Colors.grey, fontSize: 15)),
                      Spacer(),
                      Text(' '),
                    ]),
                  )
              )
          ),
        )
    );
  }
}
class AllApp extends StatefulWidget {
  const AllApp({Key? key}) : super(key: key);

  @override
  State<AllApp> createState() => _AllAppState();
}

class _AllAppState extends State<AllApp> with WidgetsBindingObserver{
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<dynamic> notifyDialog(BuildContext context) async {

    final HourController = TextEditingController();
    final MinController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              elevation: 0.0,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Center(child: Text('알림 시간 설정', style: TextStyle(color: AllFontColor, fontSize: 20, fontWeight: FontWeight.bold),)),
              content: SingleChildScrollView(
                  child: notifyMe ? Column(
                      children: [
                        Text('24시간 형식으로 입력해야 해요.\n', style: TextStyle(color: AllFontColor, fontSize: 15)),
                        Container(
                            margin: EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1, color: Colors.black.withOpacity(0.1)),
                              color: Color(0xffF7F7F7),
                            ),
                            padding: EdgeInsets.only(left: 10),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '시간',
                                  hintStyle: TextStyle(color: Colors.grey)
                              ),
                              controller: HourController,
                            )
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 20, bottom: 30),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.black.withOpacity(0.1)),
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xffF7F7F7),
                            ),
                            padding: EdgeInsets.only(left: 10),
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '분',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              controller: MinController,
                            )
                        ),
                        Container(
                            child: Bounce(
                                duration: Duration(milliseconds: 100),
                                onPressed: () async {
                                  if (int.parse(HourController.text) >= 0 && int.parse(HourController.text) < 24 && int.parse(MinController.text) >= 0 && int.parse(MinController.text) <= 60){
                                    setState((){
                                      notifyHour = int.parse(HourController.text);
                                      notifyMin = int.parse(MinController.text);
                                      setNotifyTime();
                                    });
                                    await _cancelNotification();
                                    await _requestPermissions();

                                    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
                                    await _registerMessage(
                                      hour: notifyHour,
                                      minutes: notifyMin,
                                      message: '오늘의 꿀곰 챌린지가 있어요!',
                                    );

                                    print(notifyHour);
                                    print(notifyMin);
                                    Navigator.pop(context);
                                  }
                                  else {
                                    Fluttertoast.showToast(
                                      msg: "유효하지 않은 시간이에요.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: AllFontColor,
                                      textColor: AllWidgetColor,
                                    );
                                  }
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.all(15),
                                    child: Row(children: [
                                      Spacer(),
                                      Text('알림 켜기', style: TextStyle(color: Colors.white, fontSize: 15)),
                                      Spacer(),
                                    ])
                                )
                            )
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 15),
                            child: Bounce(
                                duration: Duration(milliseconds: 100),
                                onPressed: () async {
                                  await _cancelNotification();
                                  setNotifyMe();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('알림 끄기', style: TextStyle(fontSize: 15, color: Colors.redAccent)),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.redAccent.withOpacity(0.1),
                                    border: Border.all(width: 1, color: Colors.redAccent.withOpacity(0.1)),
                                  ),
                                  padding: EdgeInsets.all(15),
                                )
                            )
                        ),
                      ]
                  ):
                  Column(
                      children: [
                        Text('알림이 꺼져 있어요.\n', style: TextStyle(color: AllFontColor, fontSize: 15)),
                        Container(
                            child: Bounce(
                              duration: Duration(milliseconds: 100),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blueAccent,
                                  ),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      Text('알림 켜기', style: TextStyle(fontSize: 15, color: Colors.white)),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                await _cancelNotification();
                                await _requestPermissions();

                                final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
                                await _registerMessage(
                                  hour: notifyHour,
                                  minutes: notifyMin,
                                  message: '오늘의 꿀곰 챌린지가 있어요!',
                                );
                                setNotifyMe();
                                Navigator.pop(context);
                              },
                            )
                        ),
                      ]
                  )
              )
          );
        }
    );
  }
  @override
  setNotifyMe () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      print('setNotifyMe: $notifyMe');
      notifyMe ? notifyMe = false : notifyMe = true;
      prefs.setBool('notifyMe', notifyMe);
      print('setNotifyMe');
      print('setNotifyMe: $notifyMe');
    });
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _init();
    loadChallengeHow();
    loadNotifyTime();
  }
  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FlutterAppBadger.removeBadge();
    }
  }

  Future<void> _init() async {
    await _configureLocalTimeZone();
    await _initializeNotification();
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  Future<void> _initializeNotification() async {
    const IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _requestPermissions() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _registerMessage({
    required int hour,
    required int minutes,
    required message,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      '꿀곰',
      message,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          importance: Importance.max,
          priority: Priority.high,
          ongoing: true,
          styleInformation: BigTextStyleInformation(message),
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const IOSNotificationDetails(
          badgeNumber: 1,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
  @override
  setChallengeHow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      challengeHow ? challengeHow = false : challengeHow = true;
      prefs.setBool('challengeHow', challengeHow);
      print('setChallengeHow');
    });
  }
  @override
  loadChallengeHow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      challengeHow = prefs.getBool('challengeHow') ?? challengeHow;
      print('loadChallengeHow');
      print(challengeHow);
    });
  }
  @override
  setNotifyTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      prefs.setInt('notifyHour', notifyHour);
      prefs.setInt('notifyMin', notifyMin);
    });
  }
  @override
  loadNotifyTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      notifyHour = prefs.getInt('notifyHour') ?? notifyHour;
      notifyMin = prefs.getInt('notifyMin') ?? notifyMin;
    });
  }

  Future<dynamic> notifyChallenge(BuildContext context) async {

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              elevation: 0.0,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Row(
                children: [
                  Text('새단장 중이에요', style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),),
                  Spacer(),
                  Bounce(
                    duration: Duration(milliseconds: 100),
                    child: Icon(Icons.close, color: Colors.grey, size: 20),
                    onPressed: () {
                      setState((){
                        Navigator.pop(context);
                      });
                    },
                  )
                ],
              ),
              content: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('도전과제 형태 \'문제\'가 새단장을 준비하고 있어요.\n많은 관심 부탁드립니다!', style: TextStyle(color: Colors.black, fontSize: 15)),
                      ]
                  )
              )
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    print('challengeHow: $challengeHow');
    return MaterialApp(
        home: Scaffold(
          backgroundColor: Color(0xffF2F2F7),
          appBar: AppBar(
            backgroundColor: Color(0xffF2F2F7),
            elevation: 0.0,
            leading: Padding(
                padding: EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.pop(context),
                  },
                  child: Icon(Icons.navigate_before_rounded, color: AllFontColor, size: 40),
                )
            ),
          ),
          body:
          ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: ListView(
                  children: [
                    Text('   설정', style: TextStyle(color: Colors.black, fontSize: 35, fontWeight: FontWeight.bold)),
                    Text('', style: TextStyle(fontSize: 20)),
                    Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        margin: EdgeInsets.only(top: 10, bottom: 20, left: 15, right: 15),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(width: 1, color: Colors.black.withOpacity(0.1))),
                              ),
                              child: Bounce(
                                  duration: Duration(milliseconds: 100),
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Row(children: [
                                      Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(7),
                                            color: Colors.green,
                                          ),
                                          child: Center(child: Icon(Icons.notifications_rounded, color: Colors.white, size: 20))),
                                      Text('   알림', style: TextStyle(color: Colors.black, fontSize: 18)),
                                      Spacer(),
                                      Text(notifyMe ? '켜짐' : '꺼짐', style: TextStyle(color: Colors.grey, fontSize: 15)),
                                      Icon(Icons.navigate_next_rounded, color: AllWidgetColor),
                                    ]),
                                  ),
                                  onPressed: () {}
                              ),
                            ),
                            Bounce(
                              duration: Duration(milliseconds: 100),
                              child: Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Row(children: [
                                  Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: Colors.teal,
                                      ),
                                      child: Center(child: Icon(Icons.watch_later_rounded, color: Colors.white, size: 20))),
                                  Text('   알림 시간', style: TextStyle(color: Colors.black, fontSize: 18)),
                                  Spacer(),
                                  Text(notifyMe ? '${notifyHour}시 ${notifyMin}분' : '꺼져 있음', style: TextStyle(color: Colors.grey, fontSize: 15)),
                                  Icon(Icons.navigate_next_rounded, color: Colors.grey),
                                ]),
                              ),
                              onPressed: () {
                                notifyDialog(context);
                              },
                            ),
                          ],
                        )
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        margin: EdgeInsets.only(top: 5, right: 15, left: 15),
                        child: Column(
                          children: [
                            Row(children: [
                              Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.indigoAccent,
                                  ),
                                  child: Center(child: Icon(Icons.check_circle_rounded, color: Colors.white, size: 20))),
                              Text('   도전과제 형태', style: TextStyle(color: Colors.black, fontSize: 18)),
                              Spacer(),
                              Container(
                                  child: Row(
                                    children: [
                                      Bounce(
                                        duration: Duration(milliseconds: 100),
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          margin: EdgeInsets.only(right: 5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: challengeHow ? Color(0xffDFDFDF) : Colors.transparent,
                                          ),
                                          child: Text('활동', style: TextStyle(color: challengeHow ? Colors.black : Colors.grey, fontSize: 15)),
                                        ),
                                        onPressed: () {
                                          if (challengeHow == false) {
                                            setState(() {
                                              _nowChallenge = false;
                                              setChallengeHow();
                                              print(challengeHow);
                                            });
                                          }
                                        },
                                      ),
                                      Bounce(
                                        duration: Duration(milliseconds: 100),
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: challengeHow ? Colors.transparent : Color(0xffDFDFDF),
                                          ),
                                          child: Text('문제', style: TextStyle(color: challengeHow ? Colors.grey : Colors.black, fontSize: 15)),
                                        ),
                                        onPressed: () {
                                          /*if (challengeHow == true) {
                                            setState(() {
                                              _nowChallenge = false;
                                              setChallengeHow();
                                              print(challengeHow);
                                            });
                                          }*/
                                          notifyChallenge(context);
                                        },
                                      ),
                                    ],
                                  )
                              )
                            ]),
                          ],
                        )
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 25, left: 20, bottom: 5),
                      child: Text('꿀곰 프로젝트 팀', style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Bounce(
                              duration: Duration(milliseconds: 100),
                              child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(width: 1, color: Colors.black.withOpacity(0.1))),
                                  ),
                                  child: Column(children: [
                                    Container(
                                        child: Row(children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7),
                                              border: Border.all(width: 1, color: Colors.black.withOpacity(0.1)),
                                            ),
                                              child: Center(
                                            child: Text('\u{1F4E2}', style: TextStyle(fontSize: 17)),
                                        )
                                          ),
                                          Text('  강원중', style: TextStyle(fontSize: 17)),
                                          Spacer(),
                                          Text('연결', style: TextStyle(color: Colors.grey, fontSize: 15)),
                                          Icon(Icons.navigate_next_rounded, color: Colors.grey),
                                        ])
                                    )
                                  ])
                              ),
                              onPressed: () {},
                            ),
                            Bounce(
                              duration: Duration(milliseconds: 100),
                              child: Container(
                                  padding: EdgeInsets.only(bottom: 10, top: 10),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(width: 1, color: Colors.black.withOpacity(0.1))),
                                  ),
                                  child: Column(children: [
                                    Container(
                                        child: Row(children: [
                                          Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(7),
                                                border: Border.all(width: 1, color: Colors.black.withOpacity(0.1)),
                                              ),
                                              child: Center(
                                                child: Text('\u{1F4DD}', style: TextStyle(fontSize: 17)),
                                              )
                                          ),
                                          Text('  이씨의 길', style: TextStyle(fontSize: 17)),
                                          Spacer(),
                                          Text('네이버 블로그', style: TextStyle(color: Colors.grey, fontSize: 15)),
                                          Icon(Icons.navigate_next_rounded, color: Colors.grey),
                                        ])
                                    )
                                  ])
                              ),
                              onPressed: () async {
                                final url = Uri.parse(
                                  'https://blog.naver.com/rldyd0304',
                                );
                                if (await canLaunchUrl(url)) {
                                  launchUrl(url);
                                }
                                else {
                                  print('페이지를 열 수 없어요.');
                                }
                              },
                            ),
                            Bounce(
                              duration: Duration(milliseconds: 100),
                              child: Container(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                  ),
                                  child: Column(children: [
                                    Container(
                                        child: Row(children: [
                                          Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(7),
                                                border: Border.all(width: 1, color: Colors.black.withOpacity(0.1)),
                                              ),
                                              child: Center(
                                                child: Text('\u{1F528}', style: TextStyle(fontSize: 17)),
                                              )
                                          ),
                                          Text('  kim__tune', style: TextStyle(fontSize: 17)),
                                          Spacer(),
                                          Text('인스타그램', style: TextStyle(color: Colors.grey, fontSize: 15)),
                                          Icon(Icons.navigate_next_rounded, color: Colors.grey),
                                        ])
                                    )
                                  ])
                              ),
                              onPressed: () async {
                                final url = Uri.parse(
                                  'https://www.instagram.com/kim__tune/',
                                );
                                if (await canLaunchUrl(url)) {
                                  launchUrl(url);
                                }
                                else {
                                  print('페이지를 열 수 없어요.');
                                }
                              },
                            )
                          ],
                        )
                    )
                  ]
              ),
            ),
          ),
        )
    );
  }
}







class WidgetBadge extends StatelessWidget {
  const WidgetBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.17,
      width: MediaQuery.of(context).size.height*0.17,
      margin: EdgeInsets.only(bottom: 15, right: 10, left: 20),
      child: Bounce(
          duration: Duration(milliseconds: 100),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),

                ),
                padding: EdgeInsets.all(25),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/badgeicon.png', width: 45),
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('배지', style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 17)),
                          Text(' ', style: TextStyle(fontSize: 6)),
                          Text('${badgeHave}개', style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold)),
                        ]),
                  ]),
                ]),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BadgeApp()),);
          }
      ),
    );
  }
}



class WidgetPoint extends StatelessWidget {
  const WidgetPoint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.17,
      width: MediaQuery.of(context).size.height*0.17,
      margin: EdgeInsets.only(bottom: 15, right: 5, left: 5),
      child: Bounce(
          duration: Duration(milliseconds: 100),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),

                ),
                padding: EdgeInsets.all(25),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/stricticon.png', width: 50),
                    ],
                  ),
                  Spacer(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('앱', style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 17)),
                              Text(' ', style: TextStyle(fontSize: 6)),
                              Text('제한', style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold)),
                            ]),
                      ]),
                ]),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StrictApp()),);
          }
      ),
    );
  }
}

class WidgetAll extends StatelessWidget {
  const WidgetAll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height*0.17,
        width: MediaQuery.of(context).size.height*0.1,
        margin: EdgeInsets.only(bottom: 15, left: 10, right: 20),
        child: Bounce(
            duration: Duration(milliseconds: 100),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllApp()),
              ),
            },
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: Center(child:
                Icon(Icons.navigate_next, color: AllFontColor, size: 30),
                )
            )
        )
    );
  }
}



class WidgetImage extends StatelessWidget {
  const WidgetImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Image.asset('assets/rest.jpg'),
    );
  }
}

class MainchallengeButton extends StatefulWidget {
  const MainchallengeButton({Key? key}) : super(key: key);

  @override
  State<MainchallengeButton> createState() => _MainchallengeButtonState();
}

class _MainchallengeButtonState extends State<MainchallengeButton> {

  @override
  setDayWeek() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('dayWeek', dayWeek + 1);
    print('dayWeek + 1');
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Bounce(
        duration: Duration(milliseconds: 100),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AllWidgetColor,
            ),
            padding: EdgeInsets.all(25),
            child: Row(children: [
              Icon(todayChallenge ? completeChallenge ? Icons.monetization_on_rounded : Icons.abc : Icons.verified_rounded, color: todayChallenge ? completeChallenge ? Colors.amber:Colors.redAccent:Colors.amber),
              Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_nowChallenge ? todayChallenge ? completeChallenge ? '오늘의 챌린지를 완수했어요!' : '내일 다시 만나요!': '챌린지에 도전 중이에요!' : '새로운 챌린지가 왔어요!', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        Text(_nowChallenge ?
                        todayChallenge ?
                        completeChallenge ?
                        (challengeHow ? challengelistPoint[challengeNumber[timeBlock]].toString() + 'P를 받았어요.' : questionPoint[challengeNumber[timeBlock]].toString() + 'P를 받았어요.')
                            : '오늘의 챌린지를 완수하지 못했어요...'
                            : (challengeHow ? challengelist[challengeNumber[timeBlock]] : question[challengeNumber[timeBlock]])
                            : (challengeHow ? '챌린지 도전하고 '+challengelistPoint[challengeNumber[timeBlock]].toString()+'포인트 받기'
                            : '챌린지 도전하고 '+questionPoint[challengeNumber[timeBlock]].toString()+'포인트 받기'),
                            style: TextStyle(color: todayChallenge ? completeChallenge ? Colors.amber : Colors.redAccent : Colors.amber, fontSize: 15, fontWeight: FontWeight.bold)),
                      ])
              ),
              Spacer(),
              Icon(Icons.navigate_next, color: Colors.grey),
            ])
        ),
        onPressed: () {
          print(answer);
          setState(() {
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChallengeMode()),
          ).then((value) {
            setState((){});
          });
          todayMemo[timeBlock] = false;
        },

      ),
    );
  }
}


class NewBadgePage extends StatefulWidget {
  const NewBadgePage({Key? key}) : super(key: key);

  @override
  State<NewBadgePage> createState() => _NewBadgePageState();
}

class _NewBadgePageState extends State<NewBadgePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blueAccent.withOpacity(0),
                Color(0xffcad1e3).withOpacity(0.5),
              ]
            )
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Container(
                  child: Text('새로운 배지를 얻었어요!', style: TextStyle(color: Color(0xff0f1f42), fontSize: 25)),
                ),
                Spacer(),
                Stack(
                  children: [
                    Container(
                      width: 250,
                      height: 250,
                      margin: EdgeInsets.only(bottom: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(130),
                        gradient: RadialGradient(
                          colors: [
                            Colors.blueAccent.withOpacity(0.7),
                            Colors.blueAccent.withOpacity(0),
                          ],
                        )
                      )
                    ),
                    Container(
                      width: 200,
                      height: 200,
                        margin: EdgeInsets.only(bottom: 30, left: 25, top: 25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blueAccent.withOpacity(0.4),
                              Colors.blueAccent.withOpacity(0.9),
                            ]
                          )
                        )
                    ),
                    Container(
                        width: 180,
                        height: 180,
                        margin: EdgeInsets.only(bottom: 30, left: 35, top: 35),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.blueAccent.withOpacity(0.4),
                                  Colors.blueAccent.withOpacity(0.9),
                                ]
                            ),
                          border: Border.all(width: 3, color: Colors.white.withOpacity(0.25))
                        )
                    ),
                    Container(
                        width: 150,
                        height: 150,
                        margin: EdgeInsets.only(bottom: 30, left: 50, top: 50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white.withOpacity(0.9),
                          border: Border.all(width: 3, color: Colors.indigo.withOpacity(0.8))
                        ),
                        child: Center(
                        child: Image.asset('assets/badge/badge${badgeHave + 1}.png', width: 120),
                    )
                    ),
                  ]
                ),
                Text('${badgelist[badgeHave]}', style: TextStyle(color: Color(0xff0f1f42), fontSize: 20, fontWeight: FontWeight.bold)),
                Spacer(),
                Bounce(
                  duration: Duration(milliseconds: 100),
                  child: Container(
                    padding: EdgeInsets.all(5),
                      margin: EdgeInsets.fromLTRB(50, 0, 50, 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xff224087),
                      ),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.1),
                          border: Border.all(width: 2, color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Spacer(),
                            Text('받기', style: TextStyle(color: Color(0xffcad1e3), fontSize: 17, fontWeight: FontWeight.bold)),
                            Spacer(),
                          ]
                        ),
                      ),
                    )
                  ),
                  onPressed: () async {
                    badgeHave += 1;
                    print('badgeHave: ${badgeHave}');
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                )
              ]
            ),
          )
        )
      )
    );
  }
}





class ChallengeMode extends StatefulWidget {
  const ChallengeMode({Key? key}) : super(key: key);

  @override
  State<ChallengeMode> createState() => _ChallengeModeState();
}

class _ChallengeModeState extends State<ChallengeMode> {

  var sec = 30000;
  var timeroff = false;
  var timerset = false;

  @override
  timer() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState((){
        sec-=100;
      });
      if(sec < 1000){
        timer.cancel();
        timeroff = true;
      }
    });
  }
  @override
  setDayWeek() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(todayCheck == false) {
      setState(() {
        prefs.setInt('dayWeek', dayWeek + 1);
      });
      print('setDayWeek + 1');
    }
    else {
      print('setDayWeek 그대로');
    }
  }
  @override
  setIsChallenge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      prefs.setBool('isChallenge', _isChallenge);
    });
    print('setIsChallenge: ${prefs.getBool('isChallenge') ?? null}');
  }
  var really = false;
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.white,
            body: WillPopScope(
              child: _isChallenge ?
              challengeHow ?
              _nowChallenge ?
              todayChallenge ?
              Container(
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Center(child: Column(children:[
                    Center(child: Text('')),
                    Spacer(),
                    SizedBox(child: Column(children: [
                      Icon(completeChallenge ? Icons.check_circle_rounded : Icons.abc, color: completeChallenge ? Colors.blueAccent : Colors.redAccent, size: 70),
                      Container(margin: EdgeInsets.only(top: 30), child: Column(children: [
                        Text(completeChallenge ? '도전과제를 완료했어요' : '포인트 획득 실패!', style: TextStyle(color: completeChallenge ? Colors.black : Colors.redAccent, fontSize: 25, fontWeight: FontWeight.bold)),
                        if(completeChallenge == true)
                          Container(
                              margin: EdgeInsets.only(top: 60),
                              child: Container(
                                padding: EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  border: Border.all(width: 1, color: Colors.black.withOpacity(0.1)),
                                ),
                                width: MediaQuery.of(context).size.width*0.8,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(challengelist[challengeNumber[timeBlock]], style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Text('', style: TextStyle(fontSize: 10)),
                                    Text(challengelistHow[challengeNumber[timeBlock]][0], style: TextStyle(color: Colors.grey, fontSize: 15)),
                                  ],
                                ),
                              )),
                      ]
                      )
                      ),
                    ])),
                    Spacer(),
                    Spacer(),
                    Bounce(
                      duration: Duration(milliseconds: 100),
                      child: Container(
                          padding: EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Spacer(),
                            Text('배지 생성'),
                            Spacer(),
                          ]
                        )
                      ),
                      onPressed: () {
                        newBadge = true;
                      }
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20, left: 40, right: 40),
                      child:Bounce(
                        duration: Duration(milliseconds: 100),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: todayMemo[timeBlock] ? Colors.blueAccent : Color(0xffF2F2F2),
                          ),
                          child: Row(children: [
                            Spacer(),
                            Text('확인', style: TextStyle(fontSize: 17, color: todayMemo[timeBlock] ? Colors.white : Colors.black, fontWeight: todayMemo[timeBlock] ? FontWeight.bold : FontWeight.normal)),
                            Spacer(),
                          ]),
                        ),
                        onPressed: () async {
                          print('리워드 받기');
                          setDayWeek();
                          if(newBadge == false){
                            Navigator.pop(context);
                          }
                          else{
                            if(badgeHave < 6) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          NewBadgePage()));
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              setState(() {
                                                prefs.setInt(
                                                    'badgeHave', badgeHave + 1);
                                              });
                                              newBadge = false;
                                            }
                                          }
                          if (todayMemo[timeBlock] == false) {
                            time += 1;
                            setTime();
                            DBHelper().insertMemo(Memo(id: year * 1000000 + month * 10000 + day * 100 + time, title: challengelist[challengeNumber[timeBlock]], point: challengelistPoint[challengeNumber[timeBlock]], createTime: getToday(), time: getTime()));
                            print(await DBHelper().memos());
                            todayMemo[timeBlock] = true;
                            print(todayMemo);
                          }
                          _isChallenge = false;
                          setIsChallenge();
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          setState((){
                            prefs.setBool('todayCheck', true);
                          });
                          },
                      ),
                    ),
                    Bounce(
                      duration: Duration(milliseconds: 100),
                      child: Container(
                          margin: EdgeInsets.fromLTRB(40, 0, 40, 50),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: todayMemo[timeBlock] ? Color(0xffF2F2F2) : Colors.blueAccent,
                          ),
                          child: Row(children:[
                            Text(' '),
                            Spacer(),
                            Column(children: [
                              Text(todayMemo[timeBlock] ? '수정하기' : '기록 하기', style: TextStyle(color: todayMemo[timeBlock] ? Colors.grey : Colors.white, fontSize: 17, fontWeight: todayMemo[timeBlock] ? FontWeight.normal : FontWeight.bold,)),
                              Row(children: [
                                Text(todayMemo[timeBlock] ? '' : '\n추가 경험치를 얻을 수 있어요', style: TextStyle(color: todayMemo[timeBlock] ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.6), fontSize: todayMemo[timeBlock] ? 0 : 13)),
                              ])
                            ]),
                            Spacer(),
                            Text(' '),
                          ])
                      ),
                      onPressed: () {
                        print('리워드 받기');
                        Navigator.push(context,
                            MaterialPageRoute(builder: (builder) => RememberList()));
                      },
                    )
                  ]))
              ) :
                  timeAttack ?
                  Column(
                    children: [
                      Stack(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height*0.4,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/neck${challengeNumber[timeBlock]}.jpeg'),
                                    fit: BoxFit.cover,
                                  ),
                                )
                            ),
                            Center(
                              child: Container(
                                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.17,),
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.black.withOpacity(0.3),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0XFF000066).withOpacity(0.03),
                                          blurRadius: 15,
                                          spreadRadius: 10,
                                          offset: const Offset(0, 10),
                                        ),
                                        BoxShadow(
                                          color: Color(0XFF000066).withOpacity(0.0165),
                                          blurRadius: 7.5,
                                          spreadRadius: 5,
                                          offset: const Offset(0, 5),
                                        ),
                                        BoxShadow(
                                          color: Color(0XFF000066).withOpacity(0.0095),
                                          blurRadius: 5,
                                          spreadRadius: 2.5,
                                          offset: const Offset(0, 2.5),
                                        ),
                                      ]
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                                      child: Container(
                                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.17,),
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                  )
                              ),
                            ),
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.17,),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(75),
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                                child: Center(child: timeroff ? Icon(Icons.check_rounded, color: Colors.white, size: 50) : Text('${sec~/1000}', style: TextStyle(color: (sec~/1000) <= 5 ? (sec~/1000) < 1 ? Colors.white : Colors.redAccent : Colors.white, fontSize: 50))),),
                            ),
                            Bounce(
                              duration: Duration(milliseconds: 100),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                  margin: EdgeInsets.only(top: 50, left: 30),
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey.withOpacity(1),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0XFF000066).withOpacity(0.03),
                                          blurRadius: 15,
                                          spreadRadius: 10,
                                          offset: const Offset(0, 10),
                                        ),
                                        BoxShadow(
                                          color: Color(0XFF000066).withOpacity(0.0165),
                                          blurRadius: 7.5,
                                          spreadRadius: 5,
                                          offset: const Offset(0, 5),
                                        ),
                                        BoxShadow(
                                          color: Color(0XFF000066).withOpacity(0.0095),
                                          blurRadius: 5,
                                          spreadRadius: 2.5,
                                          offset: const Offset(0, 2.5),
                                        ),
                                      ]
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                                      child: Center(
                                        child: Icon(Icons.navigate_before_rounded, color: Colors.white, size: 30),
                                      )
                                    ),
                                  )
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.4-20),
                              height: 20,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  color: Colors.white,
                                ),
                            )
                          ]),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Container(
                            padding: EdgeInsets.fromLTRB(50, 20, 50, 0),
                            child: Center(child: Column(children:[
                              SizedBox(child: Column(children: [
                                Container(margin: EdgeInsets.only(top: 0), child: Column(children: [
                                  Text(challengelist[challengeNumber[timeBlock]], style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold)),
                                  Text('', style: TextStyle(fontSize: 10)),
                                  Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: Colors.blueAccent.withOpacity(0.1),
                                      ),
                                      child: Text('# ${categorylist[0][0]}', style: TextStyle(color: Colors.blueAccent, fontSize: 17))
                                  ),
                                  Text('', style: TextStyle(fontSize: 6)),
                                  Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Text(challengelistHow[challengeNumber[timeBlock]][0], style: TextStyle(color: Colors.grey, fontSize: 15, letterSpacing: 1.2, wordSpacing: 1.2, height: 1.2))),
                                ]
                                )
                                ),
                              ])),
                              Bounce(
                                  duration: Duration(milliseconds: 100),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => ChallengeTip()));
                                  },
                                  child: Container(
                                    child:
                                    Icon(Icons.lightbulb_rounded, color: Colors.orange, size: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.orange.withOpacity(0.1),
                                    ),
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(top: 40),
                                  )
                              ),
                              Spacer(),
                              Spacer(),
        Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Bounce(
                    duration: Duration(milliseconds: 100),
                    onPressed: () {
                      print('포기하기');
                      if (really == true) {
                        setState((){
                          _nowChallenge = false;
                          _isChallenge = false;
                          setIsChallenge();
                          Navigator.pop(context);
                        });
                      }
                      else {
                        setState((){
                          Duration duration = new Duration(seconds: 3);
                          really = true;
                          Future.delayed(duration, (){
                            setState((){
                              really = false;
                            });
                          });
                        });
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.redAccent.withOpacity(really ? 1 : 0.07),
                        ),
                        padding: EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width*0.35,
                        margin: EdgeInsets.only(bottom: 50),
                        child: Center(child: Text(really ? '정말 포기하기':'포기하기', style: TextStyle(color: really ? Colors.white : Colors.redAccent, fontSize: 15)))),
                  ),
        Stack(
            children: [
        Container(
        width: MediaQuery.of(context).size.width*0.35,
        height: 55,

        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.04, 0, 0, 50),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            valueColor: new AlwaysStoppedAnimation(Colors.blueAccent),
            backgroundColor: Color(0xffF2F2F2),
            value: ((30-(sec/1000)) + 1/(sec/1000))/30,
          ),
        )
    ),
    Bounce(
    duration: Duration(milliseconds: 100),
    onPressed: () {
    if(timeroff == true) {
    setState(() {
    _nowChallenge = true;
    todayChallenge = true;
    completeChallenge = true;
    successChallenge.add(
    challengelist[
    challengeNumber[
    timeBlock]]);
    successChallengePoint.add(
    challengelistPoint[
    challengeNumber[
    timeBlock]]);
    sum += challengelistPoint[
    challengeNumber[
    timeBlock]];
    addPoint = false;
    });
    }else {
      if(timerset == false){
        timer();
      }
      timerset = true;
    }
    },
        child: Container(
            width: MediaQuery.of(context).size.width*0.35,
            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.04, 0, 0, 50),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent,
            ),
            child: Row(
                children: [
                  Spacer(),
                  timerset ? Row(
                      children: [
                        Text(timeroff ? '완료했어요' : '${sec~/1000}',style: TextStyle(color: timeroff ? Colors.white : (sec/1000) > 15 == true ? Colors.grey : Colors.white, fontSize: 15)),
                      ]
                  ) : Text(timeroff ? '완료했어요' : timerset ? '${sec~/1000}' : '타이머 시작', style: TextStyle(color: timeroff ? Colors.white : timerset ? Colors.grey : Colors.black, fontSize: 15)),
                  Spacer(),
                ]
            )
        )
    ),
            ],
        ),
                ],
            ),
        ),
                            ]))
                        ),
                      ),
                    ],
                  ):Column(
                    children: [
                      Stack(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height*0.4,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/neck${challengeNumber[timeBlock]}.jpeg'),
                                    fit: BoxFit.cover,
                                  ),
                                )
                            ),
                            Center(
                              child: Container(
                                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.17,),
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.black.withOpacity(0.3),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0XFF000066).withOpacity(0.03),
                                          blurRadius: 15,
                                          spreadRadius: 10,
                                          offset: const Offset(0, 10),
                                        ),
                                        BoxShadow(
                                          color: Color(0XFF000066).withOpacity(0.0165),
                                          blurRadius: 7.5,
                                          spreadRadius: 5,
                                          offset: const Offset(0, 5),
                                        ),
                                        BoxShadow(
                                          color: Color(0XFF000066).withOpacity(0.0095),
                                          blurRadius: 5,
                                          spreadRadius: 2.5,
                                          offset: const Offset(0, 2.5),
                                        ),
                                      ]
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                                      child: Container(
                                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.17,),
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                  )
                              ),
                            ),
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.17,),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(75),
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                                child: Center(child: Icon(challengeListIcon[challengeNumber[timeBlock]], color: Colors.white, size: 70)),),
                            ),
                            Bounce(
                              duration: Duration(milliseconds: 100),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                  margin: EdgeInsets.only(top: 50, left: 30),
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey.withOpacity(1),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0XFF000066).withOpacity(0.03),
                                          blurRadius: 15,
                                          spreadRadius: 10,
                                          offset: const Offset(0, 10),
                                        ),
                                        BoxShadow(
                                          color: Color(0XFF000066).withOpacity(0.0165),
                                          blurRadius: 7.5,
                                          spreadRadius: 5,
                                          offset: const Offset(0, 5),
                                        ),
                                        BoxShadow(
                                          color: Color(0XFF000066).withOpacity(0.0095),
                                          blurRadius: 5,
                                          spreadRadius: 2.5,
                                          offset: const Offset(0, 2.5),
                                        ),
                                      ]
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                                        child: Center(
                                          child: Icon(Icons.navigate_before_rounded, color: Colors.white, size: 30),
                                        )
                                    ),
                                  )
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.4-20),
                              height: 20,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                color: Colors.white,
                              ),
                            )
                          ]),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Container(
                            padding: EdgeInsets.fromLTRB(50, 20, 50, 0),
                            child: Center(child: Column(children:[
                              SizedBox(child: Column(children: [
                                Container(margin: EdgeInsets.only(top: 0), child: Column(children: [
                                  Text(challengelist[challengeNumber[timeBlock]], style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold)),
                                  Text('', style: TextStyle(fontSize: 10)),
                                  Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: Colors.blueAccent.withOpacity(0.1),
                                      ),
                                      child: Text('# ${categorylist[0][0]}', style: TextStyle(color: Colors.blueAccent, fontSize: 17))
                                  ),
                                  Text('', style: TextStyle(fontSize: 6)),
                                  Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Text(challengelistHow[challengeNumber[timeBlock]][0], style: TextStyle(color: Colors.grey, fontSize: 15, letterSpacing: 1.2, wordSpacing: 1.2, height: 1.2))),
                                ]
                                )
                                ),
                              ])),
                              Bounce(
                                  duration: Duration(milliseconds: 100),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => ChallengeTip()));
                                  },
                                  child: Container(
                                    child:
                                    Icon(Icons.lightbulb_rounded, color: Colors.orange, size: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.orange.withOpacity(0.1),
                                    ),
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(top: 40),
                                  )
                              ),
                              Spacer(),
                              Spacer(),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Bounce(
                                      duration: Duration(milliseconds: 100),
                                      onPressed: () {
                                        print('포기하기');
                                        if (really == true) {
                                          setState((){
                                            _nowChallenge = false;
                                            _isChallenge = false;
                                            setIsChallenge();
                                            Navigator.pop(context);
                                          });
                                        }
                                        else {
                                          setState((){
                                            Duration duration = new Duration(seconds: 3);
                                            really = true;
                                            Future.delayed(duration, (){
                                              setState((){
                                                really = false;
                                              });
                                            });
                                          });
                                        }
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.redAccent.withOpacity(really ? 1 : 0.07),
                                          ),
                                          padding: EdgeInsets.all(20),
                                          width: MediaQuery.of(context).size.width*0.35,
                                          margin: EdgeInsets.only(bottom: 50),
                                          child: Center(child: Text(really ? '정말 포기하기':'포기하기', style: TextStyle(color: really ? Colors.white : Colors.redAccent, fontSize: 15)))),
                                    ),
                                    Bounce(
                                        duration: Duration(milliseconds: 100),
                                        onPressed: () {
                                          setState((){
                                            _nowChallenge = true;
                                            todayChallenge = true;
                                            completeChallenge = true;
                                            successChallenge.add(challengelist[challengeNumber[timeBlock]]);
                                            successChallengePoint.add(challengelistPoint[challengeNumber[timeBlock]]);
                                            sum += challengelistPoint[challengeNumber[timeBlock]];
                                            addPoint = false;
                                          });
                                        },
                                        child: Container(
                                            width: MediaQuery.of(context).size.width*0.35,
                                            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.04, 0, 0, 50),
                                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.blueAccent,
                                            ),
                                            child: Row(
                                                children: [
                                                  Spacer(),
                                                  Text('완료했어요', style: TextStyle(color: Colors.white, fontSize: 15)),
                                                  Spacer(),
                                                ]
                                            )
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ]))
                        ),
                      ),
                    ],
                  )
                  :
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height*0.4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/neck${challengeNumber[timeBlock]}.jpeg'),
                            fit: BoxFit.cover,
                          ),
                        )
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.17,),
                          width: 100,
                          height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.black.withOpacity(0.3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0XFF000066).withOpacity(0.03),
                                    blurRadius: 15,
                                    spreadRadius: 10,
                                    offset: const Offset(0, 10),
                                  ),
                                  BoxShadow(
                                    color: Color(0XFF000066).withOpacity(0.0165),
                                    blurRadius: 7.5,
                                    spreadRadius: 5,
                                    offset: const Offset(0, 5),
                                  ),
                                  BoxShadow(
                                    color: Color(0XFF000066).withOpacity(0.0095),
                                    blurRadius: 5,
                                    spreadRadius: 2.5,
                                    offset: const Offset(0, 2.5),
                                  ),
                                ]
                            ),
                            child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                              child: Container(
                                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.17,),
                                width: 100,
                                height: 100,
                              ),
                            ),
                          )
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.17,),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(75),
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          child: Center(child: timeAttack ? Text('30', style: TextStyle(color: Colors.white, fontSize: 50)) : Icon(challengeListIcon[challengeNumber[timeBlock]], color: Colors.white, size: 70)),
                        ),
                      ),
                      Bounce(
                        duration: Duration(milliseconds: 100),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            margin: EdgeInsets.only(top: 50, left: 30),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.withOpacity(1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0XFF000066).withOpacity(0.03),
                                    blurRadius: 15,
                                    spreadRadius: 10,
                                    offset: const Offset(0, 10),
                                  ),
                                  BoxShadow(
                                    color: Color(0XFF000066).withOpacity(0.0165),
                                    blurRadius: 7.5,
                                    spreadRadius: 5,
                                    offset: const Offset(0, 5),
                                  ),
                                  BoxShadow(
                                    color: Color(0XFF000066).withOpacity(0.0095),
                                    blurRadius: 5,
                                    spreadRadius: 2.5,
                                    offset: const Offset(0, 2.5),
                                  ),
                                ]
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                                  child: Center(
                                    child: Icon(Icons.navigate_before_rounded, color: Colors.white, size: 30),
                                  )
                              ),
                            )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.4-20),
                        height: 20,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          color: Colors.white,
                        ),
                      )
                      ]),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Container(
                        padding: EdgeInsets.fromLTRB(50, 20, 50, 0),
                        child: Center(child: Column(children:[
                          SizedBox(child: Column(children: [
                            Container(margin: EdgeInsets.only(top: 0), child: Column(children: [
                              Text(challengelist[challengeNumber[timeBlock]], style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold)),
                              Text('', style: TextStyle(fontSize: 10)),
                              Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.blueAccent.withOpacity(0.1),
                                  ),
                                  child: Text('# ${categorylist[0][0]}', style: TextStyle(color: Colors.blueAccent, fontSize: 17))
                              ),
                              Text('', style: TextStyle(fontSize: 6)),
                              Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Text(challengelistHow[challengeNumber[timeBlock]][0], style: TextStyle(color: Colors.grey, fontSize: 15, letterSpacing: 1.2, wordSpacing: 1.2, height: 1.2))),
                            ]
                            )
                            ),
                          ])),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              Container(
                                width: MediaQuery.of(context).size.width*0.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                  border: Border.all(width: 1, color: timeAttack ? Colors.indigoAccent.withOpacity(0.1) : Color(0xffDFDFDF)),
                                  color: timeAttack ? Colors.indigoAccent.withOpacity(0.1) : Colors.white,
                                ),
                                child: Bounce(
                                  duration: Duration(milliseconds: 100),
                                  onPressed: () {
                                    setState((){
                                      timeAttack = true;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                      ),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Center(
                                            child: Icon(Icons.access_alarm_rounded, color: timeAttack ? Colors.indigoAccent : Colors.grey, size: 20),
                                          )
                                        ),
                                        Text('시간 제한', style: TextStyle(color: timeAttack ? Colors.indigoAccent : Colors.grey, fontSize: 15, fontWeight: timeAttack ? FontWeight.bold : FontWeight.normal)),
                                      ],
                                    )
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width*0.3,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: timeAttack ? Color(0xffDFDFDF) : Colors.redAccent.withOpacity(0.1)),
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                  color: timeAttack ? Colors.white : Colors.redAccent.withOpacity(0.1),
                                ),
                                child: Bounce(
                                  duration: Duration(milliseconds: 100),
                                  onPressed: () {
                                    setState((){
                                      timeAttack = false;
                                    });
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Container(
                                              child: Center(
                                                child: Icon(Icons.close, color: timeAttack ? Colors.grey : Colors.redAccent, size: 20),
                                              )
                                          ),
                                          Text('시간 제한 없이', style: TextStyle(color: timeAttack ? Colors.grey : Colors.redAccent, fontSize: 15, fontWeight: timeAttack ? FontWeight.normal : FontWeight.bold)),
                                        ],
                                      )
                                  ),
                                ),
                              )
                            ]),
                          Spacer(),
                          Container(
                              child: Bounce(
                                duration: Duration(milliseconds: 100),
                                child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.blueAccent,
                                    ),
                                    child: Row(
                                        children: [
                                          Spacer(),
                                          Text('도전하기', style: TextStyle(color: Colors.white, fontSize: 15)),
                                          Spacer(),
                                        ]
                                    )
                                ),
                                onPressed: () {
                                  print('도전하기');
                                  setState((){
                                    _nowChallenge = true;
                                  });
                                  print(_nowChallenge);
                                  print(todayChallenge);
                                },
                              )
                          ),
                        ]))
                    ),
                  ),
                ],
              ):
              _nowChallenge ?
              todayChallenge ?
              Container(
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Center(child: Column(children:[
                    Center(child: Text('')),
                    Spacer(),
                    SizedBox(child: Column(children: [
                      Icon(completeChallenge ? Icons.monetization_on_rounded : Icons.abc, color: completeChallenge ? Colors.amber : Colors.redAccent, size: 70),
                      Container(margin: EdgeInsets.only(top: 30), child: Column(children: [
                        Text(completeChallenge ? questionPoint[challengeNumber[timeBlock]].toString()+'P 획득!' : '포인트 획득 실패!', style: TextStyle(color: completeChallenge ? Colors.black : Colors.redAccent, fontSize: 25, fontWeight: FontWeight.bold)),
                        Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Text(completeChallenge ? '챌린지를 완수하여 리워드를 받았어요.' : '챌린지 문제를 틀렸어요ㅠㅠ', style: TextStyle(color: Colors.grey, fontSize: 15))),
                      ]
                      )
                      ),
                    ])),
                    Spacer(),
                    Spacer(),
                    Container(
                        margin: EdgeInsets.only(bottom: 50, left: 20, right: 20),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                primary: Color(0xffF2F2F2),
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )
                            ),
                            onPressed: () async {
                              print('리워드 받기');
                              Navigator.pop(context);
                              if (todayMemo[timeBlock] == false) {
                                time += 1;
                                setTime();
                                DBHelper().insertMemo(Memo(id: year * 1000000 + month * 10000 + day * 100 + time, title: question[challengeNumber[timeBlock]], point: questionPoint[challengeNumber[timeBlock]], createTime: getToday(), time: getTime()));
                                print(await DBHelper().memos());
                                todayMemo[timeBlock] = true;
                              }
                              _isChallenge = false;
                              setIsChallenge();
                            },
                            child: Row(children:[
                              Text(' '),
                              Spacer(),
                              Text('확인', style: TextStyle(color: Colors.black, fontSize: 20)),
                              Spacer(),
                              Text(' '),
                            ])
                        )
                    ),
                  ]))
              ) :

              Container(
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Center(child: Column(children:[
                    Center(child: Text('')),
                    Spacer(),
                    SizedBox(child: Column(children: [
                      Icon(challengeListIcon[challengeNumber[timeBlock]], color: challengeListIconColor[challengeNumber[timeBlock]], size: 70),
                      Container(margin: EdgeInsets.only(top: 30), child: Column(children: [
                        Text(question[challengeNumber[timeBlock]], style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold)),
                        Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                Text('챌린지를 진행 중이에요\n', style: TextStyle(color: Colors.grey, fontSize: 20)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.monetization_on_rounded, color: Colors.amber),
                                    Text(questionPoint[challengeNumber[timeBlock]].toString()+' 획득이 가능해요.', style: TextStyle(color: Colors.amber, fontSize: 17)),
                                  ],
                                ),
                              ],
                            )),
                      ]
                      )
                      ),
                    ])),
                    Spacer(),
                    Spacer(),
                    Container(
                      child: GridView.builder(
                        itemCount: 4,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 2 / 1,
                        ),
                        itemBuilder: (context, index){
                          return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xffF2F2F2),
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )
                              ),
                              onPressed: () {
                                setState(() {
                                  if (answer == index) {
                                    print('answer');
                                    _nowChallenge = true;
                                    todayChallenge = true;
                                    completeChallenge = true;
                                    successChallenge.add(question[challengeNumber[timeBlock]]);
                                    successChallengePoint.add(questionPoint[challengeNumber[timeBlock]]);
                                    sum += questionPoint[challengeNumber[timeBlock]];
                                  }
                                  else {
                                    print('not answer');
                                    _nowChallenge = true;
                                    todayChallenge = true;
                                    completeChallenge = false;
                                    print(answer);
                                  }
                                });
                              },
                              child: Text(answer == index ? questionAnswer[challengeNumber[timeBlock]] : questionChooser[challengeNumber[timeBlock]][index], style: TextStyle(color: Colors.black, fontSize: 17),
                              )
                          );
                        },
                      ),
                      margin: EdgeInsets.only(bottom: 20),
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 50),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xffFFFFFF),
                            elevation: 0.0,
                          ),
                          onPressed: () {
                            print('포기하기');
                            setState((){
                              _nowChallenge = false;
                              _isChallenge = false;
                              setIsChallenge();
                            });
                            Navigator.pop(context);
                          },
                          child: Text('포기하기', style: TextStyle(color: Colors.redAccent, fontSize: 20)),
                        )
                    )
                  ]))
              ):
              Container(
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Center(child: Column(children:[
                    Center(child: Text('')),
                    Spacer(),
                    SizedBox(child: Column(children: [
                      Icon(challengeListIcon[challengeNumber[timeBlock]], color: challengeListIconColor[challengeNumber[timeBlock]], size: 70),
                      Container(margin: EdgeInsets.only(top: 30), child: Column(children: [
                        Text(question[challengeNumber[timeBlock]], style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold)),
                        Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Text(questionPoint[challengeNumber[timeBlock]].toString()+'포인트 획득이 가능해요.', style: TextStyle(color: Colors.grey, fontSize: 20))),
                      ]
                      )
                      ),
                    ])),
                    Spacer(),
                    Spacer(),
                    Container(
                        margin: EdgeInsets.only(bottom: 50, left: 20, right: 20),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                primary: Color(0xffF2F2F2),
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )
                            ),
                            onPressed: () {
                              print('도전하기');
                              setState((){
                                _nowChallenge = true;
                              });
                              print(_nowChallenge);
                              print(todayChallenge);
                            },
                            child: Row(children:[
                              Text(' '),
                              Spacer(),
                              Text('도전하기', style: TextStyle(color: Colors.black, fontSize: 20)),
                              Spacer(),
                              Text(' '),
                            ])
                        )
                    ),
                  ]))
              ) : Center(
                  child: Column(
                      children: [
                        Spacer(),
                        Spacer(),
                        Image.asset('assets/CharacterTime.png', height: 200),
                        Spacer(),
                        Text('다음 도전과제를 기다려 주세요!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('', style: TextStyle(fontSize: 6)),
                        Text('조금 있다가 다시 만나요.', style: TextStyle(color: Colors.grey, fontSize: 15)),
                        Spacer(),
                        Spacer(),
                        Bounce(
                          duration: Duration(milliseconds: 100),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 50, right: 50, left: 50),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blueAccent,
                            ),
                            child: Row(
                              children: [
                                Spacer(),
                                Text('확인', style: TextStyle(color: Colors.white, fontSize: 15)),
                                Spacer(),
                              ],
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ])
              ),

              onWillPop: () {
                print('나갈수 없어!');
                return Future(()=>false);
              },
            )
        )
    );
  }
  @override
  setTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('time', time);
  }
}
CalendarFormat _calendarFormat = CalendarFormat.month;



class RememberList extends StatefulWidget {
  const RememberList({Key? key}) : super(key: key);

  @override
  State<RememberList> createState() => _RememberListState();
}

class _RememberListState extends State<RememberList> {
  final memoController = TextEditingController();
  var memoSave = true;

  @override
  setDayWeek() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(todayCheck = false){
      setState((){
        prefs.setInt('dayWeek', dayWeek + 1);
      });
    }
  }
  @override
  setIsChallenge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isChallenge', _isChallenge);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          backgroundColor: Color(0xffF2F2F2),
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              leading: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => {
                      Navigator.pop(context),
                    },
                    child: Icon(Icons.navigate_before_rounded, color: AllFontColor, size: 40),
                  )
              )
          ),
          body:
          ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: Column(
                children: [
                  Column(children: [
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          border: Border(bottom: BorderSide(width: 1, color: Colors.black.withOpacity(0.1))),
                        ),
                        padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
                        child: Row(
                          children: [
                            Spacer(),
                            Container(
                              width: MediaQuery.of(context).size.width*0.8,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              color: Color(0xffF2F2F2),
                                            ),
                                            child: Center(child: Icon(challengeListIcon[challengeNumber[timeBlock]], color: challengeListIconColor[challengeNumber[timeBlock]], size: 30))),
                                        SizedBox(
                                            width: MediaQuery.of(context).size.width*0.6,
                                            child: Text('  '+challengelist[challengeNumber[timeBlock]], style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis))),
                                      ],
                                    ),
                                    Text('', style: TextStyle(fontSize: 10)),
                                    Text(challengelistHow[challengeNumber[timeBlock]][0], style: TextStyle(color: Colors.grey, fontSize: 15)),
                                    Text('', style: TextStyle(fontSize: 20)),
                                  ]),
                            ),
                            Spacer(),
                          ],
                        )
                    ),]),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                          margin: EdgeInsets.only(top: 40),
                          child: Column(
                            children: [
                              Text('종합 평가', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                              Text('\n방금 활동은 어땠나요?', style: TextStyle(color: Colors.grey, fontSize: 13)),
                              Text('', style: TextStyle(fontSize: 20)),
                              Row(children: [
                                Spacer(),
                                Spacer(),
                                Column(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: emotion[0] ? Color(0xffDFDFDF) : Color(0xffF2F2F2),
                                      ),
                                      child:
                                      Center(
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          child: ElevatedButton(
                                            child: Text(''),
                                            onPressed: () {
                                              setState((){
                                                emotion[0] = true;
                                                emotion[1] = false;
                                                emotion[2] = false;
                                                nowemotion = 0;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25),
                                              ),
                                              primary: Colors.redAccent,
                                              elevation: 0.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      margin: EdgeInsets.only(bottom: 10),
                                    ),
                                    Text('좋지 않음', style: TextStyle(fontSize: 15)),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: emotion[1] ? Color(0xffDFDFDF) : Color(0xffF2F2F2),
                                      ),
                                      child:
                                      Center(
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          child: ElevatedButton(
                                            child: Text(''),
                                            onPressed: () {
                                              setState((){
                                                emotion[0] = false;
                                                emotion[1] = true;
                                                emotion[2] = false;
                                                nowemotion = 1;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25),
                                              ),
                                              primary: Colors.amber,
                                              elevation: 0.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      margin: EdgeInsets.only(bottom: 10),
                                    ),
                                    Text('보통', style: TextStyle(fontSize: 15)),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: emotion[2] ? Color(0xffDFDFDF) : Color(0xffF2F2F2),
                                      ),
                                      child:
                                      Center(
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          child: ElevatedButton(
                                            child: Text(''),
                                            onPressed: () {
                                              setState((){
                                                emotion[0] = false;
                                                emotion[1] = false;
                                                emotion[2] = true;
                                                nowemotion = 2;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25),
                                              ),
                                              primary: Colors.green,
                                              elevation: 0.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      margin: EdgeInsets.only(bottom: 10),
                                    ),
                                    Text('좋음', style: TextStyle(fontSize: 15)),
                                  ],
                                ),
                                Spacer(),
                                Spacer(),
                              ]),
                              Container(
                                  padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
                                  margin: EdgeInsets.only(top: 30),
                                  child: Center(
                                      child: Column(children: [
                                        Text('느낀 점', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                                        Text('\n느낀 점은 나중에 \'기록\'에서 다시 볼 수 있어요.\n', style: TextStyle(color: Colors.grey, fontSize: 13)),
                                        Container(
                                            margin: EdgeInsets.only(top: 20),
                                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(width: 1, color: Colors.black.withOpacity(0.1)),
                                              color: Colors.white,
                                            ),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: '도움이 되었나요?',
                                                  hintStyle: TextStyle(color: Colors.grey)
                                              ),
                                              maxLines: null,
                                              controller: memoController,
                                            )
                                        )
                                      ])
                                  )
                              ),
                            ],
                          )
                      ),
                    ),
                  )
                ]
            ),
          ),
          bottomNavigationBar: Container(
            margin: EdgeInsets.fromLTRB(40, 0, 40, 50),
            child: Bounce(
                duration: Duration(milliseconds: 100),
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  decoration: BoxDecoration(
                      color: memoSave ? Colors.blueAccent : Color(0xffDFDFDF),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0XFF000066).withOpacity(memoSave ? 0.03 : 0),
                          blurRadius: 15,
                          spreadRadius: 10,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: Color(0XFF000066).withOpacity(memoSave ? 0.0165 : 0),
                          blurRadius: 7.5,
                          spreadRadius: 5,
                          offset: const Offset(0, 5),
                        ),
                        BoxShadow(
                          color: Color(0XFF000066).withOpacity(memoSave ? 0.0095 : 0),
                          blurRadius: 5,
                          spreadRadius: 2.5,
                          offset: const Offset(0, 2.5),
                        ),
                      ]
                  ),
                  child: Row(children: [
                    Spacer(),
                    Text(memoSave ? '저장하기': '느낀 점을 입력해주세요.', style: TextStyle(color: memoSave ? Colors.white : Colors.grey, fontSize: 17)),
                    Spacer(),
                  ]),
                ),
                onPressed: () async {
                  if(memoSave == true){
                    if(memoController.text.length > 0){
                      if (addPoint == false) {
                        successChallenge.add('기록하기');
                        successChallengePoint.add(20);
                        sum += 20;
                        addPoint = true;
                        print('time: $time');
                        if (todayMemo[timeBlock] == false) {
                          time += 1;
                          setTime();
                          DBHelper().insertMemo(Memo(
                              id: year * 1000000 + month * 10000 + day * 100 + time,
                              title: challengelist[challengeNumber[timeBlock]],
                              point: challengelistPoint[challengeNumber[timeBlock]],
                              emotion: nowemotion,
                              memo: memoController.text,
                              createTime: getToday(),
                              time: getTime()));
                          print(await DBHelper().memos());
                          setState((){
                            todayMemo[timeBlock] = true;
                          });
                        }
                        _isChallenge = false;
                        setIsChallenge();
                        if(newBadge == false){
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                        }
                        else {
                          if(badgeHave < 6) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NewBadgePage()));
                            SharedPreferences prefs =
                            await SharedPreferences
                                .getInstance();
                            setState(() {
                              prefs.setInt(
                                  'badgeHave', badgeHave + 1);
                            });
                            newBadge = false;
                          }
                        }
                        setDayWeek();
                        todayCheck = true;
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        setState((){
                          prefs.setBool('todayCheck', true);
                        });
                      }
                      else {
                        DBHelper().updateMemo(Memo(
                            id: year * 1000000 + month * 10000 + day * 100 + time,
                            title: challengelist[challengeNumber[timeBlock]],
                            point: challengelistPoint[challengeNumber[timeBlock]],
                            emotion: nowemotion,
                            memo: memoController.text,
                            createTime: getToday(),
                            time: getTime()));
                        if(newBadge == false){
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                        }
                        else {
                          if(badgeHave < 6) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NewBadgePage()));
                            SharedPreferences prefs =
                            await SharedPreferences
                                .getInstance();
                            setState(() {
                              prefs.setInt(
                                  'badgeHave', badgeHave + 1);
                            });
                            newBadge = false;
                          }
                        }
                      }
                    }
                    else {
                      setState((){
                        Duration duration = new Duration(seconds: 3);
                        memoSave = false;
                        Future.delayed(duration, (){
                          setState((){
                            memoSave = true;
                          });
                          print('memoSave = true');
                        });
                      });
                    }}
                  else {
                  }
                }
            ),
          ),
        )
    );
  }
  @override
  setTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('time', time);
  }
}


class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}


class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('az');
    return TableCalendar(
      calendarBuilders: CalendarBuilders(
          dowBuilder: (context, day){
            switch(day.weekday){
              case 6:
                return Center(child: Text('토', style: TextStyle(color: Colors.blue)),);
              case 7:
                return Center(child: Text('일', style: TextStyle(color: Colors.red),),);
            }
          }
      ),
      focusedDay: DateTime.now(),
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),

        ),
        todayTextStyle: TextStyle(color: Colors.black),
        defaultTextStyle: TextStyle(color: Colors.white),
        selectedTextStyle: TextStyle(color: Colors.black),
      ),
      locale: 'ko-KR',
      daysOfWeekHeight: 30,
      headerStyle: HeaderStyle(
        headerMargin: EdgeInsets.only(left:40, top: 10, right: 40, bottom: 10),
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        setState((){
          _calendarFormat = format;
        });
      },
      eventLoader: (day){
        return [];
      },
    );
  }
}

class Player extends StatefulWidget {
  final String _videoID;

  Player(this._videoID);

  @override
  PlayerState createState() => PlayerState(_videoID);
}

class PlayerState extends State<Player> {
  String _videoID;

  PlayerState(this._videoID);

  late YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: _videoID,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: true,
        loop: true,
        isLive: false,
        forceHD: true,
        enableCaption: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
        child: YoutubePlayer(
          key: ObjectKey(_controller),
          controller: _controller,
          actionsPadding: const EdgeInsets.only(left: 16.0),
          bottomActions: [
            CurrentPosition(),
            const SizedBox(width: 10.0),
            ProgressBar(isExpanded: true),
            const SizedBox(width: 10.0),
            RemainingDuration(),
            //FullScreenButton(),
          ],
        ),
      );
  }
}

class ChallengeTip extends StatefulWidget {
  const ChallengeTip({Key? key}) : super(key: key);

  @override
  State<ChallengeTip> createState() => _ChallengeTipState();
}

class _ChallengeTipState extends State<ChallengeTip> {
  @override
  Widget build(BuildContext context) {
    var i = 1;
    return MaterialApp(
        home: Scaffold(
          backgroundColor: Color(0xff1F1F1F),
          body:
          Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Player(challengelistVideo[challengeNumber[timeBlock]]),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(40, 20, 40, 50),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(' ', style: TextStyle(fontSize: 30),),
                            Text('운동 방법', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('', style: TextStyle(fontSize: 30)),
                            Container(
                              child: Column(children: [
                                for(var i = 2; i <= challengelistHow[challengeNumber[timeBlock]].length; i++)
                                  Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      child: Row(children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 20),
                                          child: Center(child: Text('${i-1}', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold))),
                                          decoration: BoxDecoration(
                                            color: AllFontColor,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          width: 30,
                                          height: 30,
                                        ),
                                        Flexible(
                                            child: RichText(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 5,
                                              strutStyle: StrutStyle(fontSize: 17),
                                              text: TextSpan(text: challengelistHow[challengeNumber[timeBlock]][i - 1], style: TextStyle(color: AllWidgetColor, fontSize: 15)),
                                            )
                                        )
                                      ])
                                  )
                              ]),
                            ),
                          ]),
                    ),
                  ],
                ),
              )
          ),
          bottomNavigationBar: Bounce(
              duration: Duration(milliseconds: 100),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  margin: EdgeInsets.fromLTRB(50, 0, 50, 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xff3F3F3F),
                  ),
                  child: Row(
                      children: [
                        Spacer(),
                        Text('확인', style: TextStyle(color: AllWidgetColor, fontSize: 15)),
                        Spacer(),
                      ]
                  )
              )
          ),
        )
    );
  }
}
