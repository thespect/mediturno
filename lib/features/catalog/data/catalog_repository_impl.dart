import 'dart:math';
import '../domain/models/doctor.dart';
import '../domain/models/specialty.dart';
import '../domain/models/time_slot.dart';
import '../domain/repositories/catalog_repository.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  static const List<Specialty> _specialties = [
    Specialty(
      id: 'spec-general',
      name: 'Medicina General',
      iconKey: 'medical_services',
      description: 'Atención integral, prevención y diagnóstico clínico primario.',
      colorValue: 0xFF00897B, // Teal
    ),
    Specialty(
      id: 'spec-pediatria',
      name: 'Pediatría',
      iconKey: 'child_care',
      description: 'Cuidado médico integral de bebés, niños y adolescentes.',
      colorValue: 0xFF0284C7, // Cyan/Sky
    ),
    Specialty(
      id: 'spec-cardiologia',
      name: 'Cardiología',
      iconKey: 'favorite',
      description: 'Prevención, diagnóstico y tratamiento cardiovascular.',
      colorValue: 0xFFE11D48, // Rose/Red
    ),
    Specialty(
      id: 'spec-odontologia',
      name: 'Odontología',
      iconKey: 'sentiment_satisfied_alt',
      description: 'Salud bucal, profilaxis, resinas y ortodoncia preventiva.',
      colorValue: 0xFF7C3AED, // Violet
    ),
    Specialty(
      id: 'spec-dermatologia',
      name: 'Dermatología',
      iconKey: 'spa',
      description: 'Diagnóstico y tratamiento de afecciones de la piel.',
      colorValue: 0xFFD97706, // Amber
    ),
    Specialty(
      id: 'spec-ginecologia',
      name: 'Ginecología',
      iconKey: 'pregnant_woman',
      description: 'Salud reproductiva femenina y control prenatal.',
      colorValue: 0xFFDB2777, // Pink
    ),
    Specialty(
      id: 'spec-oftalmologia',
      name: 'Oftalmología',
      iconKey: 'visibility',
      description: 'Evaluación visual completa y salud ocular.',
      colorValue: 0xFF2563EB, // Blue
    ),
    Specialty(
      id: 'spec-traumatologia',
      name: 'Traumatología',
      iconKey: 'healing',
      description: 'Tratamiento de lesiones óseas, articulares y musculares.',
      colorValue: 0xFF059669, // Emerald
    ),
  ];

  static final List<Doctor> _doctors = [
    Doctor(
      id: 'doc-01',
      specialtyId: 'spec-general',
      fullName: 'Dra. Elena Morales',
      medicalLicense: 'MED-748291-GP',
      avatarUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=300',
      roomNumber: 'Consultorio 101 (Planta Baja)',
      biography: 'Especialista en Medicina Interna y Atención Primaria con más de 12 años de experiencia en manejo preventivo y chequeos rutinarios.',
      rating: 4.9,
      reviewsCount: 142,
      availableDays: ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'],
      specialty: _specialties[0],
    ),
    Doctor(
      id: 'doc-02',
      specialtyId: 'spec-general',
      fullName: 'Dr. Alejandro Vargas',
      medicalLicense: 'MED-891023-GP',
      avatarUrl: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&q=80&w=300',
      roomNumber: 'Consultorio 102 (Planta Baja)',
      biography: 'Médico cirujano egresado con mención de honor. Enfoque holístico en estilo de vida y prevención de enfermedades crónicas.',
      rating: 4.8,
      reviewsCount: 98,
      availableDays: ['Lunes', 'Miércoles', 'Viernes'],
      specialty: _specialties[0],
    ),
    Doctor(
      id: 'doc-03',
      specialtyId: 'spec-pediatria',
      fullName: 'Dra. Sofía Ramírez',
      medicalLicense: 'PED-562910-MX',
      avatarUrl: 'https://images.unsplash.com/photo-1594824813576-928646b5a36f?auto=format&fit=crop&q=80&w=300',
      roomNumber: 'Consultorio 204 (Ala Infantil)',
      biography: 'Pediatra certificada con subespecialidad en nutrición infantil y seguimiento del neurodesarrollo. Trato empático y cálido con los niños.',
      rating: 5.0,
      reviewsCount: 210,
      availableDays: ['Lunes', 'Martes', 'Jueves', 'Viernes'],
      specialty: _specialties[1],
    ),
    Doctor(
      id: 'doc-04',
      specialtyId: 'spec-cardiologia',
      fullName: 'Dr. Roberto Gómez',
      medicalLicense: 'CRD-339182-CL',
      avatarUrl: 'https://images.unsplash.com/photo-1537368910025-700350fe46c7?auto=format&fit=crop&q=80&w=300',
      roomNumber: 'Consultorio 301 (Piso 3)',
      biography: 'Cardiólogo clínico. Experto en hipertensión arterial, ecocardiografía y prevención de riesgo cardiovascular.',
      rating: 4.9,
      reviewsCount: 165,
      availableDays: ['Martes', 'Miércoles', 'Jueves'],
      specialty: _specialties[2],
    ),
    Doctor(
      id: 'doc-05',
      specialtyId: 'spec-odontologia',
      fullName: 'Dra. Camila Duarte',
      medicalLicense: 'ODO-992018-OD',
      avatarUrl: 'https://images.unsplash.com/photo-1582750433449-648ed127bb54?auto=format&fit=crop&q=80&w=300',
      roomNumber: 'Clínica Dental - Sala B',
      biography: 'Odontóloga especialista en estética dental, limpieza profunda por ultrasonido y rehabilitación oral conservadora.',
      rating: 4.8,
      reviewsCount: 114,
      availableDays: ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'],
      specialty: _specialties[3],
    ),
    Doctor(
      id: 'doc-06',
      specialtyId: 'spec-dermatologia',
      fullName: 'Dr. Fernando Navarro',
      medicalLicense: 'DER-448102-MX',
      avatarUrl: 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?auto=format&fit=crop&q=80&w=300',
      roomNumber: 'Consultorio 208 (Piso 2)',
      biography: 'Dermatólogo clínico y quirúrgico. Especialista en acné, dermatitis atópica y control de lunares/lesiones cutáneas.',
      rating: 4.7,
      reviewsCount: 88,
      availableDays: ['Lunes', 'Martes', 'Jueves'],
      specialty: _specialties[4],
    ),
    Doctor(
      id: 'doc-07',
      specialtyId: 'spec-ginecologia',
      fullName: 'Dra. Mariana Restrepo',
      medicalLicense: 'GIN-773192-OG',
      avatarUrl: 'https://images.unsplash.com/photo-1527613426441-4da17471b66d?auto=format&fit=crop&q=80&w=300',
      roomNumber: 'Consultorio 105 (Planta Baja)',
      biography: 'Gineco-obstetra con enfoque en salud integral de la mujer en todas las etapas de la vida y control prenatal humanizado.',
      rating: 4.9,
      reviewsCount: 177,
      availableDays: ['Lunes', 'Miércoles', 'Viernes'],
      specialty: _specialties[5],
    ),
    Doctor(
      id: 'doc-08',
      specialtyId: 'spec-traumatologia',
      fullName: 'Dr. Javier Peña',
      medicalLicense: 'TRM-128945-TP',
      avatarUrl: 'https://images.unsplash.com/photo-1584467735871-8e85353a8413?auto=format&fit=crop&q=80&w=300',
      roomNumber: 'Consultorio 305 (Piso 3)',
      biography: 'Traumatólogo y ortopedista. Experto en lesiones deportivas, artrosis, esguinces y rehabilitación musculoesquelética.',
      rating: 4.8,
      reviewsCount: 130,
      availableDays: ['Martes', 'Jueves', 'Viernes'],
      specialty: _specialties[7],
    ),
  ];

  @override
  Future<List<Specialty>> getSpecialties() async {
    await Future.delayed(const Duration(milliseconds: 100)); // Simula latencia
    return _specialties;
  }

  @override
  Future<List<Doctor>> getDoctors({String? specialtyId, String? query}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    var results = List<Doctor>.from(_doctors);

    if (specialtyId != null && specialtyId.isNotEmpty) {
      results = results.where((doc) => doc.specialtyId == specialtyId).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      results = results.where((doc) {
        final matchesName = doc.fullName.toLowerCase().contains(q);
        final matchesSpecialty = doc.specialty?.name.toLowerCase().contains(q) ?? false;
        final matchesRoom = doc.roomNumber.toLowerCase().contains(q);
        return matchesName || matchesSpecialty || matchesRoom;
      }).toList();
    }

    return results;
  }

  @override
  Future<Doctor?> getDoctorById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _doctors.firstWhere((doc) => doc.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<TimeSlot>> getAvailableSlots(String doctorId, DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final slots = <TimeSlot>[];

    // Horarios matutinos y vespertinos estándar
    final times = [
      [8, 30],
      [9, 15],
      [10, 0],
      [10, 45],
      [11, 30],
      [12, 15],
      [14, 0],
      [14, 45],
      [15, 30],
      [16, 15],
      [17, 0],
    ];

    final random = Random(date.year * 1000 + date.month * 100 + date.day + doctorId.hashCode);

    for (int i = 0; i < times.length; i++) {
      final hour = times[i][0];
      final minute = times[i][1];
      final slotDateTime = DateTime(date.year, date.month, date.day, hour, minute);

      // Disponibilidad pseudo-aleatoria pero consistente para la fecha
      final isAvailable = random.nextDouble() > 0.35;

      slots.add(TimeSlot(
        id: 'slot-$doctorId-${date.day}-$hour-$minute',
        doctorId: doctorId,
        dateTime: slotDateTime,
        isAvailable: isAvailable,
      ));
    }

    return slots;
  }
}
