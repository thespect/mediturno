import 'package:flutter/foundation.dart';
import '../../domain/models/doctor.dart';
import '../../domain/models/specialty.dart';
import '../../domain/repositories/catalog_repository.dart';

class CatalogProvider extends ChangeNotifier {
  final CatalogRepository _repository;

  List<Specialty> _specialties = [];
  List<Doctor> _doctors = [];
  List<Doctor> _filteredDoctors = [];

  String? _selectedSpecialtyId;
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  CatalogProvider(this._repository) {
    loadCatalog();
  }

  List<Specialty> get specialties => _specialties;
  List<Doctor> get doctors => _filteredDoctors;
  List<Doctor> get allDoctors => _doctors;
  String? get selectedSpecialtyId => _selectedSpecialtyId;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadCatalog() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _specialties = await _repository.getSpecialties();
      _doctors = await _repository.getDoctors();
      _applyFilters();
    } catch (e) {
      _errorMessage = 'Error al cargar el catálogo médico';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectSpecialty(String? specialtyId) {
    if (_selectedSpecialtyId == specialtyId) {
      _selectedSpecialtyId = null; // Toggle / quitar filtro
    } else {
      _selectedSpecialtyId = specialtyId;
    }
    _applyFilters();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    var result = List<Doctor>.from(_doctors);

    if (_selectedSpecialtyId != null) {
      result = result.where((d) => d.specialtyId == _selectedSpecialtyId).toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      result = result.where((d) {
        final matchesName = d.fullName.toLowerCase().contains(q);
        final matchesSpec = d.specialty?.name.toLowerCase().contains(q) ?? false;
        final matchesRoom = d.roomNumber.toLowerCase().contains(q);
        return matchesName || matchesSpec || matchesRoom;
      }).toList();
    }

    _filteredDoctors = result;
  }

  Specialty? getSpecialtyById(String id) {
    try {
      return _specialties.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
