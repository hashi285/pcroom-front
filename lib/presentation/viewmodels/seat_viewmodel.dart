import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/models/seat_model.dart';

class SeatViewModel extends ChangeNotifier {
  final double itemSize = 60;
  final double minDistance = 70;
  final int itemCount = 10;
  final double snapThreshold = 30;

  late List<SeatModel> _seats;

  List<SeatModel> get seats => _seats;

  SeatViewModel() {
    _seats = List.generate(
      itemCount,
          (i) => SeatModel(
        id: i,
        position: Offset(
          20.0 + (i % 5) * (itemSize + 20),
          20.0 + (i ~/ 5) * (itemSize + 20),
        ),
      ),
    );
  }

  void toggleSeat(int index) {
    _seats[index].selected = !_seats[index].selected;
    notifyListeners();
  }

  void updateSeatPosition(int index, Offset newPos, Size screenSize) {
    Offset adjusted = _adjustPosition(index, newPos, screenSize);
    _seats[index].position = adjusted;
    notifyListeners();
  }

  Offset _adjustPosition(int movingIndex, Offset newPos, Size screenSize) {
    Offset adjustedPos = newPos;

    for (int i = 0; i < itemCount; i++) {
      if (i == movingIndex) continue;
      final other = _seats[i].position;

      final dx = (adjustedPos.dx - other.dx).abs();
      final dy = (adjustedPos.dy - other.dy).abs();

      if (dx < snapThreshold) {
        adjustedPos = Offset(other.dx, adjustedPos.dy.clamp(0, screenSize.height - itemSize));
      }

      if (dy < snapThreshold) {
        adjustedPos = Offset(adjustedPos.dx.clamp(0, screenSize.width - itemSize), other.dy);
      }

      final dist = sqrt(pow(adjustedPos.dx - other.dx, 2) + pow(adjustedPos.dy - other.dy, 2));
      if (dist < minDistance) {
        final dx = adjustedPos.dx - other.dx;
        final dy = adjustedPos.dy - other.dy;
        final distNonZero = dist == 0 ? 0.1 : dist;

        double newX = adjustedPos.dx + (minDistance - dist) * (dx / distNonZero);
        double newY = adjustedPos.dy + (minDistance - dist) * (dy / distNonZero);

        newX = newX.clamp(0, screenSize.width - itemSize);
        newY = newY.clamp(0, screenSize.height - itemSize);
        adjustedPos = Offset(newX, newY);
      }
    }

    return adjustedPos;
  }
}
