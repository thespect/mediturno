import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/notification_service.dart';
import '../domain/models/appointment.dart';
import '../domain/models/appointment_status.dart';
import '../domain/repositories/appointment_repository.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  static const String _appointmentsKey = 'mediturno_appointments_list';
  final NotificationService _notificationService;

  AppointmentRepositoryImpl(this._notificationService);

  @override
  Future<List<Appointment>> getAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonListString = prefs.getString(_appointmentsKey);

    if (jsonListString == null || jsonListString.isEmpty) {
      final initialSeed = _generateInitialSeedAppointments();
      await _persistAppointments(initialSeed);
      return initialSeed;
    }

    try {
      final List<dynamic> decoded = json.decode(jsonListString) as List<dynamic>;
      final list = decoded
          .map((item) => Appointment.fromMap(item as Map<String, dynamic>))
          .toList();
      // Ordenar: primero las más cercanas en fecha
      list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      return list;
    } catch (e) {
      debugPrint('[AppointmentRepositoryImpl] Error decodificando citas: $e');
      return _generateInitialSeedAppointments();
    }
  }

  @override
  Future<List<Appointment>> getUpcomingAppointments() async {
    final all = await getAppointments();
    return all.where((a) => a.isUpcoming).toList();
  }

  @override
  Future<List<Appointment>> getPastAppointments() async {
    final all = await getAppointments();
    final past = all.where((a) => a.isPast).toList();
    // En el historial, mostrar las más recientes primero
    past.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return past;
  }

  @override
  Future<Appointment> createAppointment(Appointment appointment) async {
    final currentList = await getAppointments();
    final updatedList = [appointment, ...currentList];
    await _persistAppointments(updatedList);

    // Agendar recordatorio local
    await _notificationService.scheduleAppointmentReminder(
      id: appointment.notificationId,
      title: 'Recordatorio: Cita Médica MediTurno',
      body: 'Tu cita con ${appointment.doctorName} (${appointment.specialtyName}) es el ${appointment.dateTime.day}/${appointment.dateTime.month}.',
      scheduledDate: appointment.dateTime.subtract(const Duration(hours: 2)),
    );

    return appointment;
  }

  @override
  Future<void> cancelAppointment(String appointmentId, String reason) async {
    final currentList = await getAppointments();
    final index = currentList.indexWhere((a) => a.id == appointmentId);

    if (index != -1) {
      final existing = currentList[index];
      final cancelled = existing.copyWith(
        status: AppointmentStatus.cancelada,
        cancellationReason: reason,
      );
      currentList[index] = cancelled;
      await _persistAppointments(currentList);

      // Cancelar recordatorio local asociado
      await _notificationService.cancelReminder(existing.notificationId);
    }
  }

  @override
  Future<Appointment?> getAppointmentById(String appointmentId) async {
    final all = await getAppointments();
    try {
      return all.firstWhere((a) => a.id == appointmentId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _persistAppointments(List<Appointment> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(list.map((a) => a.toMap()).toList());
    await prefs.setString(_appointmentsKey, jsonString);
  }

  List<Appointment> _generateInitialSeedAppointments() {
    final now = DateTime.now();

    return [
      // 1. Cita Próxima Confirmada (Mañana a las 09:30 AM)
      Appointment(
        id: 'apt-seed-01',
        patientId: 'pat-1001',
        doctorId: 'doc-04',
        doctorName: 'Dr. Roberto Gómez',
        doctorAvatar: 'https://images.unsplash.com/photo-1537368910025-700350fe46c7?auto=format&fit=crop&q=80&w=300',
        specialtyName: 'Cardiología',
        roomNumber: 'Consultorio 301 (Piso 3)',
        dateTime: DateTime(now.year, now.month, now.day + 1, 9, 30),
        reasonForVisit: 'Control rutinario de presión arterial y revisión de electrocardiograma.',
        notes: 'Llevar los estudios de sangre previos en ayunas.',
        status: AppointmentStatus.confirmada,
        createdAt: now.subtract(const Duration(days: 2)),
        notificationId: 101,
      ),
      // 2. Cita Próxima Solicitada (En 3 días a las 11:00 AM)
      Appointment(
        id: 'apt-seed-02',
        patientId: 'pat-1001',
        doctorId: 'doc-03',
        doctorName: 'Dra. Sofía Ramírez',
        doctorAvatar: 'https://images.unsplash.com/photo-1594824813576-928646b5a36f?auto=format&fit=crop&q=80&w=300',
        specialtyName: 'Pediatría',
        roomNumber: 'Consultorio 204 (Ala Infantil)',
        dateTime: DateTime(now.year, now.month, now.day + 3, 11, 0),
        reasonForVisit: 'Valoración de crecimiento y cartilla de vacunación.',
        notes: 'Presentar cartilla nacional de salud infantil.',
        status: AppointmentStatus.solicitada,
        createdAt: now.subtract(const Duration(hours: 5)),
        notificationId: 102,
      ),
      // 3. Cita Pasada Atendida (Hace 2 semanas)
      Appointment(
        id: 'apt-seed-03',
        patientId: 'pat-1001',
        doctorId: 'doc-01',
        doctorName: 'Dra. Elena Morales',
        doctorAvatar: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=300',
        specialtyName: 'Medicina General',
        roomNumber: 'Consultorio 101 (Planta Baja)',
        dateTime: now.subtract(const Duration(days: 14, hours: 2)),
        reasonForVisit: 'Chequeo preventivo anual y cuadro gripal estacional.',
        notes: 'Se recetó tratamiento sintomático por 5 días.',
        status: AppointmentStatus.atendida,
        createdAt: now.subtract(const Duration(days: 18)),
        notificationId: 103,
      ),
      // 4. Cita Pasada Cancelada (El mes pasado)
      Appointment(
        id: 'apt-seed-04',
        patientId: 'pat-1001',
        doctorId: 'doc-05',
        doctorName: 'Dra. Camila Duarte',
        doctorAvatar: 'https://images.unsplash.com/photo-1582750433449-648ed127bb54?auto=format&fit=crop&q=80&w=300',
        specialtyName: 'Odontología',
        roomNumber: 'Clínica Dental - Sala B',
        dateTime: now.subtract(const Duration(days: 28)),
        reasonForVisit: 'Limpieza dental y profilaxis general.',
        notes: '',
        status: AppointmentStatus.cancelada,
        cancellationReason: 'Imprevisto laboral del paciente. Se reprogramará en otra fecha.',
        createdAt: now.subtract(const Duration(days: 35)),
        notificationId: 104,
      ),
    ];
  }
}
