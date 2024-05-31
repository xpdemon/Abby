import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/persona.dart';

class PersonaMenu extends StatelessWidget {
  final Persona selection;
  final List<Persona> personas;

  final ValueChanged<Persona> onSelected;
  final VoidCallback onReload;

  const PersonaMenu({
    super.key,
    required this.selection,
    required this.personas,
    required this.onSelected,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownMenu<Persona>(
          label: const Text('Persona'),
          dropdownMenuEntries: personas
              .map(
                (persona) => DropdownMenuEntry(
              value: persona,
              leadingIcon: const Icon(Icons.person),
              label:
              '${persona.name}(${persona.job})',
            ),
          )
              .toList(),
          leadingIcon: const Icon(Icons.person),
          initialSelection: selection,
          onSelected: (newSelection) => onSelected(newSelection ?? selection),
          inputDecorationTheme: InputDecorationTheme(
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal.shade800),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            contentPadding: const EdgeInsets.all(4.0),
          ),
        ),
        IconButton(
          onPressed: onReload,
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}

class PersonaTile extends StatelessWidget {
  final bool selected;

  final Persona persona;

  final VoidCallback onTap;

  const PersonaTile(
      this.persona, {
        required this.selected,
        super.key,
        required this.onTap,
      });

  @override
  Widget build(final BuildContext context) => ListTile(
    selected: selected,
    title: Text(persona.name),
    subtitle: Text(
      '${persona.job} - '
          '${persona.lastUpdate == null ? '/' : DateFormat('dd/MM/yyyy').format(persona.lastUpdate)}',
    ),
    onTap: onTap,
    subtitleTextStyle: const TextStyle(color: Colors.grey),
    dense: true,
  );
}
