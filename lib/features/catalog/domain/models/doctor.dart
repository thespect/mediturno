import 'specialty.dart';

class Doctor {
  final String id;
  final String specialtyId;
  final String fullName;
  final String medicalLicense;
  final String avatarUrl;
  final String roomNumber;
  final String biography;
  final double rating;
  final int reviewsCount;
  final List<String> availableDays; // e.g. ['Lunes', 'Martes', ...]
  final Specialty? specialty;

  const Doctor({
    required this.id,
    required this.specialtyId,
    required this.fullName,
    required this.medicalLicense,
    required this.avatarUrl,
    required this.roomNumber,
    required this.biography,
    required this.rating,
    required this.reviewsCount,
    required this.availableDays,
    this.specialty,
  });

  Doctor copyWith({
    String? id,
    String? specialtyId,
    String? fullName,
    String? medicalLicense,
    String? avatarUrl,
    String? roomNumber,
    String? biography,
    double? rating,
    int? reviewsCount,
    List<String>? availableDays,
    Specialty? specialty,
  }) {
    return Doctor(
      id: id ?? this.id,
      specialtyId: specialtyId ?? this.specialtyId,
      fullName: fullName ?? this.fullName,
      medicalLicense: medicalLicense ?? this.medicalLicense,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      roomNumber: roomNumber ?? this.roomNumber,
      biography: biography ?? this.biography,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      availableDays: availableDays ?? this.availableDays,
      specialty: specialty ?? this.specialty,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'specialtyId': specialtyId,
      'fullName': fullName,
      'medicalLicense': medicalLicense,
      'avatarUrl': avatarUrl,
      'roomNumber': roomNumber,
      'biography': biography,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'availableDays': availableDays,
      if (specialty != null) 'specialty': specialty!.toMap(),
    };
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'] as String,
      specialtyId: map['specialtyId'] as String,
      fullName: map['fullName'] as String,
      medicalLicense: map['medicalLicense'] as String,
      avatarUrl: map['avatarUrl'] as String? ?? '',
      roomNumber: map['roomNumber'] as String,
      biography: map['biography'] as String,
      rating: (map['rating'] as num).toDouble(),
      reviewsCount: map['reviewsCount'] as int? ?? 50,
      availableDays: List<String>.from(map['availableDays'] as List),
      specialty: map['specialty'] != null
          ? Specialty.fromMap(map['specialty'] as Map<String, dynamic>)
          : null,
    );
  }
}
