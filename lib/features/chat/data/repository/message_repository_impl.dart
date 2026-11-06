import 'package:moviles_auth/features/avatar/data/source/device_photo_data_source.dart';
import 'package:moviles_auth/features/avatar/domain/entities/picked_photo.dart';
import 'package:moviles_auth/features/chat/data/source/supabase_chat_image_data_source.dart';
import 'package:moviles_auth/features/chat/data/source/supabase_message_data_source.dart';
import 'package:moviles_auth/features/chat/domain/entities/message.dart';
import 'package:moviles_auth/features/chat/domain/repository/message_repository.dart';
import 'package:moviles_auth/injection_container.dart';

/// Fulfils MessageRepository with the messages table, the phone and the chat-images bucket.
class MessageRepositoryImpl implements MessageRepository {
  final SupabaseMessageDataSource _messages = sl();
  final SupabaseChatImageDataSource _images = sl();
  final DevicePhotoDataSource _device = sl();
  final Map<String, String> _urls = {};

  @override
  Stream<List<Message>> watchLatest({required int limit}) {
    return _messages.watchLatest(limit: limit);
  }

  @override
  Future<List<Message>> fetchBefore(DateTime before, {required int limit}) {
    return _messages.fetchBefore(before, limit: limit);
  }

  @override
  Future<void> send(String content, {String? imagePath}) {
    return _messages.send(content, imagePath: imagePath);
  }

  @override
  Future<PickedPhoto?> pickImage() {
    return _device.pick();
  }

  @override
  Future<String> uploadImage(PickedPhoto photo) {
    return _images.upload(photo);
  }

  @override
  Future<String> imageUrl(String path) async {
    final cached = _urls[path];
    if (cached != null) return cached;
    final url = await _images.signedUrl(path);
    _urls[path] = url;
    return url;
  }
}
