import 'package:moviles_auth/features/avatar/domain/entities/picked_photo.dart';
import 'package:moviles_auth/features/chat/domain/entities/message.dart';

/// Contract of everything the chat can ask about messages and their photos.
abstract class MessageRepository {
  Stream<List<Message>> watchLatest(
    String conversationId, {
    required int limit,
  });
  Future<List<Message>> fetchBefore(
    String conversationId,
    DateTime before, {
    required int limit,
  });
  Future<void> send(String conversationId, String content, {String? imagePath});
  Future<PickedPhoto?> pickImage();
  Future<String> uploadImage(PickedPhoto photo);
  Future<String> imageUrl(String path);
}
