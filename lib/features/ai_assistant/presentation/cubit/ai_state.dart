import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';

abstract class AiState extends Equatable {
  const AiState();

  @override
  List<Object> get props => [];
}

class AiInitial extends AiState {}

class AiLoading extends AiState {
  final List<Message> messages;
  const AiLoading(this.messages);

  @override
  List<Object> get props => [messages];
}

class AiLoaded extends AiState {
  final List<Message> messages;
  const AiLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class AiError extends AiState {
  final String errorMessage;
  final List<Message> messages;
  const AiError(this.errorMessage, this.messages);

  @override
  List<Object> get props => [errorMessage, messages];
}
