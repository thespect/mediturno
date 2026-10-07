import 'package:flutter/foundation.dart';
import '../../../../core/services/notification_service.dart';
import '../../domain/models/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';

class AppointmentProvider extends ChangeNotifier {
  final AppointmentRepository _repository;
  final NotificationService _notificationService;

  List<Appointment> _upcomingAppointments = [];
  List<Appointment> _pastAppointments = [];
  bool _isLoading = false;
  String? _errorMessage;

  AppointmentProvider(this._repository, this._notificationService) {
    loadAppointments();
  }

  List<Appointment> get upcomingAppointments => _upcomingAppointments;
  List<Appointment> get pastAppointments => _pastAppointments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAppointments() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _upcomingAppointments = await _repository.getUpcomingAppointments();
      _pastAppointments = await _repository.getPastAppointments();
    } catch (e) {
      _errorMessage = 'No se pudieron cargar las citas';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> cancelAppointment(String appointmentId, String reason) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.cancelAppointment(appointmentId, reason);
      await loadAppointments();
      return true;
    } catch (e) {
      _errorMessage = 'No se pudo cancelar la cita';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> addCreatedAppointment(Appointment appointment) async {
    await _repository.createAppointment(appointment);
    await loadAppointments();
  }

  Future<void> triggerTestReminder(Appointment appointment) async {
    await _notificationService.showInstantNotification(
      id: appointment.notificationId,
      title: '⏰ Recordatorio MediTurno: Cita Próxima',
      body: 'Recuerda tu cita con ${appointment.doctorName} (${appointment.specialtyName}) en ${appointment.roomNumber}.',
    );
  }
}
