import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../../appointments/domain/models/appointment.dart';
import '../../../appointments/domain/models/appointment_status.dart';
import '../../../appointments/domain/repositories/appointment_repository.dart';
import '../../../catalog/domain/models/doctor.dart';
import '../../../catalog/domain/models/specialty.dart';
import '../../../catalog/domain/models/time_slot.dart';
import '../../../catalog/domain/repositories/catalog_repository.dart';

class BookingProvider extends ChangeNotifier {
  final CatalogRepository _catalogRepository;
  final AppointmentRepository _appointmentRepository;

  Doctor? _selectedDoctor;
  Specialty? _selectedSpecialty;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeSlot? _selectedTimeSlot;
  List<TimeSlot> _availableSlots = [];
  bool _isLoadingSlots = false;

  String _reasonForVisit = '';
  String _notes = '';
  int _currentStep = 0;
  bool _isSubmitting = false;

  BookingProvider(this._catalogRepository, this._appointmentRepository);

  Doctor? get selectedDoctor => _selectedDoctor;
  Specialty? get selectedSpecialty => _selectedSpecialty;
  DateTime get selectedDate => _selectedDate;
  TimeSlot? get selectedTimeSlot => _selectedTimeSlot;
  List<TimeSlot> get availableSlots => _availableSlots;
  bool get isLoadingSlots => _isLoadingSlots;
  String get reasonForVisit => _reasonForVisit;
  String get notes => _notes;
  int get currentStep => _currentStep;
  bool get isSubmitting => _isSubmitting;

  void startBookingWithDoctor(Doctor doctor) {
    _reset();
    _selectedDoctor = doctor;
    _selectedSpecialty = doctor.specialty;
    _currentStep = 1; // Directo a elegir fecha/hora
    loadSlotsForSelectedDoctor();
    notifyListeners();
  }

  void startBookingFresh() {
    _reset();
    notifyListeners();
  }

  void selectDoctor(Doctor doctor) {
    _selectedDoctor = doctor;
    _selectedSpecialty = doctor.specialty;
    _selectedTimeSlot = null;
    loadSlotsForSelectedDoctor();
    notifyListeners();
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    _selectedTimeSlot = null;
    loadSlotsForSelectedDoctor();
    notifyListeners();
  }

  void selectTimeSlot(TimeSlot slot) {
    _selectedTimeSlot = slot;
    notifyListeners();
  }

  void setReasonAndNotes(String reason, String notes) {
    _reasonForVisit = reason;
    _notes = notes;
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < 2) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  Future<void> loadSlotsForSelectedDoctor() async {
    if (_selectedDoctor == null) return;
    _isLoadingSlots = true;
    notifyListeners();

    try {
      _availableSlots = await _catalogRepository.getAvailableSlots(
        _selectedDoctor!.id,
        _selectedDate,
      );
    } catch (_) {
      _availableSlots = [];
    } finally {
      _isLoadingSlots = false;
      notifyListeners();
    }
  }

  Future<Appointment?> confirmAppointment(String patientId) async {
    if (_selectedDoctor == null || _selectedTimeSlot == null) return null;

    _isSubmitting = true;
    notifyListeners();

    try {
      final randNotificationId = Random().nextInt(90000) + 1000;
      final newAppointment = Appointment(
        id: const Uuid().v4(),
        patientId: patientId,
        doctorId: _selectedDoctor!.id,
        doctorName: _selectedDoctor!.fullName,
        doctorAvatar: _selectedDoctor!.avatarUrl,
        specialtyName: _selectedSpecialty?.name ?? 'Medicina General',
        roomNumber: _selectedDoctor!.roomNumber,
        dateTime: _selectedTimeSlot!.dateTime,
        reasonForVisit: _reasonForVisit.trim().isNotEmpty
            ? _reasonForVisit.trim()
            : 'Consulta médica general',
        notes: _notes.trim(),
        status: AppointmentStatus.solicitada,
        createdAt: DateTime.now(),
        notificationId: randNotificationId,
      );

      final created = await _appointmentRepository.createAppointment(newAppointment);
      _isSubmitting = false;
      notifyListeners();
      return created;
    } catch (e) {
      _isSubmitting = false;
      notifyListeners();
      return null;
    }
  }

  void _reset() {
    _selectedDoctor = null;
    _selectedSpecialty = null;
    _selectedDate = DateTime.now().add(const Duration(days: 1));
    _selectedTimeSlot = null;
    _availableSlots = [];
    _reasonForVisit = '';
    _notes = '';
    _currentStep = 0;
    _isSubmitting = false;
  }
}
