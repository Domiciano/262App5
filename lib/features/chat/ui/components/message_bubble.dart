import 'package:flutter/material.dart';

import 'package:moviles_auth/features/chat/domain/entities/message.dart';
import 'package:moviles_auth/theme/app_theme.dart';

/// One message: mine on the right in green, the others on the left in white.
class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  String _time() {
    final local = message.createdAt.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _image() {
    final url = message.imageUrl;
    return Container(
      height: 180,
      width: 240,
      margin: const EdgeInsets.only(bottom: 6),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: url == null
          ? const Center(child: Icon(Icons.image_outlined))
          : Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image_outlined)),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mine = message.isMine;
    final foreground = mine ? Colors.white : AppColors.textPrimary;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
        decoration: BoxDecoration(
          color: mine ? AppColors.primaryDark : AppColors.surface,
          border: mine ? null : Border.all(color: AppColors.border),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(mine ? 16 : 4),
            bottomRight: Radius.circular(mine ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: mine
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.imagePath != null) _image(),
            if (message.content.isNotEmpty)
              Text(message.content, style: TextStyle(color: foreground)),
            const SizedBox(height: 2),
            Text(
              _time(),
              style: TextStyle(
                fontSize: 11,
                color: mine ? Colors.white70 : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
