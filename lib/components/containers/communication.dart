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
      "message": "I will be settling the rent payments this weekend",
      "read": false,
    },
    {
      "read": true,
      "from": "Jane Doe",
      "time": DateTime.now(),
      "message": "I have not received the rent payment yet",
    },
    {
      "read": false,
      "from": "Albert Einstein",
      "time": DateTime.now(),
      "message": "E=mc^2",
    },
    {
      "read": true,
      "from": "Isaac Newton",
      "time": DateTime.now(),
      "message": "F=ma",
    },
    {
      "read": false,
      "from": "Berkshire Hathaway",
      "time": DateTime.now(),
      "message": "We are interested in your property",
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
                      trailing: messages[index]['read']
                          ? const Icon(Icons.done)
                          : const Icon(Icons.done_all),
                      leading: const CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            "https://www.w3schools.com/w3images/avatar2.png"),
                      ),
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
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    "https://www.w3schools.com/w3images/avatar2.png"),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Kagema Njoroge",
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.call),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.videocam),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
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
