import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../appointments/domain/models/appointment.dart';
import '../../../appointments/presentation/widgets/status_badge.dart';

class BookingSuccessScreen extends StatelessWidget {
  final Appointment appointment;

  const BookingSuccessScreen({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Confirmación de Cita'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Círculo animado de éxito
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 3),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.primary,
                  size: 52,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Cita Registrada!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Tu solicitud ha sido guardada en la clínica. Hemos programado recordatorios locales automáticos para avisarte antes de la hora de tu cita.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Tarjeta Resumen
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Estado inicial:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        StatusBadge(status: appointment.status),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    _buildSummaryRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Especialista',
                      value: appointment.doctorName,
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryRow(
                      icon: Icons.medical_services_outlined,
                      label: 'Especialidad',
                      value: appointment.specialtyName,
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryRow(
                      icon: Icons.calendar_today_rounded,
                      label: 'Fecha y Hora',
                      value: DateFormatter.formatFullWithTime(appointment.dateTime),
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryRow(
                      icon: Icons.room_outlined,
                      label: 'Ubicación',
                      value: appointment.roomNumber,
                    ),
                    if (appointment.reasonForVisit.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildSummaryRow(
                        icon: Icons.notes_rounded,
                        label: 'Motivo',
                        value: appointment.reasonForVisit,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Botones de acción
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Cerrar y volver al stack
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('Volver al Inicio'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('Ver Mis Citas'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
