import 'package:moviles_auth/features/avatar/domain/entities/picked_photo.dart';
import 'package:moviles_auth/features/chat/domain/repository/message_repository.dart';
import 'package:moviles_auth/injection_container.dart';

/// Uploads the optional photo and then inserts the message.
class SendMessageUseCase {
  final MessageRepository _messages = sl();

  Future<void> call(String content, {PickedPhoto? photo}) async {
    final text = content.trim();
    if (text.isEmpty && photo == null) return;
    final path = photo == null ? null : await _messages.uploadImage(photo);
    await _messages.send(text, imagePath: path);
  }
}
