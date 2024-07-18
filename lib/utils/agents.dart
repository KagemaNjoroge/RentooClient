import 'package:dio/dio.dart';

import '../models/agent.dart';

const agentsUrl = "http://localhost:8000/agents/";

final dio = Dio();

Future<Map<String, dynamic>> fetchAgents() async {
  final response = await dio.get(agentsUrl, options: Options());

  if (response.statusCode == 200) {
    var agents = [];
    for (var prop in response.data) {
      agents.add(Agent.fromJson(prop));
    }

    return {
      "status": "success",
      "agents": agents,
    };
  } else {
    throw "An error occured";
  }
}
