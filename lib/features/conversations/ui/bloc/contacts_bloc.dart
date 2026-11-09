import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles_auth/features/conversations/domain/usecases/get_contacts_usecase.dart';
import 'package:moviles_auth/features/conversations/domain/usecases/open_conversation_usecase.dart';
import 'package:moviles_auth/features/conversations/ui/bloc/contacts_event.dart';
import 'package:moviles_auth/features/conversations/ui/bloc/contacts_state.dart';
import 'package:moviles_auth/injection_container.dart';

/// Lists the registered users and opens the conversation with the chosen one.
class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final GetContactsUseCase _getContacts = sl();
  final OpenConversationUseCase _openConversation = sl();

  ContactsBloc() : super(const ContactsState()) {
    on<ContactsStarted>(_onStarted);
    on<ContactSelected>(_onSelected);
  }

  String _message(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  Future<void> _onStarted(
    ContactsStarted event,
    Emitter<ContactsState> emit,
  ) async {
    emit(state.copyWith(status: ContactsStatus.loading));
    try {
      final contacts = await _getContacts();
      emit(state.copyWith(status: ContactsStatus.success, contacts: contacts));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: ContactsStatus.failure,
          errorMessage: _message(e),
        ),
      );
    }
  }

  Future<void> _onSelected(
    ContactSelected event,
    Emitter<ContactsState> emit,
  ) async {
    if (state.openingId != null) return;
    emit(state.copyWith(openingId: event.contact.id));
    try {
      final conversation = await _openConversation(event.contact);
      emit(state.copyWith(opened: conversation));
    } on Exception catch (e) {
      emit(state.copyWith(errorMessage: _message(e)));
    }
  }
}
