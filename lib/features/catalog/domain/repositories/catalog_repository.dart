import '../models/doctor.dart';
import '../models/specialty.dart';
import '../models/time_slot.dart';

abstract class CatalogRepository {
  Future<List<Specialty>> getSpecialties();
  Future<List<Doctor>> getDoctors({String? specialtyId, String? query});
  Future<Doctor?> getDoctorById(String id);
  Future<List<TimeSlot>> getAvailableSlots(String doctorId, DateTime date);
}
