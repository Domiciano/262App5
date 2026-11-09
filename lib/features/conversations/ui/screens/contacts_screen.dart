import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moviles_auth/features/conversations/ui/bloc/contacts_bloc.dart';
import 'package:moviles_auth/features/conversations/ui/bloc/contacts_event.dart';
import 'package:moviles_auth/features/conversations/ui/bloc/contacts_state.dart';
import 'package:moviles_auth/features/conversations/ui/components/contact_tile.dart';
import 'package:moviles_auth/theme/app_theme.dart';

/// The registered users, me included. Tapping one opens the chat with them.
class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() {
    return _ContactsScreenState();
  }
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ContactsBloc>().add(ContactsStarted());
  }

  Widget _body(ContactsState state) {
    if (state.status == ContactsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == ContactsStatus.failure) {
      return Center(
        child: Text(
          state.errorMessage ?? 'No se pudieron cargar los usuarios',
          style: const TextStyle(color: AppColors.error),
        ),
      );
    }
    final bloc = context.read<ContactsBloc>();
    return ListView.separated(
      itemCount: state.contacts.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final contact = state.contacts[index];
        return ContactTile(
          contact: contact,
          isOpening: state.openingId == contact.profile.id,
          onTap: () => bloc.add(ContactSelected(contact.profile)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ContactsBloc, ContactsState>(
          listenWhen: (previous, current) =>
              current.opened != null && previous.opened != current.opened,
          listener: (context, state) {
            Navigator.pushNamed(context, '/chat', arguments: state.opened);
          },
        ),
        BlocListener<ContactsBloc, ContactsState>(
          listenWhen: (previous, current) =>
              current.status == ContactsStatus.success &&
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
        appBar: AppBar(title: const Text('Chats')),
        body: SafeArea(
          child: BlocBuilder<ContactsBloc, ContactsState>(
            builder: (context, state) => _body(state),
          ),
        ),
      ),
    );
  }
}
