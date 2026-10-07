import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../appointments/presentation/providers/appointment_provider.dart';
import '../../../appointments/presentation/screens/appointment_detail_screen.dart';
import '../../../appointments/presentation/widgets/status_badge.dart';
import '../../../booking/presentation/providers/booking_provider.dart';
import '../../../booking/presentation/screens/book_appointment_screen.dart';
import '../../../catalog/presentation/providers/catalog_provider.dart';
import '../../../catalog/presentation/screens/doctors_screen.dart';
import '../../../catalog/presentation/widgets/doctor_card.dart';
import '../../../catalog/presentation/widgets/specialty_card.dart';
import '../../../patient/presentation/providers/patient_provider.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int>? onNavigateTab;

  const HomeScreen({
    super.key,
    this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer3<PatientProvider, CatalogProvider, AppointmentProvider>(
      builder: (context, patientProv, catalogProv, appointmentProv, _) {
        final patientName = patientProv.patient?.fullName.split(' ').first ?? 'Paciente';
        final specialties = catalogProv.specialties;
        final topDoctors = catalogProv.allDoctors.take(4).toList();
        final upcomingAppointments = appointmentProv.upcomingAppointments;
        final nextAppointment =
            upcomingAppointments.isNotEmpty ? upcomingAppointments.first : null;

        return Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  catalogProv.loadCatalog(),
                  appointmentProv.loadAppointments(),
                  patientProv.loadPatientProfile(),
                ]);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header de Bienvenida
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hola, $patientName 👋',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              '¿En qué podemos ayudarte hoy?',
                              style: TextStyle(
                                fontSize: 13.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () => onNavigateTab?.call(3), // Tab Perfil
                          borderRadius: BorderRadius.circular(30),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: AppColors.primaryLight,
                            child: Text(
                              patientName.isNotEmpty ? patientName[0] : 'U',
                              style: const TextStyle(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Hero Banner Salud
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00897B), Color(0xFF0284C7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00897B).withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Atención Primaria y Especializada',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Agenda tu cita médica sin filas',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Consulta médicos disponibles, selecciona tu fecha y recibe recordatorios automáticos en tu móvil.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primaryDark,
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                            ),
                            icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                            label: const Text(
                              'Agendar Cita Ahora',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            onPressed: () {
                              context.read<BookingProvider>().startBookingFresh();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const BookAppointmentScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Tarjeta de Próxima Cita (si tiene alguna activa)
                    if (nextAppointment != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tu Próxima Cita',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextButton(
                            onPressed: () => onNavigateTab?.call(2), // Tab Mis Citas
                            child: const Text('Ver todas'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.primaryLight, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    AppointmentDetailScreen(appointmentId: nextAppointment.id),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  StatusBadge(status: nextAppointment.status, isCompact: true),
                                  Text(
                                    DateFormatter.getRelativeTimeSpan(nextAppointment.dateTime),
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppColors.primaryLight,
                                    child: Text(
                                      nextAppointment.doctorName
                                          .split(' ')
                                          .map((n) => n[0])
                                          .take(2)
                                          .join(),
                                      style: const TextStyle(
                                        color: AppColors.primaryDark,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          nextAppointment.doctorName,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${nextAppointment.specialtyName} • ${nextAppointment.roomNumber}',
                                          style: const TextStyle(
                                            fontSize: 12.5,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Sección de Especialidades
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Especialidades Médicas',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const DoctorsScreen()),
                            );
                          },
                          child: const Text('Ver todas'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Carrusel horizontal de especialidades
                    SizedBox(
                      height: 125,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: specialties.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final spec = specialties[index];
                          return SpecialtyCard(
                            specialty: spec,
                            isSelected: catalogProv.selectedSpecialtyId == spec.id,
                            onTap: () {
                              catalogProv.selectSpecialty(spec.id);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DoctorsScreen(initialSpecialtyId: spec.id),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 26),

                    // Médicos recomendados / destacados
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Médicos Disponibles',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            catalogProv.selectSpecialty(null);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const DoctorsScreen()),
                            );
                          },
                          child: const Text('Ver directorio'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    ...topDoctors.map(
                      (doc) => DoctorCard(
                        doctor: doc,
                        onBookTap: () {
                          context.read<BookingProvider>().startBookingWithDoctor(doc);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const BookAppointmentScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
