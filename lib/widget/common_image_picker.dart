import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CommonImagePicker extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;

  const CommonImagePicker({
    Key? key,
    required this.imageFile,
    required this.onPickImage,
    required this.onRemoveImage,
  }) : super(key: key);

  bool _isNetworkPath(String path) {
    return path.startsWith("http://") || path.startsWith("https://");
  }

  @override
  Widget build(BuildContext context) {
    Widget previewWidget;

    if (imageFile != null) {
      final path = imageFile!.path;

      if (_isNetworkPath(path)) {
        previewWidget = ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            path,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Text('이미지가 없습니다', style: TextStyle(color: Colors.grey));
            },
          ),
        );
      } else {
        previewWidget = ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            imageFile!,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Text('이미지가 없습니다', style: TextStyle(color: Colors.grey));
            },
          ),
        );
      }
    } else {
      previewWidget = const Text(
        '이미지가 없습니다',
        style: TextStyle(color: Colors.grey),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onPickImage,
          child: const Text("이미지 등록하기"),
        ),
        const SizedBox(width: 16),
        previewWidget,
      ],
    );
  }
}