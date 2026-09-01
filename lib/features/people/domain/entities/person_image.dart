import 'package:equatable/equatable.dart';

class PersonImage extends Equatable {
  final String filePath;

  const PersonImage({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}
