import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ollama_dart/ollama_dart.dart';
import 'package:provider/provider.dart';

import '../db.dart';
import '../model.dart';
import '../model_controller.dart';

class DeletePersonaButton extends StatelessWidget {
  final Persona persona;

  const DeletePersonaButton({super.key, required this.persona});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<PersonaService>();

    return IconButton(
      tooltip: 'Delete Persona',
      onPressed: () async {
        final confirm = await showAdaptiveDialog<bool>(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text('Delete ${persona.name} ? '),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
              CupertinoDialogAction(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          ),
        );
        if (confirm ?? false) {
          controller.deletePersona(persona);
        }
      },
      icon: const Icon(Icons.delete),
      color: Theme.of(context).colorScheme.secondary,
    );
  }
}
