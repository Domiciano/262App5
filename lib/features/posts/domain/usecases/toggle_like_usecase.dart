import 'package:moviles_auth/features/posts/domain/entities/post.dart';
import 'package:moviles_auth/features/posts/domain/repository/post_repository.dart';
import 'package:moviles_auth/injection_container.dart';

/// Gives or removes the like of the signed in user on a post.
class ToggleLikeUseCase {
  final PostRepository _posts = sl();

  Future<Post> call(Post post) async {
    if (post.likedByMe) {
      await _posts.unlike(post.id);
      return post.copyWith(likeCount: post.likeCount - 1, likedByMe: false);
    }
    await _posts.like(post.id);
    return post.copyWith(likeCount: post.likeCount + 1, likedByMe: true);
  }
}
