/// One chat message: what it says, when it was sent, whether it is mine and its optional photo.
class Message {
  final String id;
  final String content;
  final DateTime createdAt;
  final bool isMine;
  final String? imagePath;
  final String? imageUrl;

  const Message({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.isMine,
    this.imagePath,
    this.imageUrl,
  });

  Message copyWith({String? imageUrl}) {
    return Message(
      id: id,
      content: content,
      createdAt: createdAt,
      isMine: isMine,
      imagePath: imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() {
    return 'Message(${isMine ? 'mío' : 'otro'}: $content)';
  }
}
