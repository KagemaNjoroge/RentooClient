import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/stats/property_stats.dart';
import '../../sdk/stats/property_stats.dart';
import '../../utils/snack.dart';
import '../common/progress_indicator.dart';
import '../rent_collection_sample_chart.dart';

class RecentMessages extends StatelessWidget {
  final List<Message> messages;

  const RecentMessages({
    super.key,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.message, size: 20, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  'Recent Messages',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: messages.map((message) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/user_avatar.png'),
                        radius: 15,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // navigate to chat screen
                            showSnackBar(
                                context, Colors.green, message.content, 600);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.sender,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                message.content,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700]),
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        message.time,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String sender;
  final String content;
  final String time;

  Message({
    required this.sender,
    required this.content,
    required this.time,
  });
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final PropertyStatsAPI _propertyStatsAPI = PropertyStatsAPI();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Dashboard",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            FutureBuilder(
              future: _propertyStatsAPI.get(propertyStatsUrl),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('An error occurred while loading stats.'),
                  );
                }
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  PropertyStats stats = snapshot.data!['stats'] ??
                      PropertyStats(
                        propertyCount: 0,
                        houseCount: 0,
                        vacantHouses: 0,
                        occupiedHouses: 0,
                      );
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PropertyCard(
                        title: "Total properties",
                        count: stats.propertyCount,
                        color: Colors.green,
                        icon: Icons.home,
                      ),
                      PropertyCard(
                        title: "Total houses",
                        count: stats.houseCount,
                        color: Colors.blue,
                        icon: Icons.house,
                      ),
                      // occupied houses
                      PropertyCard(
                        title: "Occupied houses",
                        count: stats.occupiedHouses,
                        color: Colors.orange,
                        icon: Icons.house_siding,
                      ),
                      // vacant houses
                      PropertyCard(
                        title: "Vacant houses",
                        count: stats.vacantHouses,
                        color: Colors.red,
                        icon: Icons.house_outlined,
                      ),
                    ],
                  );
                }
                return const Center(
                  child: CustomProgressIndicator(),
                );
              },
            ),
            const Row(
              children: [
                Expanded(child: RentCollectionChartSample()),
                Expanded(child: RentCollectionChartSample()),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: RecentMessages(
                    messages: [
                      Message(
                        sender: 'Alice',
                        content: 'The heating system is not working.',
                        time: '10:30 AM',
                      ),
                      Message(
                        sender: 'Bob',
                        content: 'Can I extend my lease for another year?',
                        time: '9:15 AM',
                      ),
                      Message(
                        sender: 'Charlie',
                        content: 'The kitchen sink is leaking.',
                        time: '8:45 AM',
                      ),
                    ],
                  ),
                ),
                const Expanded(child: RecentNotifications()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final IconData icon;

  const PropertyCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  count.toString(),
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RecentNotifications extends StatelessWidget {
  const RecentNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Recent Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.blue),
            title: Text('You have a new message from Alice.'),
            subtitle: Text('10:30 AM'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.blue),
            title: Text('You have a new message from Bob.'),
            subtitle: Text('9:15 AM'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.blue),
            title: Text('You have a new message from Charlie.'),
            subtitle: Text('8:45 AM'),
          ),
        ],
      ),
    );
  }
}
