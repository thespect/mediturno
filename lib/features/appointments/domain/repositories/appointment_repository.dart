import '../models/appointment.dart';

abstract class AppointmentRepository {
  Future<List<Appointment>> getAppointments();
  Future<List<Appointment>> getUpcomingAppointments();
  Future<List<Appointment>> getPastAppointments();
  Future<Appointment> createAppointment(Appointment appointment);
  Future<void> cancelAppointment(String appointmentId, String reason);
  Future<Appointment?> getAppointmentById(String appointmentId);
}
