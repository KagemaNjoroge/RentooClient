import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/tenant.dart';
import '../../providers/destination_provider.dart';
import '../../sdk/tenants.dart';
import '../../utils/snack.dart';
import '../common/gap.dart';
import '../common/progress_indicator.dart';

class TenantDetails extends StatefulWidget {
  int tenantID;
  TenantDetails({super.key, required this.tenantID});

  @override
  State<TenantDetails> createState() => _TenantDetailsState();
}

class _TenantDetailsState extends State<TenantDetails> {
  final TenantsAPI _tenantsAPI = TenantsAPI();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Provider.of<DestinationProvider>(context, listen: false)
                            .changeDestination(0);
                      },
                      icon: const Icon(Icons.arrow_back)),
                  const HorizontalGap(),
                  const Text("Tenant details"),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                    tooltip: "Edit tenant details",
                  )
                ],
              )
            ],
          ),
          FutureBuilder(
            future: _tenantsAPI.getItem("$tenantsUrl${widget.tenantID}/"),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("An error occurred."),
                    const Gap(),
                    ElevatedButton.icon(
                      label: const Text("Retry"),
                      onPressed: () {},
                      icon: const Icon(Icons.refresh_rounded),
                    )
                  ],
                );
              }
              if (!snapshot.hasError &&
                  snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                Tenant tenant = snapshot.data!['tenant'];
                return Column(
                  children: [
                    Text(
                      "${tenant.firstName} ${tenant.lastName}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Colors.black12),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircleAvatar(
                                  radius: 100,
                                  backgroundImage:
                                      AssetImage("assets/images/logo.png"),
                                ),
                                const Gap(),
                                // phone number
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.phone_enabled_outlined,
                                      size: 20,
                                      color: kPrimaryColor,
                                    ),
                                    const HorizontalGap(),
                                    Text(
                                      tenant.phoneNumber ?? "Unknown",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "First Name:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const HorizontalGap(),
                                    Text("${tenant.firstName}"),
                                  ],
                                ),
                                const Gap(),
                                Row(
                                  children: [
                                    const Text(
                                      "Other Name:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const HorizontalGap(),
                                    Text("${tenant.lastName}"),
                                  ],
                                ),
                                const Gap(),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.language_sharp,
                                      color: kPrimaryColor,
                                      size: 16,
                                    ),
                                    const HorizontalGap(),
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      onHover: (event) {
                                        showSnackBar(context, kPrimaryColor,
                                            "Website hovered", 200);
                                      },
                                      child: Text(
                                        "${tenant.website}",
                                        style: const TextStyle(
                                          color: Colors.lightBlue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                );
              }
              return const CustomProgressIndicator();
            },
          )
        ],
      ),
    );
  }
}
