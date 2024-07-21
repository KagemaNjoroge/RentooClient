import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/brightness.dart';

class SettingHome extends StatefulWidget {
  const SettingHome({super.key});

  @override
  State<SettingHome> createState() => _SettingHomeState();
}

class _SettingHomeState extends State<SettingHome> {
  final List _supportedLanguages = ["English", "Swahili"];
  final List _currencies = ["USD", "KES", "EUR", "GBP"];

  // dummy payment methods
  final List _paymentMethods = [
    {
      "type": "Mpesa",
      "description": "Mpesa payment method",
      "logo":
          "https://play-lh.googleusercontent.com/bRZF74-13jknePwUd1xam5ZCSdAJVuI_wqtkrisBgu7EEh1jobh2boZihlk-4ikY_S3V",
      "name": "Mpesa",
    },
    {
      "type": "Paypal",
      "description": "Paypal payment method",
      "logo":
          "https://play-lh.googleusercontent.com/bRZF74-13jknePwUd1xam5ZCSdAJVuI_wqtkrisBgu7EEh1jobh2boZihlk-4ikY_S3V",
      "name": "Paypal",
    },
    {
      "type": "Visa",
      "description": "Visa payment method",
      "logo":
          "https://play-lh.googleusercontent.com/bRZF74-13jknePwUd1xam5ZCSdAJVuI_wqtkrisBgu7EEh1jobh2boZihlk-4ikY_S3V",
      "name": "Visa",
    },
    {
      "type": "Mastercard",
      "description": "Mastercard payment method",
      "logo":
          "https://play-lh.googleusercontent.com/bRZF74-13jknePwUd1xam5ZCSdAJVuI_wqtkrisBgu7EEh1jobh2boZihlk-4ikY_S3V",
      "name": "Mastercard",
    },
    {
      "type": "American Express",
      "description": "American Express payment method",
      "logo":
          "https://play-lh.googleusercontent.com/bRZF74-13jknePwUd1xam5ZCSdAJVuI_wqtkrisBgu7EEh1jobh2boZihlk-4ikY_S3V",
      "name": "American Express",
    },
    {
      "type": "Discover",
      "description": "Discover payment method",
      "logo":
          "https://play-lh.googleusercontent.com/bRZF74-13jknePwUd1xam5ZCSdAJVuI_wqtkrisBgu7EEh1jobh2boZihlk-4ikY_S3V",
      "name": "Discover",
    },
    {
      "type": "Stripe",
      "description": "Stripe payment method",
      "logo":
          "https://play-lh.googleusercontent.com/bRZF74-13jknePwUd1xam5ZCSdAJVuI_wqtkrisBgu7EEh1jobh2boZihlk-4ikY_S3V",
      "name": "Stripe",
    },
    {
      "type": "Cash",
      "description": "Cash payment method",
      "logo":
          "https://play-lh.googleusercontent.com/bRZF74-13jknePwUd1xam5ZCSdAJVuI_wqtkrisBgu7EEh1jobh2boZihlk-4ikY_S3V",
      "name": "Cash",
    },
    {
      "type": "Bank Transfer",
      "description": "Bank Transfer payment method",
      "logo":
          "https://play-lh.googleusercontent.com/bRZF74-13jknePwUd1xam5ZCSdAJVuI_wqtkrisBgu7EEh1jobh2boZihlk-4ikY_S3V",
      "name": "Bank Transfer",
    },
    {
      "type": "Cheque",
      "description": "Cheque payment method",
      "logo":
          "https://play-lh.googleusercontent.com/bRZF74-13jknePwUd1xam5ZCSdAJVuI_wqtkrisBgu7EEh1jobh2boZihlk-4ikY_S3V",
      "name": "Cheque",
    }
  ];

  // dummy users
  final List _users = [
    {
      "firstName": "John",
      "lastName": "Doe",
      "email": "johndoe@example.com",
      "role": "Admin",
    },
    {
      "firstName": "Jane",
      "lastName": "Doe",
      "email": "janedoe@example.com",
      "role": "User",
    },
    {
      "firstName": "Alice",
      "lastName": "Doe",
      "email": "alicedoe@gmail.com",
      "role": "User",
    },
    {
      "firstName": "John",
      "lastName": "Doe",
      "email": "johndoe@example.com",
      "role": "Admin",
    },
    {
      "firstName": "Jane",
      "lastName": "Doe",
      "email": "janedoe@example.com",
      "role": "User",
    },
    {
      "firstName": "Alice",
      "lastName": "Doe",
      "email": "alicedoe@gmail.com",
      "role": "User",
    },
  ];

  // controllers& keys
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _logoController = TextEditingController();

  List<DropdownMenuItem> _getDropdownItems(List items) {
    List<DropdownMenuItem> dropdownItems = [];
    for (var item in items) {
      dropdownItems.add(DropdownMenuItem(
        value: item,
        child: Text(item),
      ));
    }
    return dropdownItems;
  }

  Widget _systemSettings() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          // company name, phone, email, website, logo, currency symbol, language
          Container(
            margin: const EdgeInsets.all(8),
            child: Form(
              key: _formKey,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _companyNameController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.business),
                            labelText: "Company Name",
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.phone),
                                  labelText: "Phone",
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.email),
                                  labelText: "Email",
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: _websiteController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.language),
                            labelText: "Website",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  // logo, currency symbol, language
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _logoController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.image),
                            labelText: "Logo",
                          ),
                        ),
                        DropdownButtonFormField(
                          items: _getDropdownItems(_currencies),
                          onChanged: (val) {},
                          decoration: const InputDecoration(
                            icon: Icon(Icons.money),
                            labelText: "Currency Symbol",
                          ),
                        ),
                        DropdownButtonFormField(
                          padding: EdgeInsets.zero,
                          items: _getDropdownItems(_supportedLanguages),
                          onChanged: (val) {},
                          decoration: const InputDecoration(
                            icon: Icon(Icons.language),
                            labelText: "Language",
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // save settings
                            }
                          },
                          icon: const Icon(Icons.done),
                          label: const Text("Save"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SwitchListTile(
            value: Provider.of<BrightnessProvider>(context).isDark,
            onChanged: (val) {
              Provider.of<BrightnessProvider>(context, listen: false)
                  .swithTheme();
            },
            title: const Text("Switch theme"),
          ),
        ],
      ),
    );
  }

  Widget _paymentSettings() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Text("Payment Methods"),
          // add button, filter search
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text("Add Payment Method"),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                height: 50,
                width: 300,
                child: const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // table -> logo, name, description, actions
          Expanded(
            child: SingleChildScrollView(
              child: Expanded(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Description")),
                    DataColumn(label: Text("Actions")),
                  ],
                  rows: _paymentMethods
                      .map(
                        (e) => DataRow(
                          cells: [
                            DataCell(
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(e["logo"]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(e["name"]),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Text(e["description"]),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.settings),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Settings",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),

            // tabs for payment, system,users&roles, notifications
            const Expanded(
              child: TabBar(
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                tabs: [
                  Tab(
                    icon: Icon(Icons.settings),
                    text: "System",
                  ),
                  Tab(
                    icon: Icon(Icons.payment),
                    text: "Payments",
                  ),
                  Tab(
                    icon: Icon(Icons.people),
                    text: "Users & Roles",
                  ),
                  Tab(
                    icon: Icon(Icons.notifications),
                    text: "Notifications",
                  ),
                ],
              ),
            ),
            // tab views
            Expanded(
              flex: 5,
              child: TabBarView(
                children: [
                  _systemSettings(),
                  _paymentSettings(),

                  // users and roles
                  Card(
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        const Text("Users & Roles settings"),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.add),
                              label: const Text("Add User"),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              height: 50,
                              width: 300,
                              child: const Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Search",
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // users table
                        Expanded(
                          child: SingleChildScrollView(
                            child: DataTable(columns: const [
                              DataColumn(label: Text("First Name")),
                              DataColumn(label: Text("Last Name")),
                              DataColumn(label: Text("Email")),
                              DataColumn(label: Text("Role")),
                              DataColumn(label: Text("Actions")),
                            ], rows: [
                              for (var user in _users)
                                DataRow(cells: [
                                  DataCell(Text(user["firstName"])),
                                  DataCell(Text(user["lastName"])),
                                  DataCell(Text(user["email"])),
                                  DataCell(Text(user["role"])),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                            ]),
                          ),
                        )
                      ],
                    ),
                  ),
                  // notifications
                  Card(
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Notification settings"),
                        SwitchListTile(
                          value: false,
                          onChanged: (val) {},
                          title: const Text("Rent Payment"),
                        ),
                        SwitchListTile(
                          value: false,
                          onChanged: (val) {},
                          title: const Text("Maintenance Requests"),
                        ),
                        SwitchListTile(
                          value: false,
                          onChanged: (val) {},
                          title: const Text("System upgrade"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
