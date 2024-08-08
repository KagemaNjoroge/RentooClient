import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../utils/snack.dart';
import '../common/gap.dart';

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
  bool _sendEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Communication",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: () {
                    // show an action side menu
                    showSnackBar(
                        context, Colors.green, "More actions here", 200);
                  },
                  icon: const Icon(Icons.more_vert))
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
                        backgroundImage:
                            AssetImage("assets/images/user_avatar.png"),
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
                                backgroundImage:
                                    AssetImage("assets/images/user_avatar.png"),
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
                    // body
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    height: 40,
                                    decoration: const BoxDecoration(),
                                    child: const Text("Hey James"),
                                  ),
                                  Column(
                                    children: [
                                      const Gap(),
                                      const Gap(),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        height: 40,
                                        child: const Text("Holla"),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    height: 40,
                                    decoration: const BoxDecoration(),
                                    child: const Text("Hey James"),
                                  ),
                                  Column(
                                    children: [
                                      const Gap(),
                                      const Gap(),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        height: 40,
                                        child: const Text("Holla"),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    height: 40,
                                    decoration: const BoxDecoration(),
                                    child: const Text("Hey James"),
                                  ),
                                  Column(
                                    children: [
                                      const Gap(),
                                      const Gap(),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        height: 40,
                                        child: const Text("Holla"),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    height: 40,
                                    decoration: const BoxDecoration(),
                                    child: const Text("Hey James"),
                                  ),
                                  Column(
                                    children: [
                                      const Gap(),
                                      const Gap(),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        height: 40,
                                        child: const Text("Holla"),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    height: 40,
                                    decoration: const BoxDecoration(),
                                    child: const Text("Hey James"),
                                  ),
                                  Column(
                                    children: [
                                      const Gap(),
                                      const Gap(),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        height: 40,
                                        child: const Text("Holla"),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    height: 40,
                                    decoration: const BoxDecoration(),
                                    child: const Text("Hey James"),
                                  ),
                                  Column(
                                    children: [
                                      const Gap(),
                                      const Gap(),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        height: 40,
                                        child: const Text("Holla"),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
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
                              onChanged: (value) {
                                setState(() {
                                  _sendEnabled = value.isNotEmpty;
                                });
                              },
                              controller: _messageController,
                              decoration: const InputDecoration(
                                  hintText: "Hey there",
                                  border: InputBorder.none),
                            ),
                          ),
                          IconButton(
                            onPressed: _sendEnabled
                                ? () {
                                    showSnackBar(context, Colors.green,
                                        "Sending...", 150);
                                  }
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
