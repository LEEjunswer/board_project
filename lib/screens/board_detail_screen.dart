import 'package:board_project/controllers/board_detail_controller.dart';
import 'package:board_project/globals.dart';
import 'package:board_project/widget/common_app_bar.dart';
import 'package:board_project/widget/common_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class BoardDetailScreen extends StatefulWidget{
  const BoardDetailScreen({Key? key}) : super(key: key);

  @override
  _BoardDetailScreenState createState()=> _BoardDetailScreenState();
}
class _BoardDetailScreenState extends State<BoardDetailScreen> {
  final BoardDetailController controller = Get.put(BoardDetailController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        /*게시글 제목넣는 곳도 있음*/
        title: '게시글',
      ),
      body: Obx(() {
        final board = controller.board.value;
        final isLoading = controller.isLoading.value;

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (board == null) {
          Future.microtask(() {
            if (Get.isDialogOpen != true) {
              Get.defaultDialog(
                title: '오류',
                middleText: '게시글이 삭제되었거나 존재하지 않습니다.',
                textConfirm: '확인',
                onConfirm: () {
                  Get.back();
                  Get.back();
                },
                barrierDismissible: false,
              );
            }
          });
          return const SizedBox();
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                board.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '카테고리: ${controller.getCategoryChangeKorean(board.boardCategory!)}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    '작성일: ${controller.formatDate(board.createdAt!)}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/board_edit', arguments: {
                        'board':controller.board.value}
                      );
                    },
                    child: const Text(
                      '수정하기',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      Get.defaultDialog(
                        title: '삭제 확인',
                        middleText: '정말로 삭제하시겠습니까?',
                        textCancel: '취소',
                        textConfirm: '삭제',
                        confirmTextColor: Colors.white,
                        onConfirm: () async {
                          bool check = await controller.deleteBoard();
                         if(check) {
                           await controller.updateBoardList();
                          showSnackBar(context, "게시글 삭제 완료");
                           Get.back();
                           Get.back();
                         }else{
                           showSnackBar(context, "게시글 삭제 실패");
                         }
                          },
                      );
                    },
                    child: const Text(
                      '삭제하기',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(
                height: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              if (board.imageUrl != null && board.imageUrl!.isNotEmpty)
                Image.network(
                  '$ip${board.imageUrl}',
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              Text(
                board.content,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      }),
    );
  }


}