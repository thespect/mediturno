import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_theme.dart';
import 'core/services/notification_service.dart';
import 'features/appointments/data/appointment_repository_impl.dart';
import 'features/appointments/domain/repositories/appointment_repository.dart';
import 'features/appointments/presentation/providers/appointment_provider.dart';
import 'features/booking/presentation/providers/booking_provider.dart';
import 'features/catalog/data/catalog_repository_impl.dart';
import 'features/catalog/domain/repositories/catalog_repository.dart';
import 'features/catalog/presentation/providers/catalog_provider.dart';
import 'features/home/presentation/screens/main_nav_scaffold.dart';
import 'features/patient/data/patient_repository_impl.dart';
import 'features/patient/domain/repositories/patient_repository.dart';
import 'features/patient/presentation/providers/patient_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar formateo de fechas en español
  await initializeDateFormatting('es', null);

  // Inicializar servicio de notificaciones
  final notificationService = LocalNotificationServiceImpl();
  await notificationService.initialize();

  // Inicializar capas de datos (Repositories)
  final patientRepository = PatientRepositoryImpl();
  final catalogRepository = CatalogRepositoryImpl();
  final appointmentRepository = AppointmentRepositoryImpl(notificationService);

  runApp(
    MediTurnoApp(
      notificationService: notificationService,
      patientRepository: patientRepository,
      catalogRepository: catalogRepository,
      appointmentRepository: appointmentRepository,
    ),
  );
}

class MediTurnoApp extends StatelessWidget {
  final NotificationService notificationService;
  final PatientRepository patientRepository;
  final CatalogRepository catalogRepository;
  final AppointmentRepository appointmentRepository;

  const MediTurnoApp({
    super.key,
    required this.notificationService,
    required this.patientRepository,
    required this.catalogRepository,
    required this.appointmentRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Servicios e interfaces
        Provider<NotificationService>.value(value: notificationService),
        Provider<PatientRepository>.value(value: patientRepository),
        Provider<CatalogRepository>.value(value: catalogRepository),
        Provider<AppointmentRepository>.value(value: appointmentRepository),

        // Gestores de Estado (Providers / ViewModels)
        ChangeNotifierProvider(
          create: (_) => PatientProvider(patientRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => CatalogProvider(catalogRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => AppointmentProvider(appointmentRepository, notificationService),
        ),
        ChangeNotifierProvider(
          create: (_) => BookingProvider(catalogRepository, appointmentRepository),
        ),
      ],
      child: MaterialApp(
        title: 'MediTurno',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavScaffold(),
      ),
    );
  }
}
