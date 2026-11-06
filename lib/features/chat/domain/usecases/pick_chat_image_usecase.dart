import 'package:moviles_auth/features/avatar/domain/entities/picked_photo.dart';
import 'package:moviles_auth/features/chat/domain/repository/message_repository.dart';
import 'package:moviles_auth/injection_container.dart';

/// Opens the gallery to attach one photo to the next message.
class PickChatImageUseCase {
  final MessageRepository _messages = sl();

  Future<PickedPhoto?> call() {
    return _messages.pickImage();
  }
}
