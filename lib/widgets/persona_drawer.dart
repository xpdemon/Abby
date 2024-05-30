import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ollama_dart/ollama_dart.dart';
import 'package:provider/provider.dart';

import '../async_result.dart';
import '../db.dart';
import '../model.dart';
import '../model_controller.dart';
import 'add_model_dialog.dart';
import 'add_persona_dialog.dart';
import 'delete_model_button.dart';
import 'delete_persona_button.dart';
import 'model_info_view.dart';
import 'model_list.dart';
import 'persona_list.dart';

class PersonaDrawer extends StatelessWidget {
  const PersonaDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<PersonaService>();
    final filterNotifier = ValueNotifier('');

    return Drawer(
      width: 360,
      child: ListenableBuilder(
        listenable: Listenable.merge(
          [controller.personas, controller.defaultPersona],
        ),
        builder: (context, _) {
          final personas = controller.personas.value;

          return switch (personas) {
            Data(:final data) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _FilterField(
                          onFilterChanged: (value) =>
                              filterNotifier.value = value,
                        ),
                      ),
                      //TODO CREATE PERSONA
                      const _AddPersonaButton(),
                      const SizedBox(width: 10),
                    ],
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: filterNotifier,
                      builder: (context, filter, _) {
                        bool match(Persona element) => element.name
                            .toLowerCase()
                            .contains(filter.toLowerCase());

                        final personas =
                            filter.isEmpty ? data : data.where(match).toList();
                        return _PersonaList(
                          currentPersona: controller.defaultPersona.value,
                          personas: personas,
                        );
                      },
                    ),
                  ),
                ],
              ),
            DataError() => const Icon(Icons.warning, color: Colors.deepOrange),
            Pending() => Center(
                child: SizedBox.fromSize(
                  size: const Size.fromWidth(24),
                  child: const CircularProgressIndicator(),
                ),
              ),
          };
        },
      ),
    );
  }
}

class _AddPersonaButton extends StatelessWidget {
  const _AddPersonaButton();

  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
        icon: const Icon(Icons.add),
        tooltip: 'Create a new Persona',
        onPressed: () {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AddPersonaDialog();
            },
          );
        },
      );
}

class _PersonaList extends StatelessWidget {
  final List<Persona> personas;

  final Persona? currentPersona;

  const _PersonaList({
    required this.personas,
    required this.currentPersona,
  });

  @override
  Widget build(BuildContext context) => ListView(
        children: personas
            .map(
              (persona) => _PersonaTile(
                persona: persona,
                selected: currentPersona == persona,
              ),
            )
            .toList(),
      );
}

class _PersonaTile extends StatefulWidget {
  final Persona persona;

  final bool selected;

  const _PersonaTile({required this.persona, required this.selected});

  @override
  _PersonaTileState createState() => _PersonaTileState();
}

class _PersonaTileState extends State<_PersonaTile> {
  bool hovered = false;

  late Persona persona;

  @override
  void initState() {
    super.initState();
    persona = widget.persona;
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<PersonaService>();

    return MouseRegion(
      onHover: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: ListTile(
        title: Text(persona.name),
        subtitle: Text(
          '${persona.name} - updated ${persona.formattedDate}',
        ),
        dense: true,
        leading: const Icon(Icons.person),
        trailing: hovered || widget.selected
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DeletePersonaButton(persona: persona),
                ],
              )
            : null,
        selected: widget.selected,
        onTap: () => unawaited(controller.selectPersona(persona)),
      ),
    );
  }
}

class _FilterField extends StatelessWidget {
  final ValueChanged<String> onFilterChanged;

  final TextEditingController controller = TextEditingController();

  _FilterField({required this.onFilterChanged});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            label: const Text('Search model'),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              onPressed: () {
                controller.clear();
                onFilterChanged('');
              },
              icon: const Icon(Icons.close),
              iconSize: 14,
            ),
            suffixIconConstraints:
                const BoxConstraints(maxHeight: 32, maxWidth: 32),
            isDense: true,
          ),
          onChanged: onFilterChanged,
        ),
      );
}
