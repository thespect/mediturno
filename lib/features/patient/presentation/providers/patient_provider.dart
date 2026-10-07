import 'package:flutter/foundation.dart';
import '../../domain/models/patient.dart';
import '../../domain/repositories/patient_repository.dart';

class PatientProvider extends ChangeNotifier {
  final PatientRepository _repository;

  Patient? _patient;
  bool _isLoading = false;
  String? _errorMessage;

  PatientProvider(this._repository) {
    loadPatientProfile();
  }

  Patient? get patient => _patient;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadPatientProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _patient = await _repository.getPatientProfile();
    } catch (e) {
      _errorMessage = 'Error cargando información del paciente';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updatePatient(Patient updatedPatient) async {
    try {
      await _repository.savePatientProfile(updatedPatient);
      _patient = updatedPatient;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'No se pudo actualizar el perfil';
      notifyListeners();
      return false;
    }
  }
}
