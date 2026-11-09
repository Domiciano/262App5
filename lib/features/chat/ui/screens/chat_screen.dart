import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moviles_auth/features/chat/ui/bloc/chat_bloc.dart';
import 'package:moviles_auth/features/chat/ui/bloc/chat_event.dart';
import 'package:moviles_auth/features/chat/ui/bloc/chat_state.dart';
import 'package:moviles_auth/features/chat/ui/components/message_bubble.dart';
import 'package:moviles_auth/features/chat/ui/components/message_composer.dart';
import 'package:moviles_auth/components/avatar.dart';
import 'package:moviles_auth/theme/app_theme.dart';

/// The chat with one contact: the messages, newest at the bottom, and the composer.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() {
    return _ChatScreenState();
  }
}

class _ChatScreenState extends State<ChatScreen> {
  static const topThreshold = 48.0;
  final _scrollController = ScrollController();
  bool _atTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<ChatBloc>().add(ChatStarted());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    final atTop = position.pixels >= position.maxScrollExtent - topThreshold;
    if (atTop && !_atTop) {
      context.read<ChatBloc>().add(OlderMessagesRequested());
    }
    _atTop = atTop;
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget _messages(ChatState state) {
    if (state.messages.isEmpty) {
      if (state.status == ChatStatus.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      return const Center(
        child: Text(
          'Aún no hay mensajes. Escribe el primero.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }
    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: state.messages.length,
      itemBuilder: (context, index) =>
          MessageBubble(message: state.messages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ChatBloc>();
    return MultiBlocListener(
      listeners: [
        BlocListener<ChatBloc, ChatState>(
          listenWhen: (previous, current) =>
              previous.messages.isNotEmpty &&
              current.messages.isNotEmpty &&
              previous.messages.first.id != current.messages.first.id,
          listener: (context, state) => _scrollToBottom(),
        ),
        BlocListener<ChatBloc, ChatState>(
          listenWhen: (previous, current) =>
              current.errorMessage != null &&
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Row(
            children: [
              Avatar(
                url: bloc.conversation.contact.avatarUrl,
                name: bloc.conversation.contact.fullName,
                size: 32,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  bloc.conversation.contact.fullName,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return Column(
                children: [
                  if (state.isLoadingOlder) const LinearProgressIndicator(),
                  Expanded(child: _messages(state)),
                  MessageComposer(
                    photo: state.photo,
                    isSending: state.isSending,
                    onSend: (text) => bloc.add(MessageSent(text)),
                    onPickPhoto: () => bloc.add(ChatPhotoRequested()),
                    onRemovePhoto: () => bloc.add(ChatPhotoRemoved()),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
