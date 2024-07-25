import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:rentoo_pms/models/user.dart';
import 'package:rentoo_pms/sdk/user.dart';

import '../../constants.dart';
import '../../models/company.dart';
import '../../sdk/company.dart';
import '../../utils/snack.dart';
import '../common/gap.dart';
import '../common/theme_toggle_switch.dart';

class CompanyLogo extends StatelessWidget {
  String url;
  CompanyLogo({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: NetworkImage(url),
      radius: 50,
    );
  }
}

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
  String _logoUrl = "";
  // selected image
  XFile? _image;
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

  Future<void> selectImage() async {
    const XTypeGroup typeGroup =
        XTypeGroup(label: 'images', extensions: ['jpg', 'png']);
    final List<XFile> files = await openFiles(acceptedTypeGroups: [typeGroup]);
    if (files.isNotEmpty) {
      _logoController.text = files.first.path;
      _image = files.first;
    }
  }

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

                    _companyNameController.text = company.name.toString();
                    _websiteController.text = company.website.toString();
                    _emailController.text = company.email.toString();
                    _phoneController.text = company.phone.toString();
                    _logoController.text = company.logo.toString();
                    _currency = company.currency.toString();
                    _language = company.language.toString();
                    _companyId = int.tryParse(company.id.toString()) ?? 1;
                    _logoUrl = company.logo.toString();
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
                              // Network image if company.logo is not null, else show placeholder, on image selection show selected image
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CompanyLogo(
                                    url: _logoUrl,
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await selectImage();
                                      // upload temp image for preview&processing
                                      saveSettings(context);
                                    },
                                    icon: const Icon(Icons.image),
                                    tooltip: "Upload new logo",
                                  ),
                                ],
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
                                    await saveSettings(context);
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

  Future<void> saveSettings(BuildContext context) async {
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
      var response = await _companyAPI.patch(url, body: company.toJson());
      if (response['status'] == "success") {
        if (mounted) {
          showSnackBar(context, Colors.green, "Company details updated", 300);
        }

        // upload logo
        if (_image != null) {
          var uploadResponse =
              await _companyAPI.uploadFile(url, _image!, "logo");
          if (mounted) {
            if (uploadResponse['status'] == "success") {
              showSnackBar(context, Colors.green, "Logo uploaded", 300);
            } else {
              showSnackBar(context, Colors.red, "Failed to upload logo", 300);
            }
          }
        }
        if (mounted) {
          setState(() {});
        }
      } else {
        if (mounted) {
          showSnackBar(context, Colors.red, "An error occurred", 300);
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, Colors.red, e.toString(), 600);
      }
    }
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text("Add Payment Method"),
                  ),
                  const HorizontalGap(),
                  ElevatedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return const MpesaPaymentsSettingsBottomSheet();
                        },
                      );
                    },
                    icon: const Icon(Icons.credit_card_rounded),
                    label: const Text("MPESA Payments Settings"),
                  ),
                ],
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
              child: Row(
                children: [
                  Expanded(
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
                                        icon: const Icon(Icons.remove_red_eye),
                                        onPressed: () {
                                          showSnackBar(context, Colors.green,
                                              "Attach action here", 200);
                                        },
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
                ],
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
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                List<User> users = snapshot.data!['users'];
                return SingleChildScrollView(
                  child: Row(
                    children: [
                      Expanded(
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
                            DataColumn(label: Text("Active?")),
                            DataColumn(
                              label: Text("Actions"),
                            ),
                          ],
                          rows: [
                            for (var user in users)
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(user.firstName.toString()),
                                  ),
                                  DataCell(
                                    Text(user.lastName.toString()),
                                  ),
                                  DataCell(
                                    Text(user.email.toString()),
                                  ),
                                  DataCell(
                                      Text(user.isStaff! ? "Admin" : "User")),
                                  DataCell(
                                    Radio(
                                      value: user.isActive,
                                      groupValue: user.isActive,
                                      onChanged: (val) {},
                                    ),
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

class MpesaPaymentsSettingsBottomSheet extends StatefulWidget {
  const MpesaPaymentsSettingsBottomSheet({super.key});

  @override
  State<MpesaPaymentsSettingsBottomSheet> createState() =>
      _MpesaPaymentsSettingsBottomSheetState();
}

class _MpesaPaymentsSettingsBottomSheetState
    extends State<MpesaPaymentsSettingsBottomSheet> {
  // controllers and keys
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _consumerKeyController = TextEditingController();
  final TextEditingController _consumerSecretController =
      TextEditingController();
  final TextEditingController _shortcodeController = TextEditingController();
  final TextEditingController _passkeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
          left: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
          right: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "MPESA Payments Settings",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextFormField(
                controller: _consumerKeyController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Consumer key is required";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.vpn_key),
                  labelText: "Consumer Key",
                ),
              ),
              const Gap(),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Consumer key is required";
                  }
                  return null;
                },
                controller: _consumerSecretController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.vpn_key),
                  labelText: "Consumer Secret",
                ),
              ),
              const Gap(),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Consumer key is required";
                  }
                  return null;
                },
                controller: _shortcodeController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.phone),
                  labelText: "Shortcode",
                ),
              ),
              const Gap(),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Consumer key is required";
                  }
                  return null;
                },
                controller: _passkeyController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.vpn_key),
                  labelText: "Passkey",
                ),
              ),
              const Gap(),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("Cancel"),
                  ),
                  const HorizontalGap(),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // save settings
                        Navigator.pop(context);
                        showSnackBar(context, Colors.red, "To implement", 200);
                      }
                    },
                    icon: const Icon(Icons.done),
                    label: const Text("Save"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
