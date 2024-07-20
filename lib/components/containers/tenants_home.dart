import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../sdk/tenants.dart';

class TenantsHome extends StatefulWidget {
  const TenantsHome({super.key});

  @override
  State<TenantsHome> createState() => _TenantsHomeState();
}

Widget _gap() {
  return const SizedBox(
    height: 10,
  );
}

// controllers
TextEditingController _firstNameController = TextEditingController();
TextEditingController _lastNameController = TextEditingController();
TextEditingController _emailController = TextEditingController();
TextEditingController _phoneController = TextEditingController();
// keys
GlobalKey<FormState> _formKey = GlobalKey();

Widget _addTenantModal() {
  return Form(
    key: _formKey,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
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
        _gap(),
        TextFormField(
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
        _gap(),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.phone),
              border: UnderlineInputBorder(),
              hintText: "Phone Number"),
        ),
        _gap(),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email),
              border: UnderlineInputBorder(),
              hintText: "Email"),
        ),
      ],
    ),
  );
}

class _TenantsHomeState extends State<TenantsHome> {
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
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Center(
                            child: Text("Add new tenant"),
                          ),
                          content: _addTenantModal(),
                          actions: [
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
                                  // save
                                  await Future.delayed(
                                    const Duration(seconds: 3),
                                    () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Tenant added successfully"),
                                          behavior: SnackBarBehavior.floating,
                                          width: 300,
                                        ),
                                      );
                                      Navigator.pop(context);
                                    },
                                  );
                                }
                              },
                              label: const Text("Save"),
                              icon: const Icon(Icons.done),
                            ),
                          ],
                        );
                      },
                    );
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
