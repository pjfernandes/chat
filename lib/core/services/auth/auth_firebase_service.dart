import 'dart:io';
import 'dart:async';
import 'dart:math';

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthFirebaseService implements AuthService {
  static const defaultUser = ChatUser(
    id: '456',
    name: 'Ana',
    email: 'ana@cod3r.com.br',
    imageUrl: 'assets/images/avatar.png',
  );

  static final Map<String, ChatUser> _users = {
    defaultUser.email: defaultUser,
  };
  static ChatUser? _currentUser;
  //static MultiStreamController<ChatUser?>? _controller;

  static final _userStream = Stream<ChatUser?>.multi(
    (controller) async {
      //_controller = controller;
      //_updateUser(defaultUser);
      final authChanges = FirebaseAuth.instance.authStateChanges();
      await for (final user in authChanges) {
        _currentUser = user == null ? null : _toChatUser(user);
        controller.add(_currentUser);
      }
    },
  );

  @override
  ChatUser? get currentUser {
    return _currentUser;
  }

  @override
  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  @override
  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    // final newUser = ChatUser(
    //   id: Random().nextDouble().toString(),
    //   name: name,
    //   email: email,
    //   imageUrl: image?.path ?? '/assets/images/avatar.png',
    // );
    // _users.putIfAbsent(email, () => newUser);
    // _updateUser(newUser);
    final auth = FirebaseAuth.instance;
    UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential == null) {
      return;
    }

    credential.user?.updateDisplayName(name);
    //credential.user?.updatePhotoURL(image);
  }

  @override
  Future<void> login(
    String email,
    String password,
  ) async {
    //_updateUser(_users[email]);
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    // _updateUser(null);
    FirebaseAuth.instance.signOut();
  }

  static void _updateUser(ChatUser? user) {
    // _currentUser = user;
    // _controller?.add(_currentUser);
  }

  static ChatUser _toChatUser(User user) {
    return ChatUser(
      id: user.uid,
      name: user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageUrl: user.photoURL ?? 'assets/images/avatar.png',
    );
  }
}
