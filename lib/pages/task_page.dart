import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../cubit/task_cubit.dart';
import '../models/task.dart';
import '../widgets/custom_modal_action.dart';

class TaskPage extends StatefulWidget {
  final Task? task;
  final TaskCubit taskCubit;

  const TaskPage({Key? key, required this.taskCubit, this.task})
      : super(key: key);

  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _notesController;
  late DateFormat _dateFormat;
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _dateController = TextEditingController(
        text: widget.task?.date != null
            ? DateFormat('dd/MM/yyyy').format(widget.task!.date)
            : '');
    _notesController = TextEditingController(text: widget.task?.notes ?? '');
    _dateFormat = DateFormat('dd/MM/yyyy');
    _isCompleted = widget.task?.isCompleted ?? false;
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    "Excluir Tarefa",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(widget.task!.title),
                  const SizedBox(height: 24),
                  const SizedBox(height: 24),
                  CustomModalActionButton(
                    onClose: () {
                      Navigator.of(context).pop(false);
                    },
                    onSave: () {
                      widget.taskCubit.deleteTask(widget.task!.id);
                      Navigator.of(context).pop(true);
                      Navigator.of(context).pop();
                    },
                    titleOp1: 'Cancelar',
                    titleOp2: 'Excluir',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task != null ? 'Editar Tarefa' : 'Adicionar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: widget.task != null ? '' : 'Adicionar uma tarefa',
                prefixIcon: widget.task != null
                    ? IconButton(
                        icon: Icon(
                          color: const Color.fromRGBO(250, 30, 78, 1),
                          _isCompleted
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            _isCompleted = !_isCompleted;
                          });
                        },
                      )
                    : Icon(
                        color: const Color.fromRGBO(250, 30, 78, 1),
                        _isCompleted
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        size: 32,
                      ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(
                  labelText: 'Data',
                  prefixIcon: Icon(
                    Icons.calendar_today,
                    color: Color.fromRGBO(250, 30, 78, 1),
                  )),
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  _dateController.text = _dateFormat.format(pickedDate);
                }
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _notesController,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Anotações'),
            ),
            const SizedBox(height: 16.0),
            const Expanded(
              child: SizedBox(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () {
                    _saveTask(context, widget.taskCubit);
                  },
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(12)),
                  color: const Color.fromRGBO(250, 30, 78, 1),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(14.0),
                  child: Text(widget.task != null
                      ? 'Salvar Alterações'
                      : 'Adicionar Tarefa'),
                ),
                if (widget.task != null)
                  Expanded(
                    child: Container(),
                  ),
                if (widget.task != null)
                  MaterialButton(
                    onPressed: () {
                      _showDeleteConfirmation(context);
                    },
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12)),
                    color: Colors.white,
                    textColor: const Color.fromRGBO(250, 30, 78, 1),
                    padding: const EdgeInsets.all(14.0),
                    child: const Text('Excluir'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveTask(BuildContext context, TaskCubit taskCubit) {
    final title = _titleController.text.trim();
    final notes = _notesController.text.trim();

    DateTime? date;
    try {
      date = _dateFormat.parse(_dateController.text.trim());
    } catch (e) {
      print('Erro ao formatar a data: $e');
    }

    if (title.isNotEmpty && date != null) {
      final taskToUpdate = widget.task?.copyWith(
        title: title,
        date: date,
        notes: notes,
        isCompleted: _isCompleted,
      );
      if (widget.task != null) {
        taskCubit.updateTask(taskToUpdate!);
      } else {
        taskCubit.addTask(Task(
          id: DateTime.now().toString(),
          title: title,
          date: date,
          notes: notes,
          isCompleted: _isCompleted,
        ));
      }
      Navigator.of(context).pop();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Título não pode ser vazio.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
