import 'package:flutter/material.dart';
import 'package:rentoo_pms/utils/snack.dart';

import '../../constants.dart';
import '../../models/tenant.dart';
import '../../sdk/tenants.dart';

class TenantsHome extends StatefulWidget {
  const TenantsHome({super.key});

  @override
  State<TenantsHome> createState() => _TenantsHomeState();
}

class _TenantsHomeState extends State<TenantsHome> {
  bool _isLoading = false;
  Widget _gap() {
    return const SizedBox(
      height: 10,
    );
  }

  Widget _horizontalGap() {
    return const SizedBox(
      width: 10,
    );
  }

  List<DropdownMenuItem> _tenantsTypes() {
    return tenantTypes
        .map(
          (e) => DropdownMenuItem(
            value: e['value'],
            child: Text(e['name']!),
          ),
        )
        .toList();
  }

  String tenant_type = "Individual";

// controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
// keys
  final GlobalKey<FormState> _formKey = GlobalKey();

  Widget _addTenantModal() {
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
            DropdownButtonFormField(
              items: _tenantsTypes(),
              onChanged: (value) {
                setState(() {
                  tenant_type = value.toString();
                });
              },
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: "Tenant Type",
              ),
            ),
            _gap(),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _firstNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "First Name is required";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: UnderlineInputBorder(),
                        hintText: "First Name"),
                  ),
                ),
                _horizontalGap(),
                Expanded(
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Last Name is required";
                      }
                      return null;
                    },
                    controller: _lastNameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: UnderlineInputBorder(),
                        hintText: "Last Name"),
                  ),
                ),
              ],
            ),
            _gap(),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        border: UnderlineInputBorder(),
                        hintText: "Phone Number"),
                  ),
                ),
                _horizontalGap(),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        border: UnderlineInputBorder(),
                        hintText: "Email"),
                  ),
                ),
              ],
            ),
            _gap(),
            TextFormField(
              controller: _websiteController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.language),
                  border: UnderlineInputBorder(),
                  hintText: "Website"),
            ),
            _gap(),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: const Text("Close"),
                  icon: const Icon(Icons.close),
                ),
                TextButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Tenant tenant = Tenant(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        email: _emailController.text,
                        phoneNumber: _phoneController.text,
                        type: tenant_type,
                        website: _websiteController.text,
                        houses: [],
                      );
                      // save
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        var response = await _tenantsAPI.post(tenantsUrl,
                            body: tenant.toJson());
                        if (response['status'] == "success") {
                          showSnackBar(context, Colors.green,
                              "Tenant added successfully", 300);
                          // clear fields
                          _firstNameController.clear();
                          _lastNameController.clear();
                          _emailController.clear();
                          _phoneController.clear();
                          _websiteController.clear();
                        } else {
                          showSnackBar(
                              context, Colors.red, "An error occurred", 300);
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      } catch (e) {
                        showSnackBar(context, Colors.red, e.toString(), 300);
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
                  label: _isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : const Text("Save"),
                  icon: const Icon(Icons.done),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  final TenantsAPI _tenantsAPI = TenantsAPI();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tenants",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    showBottomSheet(
                        context: context,
                        builder: (context) {
                          return _addTenantModal();
                        });
                  },
                  label: const Text("Add Tenant"),
                  icon: const Icon(Icons.add)),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        FutureBuilder(
          future: _tenantsAPI.get(tenantsUrl),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              );
            }
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var tenant = snapshot.data!['tenants'][index];
                    return ListTile(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("${tenant.firstName} ${tenant.lastName}"),
                            behavior: SnackBarBehavior.floating,
                            width: 300,
                            backgroundColor: Colors.green,
                            action: SnackBarAction(
                              label: "Close",
                              onPressed: () {
                                ScaffoldMessenger.of(context).clearSnackBars();
                              },
                            ),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundImage: tenant.photo != null
                            ? NetworkImage(tenant.photo!)
                            : const AssetImage("assets/images/user_avatar.png"),
                      ),
                      title:
                          Text("${snapshot.data!['tenants'][index].firstName}"),
                    );
                  },
                  itemCount: snapshot.data!['tenants'].length ?? 0,
                ),
              );
            }
            return const Text("An error occurred");
          },
        )
      ],
    );
  }
}
