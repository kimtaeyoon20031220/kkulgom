class Memo {
  final int? id;
  final String? title;
  final int? point;
  final int? emotion;
  final String? memo;
  final String? createTime;
  final String? time;

  Memo({this.id, this.title, this.point, this.emotion, this.memo, this.createTime, this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'point': point,
      'emotion' : emotion,
      'memo' : memo,
      'createTime': createTime,
      'time': time,
    };
  }

  // 각 memo 정보를 보기 쉽도록 print 문을 사용하여 toString을 구현하세요
  @override
  String toString() {
    return 'Memo{id: $id, title: $title, point: $point, emotion: $emotion, memo: $memo, createTime: $createTime, time: $time}';
  }
}


class Today {
  final int? id;
  final int? memo;
  final String? createTime;

  Today({this.id, this.memo, this.createTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'memo' : memo,
      'createTime' : createTime,
    };
  }

  // 각 memo 정보를 보기 쉽도록 print 문을 사용하여 toString을 구현하세요
  @override
  String toString() {
    return 'Today{id: $id, memo: $memo, createTime: $createTime}';
  }
}


class TodayMemo {
  final int? id;
  final String? memo;
  final String? createTime;

  TodayMemo({this.id, this.memo, this.createTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'memo' : memo,
      'createTime' : createTime,
    };
  }

  // 각 memo 정보를 보기 쉽도록 print 문을 사용하여 toString을 구현하세요
  @override
  String toString() {
    return 'TodayMemo{id: $id, memo: $memo, createTime: $createTime}';
  }
}


