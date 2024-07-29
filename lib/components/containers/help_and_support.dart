import 'package:flutter/material.dart';

import '../../utils/snack.dart';
import '../common/gap.dart';

class HelpAndSupportHome extends StatefulWidget {
  const HelpAndSupportHome({super.key});

  @override
  State<HelpAndSupportHome> createState() => _HelpAndSupportHomeState();
}

class _HelpAndSupportHomeState extends State<HelpAndSupportHome> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: const Row(
              children: [
                Text(
                  "Help and support",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.question_answer_rounded),
                text: "FAQs",
              ),
              Tab(
                icon: Icon(Icons.tips_and_updates_outlined),
                text: "Guides",
              ),
              Tab(
                icon: Icon(Icons.video_collection_outlined),
                text: "Tutorials",
              ),
              Tab(
                icon: Icon(Icons.call),
                text: "Contact us",
              ),
            ],
          ),
          Expanded(
            child: TabBarView(children: [
              const FAQs(),
              const Text("User guides"),
              const Text("Tutorials"),
              Container(
                padding: const EdgeInsets.all(8),
                child: const Column(
                  children: [
                    Expanded(child: ContactForm()),
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  // controllers and keys
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _queryController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Text("Get in touch"),
              const Gap(),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Your name is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Your name*",
                        icon: Icon(Icons.person_outline_outlined),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Your phone is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Your phone*",
                        icon: Icon(Icons.phone),
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                minLines: 3,
                maxLines: 5,
                controller: _queryController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Message/query is required";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Your query*",
                  icon: Icon(Icons.messenger_outline),
                ),
              ),
              const Gap(),
              ElevatedButton.icon(
                onPressed: () {
                  if (_key.currentState!.validate()) {
                    showSnackBar(context, Colors.green, "To implement", 200);
                  }
                },
                label: const Text("Send"),
                icon: const Icon(
                  Icons.send_rounded,
                ),
              ),
              const Gap()
            ],
          ),
        ),
      ),
    );
  }
}

class FAQs extends StatefulWidget {
  const FAQs({super.key});

  @override
  State<FAQs> createState() => _FAQsState();
}

class _FAQsState extends State<FAQs> {
  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Column(
        children: [
          ExpansionTile(
            title: Text("How do I add a property?"),
            children: [
              Text("Go to the properties page"),
            ],
          ),
          Gap(),
          ExpansionTile(
            title: Text("How do I add a house?"),
            children: [
              Text("Go to the properties page"),
            ],
          ),
          Gap(),
          ExpansionTile(
            title: Text("How do I add a lease?"),
            children: [
              Text("Go to the properties page"),
            ],
          ),
        ],
      ),
    );
  }
}
