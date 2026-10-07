import 'package:flutter/material.dart';
import '../../domain/models/specialty.dart';

class SpecialtyCard extends StatelessWidget {
  final Specialty specialty;
  final bool isSelected;
  final VoidCallback onTap;

  const SpecialtyCard({
    super.key,
    required this.specialty,
    this.isSelected = false,
    required this.onTap,
  });

  IconData _mapIcon(String iconKey) {
    switch (iconKey) {
      case 'medical_services':
        return Icons.medical_services_rounded;
      case 'child_care':
        return Icons.child_care_rounded;
      case 'favorite':
        return Icons.favorite_rounded;
      case 'sentiment_satisfied_alt':
        return Icons.clean_hands_rounded;
      case 'spa':
        return Icons.spa_rounded;
      case 'pregnant_woman':
        return Icons.pregnant_woman_rounded;
      case 'visibility':
        return Icons.visibility_rounded;
      case 'healing':
        return Icons.healing_rounded;
      default:
        return Icons.local_hospital_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(specialty.colorValue);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 105,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.12) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _mapIcon(specialty.iconKey),
                color: color,
                size: 22,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              specialty.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? color : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
