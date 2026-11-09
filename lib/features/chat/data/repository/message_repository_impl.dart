import 'package:moviles_auth/features/avatar/domain/entities/picked_photo.dart';
import 'package:moviles_auth/features/chat/domain/entities/message.dart';
import 'package:moviles_auth/features/chat/domain/repository/message_repository.dart';

/// Fulfils MessageRepository with the messages table, the phone and the chat-images bucket.
class MessageRepositoryImpl implements MessageRepository {
  @override
  Stream<List<Message>> watchLatest(
    String conversationId, {
    required int limit,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<Message>> fetchBefore(
    String conversationId,
    DateTime before, {
    required int limit,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> send(
    String conversationId,
    String content, {
    String? imagePath,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<PickedPhoto?> pickImage() {
    throw UnimplementedError();
  }

  @override
  Future<String> uploadImage(PickedPhoto photo) {
    throw UnimplementedError();
  }

  @override
  Future<String> imageUrl(String path) {
    throw UnimplementedError();
  }
}
