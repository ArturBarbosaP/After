import 'package:image_picker/image_picker.dart';

class ImageService {
  final _picker = ImagePicker();

  Future<XFile?> pickImage() {
    return _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 80
    );
  }
}