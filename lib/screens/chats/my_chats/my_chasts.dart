import 'package:flutter/material.dart';
import 'package:flutter_project/cubit/app_cubit.dart';
import 'package:flutter_project/screens/chats/chat_screen/chat_screen.dart';

class MyChasts extends StatelessWidget {
  List chats = [
    {'message': "My first message", 'name': "Mahmoud Wahba"},
    {'message': "My Second message", 'name': "Hager Yehia"},
    {
      'message': "My Third  message should be so long so itest overflow",
      'name': "Ahmed Hisham"
    }
  ];
  MyChasts({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ChatItem(
            message: chats[index]['message'], name: chats[index]['name']);
      },
      itemCount: chats.length,
    );
  }
}

class ChatItem extends StatelessWidget {
  final String name;
  final String message;
  const ChatItem({required this.message, required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    AppCubit cubb = AppCubit.get(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(cubb: cubb, chatId: "301313"),
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
