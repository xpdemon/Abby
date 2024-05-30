import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:ollama_dart/ollama_dart.dart';
import 'package:provider/provider.dart';

import '../async_result.dart';
import '../db.dart';
import '../model_controller.dart';

class AddPersonaDialog extends StatelessWidget {
  final ValueNotifier<String> name = ValueNotifier('');

  AddPersonaDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final controller = context.read<PersonaService>();

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
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      'Name',
                      style: textTheme.titleSmall,
                    ),
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: TextField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          suffixIcon: name.value.isNotEmpty
                              ? IconButton(
                                  onPressed: () => name.value = '',
                                  icon: const Icon(Icons.close),
                                  iconSize: 14,
                                )
                              : null,
                          suffixIconConstraints:
                              const BoxConstraints(maxHeight: 32, maxWidth: 32),
                          isDense: true,
                        ),
                        onChanged: (value) => name.value = value,
                      ),
                    ),
                    Text(
                      'Job',
                      style: textTheme.titleSmall,
                    ),
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: TextField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          suffixIcon: name.value.isNotEmpty
                              ? IconButton(
                            onPressed: () => name.value = '',
                            icon: const Icon(Icons.close),
                            iconSize: 14,
                          )
                              : null,
                          suffixIconConstraints:
                          const BoxConstraints(maxHeight: 32, maxWidth: 32),
                          isDense: true,
                        ),
                        onChanged: (value) => name.value = value,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
