// Create a Form widget.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/persona.dart';
import '../../models/persona_hobbies.dart';
import '../../models/persona_jobs.dart';
import '../../models/persona_personality.dart';
import '../../services/persona_service.dart';



class AddPersonaForm extends StatefulWidget {
  const AddPersonaForm({super.key});

  @override
  AddPersonaFormState createState() {
    return AddPersonaFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class AddPersonaFormState extends State<AddPersonaForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final personaService = context.read<PersonaService>();
    final ValueNotifier<String> name = ValueNotifier('');
    final ValueNotifier<String> personality = ValueNotifier('');
    final ValueNotifier<String> job = ValueNotifier('');
    final ValueNotifier<String> hobby = ValueNotifier('');
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              onChanged: (value) => name.value = value,
              decoration: InputDecoration(
                label: Text(
                  'Name',
                  style: textTheme.titleSmall,
                ),
                icon: const Icon(Icons.person),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                label: Text(
                  'Personality',
                  style: textTheme.titleSmall,
                ),
                icon: const Icon(Icons.psychology),
              ),
              items: PersonaPersonality.values
                  .map(
                    (p) => DropdownMenuItem(
                      value: p.label,
                      child: Text(p.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) => personality.value = value!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a personality';
                }
                return null;
              },
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                label: Text(
                  'Job',
                  style: textTheme.titleSmall,
                ),
                icon: const Icon(Icons.work),
              ),
              items: PersonaJob.values
                  .map(
                    (p) => DropdownMenuItem(
                      value: p.label,
                      child: Text(p.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) => job.value = value!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a job';
                }
                return null;
              },
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                label: Text(
                  "centres d'interets",
                  style: textTheme.titleSmall,
                ),
                icon: const Icon(Icons.deck),
              ),
              items: PersonaHobbies.values
                  .map(
                    (p) => DropdownMenuItem(
                      value: p.label,
                      child: Text(p.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) => hobby.value = value!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a Hobby';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    var persona = Persona(
                        name: name.value,
                        lastUpdate: DateTime.now(),
                        hobby: hobby.value,
                        personality: personality.value,
                        job: job.value,
                        isDefault: 1,);
                    persona = personaService.generatePersonaPrompt(persona);
                    await personaService.savePersona(persona);
                    await personaService.loadPersonas();
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
