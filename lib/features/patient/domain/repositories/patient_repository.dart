import '../models/patient.dart';

abstract class PatientRepository {
  Future<Patient> getPatientProfile();
  Future<void> savePatientProfile(Patient patient);
}
