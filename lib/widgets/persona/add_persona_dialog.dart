
import 'package:flutter/material.dart';

import 'add_persona_form.dart';

class AddPersonaDialog extends StatelessWidget {
  final ValueNotifier<String> name = ValueNotifier('');
  final ValueNotifier<String> personality = ValueNotifier('');

  AddPersonaDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1080),
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Create a new persona',
                  style: textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(height: 18),
            const Row(
              children: [
                AddPersonaForm(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
