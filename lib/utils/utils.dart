import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/comment_card.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? _file = await imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }

  print("no image selected");
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

String displayPublishDate(DateTime dt1) {
  String publishDate = '';

  final difference = DateTime.now().difference(dt1);

  if (difference.inDays > 7) {
    // show difference in week
    publishDate = '${difference.inDays ~/ 7} w';
  } else {
    if (difference.inHours > 24) {
      // show difference in days
      publishDate = '${difference.inDays} d';
    } else {
      if (difference.inMinutes > 60) {
        // show difference in hours
        publishDate = '${difference.inHours} h';
      } else {
        if (difference.inSeconds > 60) {
          // show difference in minutes
          publishDate = '${difference.inMinutes} min';
        } else {
          // show "just now"
          publishDate = 'just now';
        }
      }
    }
  }

  return publishDate;
}
