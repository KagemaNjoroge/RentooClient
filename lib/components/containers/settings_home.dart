import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentoo_pms/sdk/user.dart';

import '../../constants.dart';
import '../../models/company.dart';
import '../../providers/brightness.dart';
import '../../sdk/company.dart';
import '../../utils/snack.dart';
import '../common/gap.dart';

class SystemSettingsTab extends StatefulWidget {
  const SystemSettingsTab({super.key});

  @override
  State<SystemSettingsTab> createState() => _SystemSettingsTabState();
}

class _SystemSettingsTabState extends State<SystemSettingsTab> {
  // controllers& keys
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _logoController = TextEditingController();
  final List _supportedLanguages = ["en", "sw"];
  final List _currencies = ["USD", "KES", "EUR", "GBP"];
  String _currency = "KES";
  String _language = "en";
  int _companyId = 1;
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

  final CompanyAPI _companyAPI = CompanyAPI();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          // company name, phone, email, website, logo, currency symbol, language
          Container(
            margin: const EdgeInsets.all(8),
            child: FutureBuilder(
              future: _companyAPI.get(companyUrl),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  if (snapshot.data!['companies'].isNotEmpty) {
                    Company company = snapshot.data!['companies'].first;
                    print(company.toJson());
                    _companyNameController.text = company.name.toString();
                    _websiteController.text = company.website.toString();
                    _emailController.text = company.email.toString();
                    _phoneController.text = company.phone.toString();
                    _logoController.text = company.logo.toString();
                    _currency = company.currency.toString();
                    _language = company.language.toString();
                    _companyId = int.tryParse(company.id.toString()) ?? 1;
                  }

                  return Form(
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
                        const Gap(),
                        // logo, currency symbol, language
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: _logoController,
                                decoration: InputDecoration(
                                  icon: const Icon(Icons.image),
                                  labelText: "Logo",
                                  suffix: IconButton(
                                    onPressed: () {
                                      showSnackBar(context, Colors.green,
                                          "Select image from gallery", 300);
                                    },
                                    icon: const Icon(Icons.image_search),
                                  ),
                                ),
                              ),
                              DropdownButtonFormField(
                                items: _getDropdownItems(_currencies),
                                value: _currency,
                                onChanged: (val) {
                                  _currency = val;
                                },
                                validator: (value) {
                                  if (value.toString().isEmpty) {
                                    return "You have to select a currency";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.money),
                                  labelText: "Currency Symbol",
                                ),
                              ),
                              DropdownButtonFormField(
                                padding: EdgeInsets.zero,
                                validator: (value) {
                                  if (value.toString().isEmpty) {
                                    return "You have to select a language";
                                  }
                                  return null;
                                },
                                items: _getDropdownItems(_supportedLanguages),
                                value: _language,
                                onChanged: (val) {
                                  _language = val;
                                },
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.language),
                                  labelText: "Language",
                                ),
                              ),
                              const Gap(),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    // save settings
                                    var url = "$companyUrl$_companyId/";

                                    Company company = Company(
                                      id: _companyId,
                                      name: _companyNameController.text,
                                      currency: _currency,
                                      email: _emailController.text,
                                      language: _language,
                                      website: _websiteController.text,
                                      phone: _phoneController.text,
                                    );

                                    try {
                                      var response = await _companyAPI
                                          .patch(url, body: company.toJson());
                                      if (response['status'] == "success") {
                                        showSnackBar(context, Colors.green,
                                            "Company details updated", 300);
                                        setState(() {});
                                      } else {
                                        showSnackBar(context, Colors.red,
                                            "An error occurred", 300);
                                      }
                                    } catch (e) {
                                      showSnackBar(context, Colors.red,
                                          e.toString(), 600);
                                    }
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
                  );
                }
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              },
            ),
          ),

          const ThemeToggleSwitch()
        ],
      ),
    );
  }
}

class ThemeToggleSwitch extends StatelessWidget {
  const ThemeToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: Provider.of<BrightnessProvider>(context).isDark,
      onChanged: (val) {
        Provider.of<BrightnessProvider>(context, listen: false).swithTheme();
      },
      title: const Text("Switch theme"),
    );
  }
}

class SettingHome extends StatefulWidget {
  const SettingHome({super.key});

  @override
  State<SettingHome> createState() => _SettingHomeState();
}

class _SettingHomeState extends State<SettingHome> {
  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
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
            Expanded(
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
                  SystemSettingsTab(),
                  PaymentSettingsTab(),
                  UserSettingsTab(),
                  NotificationSettingsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentSettingsTab extends StatefulWidget {
  const PaymentSettingsTab({super.key});

  @override
  State<PaymentSettingsTab> createState() => _PaymentSettingsTabState();
}

class _PaymentSettingsTabState extends State<PaymentSettingsTab> {
  // dummy payment methods
  final List _paymentMethods = [
    {
      "type": "Mpesa",
      "description": "Mpesa payment method",
      "logo": "assets/images/logo.png",
      "name": "Mpesa",
    },
    {
      "type": "Paypal",
      "description": "Paypal payment method",
      "logo": "assets/images/logo.png",
      "name": "Paypal",
    },
    {
      "type": "Visa",
      "description": "Visa payment method",
      "logo": "assets/images/logo.png",
      "name": "Visa",
    },
    {
      "type": "Mastercard",
      "description": "Mastercard payment method",
      "logo": "assets/images/logo.png",
      "name": "Mastercard",
    },
    {
      "type": "American Express",
      "description": "American Express payment method",
      "logo": "assets/images/logo.png",
      "name": "American Express",
    },
    {
      "type": "Discover",
      "description": "Discover payment method",
      "logo": "assets/images/logo.png",
      "name": "Discover",
    },
    {
      "type": "Stripe",
      "description": "Stripe payment method",
      "logo": "assets/images/logo.png",
      "name": "Stripe",
    },
    {
      "type": "Cash",
      "description": "Cash payment method",
      "logo": "assets/images/logo.png",
      "name": "Cash",
    },
    {
      "type": "Bank Transfer",
      "description": "Bank Transfer payment method",
      "logo": "assets/images/logo.png",
      "name": "Bank Transfer",
    },
    {
      "type": "Cheque",
      "description": "Cheque payment method",
      "logo": "assets/images/logo.png",
      "name": "Cheque",
    }
  ];
  @override
  Widget build(BuildContext context) {
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
                    DataColumn(
                      label: Text("Name"),
                    ),
                    DataColumn(
                      label: Text("Description"),
                    ),
                    DataColumn(
                      label: Text("Actions"),
                    ),
                  ],
                  rows: _paymentMethods
                      .map(
                        (e) => DataRow(
                          cells: [
                            DataCell(
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage(e['logo']),
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
}

class NotificationSettingsTab extends StatefulWidget {
  const NotificationSettingsTab({super.key});

  @override
  State<NotificationSettingsTab> createState() =>
      _NotificationSettingsTabState();
}

class _NotificationSettingsTabState extends State<NotificationSettingsTab> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Notification settings",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
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
    );
  }
}

class UserSettingsTab extends StatefulWidget {
  const UserSettingsTab({super.key});

  @override
  State<UserSettingsTab> createState() => _UserSettingsTabState();
}

class _UserSettingsTabState extends State<UserSettingsTab> {
  final UserAPI _userAPI = UserAPI();
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
  @override
  Widget build(BuildContext context) {
    return Card(
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
              child: FutureBuilder(
            builder: (context, snapshot) {
              print(snapshot.data);
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(
                        label: Text("First Name"),
                      ),
                      DataColumn(
                        label: Text("Last Name"),
                      ),
                      DataColumn(
                        label: Text("Email"),
                      ),
                      DataColumn(
                        label: Text("Role"),
                      ),
                      DataColumn(
                        label: Text("Actions"),
                      ),
                    ],
                    rows: [
                      for (var user in _users)
                        DataRow(
                          cells: [
                            DataCell(
                              Text(user["firstName"]),
                            ),
                            DataCell(
                              Text(user["lastName"]),
                            ),
                            DataCell(
                              Text(user["email"]),
                            ),
                            DataCell(
                              Text(user["role"]),
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
                    ],
                  ),
                );
              } else {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }
            },
            future: _userAPI.get(usersUrl),
          ))
        ],
      ),
    );
  }
}
