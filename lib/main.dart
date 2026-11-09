import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles_auth/injection_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:moviles_auth/features/chat/ui/bloc/chat_bloc.dart';
import 'package:moviles_auth/features/chat/ui/screens/chat_screen.dart';
import 'package:moviles_auth/features/compose/ui/bloc/compose_bloc.dart';
import 'package:moviles_auth/features/compose/ui/screens/compose_screen.dart';
import 'package:moviles_auth/features/conversations/domain/entities/conversation.dart';
import 'package:moviles_auth/features/conversations/ui/bloc/contacts_bloc.dart';
import 'package:moviles_auth/features/conversations/ui/screens/contacts_screen.dart';
import 'package:moviles_auth/features/home/ui/bloc/feed_bloc.dart';
import 'package:moviles_auth/features/home/ui/screens/home_screen.dart';
import 'package:moviles_auth/features/login/ui/bloc/login_bloc.dart';
import 'package:moviles_auth/features/login/ui/screens/login_screen.dart';
import 'package:moviles_auth/features/register/ui/bloc/register_bloc.dart';
import 'package:moviles_auth/features/register/ui/screens/register_screen.dart';
import 'package:moviles_auth/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://pmijmrkaucdwadmnnvbo.supabase.co',
    publishableKey: 'sb_publishable_8tS9o_mjkvKA4z9WUvRjCg_01oNcv6y',
  );
  initDependencies();
  runApp(const App());
}

/// Root widget that declares the theme and the named routes.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muro y chat',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      initialRoute: '/login',
      routes: {
        '/login': (_) => BlocProvider(
          create: (_) => sl<LoginBloc>(),
          child: const LoginScreen(),
        ),
        '/register': (_) => BlocProvider(
          create: (_) => sl<RegisterBloc>(),
          child: const RegisterScreen(),
        ),
        '/home': (_) => BlocProvider(
          create: (_) => sl<FeedBloc>(),
          child: const HomeScreen(),
        ),
        '/compose': (_) => BlocProvider(
          create: (_) => sl<ComposeBloc>(),
          child: const ComposeScreen(),
        ),
        '/contacts': (_) => BlocProvider(
          create: (_) => sl<ContactsBloc>(),
          child: const ContactsScreen(),
        ),
        '/chat': (context) {
          final conversation =
              ModalRoute.of(context)!.settings.arguments as Conversation;
          return BlocProvider(
            create: (_) => ChatBloc(conversation),
            child: const ChatScreen(),
          );
        },
      },
    );
  }
}
