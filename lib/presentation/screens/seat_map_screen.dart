import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/seat_model.dart';
import '../viewmodels/seat_viewmodel.dart';
import '../widgets/seat_item.dart';

class SeatMapScreen extends StatelessWidget {
  const SeatMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SeatViewModel>(context);
    final screenSize = MediaQuery.of(context).size;
    final seats = viewModel.seats;

    return Scaffold(
      appBar: AppBar(title: const Text("좌석 배치도")),
      body: Stack(
        children: [
          for (int i = 0; i < seats.length; i++)
            Positioned(
              left: seats[i].position.dx,
              top: seats[i].position.dy,
              child: Draggable<int>(
                data: i,
                feedback: SeatItem(
                  index: i,
                  isSelected: seats[i].selected,
                  isDragging: true,
                  size: viewModel.itemSize,
                ),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: SeatItem(
                    index: i,
                    isSelected: seats[i].selected,
                    isDragging: false,
                    size: viewModel.itemSize,
                  ),
                ),
                onDragEnd: (details) {
                  Offset offset = Offset(
                    details.offset.dx,
                    details.offset.dy - kToolbarHeight,
                  );
                  viewModel.updateSeatPosition(i, offset, screenSize);
                },
                child: GestureDetector(
                  onTap: () => viewModel.toggleSeat(i),
                  child: SeatItem(
                    index: i,
                    isSelected: seats[i].selected,
                    isDragging: false,
                    size: viewModel.itemSize,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
