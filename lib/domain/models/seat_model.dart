import 'dart:ui';

class SeatModel {
  final int id;
  Offset position;
  bool selected;

  SeatModel({
    required this.id,
    required this.position,
    this.selected = false,
  });
}
