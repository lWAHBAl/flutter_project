import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/models/chat_model.dart';
import 'package:flutter_project/models/message_model.dart';
import 'package:flutter_project/screens/chats/my_chats/my_chasts.dart';
import 'package:flutter_project/screens/stories/stories_screen.dart';
import 'package:flutter_project/screens/user/user_screen/user_screen.dart';
import 'package:image_picker/image_picker.dart';

import 'app_states.dart';

class AppCubit extends Cubit<Appstates> {
  AppCubit() : super(AppInitState());
  static AppCubit get(BuildContext context) => BlocProvider.of(context);

  final pages = [const MyChasts(), const UserScreen(), const StoriesScreen()];
  List<MessageModel> messages = [];
  List<ChatModel> chats = [];
  int selectedIndex = 0;
  void changeScreen(index) {
    selectedIndex = index;
    emit(ChangeScreenState());
  }

///////////////
  File? img;
  void pickChatImage(ImageSource source) async {
    final picker = ImagePicker();
    emit(ImageLoadingState());
    await picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        img = File(value.path);
        emit(PickImageState());
      }
      debugPrint("Image Picked");
    });
  }

  ////////////
  String chatImageUrl = "";
  Future<String> uploadChatimage({
    required File? file,
  }) async {
    emit(UploadChatImageState());
    String url = 'ChatImages/${Uri.file(file!.path)}';
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('ChatImages/${Uri.file(file.path).pathSegments.last}');
    TaskSnapshot snapShot = await ref.putFile(file);
    String downloadURL = await snapShot.ref.getDownloadURL();
    url = downloadURL;
    debugPrint("Url is $url");
    return url;
  }

  /////////////////////////
  Future<void> addMessage(
      {required String userId,
      required chatId,
      String? message,
      required bool type,
      String? imagaeUrl}) {
    emit(AddMessageLoadingState());
    FirebaseFirestore.instance
        .collection('Chats')
        .doc(chatId)
        .collection("Messages")
        .doc()
        .set({
      'message': message,
      'time': DateTime.now().toString(),
      'id': userId,
      "imagaeUrl": imagaeUrl,
      'type': type
    }).then((value) {
      img = null;
      emit(AddMessageSuccessState());

      // getChat(model);
    }).catchError((error) {
      debugPrint(error);
    });
    return Future(() => null);
  }

////////////////////////
  bool isTyping = false;
  void changeSendIcon(value) {
    isTyping = value.isNotEmpty;
    emit(ChangeSendIconstate());
  }

  /////////////////////
  void createChat(
      {required String userId,
      required String receiverId,
      required String message}) {
    emit(CreateChatLoadingState());
    String id = FirebaseFirestore.instance.collection('Chats').doc().id;
    FirebaseFirestore.instance
        .collection('Chats')
        .doc(id)
        .set(ChatModel(
                chatId: id,
                usersIds: [userId, receiverId],
                lastMessage: message)
            .toMap())
        .then((onValue) {
      addMessage(userId: userId, chatId: id, type: false, message: message);
      emit(CreateChatSuccessState());
    }).catchError((onError) {
      emit(CreateChatFailState());
    });
  }

//////////////////////////////////
  void getChat({required String userId, required String chatId}) {
    emit(GetChatMessagesLoadingState());
    messages = [];
    FirebaseFirestore.instance
        .collection('Chats')
        .doc(chatId)
        .collection("Messages")
        .orderBy('time')
        .snapshots()
        .listen((snapshot) {
      messages = snapshot.docs
          .map((doc) => MessageModel.fromJson(doc.data()))
          .toList()
          .reversed
          .toList();
      emit(GetChatMessagesSuccessState());
    });
  }

  ////////////////////////
  void getMyChats({required String userId}) {
    emit(GetChatsLoadingState());
    chats = [];
    FirebaseFirestore.instance
        .collection('Chats')
        .where('usersIds', arrayContains: userId)
        .snapshots()
        .listen((snapshot) {
      chats =
          snapshot.docs.map((doc) => ChatModel.fromJson(doc.data())).toList();
      emit(GetChatsSuccessState());
    });
  }
  /////////////////////////////
}
