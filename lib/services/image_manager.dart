import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageManager {
  Future<String> uploadImage(String selectedFile, String oldPath) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = "uploads/$fileName";

    print(
      "TETSETESTETSTETTETSETESTESZTESLTKJ:SLTKJS: ${selectedFile} : ${oldPath}",
    );
    if (oldPath != 'none') {
      try {
        await Supabase.instance.client.storage.from('images').remove([oldPath]);
      } catch (e) {
        print('Error: ${e.toString()}');
      }
    }

    final response = await Supabase.instance.client.storage
        .from('images')
        .upload(path, File(selectedFile));
    if (response.isNotEmpty) {
      // publicUrl = Supabase.instance.client.storage.from('images').
      return path;
    }
    return 'none';
  }

  Widget getImage(String path) {
    if (path == 'none') {
      return Image.asset('assets/images/dog.png');
    }
    return Image.network(
      Supabase.instance.client.storage.from('images').getPublicUrl(path),
      fit: BoxFit.cover,
    );
  }

  ImageProvider getImageProvider(String path) {
    if (path == 'none') {
      return AssetImage('assets/images/dog.png');
    }
    return NetworkImage(
      Supabase.instance.client.storage.from('images').getPublicUrl(path),
    );
  }

  String getImageUrl(String path) {
    final String url = Supabase.instance.client.storage
        .from('images')
        .getPublicUrl(path);
    return url;
  }

  Future<String> getImageForImageForm(String path) async {
    final String url = getImageUrl(path);
    final response = await http.head(Uri.parse(url));
    if (response.statusCode == 200) {
      return url;
    } else {
      return "not found";
    }
  }
}
