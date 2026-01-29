import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pt_todo_app/domain/entities/task_entity.dart';
import 'package:pt_todo_app/presentation/components/state_chip.dart';
import 'package:pt_todo_app/presentation/detail/detail_page.dart';
import 'package:pt_todo_app/presentation/home/bloc/home_cubit.dart';
import 'package:pt_todo_app/presentation/home/bloc/home_state.dart';
import 'package:pt_todo_app/presentation/home/bloc/theme_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        actions: [
          IconButton(
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            icon: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, state) {
                return Icon(
                  state == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
                );
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _refreshTaskList(context);
        },
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeSuccess) {
              if (state.tasks.isEmpty) {
                return _buildEmptyState(
                  'No hay tareas. Desliza para actualizar o pulsa el boton + para crear una tarea.',
                  context,
                );
              }

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];
                      return _buildTaskCard(context, task);
                    },
                  ),
                ),
              );
            }

            if (state is HomeError) {
              return _buildEmptyState(state.message, context);
            }

            return _buildEmptyState('Error al obtener tareas', context);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // el refreseh indicator necesita un child que sea scrolleable para detectar el gesto
  Widget _buildEmptyState(String message, BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height:
              MediaQuery.of(context).size.height *
              0.7, // evitamos que el texto se pueda scrollear
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(message, textAlign: TextAlign.center),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(BuildContext context, TaskEntity task) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 90, minHeight: 80),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          title: Text(task.title, overflow: TextOverflow.ellipsis, maxLines: 2),
          onTap: () => _navigateToDetail(context, task),
          leading: Hero(
            tag: 'chip_${task.id}',
            child: Material(
              color: Colors.transparent,
              child: stateChip(task.isCompleted),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshTaskList(BuildContext context) async {
    await context.read<HomeCubit>().loadTasks(isRefresh: true);
  }

  void _navigateToDetail(BuildContext context, TaskEntity task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(task: task)),
    );
  }

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Nueva Tarea'),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          scrollable: true,
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 280, maxWidth: 500),
              child: _taskForm(formKey, controller),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveTask(formKey, controller, context, dialogContext);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _saveTask(
    GlobalKey<FormState> formKey,
    TextEditingController controller,
    BuildContext context,
    BuildContext dialogContext,
  ) {
    if (formKey.currentState!.validate()) {
      final title = controller.text.trim();
      context.read<HomeCubit>().addTask(title);
      Navigator.pop(dialogContext);
    }
  }

  Form _taskForm(
    GlobalKey<FormState> formKey,
    TextEditingController controller,
  ) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Título de la tarea',
              hintText: 'Ej: Comprar leche',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              return _validateForm(value);
            },
          ),
        ],
      ),
    );
  }

  String? _validateForm(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El título no puede estar vacío';
    }
    if (value.length < 3) {
      return 'Debe tener al menos 3 caracteres';
    }
    return null;
  }
}
