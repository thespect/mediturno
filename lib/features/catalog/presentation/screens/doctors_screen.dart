import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../booking/presentation/providers/booking_provider.dart';
import '../../../booking/presentation/screens/book_appointment_screen.dart';
import '../providers/catalog_provider.dart';
import '../widgets/doctor_card.dart';

class DoctorsScreen extends StatelessWidget {
  final String? initialSpecialtyId;

  const DoctorsScreen({
    super.key,
    this.initialSpecialtyId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CatalogProvider>(
      builder: (context, catalog, _) {
        final specialties = catalog.specialties;
        final doctors = catalog.doctors;
        final selectedSpecId = catalog.selectedSpecialtyId;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Directorio Médico'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  onChanged: catalog.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Buscar médico, especialidad o consultorio...',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
                    suffixIcon: catalog.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () => catalog.setSearchQuery(''),
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  ),
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              // Filtro horizontal de especialidades
              Container(
                height: 48,
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: specialties.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      final isAllSelected = selectedSpecId == null;
                      return ChoiceChip(
                        label: const Text('Todos'),
                        selected: isAllSelected,
                        onSelected: (_) => catalog.selectSpecialty(null),
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isAllSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: isAllSelected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 12.5,
                        ),
                      );
                    }

                    final spec = specialties[index - 1];
                    final isSelected = selectedSpecId == spec.id;

                    return ChoiceChip(
                      label: Text(spec.name),
                      selected: isSelected,
                      onSelected: (_) => catalog.selectSpecialty(spec.id),
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 12.5,
                      ),
                    );
                  },
                ),
              ),

              // Lista de médicos filtrados
              Expanded(
                child: catalog.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : doctors.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.person_search_rounded,
                                    size: 64,
                                    color: AppColors.textMuted,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No se encontraron especialistas',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Intenta modificando el término de búsqueda o seleccionando otra especialidad.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
                                  ),
                                  const SizedBox(height: 16),
                                  OutlinedButton(
                                    onPressed: () {
                                      catalog.selectSpecialty(null);
                                      catalog.setSearchQuery('');
                                    },
                                    child: const Text('Restablecer Filtros'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: doctors.length,
                            itemBuilder: (context, index) {
                              final doctor = doctors[index];
                              return DoctorCard(
                                doctor: doctor,
                                onBookTap: () {
                                  context.read<BookingProvider>().startBookingWithDoctor(doctor);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const BookAppointmentScreen()),
                                  );
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}
