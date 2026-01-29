import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pt_todo_app/core/colors.dart';
import 'package:pt_todo_app/domain/entities/task_entity.dart';
import 'package:pt_todo_app/presentation/components/state_chip.dart';
import 'package:pt_todo_app/presentation/home/bloc/home_cubit.dart';

class DetailPage extends StatelessWidget {
  final TaskEntity task;

  const DetailPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Tarea')),
      body: Padding(
        padding: const .all(16.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text("ID: ${task.id}", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Text(
              task.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Hero(
              tag: 'chip_${task.id}',
              child: Material(
                color: Colors.transparent,
                child: stateChip(task.isCompleted),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _setTaskCompleted(context);
                },
                icon: Icon(task.isCompleted ? Icons.undo : Icons.check),
                label: Text(
                  task.isCompleted
                      ? "Marcar como pendiente"
                      : "Marcar como completada",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: task.isCompleted
                      ? notCompletedColor
                      : completedColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setTaskCompleted(BuildContext context) {
    context.read<HomeCubit>().toggleTaskCompletion(task);
    Navigator.pop(context);
  }
}
