import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

enum AppointmentStatus {
  solicitada,
  confirmada,
  cancelada,
  atendida;

  String get label {
    switch (this) {
      case AppointmentStatus.solicitada:
        return 'Solicitada';
      case AppointmentStatus.confirmada:
        return 'Confirmada';
      case AppointmentStatus.cancelada:
        return 'Cancelada';
      case AppointmentStatus.atendida:
        return 'Atendida';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case AppointmentStatus.solicitada:
        return AppColors.statusSolicitadaBg;
      case AppointmentStatus.confirmada:
        return AppColors.statusConfirmadaBg;
      case AppointmentStatus.cancelada:
        return AppColors.statusCanceladaBg;
      case AppointmentStatus.atendida:
        return AppColors.statusAtendidaBg;
    }
  }

  Color get textColor {
    switch (this) {
      case AppointmentStatus.solicitada:
        return AppColors.statusSolicitadaText;
      case AppointmentStatus.confirmada:
        return AppColors.statusConfirmadaText;
      case AppointmentStatus.cancelada:
        return AppColors.statusCanceladaText;
      case AppointmentStatus.atendida:
        return AppColors.statusAtendidaText;
    }
  }

  IconData get icon {
    switch (this) {
      case AppointmentStatus.solicitada:
        return Icons.hourglass_top_rounded;
      case AppointmentStatus.confirmada:
        return Icons.check_circle_rounded;
      case AppointmentStatus.cancelada:
        return Icons.cancel_rounded;
      case AppointmentStatus.atendida:
        return Icons.task_alt_rounded;
    }
  }

  static AppointmentStatus fromString(String value) {
    return AppointmentStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => AppointmentStatus.solicitada,
    );
  }
}
