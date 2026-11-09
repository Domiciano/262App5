import 'package:flutter/material.dart';

import 'package:moviles_auth/components/avatar.dart';
import 'package:moviles_auth/features/conversations/domain/entities/contact.dart';
import 'package:moviles_auth/theme/app_theme.dart';

/// One registered user in the list: photo, name and username.
class ContactTile extends StatelessWidget {
  final Contact contact;
  final bool isOpening;
  final Function() onTap;

  const ContactTile({
    super.key,
    required this.contact,
    required this.isOpening,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final profile = contact.profile;
    return ListTile(
      onTap: () => onTap(),
      leading: Avatar(url: profile.avatarUrl, name: profile.fullName),
      title: Text(contact.isMe ? '${profile.fullName} (tú)' : profile.fullName),
      subtitle: Text(
        '@${profile.username}',
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      trailing: isOpening
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.chevron_right),
    );
  }
}
