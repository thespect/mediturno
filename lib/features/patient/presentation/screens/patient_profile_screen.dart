import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../appointments/domain/models/appointment_status.dart';
import '../../../appointments/presentation/providers/appointment_provider.dart';
import '../providers/patient_provider.dart';
import 'edit_patient_screen.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PatientProvider, AppointmentProvider>(
      builder: (context, patientProv, appointmentProv, _) {
        final patient = patientProv.patient;
        final upcomingCount = appointmentProv.upcomingAppointments.length;
        final attendedCount = appointmentProv.pastAppointments
            .where((a) => a.status == AppointmentStatus.atendida)
            .length;

        if (patientProv.isLoading || patient == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Perfil del Paciente'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Editar datos',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditPatientScreen(patient: patient),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Cabecera del Paciente
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.primaryLight,
                        child: Text(
                          patient.fullName.isNotEmpty
                              ? patient.fullName.split(' ').map((n) => n[0]).take(2).join()
                              : 'PT',
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        patient.fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Cédula / DNI: ${patient.documentId}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 16),

                      // Contador de citas
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricItem(
                              label: 'Citas Activas',
                              value: '$upcomingCount',
                              color: AppColors.primary,
                            ),
                          ),
                          Container(width: 1, height: 35, color: AppColors.border),
                          Expanded(
                            child: _buildMetricItem(
                              label: 'Atendidas',
                              value: '$attendedCount',
                              color: AppColors.secondary,
                            ),
                          ),
                          Container(width: 1, height: 35, color: AppColors.border),
                          Expanded(
                            child: _buildMetricItem(
                              label: 'Tipo Sangre',
                              value: patient.bloodType,
                              color: const Color(0xFFE11D48),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Alerta de Alergias
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.statusSolicitadaBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppColors.statusSolicitadaText),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Alergias y Notas Médicas',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.statusSolicitadaText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              patient.allergiesNotes,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF78350F),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Datos de Contacto
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Datos de Contacto',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildInfoRow(Icons.email_outlined, 'Correo', patient.email),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.phone_outlined, 'Teléfono', patient.phone),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Tarjeta de la Clínica
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.local_hospital_rounded, color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Clínica MediTurno - Atención Primaria',
                                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Centro de Salud Familiar',
                                style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.place_outlined, 'Dirección', 'Av. Salud y Bienestar #450, Piso 1'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.support_agent_rounded, 'Urgencias', '(55) 8000-CLINICA'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.edit_note_rounded),
                    label: const Text('Actualizar Datos del Paciente'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditPatientScreen(patient: patient),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textMuted),
        const SizedBox(width: 10),
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
