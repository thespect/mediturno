import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../catalog/domain/models/time_slot.dart';

class TimeSlotSelector extends StatelessWidget {
  final List<TimeSlot> slots;
  final TimeSlot? selectedSlot;
  final ValueChanged<TimeSlot> onSelectSlot;
  final bool isLoading;

  const TimeSlotSelector({
    super.key,
    required this.slots,
    required this.selectedSlot,
    required this.onSelectSlot,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(strokeWidth: 2),
              SizedBox(height: 12),
              Text(
                'Consultando disponibilidad en tiempo real...',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    if (slots.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: Text(
            'No hay horarios disponibles para esta fecha. Intenta con otro día.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: slots.map((slot) {
        final isSelected = selectedSlot?.id == slot.id;
        final isAvailable = slot.isAvailable;
        final timeString = DateFormatter.formatTime(slot.dateTime);

        return InkWell(
          onTap: isAvailable ? () => onSelectSlot(slot) : null,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : (isAvailable ? Colors.white : const Color(0xFFF1F5F9)),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : (isAvailable ? AppColors.border : const Color(0xFFE2E8F0)),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isAvailable ? Icons.access_time_rounded : Icons.block_rounded,
                  size: 14,
                  color: isSelected
                      ? Colors.white
                      : (isAvailable ? AppColors.textSecondary : AppColors.textMuted),
                ),
                const SizedBox(width: 6),
                Text(
                  timeString,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isAvailable ? AppColors.textPrimary : AppColors.textMuted),
                    decoration: isAvailable ? null : TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
