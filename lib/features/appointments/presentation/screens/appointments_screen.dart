import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../booking/presentation/providers/booking_provider.dart';
import '../../../booking/presentation/screens/book_appointment_screen.dart';
import '../providers/appointment_provider.dart';
import '../widgets/appointment_card.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentProvider>(
      builder: (context, provider, _) {
        final upcoming = provider.upcomingAppointments;
        final past = provider.pastAppointments;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Mis Citas Médicas'),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textMuted,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Próximas'),
                      if (upcoming.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${upcoming.length}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Historial'),
                      if (past.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${past.length}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab 1: Próximas Citas
                    RefreshIndicator(
                      onRefresh: () => provider.loadAppointments(),
                      child: upcoming.isEmpty
                          ? _buildEmptyState(
                              title: 'No tienes citas próximas',
                              subtitle:
                                  'Agenda una consulta con nuestros especialistas de atención primaria en unos sencillos pasos.',
                              buttonText: 'Agendar una Cita Ahora',
                              icon: Icons.event_available_outlined,
                              onAction: () {
                                context.read<BookingProvider>().startBookingFresh();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const BookAppointmentScreen()),
                                );
                              },
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: upcoming.length,
                              itemBuilder: (context, index) {
                                return AppointmentCard(appointment: upcoming[index]);
                              },
                            ),
                    ),

                    // Tab 2: Historial
                    RefreshIndicator(
                      onRefresh: () => provider.loadAppointments(),
                      child: past.isEmpty
                          ? _buildEmptyState(
                              title: 'Sin historial de consultas',
                              subtitle:
                                  'Las citas atendidas o canceladas anteriormente se mostrarán organizadas en esta sección.',
                              icon: Icons.history_rounded,
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: past.length,
                              itemBuilder: (context, index) {
                                return AppointmentCard(appointment: past[index]);
                              },
                            ),
                    ),
                  ],
                ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nueva Cita', style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              context.read<BookingProvider>().startBookingFresh();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BookAppointmentScreen()),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required String title,
    required String subtitle,
    required IconData icon,
    String? buttonText,
    VoidCallback? onAction,
  }) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: const BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            if (buttonText != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.calendar_month_rounded, size: 18),
                label: Text(buttonText),
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
