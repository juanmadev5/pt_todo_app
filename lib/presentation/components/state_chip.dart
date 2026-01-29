import 'package:flutter/material.dart';
import 'package:pt_todo_app/core/colors.dart';

DecoratedBox stateChip(bool isCompleted) {
  return DecoratedBox(
    decoration: BoxDecoration(
      border: .all(
        color: isCompleted ? completedColor : notCompletedColor,
        width: 2,
      ),
      borderRadius: .circular(16),
    ),
    child: SizedBox(
      height: 32,
      width: 100,
      child: Padding(
        padding: const .all(4.0),
        child: Center(child: Text(isCompleted ? "Completado" : "Pendiente")),
      ),
    ),
  );
}
