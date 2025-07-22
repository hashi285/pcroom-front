import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 가로 모드 고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double itemSize = 60;
  int itemCount = 0;

  List<Offset> positions = [];
  List<bool> selected = [];
  final TextEditingController controller = TextEditingController();

  void generateItems() {
    final input = int.tryParse(controller.text);
    if (input == null || input <= 0) return;

    final newPositions = List.generate(
      input,
          (index) => Offset(
        20.0 + (index % 5) * (itemSize + 20),
        100.0 + (index ~/ 5) * (itemSize + 20),
      ),
    );

    setState(() {
      itemCount = input;
      positions = newPositions;
      selected = List.generate(input, (_) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height - kToolbarHeight;

    return Scaffold(
      appBar: AppBar(title: const Text('사용자 입력 바둑판')),
      body: Stack(
        children: [
          Positioned(
            left: 20,
            top: 10,
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: '아이템 수'),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: generateItems,
                  child: const Text('생성'),
                ),
              ],
            ),
          ),
          ...List.generate(itemCount, (i) {
            return Positioned(
              left: positions[i].dx.clamp(0, screenWidth - itemSize),
              top: positions[i].dy.clamp(0, screenHeight - itemSize),
              child: Draggable<int>(
                data: i,
                feedback: buildItem(i, isDragging: true),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: buildItem(i),
                ),
                onDragEnd: (details) {
                  setState(() {
                    double newX = details.offset.dx.clamp(0, screenWidth - itemSize);
                    double newY = (details.offset.dy - kToolbarHeight).clamp(0, screenHeight - itemSize);
                    positions[i] = Offset(newX, newY);
                  });
                },
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selected[i] = !selected[i];
                    });
                  },
                  child: buildItem(i),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget buildItem(int index, {bool isDragging = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: itemSize,
      height: itemSize,
      decoration: BoxDecoration(
        color: selected[index] ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDragging
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ]
            : [],
      ),
      alignment: Alignment.center,
      child: Text(
        'Item ${index + 1}',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
