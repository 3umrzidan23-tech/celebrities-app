import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  @override
  List<Object> get props => [text, isUser, timestamp];
}
