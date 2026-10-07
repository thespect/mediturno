import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../appointments/presentation/providers/appointment_provider.dart';
import '../../../appointments/presentation/screens/appointments_screen.dart';
import '../../../catalog/presentation/screens/doctors_screen.dart';
import '../../../patient/presentation/screens/patient_profile_screen.dart';
import 'home_screen.dart';

class MainNavScaffold extends StatefulWidget {
  const MainNavScaffold({super.key});

  @override
  State<MainNavScaffold> createState() => _MainNavScaffoldState();
}

class _MainNavScaffoldState extends State<MainNavScaffold> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final upcomingCount = context.watch<AppointmentProvider>().upcomingAppointments.length;

    final List<Widget> screens = [
      HomeScreen(onNavigateTab: _onTabTapped),
      const DoctorsScreen(),
      const AppointmentsScreen(),
      const PatientProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTabTapped,
          backgroundColor: Colors.white,
          indicatorColor: AppColors.primaryLight,
          elevation: 0,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
              label: 'Inicio',
            ),
            const NavigationDestination(
              icon: Icon(Icons.medical_services_outlined),
              selectedIcon: Icon(Icons.medical_services_rounded, color: AppColors.primary),
              label: 'Directorio',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: upcomingCount > 0,
                label: Text('$upcomingCount'),
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.calendar_month_outlined),
              ),
              selectedIcon: Badge(
                isLabelVisible: upcomingCount > 0,
                label: Text('$upcomingCount'),
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.calendar_month_rounded, color: AppColors.primary),
              ),
              label: 'Mis Citas',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded, color: AppColors.primary),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
