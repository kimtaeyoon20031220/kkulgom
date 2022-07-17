import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications_example/main.dart';

class challengeAnimationContainer extends StatefulWidget {
  const challengeAnimationContainer({Key? key}) : super(key: key);

  @override
  State<challengeAnimationContainer> createState() => _challengeAnimationContainerState();
}

class _challengeAnimationContainerState extends State<challengeAnimationContainer> {
  bool _start = false;
  bool _check = false;
  bool _title = true;
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0), () {
      setState((){
        _start = true;
      });
    });
    Future.delayed(Duration(milliseconds: 1600), () {
      setState((){
        _title = false;
      });
    });
    Future.delayed(Duration(seconds: 3), () {
      setState((){
        _check = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      width: MediaQuery.of(context).size.width,
      height: _check ? 0 : MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: _check ? Color(0xff516b8c) : Color(0xffdceafc),
        borderRadius: BorderRadius.only(bottomLeft: _check ? Radius.circular(30) : Radius.circular(0), bottomRight: _check ? Radius.circular(30) : Radius.circular(0))
      ),
      curve: Curves.fastOutSlowIn,
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height*0.3,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              AnimatedAlign(
                duration: Duration(milliseconds: 1300),
                alignment: _title ? Alignment.center : Alignment.topCenter,
                curve: Curves.easeInCirc,
                child: AnimatedScale(
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.easeInOutBack,
                  scale: _start ? 1 : 0.8,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: _title ? 300 : 200),
                    alignment: _title ? Alignment.center : Alignment.topCenter,
                    child: AnimatedOpacity(
                      opacity: _title ? _start ? 1 : 0 : 0,
                      duration: Duration(milliseconds: 150),
                        child: AnimatedDefaultTextStyle(
                          duration: Duration(seconds: 4),
                            curve: Curves.easeIn,
                            child: Text('${dayWeek+1}일차'),
                            style: TextStyle(color: Color(0xff516b8c), fontSize: 60, fontWeight: FontWeight.bold),
                        )),
                    curve: Curves.easeInQuart,
                  ),
                ),
              ),
              AnimatedAlign(
                duration: Duration(milliseconds: 1300),
                alignment: _title ? Alignment.bottomCenter : Alignment.center,
                curve: Curves.ease,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  child: AnimatedOpacity(
                      opacity: _title ? 0 : _check ? 0 : 1,
                      duration: Duration(milliseconds: 150),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '#${categorylist[0][0]}\n',
                          style: TextStyle(
                            color: Color(0xff516b8c), fontSize: 25, fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '${challengelist[challengeNumber[timeBlock]]}',
                          style: TextStyle(
                            color: Color(0xff516b8c), fontWeight: FontWeight.bold, fontSize: 40,
                          )
                        )
                      ]
                    )
                  ),
                  curve: Curves.elasticOut,
                ),
          ),
              ),
              /*Container(
                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1),
                child: Transform.rotate(
                  angle: -30 * 3.141592 / 180,
                  child: AnimatedOpacity(opacity: _check ? 0 : 1, duration: Duration(milliseconds: 300),
                  child: Image.asset('assets/challengeTitle.png', width: 100)),
                ),
              ),*/
            ]
        ),
      )
    ));
  }
}
