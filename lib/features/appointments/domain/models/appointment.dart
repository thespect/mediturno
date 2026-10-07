import 'dart:convert';
import 'appointment_status.dart';

class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final String doctorName;
  final String doctorAvatar;
  final String specialtyName;
  final String roomNumber;
  final DateTime dateTime;
  final String reasonForVisit;
  final String notes;
  final AppointmentStatus status;
  final String? cancellationReason;
  final DateTime createdAt;
  final int notificationId;

  const Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.doctorName,
    required this.doctorAvatar,
    required this.specialtyName,
    required this.roomNumber,
    required this.dateTime,
    required this.reasonForVisit,
    required this.notes,
    required this.status,
    this.cancellationReason,
    required this.createdAt,
    required this.notificationId,
  });

  bool get isUpcoming =>
      (status == AppointmentStatus.solicitada ||
          status == AppointmentStatus.confirmada) &&
      dateTime.isAfter(DateTime.now().subtract(const Duration(hours: 1)));

  bool get isPast => !isUpcoming;

  Appointment copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    String? doctorName,
    String? doctorAvatar,
    String? specialtyName,
    String? roomNumber,
    DateTime? dateTime,
    String? reasonForVisit,
    String? notes,
    AppointmentStatus? status,
    String? cancellationReason,
    DateTime? createdAt,
    int? notificationId,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorAvatar: doctorAvatar ?? this.doctorAvatar,
      specialtyName: specialtyName ?? this.specialtyName,
      roomNumber: roomNumber ?? this.roomNumber,
      dateTime: dateTime ?? this.dateTime,
      reasonForVisit: reasonForVisit ?? this.reasonForVisit,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      createdAt: createdAt ?? this.createdAt,
      notificationId: notificationId ?? this.notificationId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorAvatar': doctorAvatar,
      'specialtyName': specialtyName,
      'roomNumber': roomNumber,
      'dateTime': dateTime.toIso8601String(),
      'reasonForVisit': reasonForVisit,
      'notes': notes,
      'status': status.name,
      'cancellationReason': cancellationReason,
      'createdAt': createdAt.toIso8601String(),
      'notificationId': notificationId,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'] as String,
      patientId: map['patientId'] as String,
      doctorId: map['doctorId'] as String,
      doctorName: map['doctorName'] as String,
      doctorAvatar: map['doctorAvatar'] as String? ?? '',
      specialtyName: map['specialtyName'] as String,
      roomNumber: map['roomNumber'] as String? ?? 'Consultorio General',
      dateTime: DateTime.parse(map['dateTime'] as String),
      reasonForVisit: map['reasonForVisit'] as String,
      notes: map['notes'] as String? ?? '',
      status: AppointmentStatus.fromString(map['status'] as String),
      cancellationReason: map['cancellationReason'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
      notificationId: (map['notificationId'] as num?)?.toInt() ?? 100,
    );
  }

  String toJson() => json.encode(toMap());

  factory Appointment.fromJson(String source) =>
      Appointment.fromMap(json.decode(source) as Map<String, dynamic>);
}
