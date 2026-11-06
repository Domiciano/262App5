import 'package:moviles_auth/features/posts/domain/entities/post.dart';
import 'package:moviles_auth/features/posts/domain/repository/post_repository.dart';
import 'package:moviles_auth/injection_container.dart';

/// Brings one page of the wall, newest first.
class GetFeedUseCase {
  final PostRepository _posts = sl();

  Future<List<Post>> call({required int page, required int size}) async {
    final posts = await _posts.fetchFeed(page: page, size: size);
    return Future.wait(posts.map(_withImage));
  }

  Future<Post> _withImage(Post post) async {
    final path = post.imagePath;
    if (path == null) return post;
    return post.copyWith(imageUrl: await _posts.imageUrl(path));
  }
}
