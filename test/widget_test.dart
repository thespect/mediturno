import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediturno/core/services/notification_service.dart';
import 'package:mediturno/features/appointments/data/appointment_repository_impl.dart';
import 'package:mediturno/features/catalog/data/catalog_repository_impl.dart';
import 'package:mediturno/features/patient/data/patient_repository_impl.dart';
import 'package:mediturno/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('MediTurno Smoke Test - Carga de interfaz y navegación', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    final notifService = LocalNotificationServiceImpl();
    final patientRepo = PatientRepositoryImpl();
    final catalogRepo = CatalogRepositoryImpl();
    final appointmentRepo = AppointmentRepositoryImpl(notifService);

    await tester.pumpWidget(
      MediTurnoApp(
        notificationService: notifService,
        patientRepository: patientRepo,
        catalogRepository: catalogRepo,
        appointmentRepository: appointmentRepo,
      ),
    );

    // Permitir la inicialización asíncrona de providers
    await tester.pumpAndSettle();

    // Comprobar que los elementos de navegación y bienvenida se renderizan
    expect(find.text('Inicio'), findsWidgets);
    expect(find.text('Directorio'), findsWidgets);
    expect(find.text('Mis Citas'), findsWidgets);
    expect(find.text('Perfil'), findsWidgets);
  });
}
