import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/patient.dart';
import '../domain/repositories/patient_repository.dart';

class PatientRepositoryImpl implements PatientRepository {
  static const String _patientKey = 'mediturno_patient_profile';

  static final Patient _defaultPatient = Patient(
    id: 'pat-1001',
    fullName: 'Carlos Eduardo Mendoza',
    documentId: '1098765432',
    email: 'carlos.mendoza@email.com',
    phone: '+52 55 1234 5678',
    birthDate: DateTime(1994, 7, 15),
    bloodType: 'O+',
    allergiesNotes: 'Alérgico a la Penicilina',
  );

  @override
  Future<Patient> getPatientProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_patientKey);

    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        return Patient.fromJson(jsonString);
      } catch (_) {
        return _defaultPatient;
      }
    }

    // Guardar el perfil inicial por defecto para futuras sesiones
    await savePatientProfile(_defaultPatient);
    return _defaultPatient;
  }

  @override
  Future<void> savePatientProfile(Patient patient) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_patientKey, patient.toJson());
  }
}
