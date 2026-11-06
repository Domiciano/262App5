import 'package:moviles_auth/features/avatar/data/source/device_photo_data_source.dart';
import 'package:moviles_auth/features/avatar/data/source/supabase_avatar_data_source.dart';
import 'package:moviles_auth/features/avatar/domain/entities/picked_photo.dart';
import 'package:moviles_auth/features/avatar/domain/repository/avatar_repository.dart';
import 'package:moviles_auth/injection_container.dart';

/// Fulfils AvatarRepository with the phone for picking and Storage for keeping.
class AvatarRepositoryImpl implements AvatarRepository {
  final DevicePhotoDataSource _device = sl();
  final SupabaseAvatarDataSource _storage = sl();

  @override
  Future<PickedPhoto?> pick() async {
    return await _device.pick();
  }

  @override
  Future<String> upload(PickedPhoto photo) async {
    return await _storage.upload(photo);
  }

  @override
  Future<void> remove(String path) async {
    await _storage.remove(path);
  }
}
