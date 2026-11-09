# Laboratorio 8 · Chat en tiempo real

Punto de partida del **Laboratorio 8**: el muro del Laboratorio 7, ya resuelto, más un chat entre dos personas al que le faltan las capas. El botón de chat lleva a la lista de usuarios registrados, tú incluido, y al elegir uno se abre la conversación con esa persona. La guía paso a paso está en el visor del curso, en la sección *Realtime DB*, lección *Laboratorio 8 · Chat en tiempo real*.

- **Parte 1 · Chat sencillo en tiempo real.** Los mensajes llegan por un `Stream` de Supabase Realtime. Los míos van a la derecha, los de los demás a la izquierda.
- **Parte 2 · Paginación.** El stream solo trae los 15 últimos. Al llegar arriba, se piden los 5 anteriores con un `Future` que modifica el mismo estado.
- **Parte 3 · Mensajes con imagen.** Cada mensaje puede llevar una sola foto, opcional, guardada en el bucket privado `chat-images`.

La convención del curso: **a lo largo de las capas se retorna el `Stream`, y solo el Bloc hace `listen`.**

## Cómo correrlo

1. Pon la `Project URL` y la `publishable key` de **tu** proyecto de Supabase en `lib/main.dart`.
2. Conéctate a tu proyecto y trae las migraciones anteriores: `npx supabase init`, `npx supabase link --project-ref TU_IDENTIFICADOR` y `npx supabase migration fetch --remote`.
3. Sigue la *Preparación* de la guía para crear las tablas `conversations` y `messages` y activarle Realtime a `messages`.
4. Corre la app:

```bash
flutter pub get
flutter run
```

El botón de chat está en la barra superior del muro. Para probar, abre dos cuentas a la vez y elige una a la otra en la lista.

## Qué ya funciona

- **Todo el Laboratorio 7.** Registro, inicio de sesión, el muro paginado, los «me gusta», las fotos de perfil y los posts con imagen.
- **La lista de usuarios y las conversaciones.** `lib/features/conversations/` está completa: `ContactsScreen` lista los perfiles y, al tocar uno, `OpenConversationUseCase` carga la fila de `conversations` de esa pareja o la crea si no existe.
- **El chat sabe con quién hablas.** `ChatBloc` recibe la `Conversation` en su constructor y la guarda en `conversation`. Los métodos de cada capa ya reciben el `conversationId`.
- **Toda la interfaz del chat.** `ChatScreen`, `MessageBubble` y `MessageComposer`. Mandar un mensaje, llegar arriba en la lista y el botón de foto ya lanzan su evento. Cuando cambia el mensaje más nuevo, la lista baja sola hasta el final.
- **La entidad y el contrato.** `Message` (con `isMine`, `imagePath` e `imageUrl` opcionales) y `MessageRepository` completo.
- **Los eventos y el estado.** `ChatStarted`, `MessagesUpdated`, `ChatStreamFailed`, `MessageSent`, `OlderMessagesRequested`, `ChatPhotoRequested`, `ChatPhotoRemoved` y `ChatState` con su `copyWith`.
- **La inyección de dependencias.** Todo lo del chat ya está registrado en `injection_container.dart`.

Los métodos de cada capa ya existen con su firma, pero su cuerpo es `throw UnimplementedError()`. Los `on` de `ChatBloc` solo imprimen el evento que reciben:

```text
ChatBloc recibió ChatStarted()
ChatBloc recibió MessageSent(Hola)
ChatBloc recibió OlderMessagesRequested()
```

## Qué te toca

Todo está en `lib/features/chat/`.

**Parte 1**

- `data/source/supabase_message_data_source.dart`: `watchLatest` y `send`, filtrando e insertando por `conversation_id`.
- `data/repository/message_repository_impl.dart`: `watchLatest` y `send`.
- `domain/usecases/watch_messages_usecase.dart` y `send_message_usecase.dart`: `call`.
- `ui/bloc/chat_bloc.dart`: el `listen` en `ChatStarted`, `MessagesUpdated`, `ChatStreamFailed`, `MessageSent` y `close`.

**Parte 2**

- `data/source/supabase_message_data_source.dart` y su `Impl`: `fetchBefore`.
- `domain/usecases/load_older_messages_usecase.dart`: `call`.
- `ui/bloc/chat_bloc.dart`: `OlderMessagesRequested`, y juntar en `MessagesUpdated` lo que llega por el stream con lo que ya estaba.

**Parte 3**

- `data/source/supabase_chat_image_data_source.dart`: `upload` y `signedUrl`.
- `data/repository/message_repository_impl.dart`: `pickImage`, `uploadImage` e `imageUrl`.
- `domain/usecases/pick_chat_image_usecase.dart`: `call`. `send_message_usecase.dart`: subir la foto antes de insertar. `watch_messages_usecase.dart` y `load_older_messages_usecase.dart`: la URL firmada de cada imagen.
- `ui/bloc/chat_bloc.dart`: `ChatPhotoRequested`, `ChatPhotoRemoved` y pasar `state.photo` al enviar.

`flutter test` comprueba que la interfaz lanza los eventos correctos.
