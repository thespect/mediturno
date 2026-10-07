import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/models/patient.dart';
import '../providers/patient_provider.dart';

class EditPatientScreen extends StatefulWidget {
  final Patient patient;

  const EditPatientScreen({
    super.key,
    required this.patient,
  });

  @override
  State<EditPatientScreen> createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _docController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _allergiesController;
  late String _selectedBloodType;

  final List<String> _bloodTypes = ['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.patient.fullName);
    _docController = TextEditingController(text: widget.patient.documentId);
    _emailController = TextEditingController(text: widget.patient.email);
    _phoneController = TextEditingController(text: widget.patient.phone);
    _allergiesController = TextEditingController(text: widget.patient.allergiesNotes);
    _selectedBloodType = _bloodTypes.contains(widget.patient.bloodType)
        ? widget.patient.bloodType
        : 'O+';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _docController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Información del Paciente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Datos Personales',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre Completo *',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'El nombre es requerido' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _docController,
                decoration: const InputDecoration(
                  labelText: 'Documento de Identidad (DNI/CURP/Cédula) *',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'El documento es requerido' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico *',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (val) =>
                    (val == null || !val.contains('@')) ? 'Ingresa un correo válido' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Teléfono de Contacto *',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'El teléfono es requerido' : null,
              ),
              const SizedBox(height: 24),

              const Text(
                'Información Médica Básica',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                value: _selectedBloodType,
                decoration: const InputDecoration(
                  labelText: 'Grupo Sanguíneo',
                  prefixIcon: Icon(Icons.bloodtype_outlined),
                ),
                items: _bloodTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedBloodType = val);
                },
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _allergiesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Alergias o Antecedentes Clínicos Relevantes',
                  prefixIcon: Icon(Icons.warning_amber_rounded),
                  hintText: 'Ej. Alergia a la penicilina, asma, etc.',
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final updated = widget.patient.copyWith(
                        fullName: _nameController.text.trim(),
                        documentId: _docController.text.trim(),
                        email: _emailController.text.trim(),
                        phone: _phoneController.text.trim(),
                        bloodType: _selectedBloodType,
                        allergiesNotes: _allergiesController.text.trim().isNotEmpty
                            ? _allergiesController.text.trim()
                            : 'Ninguna conocida',
                      );

                      final success =
                          await context.read<PatientProvider>().updatePatient(updated);

                      if (context.mounted && success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Perfil de paciente actualizado correctamente.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Text('Guardar Cambios'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
