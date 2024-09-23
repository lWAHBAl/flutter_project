import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/Components/components.dart';
import 'package:flutter_project/cubit/app_cubit.dart';
import 'package:flutter_project/cubit/app_states.dart';
import 'package:flutter_project/screens/chats/chat_screen/chat_screen.dart';

class MyChasts extends StatefulWidget {
  const MyChasts({super.key});

  @override
  State<MyChasts> createState() => _MyChastsState();
}

class _MyChastsState extends State<MyChasts> {
  // List chats = [
  TextEditingController addUserChatController = TextEditingController();

  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final AppCubit cubb = AppCubit.get(context);
    cubb.getMyChats(userId: "22010237");
  }

  @override
  Widget build(BuildContext context) {
    final AppCubit cubb = AppCubit.get(context);

    return BlocConsumer<AppCubit, Appstates>(
      listener: (context, state) {
        if (state is CreateChatLoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: CircularProgressIndicator()));
        } else if (state is CreateChatFailState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Chat creation failed")));
        } else if (state is CreateChatSuccessState) {
          Navigator.pop(context);
          addUserChatController.clear();
          messageController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Chat creation Success")));
        }
      },
      builder: (context, state) => Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              debugPrint('Add');
              showDialog(
                  context: context,
                  builder: (context) => DialogBox(
                      controller1: addUserChatController,
                      controller2: messageController,
                      onSave: () {
                        cubb.createChat(
                            userId: "22010237",
                            receiverId: addUserChatController.text,
                            message: messageController.text);
                      },
                      onCancel: () {
                        Navigator.pop(context);
                      }));
            }),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return ChatItem(
                chatId: cubb.chats[index].chatId,
                message: cubb.chats[index].lastMessage,
                name: cubb.chats[index].usersIds[1]);
          },
          itemCount: cubb.chats.length,
        ),
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  final String name;
  final String message;
  final String chatId;
  const ChatItem(
      {required this.message,
      required this.name,
      required this.chatId,
      super.key});

  @override
  Widget build(BuildContext context) {
    AppCubit cubb = AppCubit.get(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(cubb: cubb, chatId: chatId),
            ));
      },
      child: Card(
        child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.black,
            radius: 30,
          ),
          title: Text(
            name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            message,
            style: const TextStyle(
                color: Colors.grey,
                overflow: TextOverflow.ellipsis,
                fontSize: 15),
          ),
        ),
      ),
    );
  }
}
