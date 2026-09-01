import '../../domain/entities/person_image.dart';

class PersonImageModel extends PersonImage {
  const PersonImageModel({required super.filePath});

  factory PersonImageModel.fromJson(Map<String, dynamic> json) {
    return PersonImageModel(
      filePath: json['file_path'] ?? '',
    );
  }
}
