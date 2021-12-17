import 'dart:ffi';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class Storageclass {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadImage(String fileName, String filePath) async {
    File file = File(filePath);
    try {
      TaskSnapshot uploadtask =
          (await storage.ref('ImagesOrder/$fileName').putFile(file));
      var dowurl = await (await uploadtask).ref.getDownloadURL();
      return dowurl.toString();
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }
}
