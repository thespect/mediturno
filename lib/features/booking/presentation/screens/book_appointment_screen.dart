import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../appointments/presentation/providers/appointment_provider.dart';
import '../../../catalog/presentation/providers/catalog_provider.dart';
import '../../../patient/presentation/providers/patient_provider.dart';
import '../providers/booking_provider.dart';
import '../widgets/step_indicator.dart';
import '../widgets/time_slot_selector.dart';
import 'booking_success_screen.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _reasonController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<BookingProvider, CatalogProvider, PatientProvider>(
      builder: (context, booking, catalog, patientProvider, _) {
        final currentStep = booking.currentStep;
        final patient = patientProvider.patient;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Agendar Cita Médica'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (currentStep > 0) {
                  booking.previousStep();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          body: Column(
            children: [
              StepIndicator(
                currentStep: currentStep,
                steps: const ['Especialista', 'Fecha y Hora', 'Confirmación'],
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildCurrentStepView(
                    context,
                    booking,
                    catalog,
                    patient?.id ?? 'pat-1001',
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomActions(
            context,
            booking,
            patient?.id ?? 'pat-1001',
          ),
        );
      },
    );
  }

  Widget _buildCurrentStepView(
    BuildContext context,
    BookingProvider booking,
    CatalogProvider catalog,
    String patientId,
  ) {
    switch (booking.currentStep) {
      case 0:
        return _buildStep1SelectDoctor(context, booking, catalog);
      case 1:
        return _buildStep2SelectDateTime(context, booking);
      case 2:
        return _buildStep3ReasonAndConfirm(context, booking);
      default:
        return const SizedBox.shrink();
    }
  }

  // PASO 1: Selección de Especialista
  Widget _buildStep1SelectDoctor(
    BuildContext context,
    BookingProvider booking,
    CatalogProvider catalog,
  ) {
    final doctors = catalog.doctors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1. Selecciona a tu Médico Especialista',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Elige el profesional de salud con quien deseas tener tu consulta médica:',
          style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        if (booking.selectedDoctor != null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    booking.selectedDoctor!.fullName.split(' ').map((n) => n[0]).take(2).join(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Seleccionado actualmente:',
                        style: TextStyle(fontSize: 11, color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        booking.selectedDoctor!.fullName,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        booking.selectedDoctor!.specialty?.name ?? '',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle_rounded, color: AppColors.primary),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'O cambia por otro especialista:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
        ],
        ...doctors.map((doc) {
          final isSelected = booking.selectedDoctor?.id == doc.id;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryLight.withOpacity(0.3) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  doc.fullName.split(' ').map((n) => n[0]).take(2).join(),
                  style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                doc.fullName,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
              ),
              subtitle: Text(
                '${doc.specialty?.name ?? ""} • ${doc.roomNumber}',
                style: const TextStyle(fontSize: 12.5),
              ),
              trailing: isSelected
                  ? const Icon(Icons.radio_button_checked, color: AppColors.primary)
                  : const Icon(Icons.radio_button_off, color: AppColors.border),
              onTap: () => booking.selectDoctor(doc),
            ),
          );
        }),
      ],
    );
  }

  // PASO 2: Fecha y Horario
  Widget _buildStep2SelectDateTime(
    BuildContext context,
    BookingProvider booking,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '2. Selecciona la Fecha y Horario',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Médico seleccionado: ${booking.selectedDoctor?.fullName ?? ""}',
          style: const TextStyle(fontSize: 13.5, color: AppColors.primary, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        // Selector horizontal interactivo de los próximos 10 días
        const Text(
          'Día de la consulta:',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 14,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index + 1));
              final isSelected = booking.selectedDate.year == date.year &&
                  booking.selectedDate.month == date.month &&
                  booking.selectedDate.day == date.day;

              final weekday = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'][date.weekday - 1];

              return InkWell(
                onTap: () => booking.selectDate(date),
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 65,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        weekday,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white.withOpacity(0.85) : AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Horarios disponibles:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            Text(
              DateFormatter.formatShort(booking.selectedDate),
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 12),

        TimeSlotSelector(
          slots: booking.availableSlots,
          selectedSlot: booking.selectedTimeSlot,
          isLoading: booking.isLoadingSlots,
          onSelectSlot: booking.selectTimeSlot,
        ),
      ],
    );
  }

  // PASO 3: Motivo y Confirmación
  Widget _buildStep3ReasonAndConfirm(
    BuildContext context,
    BookingProvider booking,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '3. Motivo de Consulta y Confirmación',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Describe brevemente tus síntomas o el objetivo de la cita médica:',
          style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),

        TextField(
          controller: _reasonController,
          decoration: const InputDecoration(
            labelText: 'Motivo principal de consulta *',
            hintText: 'Ej. Dolor de cabeza persistente, chequeo anual, etc.',
          ),
          onChanged: (val) {
            booking.setReasonAndNotes(val, _notesController.text);
          },
        ),
        const SizedBox(height: 14),

        TextField(
          controller: _notesController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Notas o antecedentes para el médico (opcional)',
            hintText: 'Ej. Medicación actual, alergias o síntomas adicionales...',
          ),
          onChanged: (val) {
            booking.setReasonAndNotes(_reasonController.text, val);
          },
        ),
        const SizedBox(height: 24),

        // Resumen antes de pulsar confirmación
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
                'Resumen de la cita programada:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              _buildReviewItem('Médico:', booking.selectedDoctor?.fullName ?? ''),
              _buildReviewItem('Especialidad:', booking.selectedDoctor?.specialty?.name ?? ''),
              _buildReviewItem('Consultorio:', booking.selectedDoctor?.roomNumber ?? ''),
              _buildReviewItem(
                'Horario:',
                booking.selectedTimeSlot != null
                    ? '${DateFormatter.formatShort(booking.selectedDate)} - ${DateFormatter.formatTime(booking.selectedTimeSlot!.dateTime)}'
                    : 'Sin horario',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    BookingProvider booking,
    String patientId,
  ) {
    final currentStep = booking.currentStep;
    final canProceedStep1 = booking.selectedDoctor != null;
    final canProceedStep2 = booking.selectedTimeSlot != null;
    final isLastStep = currentStep == 2;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (currentStep > 0) ...[
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: booking.isSubmitting ? null : booking.previousStep,
                  child: const Text('Atrás'),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: booking.isSubmitting
                    ? null
                    : () async {
                        if (currentStep == 0) {
                          if (canProceedStep1) booking.nextStep();
                        } else if (currentStep == 1) {
                          if (canProceedStep2) booking.nextStep();
                        } else if (isLastStep) {
                          final newAppointment = await booking.confirmAppointment(patientId);
                          if (newAppointment != null && context.mounted) {
                            await context.read<AppointmentProvider>().loadAppointments();
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookingSuccessScreen(appointment: newAppointment),
                                ),
                              );
                            }
                          } else if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error al registrar la cita. Por favor intenta de nuevo.'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        }
                      },
                child: booking.isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        isLastStep
                            ? 'Confirmar Cita'
                            : (currentStep == 0 && !canProceedStep1
                                ? 'Elige un médico'
                                : (currentStep == 1 && !canProceedStep2
                                    ? 'Elige un horario'
                                    : 'Continuar')),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
