class TimeSlot {
  final String id;
  final String doctorId;
  final DateTime dateTime;
  final bool isAvailable;

  const TimeSlot({
    required this.id,
    required this.doctorId,
    required this.dateTime,
    required this.isAvailable,
  });

  TimeSlot copyWith({
    String? id,
    String? doctorId,
    DateTime? dateTime,
    bool? isAvailable,
  }) {
    return TimeSlot(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      dateTime: dateTime ?? this.dateTime,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doctorId': doctorId,
      'dateTime': dateTime.toIso8601String(),
      'isAvailable': isAvailable,
    };
  }

  factory TimeSlot.fromMap(Map<String, dynamic> map) {
    return TimeSlot(
      id: map['id'] as String,
      doctorId: map['doctorId'] as String,
      dateTime: DateTime.parse(map['dateTime'] as String),
      isAvailable: map['isAvailable'] as bool? ?? true,
    );
  }
}
