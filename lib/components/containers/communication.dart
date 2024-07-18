import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../utils/snack.dart';


class Communication extends StatefulWidget {
  const Communication({super.key});

  @override
  State<Communication> createState() => _CommunicationState();
}

class _CommunicationState extends State<Communication> {
  List messages = [
    {
      "from": "Kagema Njoroge",
      "time": DateTime.now(),
      "message": "I will be settling the rent payments this weekend"
    },
    {
      "from": "Kagema Njoroge",
      "time": DateTime.now(),
      "message": "I will be settling the rent payments this weekend"
    },
    {
      "from": "Kagema Njoroge",
      "time": DateTime.now(),
      "message": "I will be settling the rent payments this weekend"
    },
    {
      "from": "Kagema Njoroge",
      "time": DateTime.now(),
      "message": "I will be settling the rent payments this weekend"
    },
    {
      "from": "Kagema Njoroge",
      "time": DateTime.now(),
      "message": "I will be settling the rent payments this weekend"
    },
    {
      "from": "Kagema Njoroge",
      "time": DateTime.now(),
      "message": "I will be settling the rent payments this weekend"
    },
    {
      "from": "Kagema Njoroge",
      "time": DateTime.now(),
      "message": "I will be settling the rent payments this weekend"
    },
    {
      "from": "Kagema Njoroge",
      "time": DateTime.now(),
      "message": "I will be settling the rent payments this weekend"
    },
    {
      "from": "Kagema Njoroge",
      "time": DateTime.now(),
      "message": "I will be settling the rent payments this weekend"
    },
    {
      "from": "Kagema Njoroge",
      "time": DateTime.now(),
      "message": "I will be settling the rent payments this weekend"
    },
    {
      "from": "Kagema Njoroge",
      "time": DateTime.now(),
      "message": "I will be settling the rent payments this weekend"
    },
    {
      "from": "Kagema Njoroge",
      "time": DateTime.now(),
      "message": "I will be settling the rent payments this weekend"
    },
    {
      "from": "Kagema Njoroge",
      "time": DateTime.now(),
      "message": "I will be settling the rent payments this weekend"
    },
    {
      "from": "Kagema Njoroge",
      "time": DateTime.now(),
      "message": "I will be settling the rent payments this weekend"
    },
    {
      "from": "Kagema Njoroge",
      "time": DateTime.now(),
      "message": "I will be settling the rent payments this weekend"
    },
    {
      "from": "Kagema Njoroge",
      "time": DateTime.now(),
      "message": "I will be settling the rent payments this weekend"
    }
  ];
  final TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: const Row(
            children: [
              Text(
                "Communication",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        showSnackBar(
                            context, Colors.red, "Add action here", 300);
                      },
                      title: Text(messages[index]['from']),
                      subtitle: Text(messages[index]['message']),
                    );
                  },
                  itemCount: messages.length,
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Messages"),
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.mic),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.emoji_emotions),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: const InputDecoration(
                                  hintText: "Hey there",
                                  border: InputBorder.none),
                            ),
                          ),
                          IconButton(
                            onPressed: _messageController.text.isNotEmpty
                                ? () {}
                                : null,
                            icon: const Icon(Icons.send),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
