import 'package:flutter/material.dart';

import 'package:moviles_auth/features/avatar/domain/entities/picked_photo.dart';
import 'package:moviles_auth/theme/app_theme.dart';

/// The bar under the chat: the attached photo, the text field and the send button.
class MessageComposer extends StatefulWidget {
  final PickedPhoto? photo;
  final bool isSending;
  final Function(String) onSend;
  final Function() onPickPhoto;
  final Function() onRemovePhoto;

  const MessageComposer({
    super.key,
    required this.photo,
    required this.isSending,
    required this.onSend,
    required this.onPickPhoto,
    required this.onRemovePhoto,
  });

  @override
  State<MessageComposer> createState() {
    return _MessageComposerState();
  }
}

class _MessageComposerState extends State<MessageComposer> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _textController.text.trim();
    if (text.isEmpty && widget.photo == null) return;
    widget.onSend(text);
    _textController.clear();
  }

  Widget _preview(PickedPhoto photo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            height: 64,
            width: 64,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Image.memory(photo.bytes, fit: BoxFit.cover),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () => widget.onRemovePhoto(),
            icon: const Icon(Icons.close),
            label: const Text('Quitar foto'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photo = widget.photo;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (photo != null) _preview(photo),
          Row(
            children: [
              IconButton(
                onPressed: () => widget.onPickPhoto(),
                icon: const Icon(Icons.image_outlined),
                tooltip: 'Adjuntar foto',
              ),
              Expanded(
                child: TextField(
                  controller: _textController,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _send(),
                  decoration: const InputDecoration(
                    hintText: 'Escribe un mensaje',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              widget.isSending
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : IconButton.filled(
                      onPressed: () => _send(),
                      icon: const Icon(Icons.send),
                      tooltip: 'Enviar',
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
