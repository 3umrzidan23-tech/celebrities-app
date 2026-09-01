import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/send_message.dart';
import 'ai_state.dart';

class AiCubit extends Cubit<AiState> {
  final SendMessage sendMessage;
  final List<Message> _messages = [];

  AiCubit({required this.sendMessage}) : super(AiInitial());

  Future<void> sendUserMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    _messages.insert(
      0,
      Message(text: text, isUser: true, timestamp: DateTime.now()),
    );
    
    emit(AiLoading(List.from(_messages)));

    final failureOrString = await sendMessage(text);
    failureOrString.fold(
      (failure) {
        emit(AiError(failure.message, List.from(_messages)));
      },
      (aiResponse) {
        _messages.insert(
          0,
          Message(text: aiResponse, isUser: false, timestamp: DateTime.now()),
        );
        emit(AiLoaded(List.from(_messages)));
      },
    );
  }
}
