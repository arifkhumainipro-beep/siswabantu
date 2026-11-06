import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

class ImageUploadHelper {
  /// Membuka dialog pemilih fail pada pelayar web / peranti untuk memilih gambar JPG/PNG
  static void pickImage(Function(String base64DataUrl) onImageSelected) {
    if (!kIsWeb) return;
    try {
      final input = web.document.createElement('input') as web.HTMLInputElement;
      input.type = 'file';
      input.accept = 'image/*';
      input.click();
      input.onChange.listen((event) {
        final files = input.files;
        if (files != null && files.length > 0) {
          final file = files.item(0);
          if (file != null) {
            final reader = web.FileReader();
            reader.readAsDataURL(file);
            reader.onLoadEnd.listen((_) {
              final result = reader.result;
              if (result != null) {
                onImageSelected(result.toString());
              }
            });
          }
        }
      });
    } catch (e) {
      debugPrint('Ralat memilih fail gambar: $e');
    }
  }

  /// Menghasilkan ImageProvider yang menyokong Data URL Base64 dan URL Rangkaian biasa
  static ImageProvider getImageProvider(String avatarUrl) {
    if (avatarUrl.startsWith('data:image')) {
      try {
        final base64String = avatarUrl.split(',').last;
        final bytes = base64Decode(base64String);
        return MemoryImage(bytes);
      } catch (_) {
        return const NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80');
      }
    }
    return NetworkImage(avatarUrl);
  }

  /// Menghasilkan Widget Image yang selamat untuk paparan avatar
  static Widget buildAvatarImage(String avatarUrl, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
    if (avatarUrl.startsWith('data:image')) {
      try {
        final base64String = avatarUrl.split(',').last;
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => Container(
            width: width,
            height: height,
            color: const Color(0xFFC8102E),
            child: const Icon(Icons.person, color: Colors.white),
          ),
        );
      } catch (_) {}
    }
    return Image.network(
      avatarUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Container(
        width: width,
        height: height,
        color: const Color(0xFFC8102E),
        child: const Icon(Icons.person, color: Colors.white),
      ),
    );
  }
}
