import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pt_todo_app/data/models/task_model.dart';

class TodoDataSource {
  final _apiUrl = Uri.parse('https://jsonplaceholder.typicode.com/todos');

  Future<List<TaskModel>> fetchTasks() async {
    try {
      final response = await http.get(
        _apiUrl,
        headers: {
          'Content-Type': 'application/json',
        }, // la API responde con un status code 403 si no se usa un header
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((job) => TaskModel.fromJson(job)).toList();
      } else {
        throw Exception("Error de servidor");
      }
    } catch (e) {
      throw Exception("Error de conexión");
    }
  }
}
