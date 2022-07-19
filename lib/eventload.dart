import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Event {
  String title;
  Event(this.title);

  @override
  String toString() => title;
}

Map<DateTime, dynamic> eventSource = {
  DateTime(2022,7,18) : Event('가슴 근육 스트레칭'),
  DateTime(2022,7,19) : Event('가슴 근육 스트레칭'),
  DateTime(2022,7,23) : Event('가슴 근육 스트레칭'),
};

final events = LinkedHashMap(
  equals: isSameDay,
)..addAll(eventSource);

List<Event> getEventsForDay(DateTime day) {
  print('${day}, ${events[day]}');
  return events[day] ?? [];
}