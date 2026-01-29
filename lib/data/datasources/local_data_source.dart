import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class LocalDataSource {
  final SharedPreferences sharedPreferences;
  static const _key = 'cached_tasks';

  LocalDataSource({required this.sharedPreferences});

  Future<List<TaskModel>> getCachedTasks() async {
    final jsonString = sharedPreferences.getString(_key);

    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((item) => TaskModel.fromJson(item)).toList();
    }

    return []; // si no hay elementos guardados retornamos una lista vacia
  }

  Future<void> cacheTask(TaskModel task) async {
    final existingTasks = await getCachedTasks();

    final index = existingTasks.indexWhere((t) => t.id == task.id);

    if (index != -1) {
      existingTasks[index] = task;
    } else {
      existingTasks.insert(0, task);
    }

    final String encodedData = jsonEncode(
      existingTasks.map((t) => t.toJson()).toList(),
    );

    await sharedPreferences.setString(_key, encodedData);
  }
}
