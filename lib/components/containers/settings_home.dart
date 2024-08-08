import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/company.dart';
import '../../models/mpesa_payment_settings.dart';
import '../../models/payment_method.dart';
import '../../models/user.dart';
import '../../sdk/company.dart';
import '../../sdk/payment_method.dart';
import '../../sdk/settings/mpesa_payment_settings.dart';
import '../../sdk/user.dart';
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

  Widget _companyDetailsForm(bool isSaving) {
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
                      if (!isSaving) {
                        await saveSettings();
                      } else if (isSaving) {
                        await createSettings();
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
                    return _companyDetailsForm(false);
                  } else {
                    return _companyDetailsForm(true);
                  }
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

  Future<void> createSettings() async {
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
      var response = await _companyAPI.post(companyUrl, body: company.toJson());
      if (response['status'] == "success") {
        if (mounted) {
          showSnackBar(context, Colors.green, "Created successfully.", 300);
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

  Future<void> saveSettings() async {
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
  final PaymentMethodAPI _paymentMethodMethodAPI = PaymentMethodAPI();
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
                    onPressed: () {
                      showBottomSheet(
                          context: context,
                          builder: (_) {
                            return const AddPaymentMethodBottomSheet();
                          });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Payment Method"),
                  ),
                  const HorizontalGap(),
                  ElevatedButton.icon(
                    onPressed: () async {
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
          FutureBuilder(
            future: _paymentMethodMethodAPI.get(paymentMethodsUrl),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  !snapshot.hasError) {
                List<PaymentMethod> methods =
                    snapshot.data!['payment_methods'] ?? [];
                if (methods.isEmpty) {
                  return const Center(
                    child: Text("No payment methods found"),
                  );
                }
                return Expanded(
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
                            rows: methods
                                .map(
                                  (e) => DataRow(
                                    cells: [
                                      DataCell(
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(e.name.toString()),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DataCell(
                                        Text(e.description.toString()),
                                      ),
                                      DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.remove_red_eye),
                                              onPressed: () {
                                                showSnackBar(
                                                    context,
                                                    Colors.green,
                                                    "Attach action here",
                                                    200);
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
                );
              }
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            },
          )
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
                onPressed: () {
                  showBottomSheet(
                    elevation: 3,
                    context: context,
                    builder: (context) {
                      return const AddUserBottomSheet();
                    },
                  );
                },
                icon: const Icon(Icons.person_add_alt_1_outlined),
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline),
                          HorizontalGap(),
                          Text("An error occurred."),
                        ],
                      ),
                      const Gap(),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {});
                        },
                        label: const Text("Try again"),
                        icon: const Icon(Icons.refresh_sharp),
                      )
                    ],
                  );
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
                                    DataCell(Checkbox(
                                      onChanged: (val) {},
                                      value: user.isActive,
                                    )),
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
            ),
          )
        ],
      ),
    );
  }
}

class AddUserBottomSheet extends StatefulWidget {
  const AddUserBottomSheet({super.key});

  @override
  State<AddUserBottomSheet> createState() => _AddUserBottomSheetState();
}

class _AddUserBottomSheetState extends State<AddUserBottomSheet> {
  final bool _isLoading = false;
  // controllers and form keys
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Add user",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const Gap(),
          SingleChildScrollView(
            child: Expanded(
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _firstNameController,
                                decoration: const InputDecoration(
                                    hintText: "First Name"),
                              ),
                            ),
                            const HorizontalGap(),
                            Expanded(
                              child: TextFormField(
                                controller: _lastNameController,
                                decoration: const InputDecoration(
                                    hintText: "Last Name"),
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: _usernameController,
                          decoration:
                              const InputDecoration(hintText: "Username"),
                        ),
                        const Gap(),
                        TextFormField(
                          controller: _passwordController,
                          decoration:
                              const InputDecoration(hintText: "Password"),
                        ),
                      ],
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
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // save settings
                          }
                        },
                        icon: const Icon(Icons.done),
                        label: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("Save"),
                      ),
                    ],
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
  // state
  bool _consumerKeyIsVisible = true;
  bool _consumerSecretIsVisible = true;
  bool _passKeyIsVisible = true;
  bool _isLoading = false;

  final MpesaPaymentSettingsAPI _mpesaPaymentSettingsAPI =
      MpesaPaymentSettingsAPI();

  Widget _mpesaSettingsForm(String url, Function submitData) {
    return Column(
      children: [
        const Text(
          "MPESA Payments Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Short code is required";
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
                  obscureText: _consumerKeyIsVisible,
                  controller: _consumerKeyController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Consumer key is required";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          _consumerKeyIsVisible = !_consumerKeyIsVisible;
                        });
                      },
                      icon: _consumerKeyIsVisible
                          ? const Icon(Icons.remove_red_eye)
                          : const Icon(Icons.visibility_off),
                    ),
                    icon: const Icon(Icons.vpn_key),
                    labelText: "Consumer Key",
                  ),
                ),
                const Gap(),
                TextFormField(
                  obscureText: _consumerSecretIsVisible,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Consumer secret is required";
                    }
                    return null;
                  },
                  controller: _consumerSecretController,
                  decoration: InputDecoration(
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          _consumerSecretIsVisible = !_consumerSecretIsVisible;
                        });
                      },
                      icon: _consumerSecretIsVisible
                          ? const Icon(Icons.remove_red_eye)
                          : const Icon(Icons.visibility_off),
                    ),
                    icon: const Icon(Icons.vpn_key),
                    labelText: "Consumer Secret",
                  ),
                ),
                const Gap(),
                TextFormField(
                  obscureText: _passKeyIsVisible,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Pass key is required";
                    }
                    return null;
                  },
                  controller: _passkeyController,
                  decoration: InputDecoration(
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          _passKeyIsVisible = !_passKeyIsVisible;
                        });
                      },
                      icon: _passKeyIsVisible
                          ? const Icon(Icons.remove_red_eye)
                          : const Icon(Icons.visibility_off),
                    ),
                    icon: const Icon(Icons.vpn_key),
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // save settings
                          setState(() {
                            _isLoading = true;
                          });
                          await submitData();
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      icon: const Icon(Icons.done),
                      label: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Save"),
                    ),
                  ],
                ),
                const Gap()
              ],
            ),
          ),
        )
      ],
    );
  }

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
        child: FutureBuilder(
          future: _mpesaPaymentSettingsAPI.get(mpesaPaymentSettingsUrl),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              if (snapshot.data!['status'] == "success") {
                if (snapshot.data!['settings'].isEmpty) {
                  return _mpesaSettingsForm(mpesaPaymentSettingsUrl, () async {
                    MpesaPaymentSettings newSettings = MpesaPaymentSettings(
                      consumerKey: _consumerKeyController.text,
                      consumerSecret: _consumerSecretController.text,
                      shortCode: _shortcodeController.text,
                      passKey: _passkeyController.text,
                      testMode: false,
                    );
                    await _mpesaPaymentSettingsAPI.post(mpesaPaymentSettingsUrl,
                        body: newSettings.toJson());
                  });
                } else {
                  MpesaPaymentSettings settings =
                      snapshot.data!['settings'].first;
                  var url = "$mpesaPaymentSettingsUrl${settings.id}/";

                  _shortcodeController.text = settings.shortCode.toString();
                  _consumerKeyController.text = settings.consumerKey.toString();
                  _passkeyController.text = settings.passKey.toString();
                  _consumerSecretController.text =
                      settings.consumerSecret.toString();
                  return _mpesaSettingsForm(url, () async {
                    MpesaPaymentSettings newSettings = MpesaPaymentSettings(
                      consumerKey: _consumerKeyController.text,
                      consumerSecret: _consumerSecretController.text,
                      shortCode: _shortcodeController.text,
                      passKey: _passkeyController.text,
                      testMode: false,
                    );

                    await _mpesaPaymentSettingsAPI.patch(url,
                        body: newSettings.toJson());
                    setState(() {
                      _isLoading = false;
                    });
                    showSnackBar(
                        context, Colors.red, "Uploaded successfully", 200);
                  });
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          },
        ),
      ),
    );
  }
}

class AddPaymentMethodBottomSheet extends StatefulWidget {
  const AddPaymentMethodBottomSheet({super.key});

  @override
  State<AddPaymentMethodBottomSheet> createState() =>
      _AddPaymentMethodBottomSheetState();
}

class _AddPaymentMethodBottomSheetState
    extends State<AddPaymentMethodBottomSheet> {
  // keys and controllers
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // api
  final PaymentMethodAPI _paymentMethodAPI = PaymentMethodAPI();

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add payment method",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Gap(),
            TextFormField(
              controller: _nameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Payment method name is required";
                }
                return null;
              },
              decoration:
                  const InputDecoration(hintText: "Payment method name*"),
            ),
            const Gap(),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(hintText: "Some description"),
            ),
            const Gap(),
            Row(
              children: [
                ElevatedButton.icon(
                  label: const Text("Close"),
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const HorizontalGap(),
                ElevatedButton.icon(
                  label: const Text("Save"),
                  icon: const Icon(Icons.done),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_descriptionController.text.isEmpty) {
                        _descriptionController.text = _nameController.text;
                      }
                      PaymentMethod method = PaymentMethod(
                        name: _nameController.text,
                        description: _descriptionController.text,
                      );
                      try {
                        var response = await _paymentMethodAPI
                            .post(paymentMethodsUrl, body: method.toJson());
                        if (response['status'] == "success") {
                          showSnackBar(context, Colors.green,
                              "Payment method added successfully", 300);
                          Navigator.pop(context);
                        } else {
                          showSnackBar(
                              context, Colors.red, "An error occurred.", 300);
                        }
                      } catch (e) {
                        showSnackBar(context, Colors.red, e.toString(), 400);
                      }
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
