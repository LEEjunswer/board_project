import 'package:board_project/controllers/board_home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class BoardViewScreen extends StatefulWidget{
  const BoardViewScreen({Key? key}) : super(key: key);

  @override
  _BoardViewScreenState createState() => _BoardViewScreenState();
}
class _BoardViewScreenState extends State<BoardViewScreen> {
  final BoardHomeController controller = Get.find<BoardHomeController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: const Color(0xFFF0F3F9),
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 200,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.9,
            child: Align(
              alignment: Alignment.center,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: List.generate(
                    controller.buttonLabels.length, (index) {
                  return ElevatedButton(
                    onPressed: () {
                      controller.categoryTabChange(index);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/board_$index.png',
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 4),
                        Text(controller.buttonLabels[index]),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.refreshBoardList(controller.categoryTab.value);
              },
              child: Obx(() {
                final boards = controller.boardList;

                if (boards.isEmpty) {
                  return const Center(child: Text('게시글이 없습니다.'));
                }
                return ListView.builder(
                  controller: controller.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: boards.length + 1,
                  itemBuilder: (context, index) {
                    if (index == boards.length) {
                      return controller.hasMoreData.value
                          ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      )
                          : const SizedBox.shrink();
                    }

                    final board = boards[index];
                    final parsedDate = DateTime.tryParse(board.createdAt ?? '');
                    final createdAt = parsedDate != null
                        ? '${parsedDate.year}-${parsedDate.month.toString()
                        .padLeft(2, '0')}-${parsedDate.day.toString().padLeft(
                        2, '0')} '
                        '${parsedDate.hour.toString().padLeft(
                        2, '0')}:${parsedDate.minute.toString().padLeft(
                        2, '0')}'
                        : '';
                    final koreanCategory = controller.getCategoryChangeKorean(
                        board.category);

                    return GestureDetector(
                      onTap: () {
                        Get.toNamed('/board_detail', arguments: {
                          'boardId': board.id,
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '[$koreanCategory] ${board.title}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '작성시간: $createdAt',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, right: 16.0),
        child: FloatingActionButton(
          onPressed: () {
            Get.toNamed('/board_create');
          },
          backgroundColor: const Color(0xFF2E85FF),
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }
}