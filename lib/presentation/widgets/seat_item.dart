import 'package:flutter/material.dart';

class SeatItem extends StatelessWidget {
  final int index;
  final bool isSelected;
  final bool isDragging;
  final double size;

  const SeatItem({
    super.key,
    required this.index,
    required this.isSelected,
    required this.isDragging,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDragging
            ? [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 8, offset: Offset(0, 4))]
            : [],
      ),
      alignment: Alignment.center,
      child: Text(
        "Item ${index + 1}",
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
