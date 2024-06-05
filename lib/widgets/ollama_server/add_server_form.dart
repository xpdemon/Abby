// Create a Form widget.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/ollama_server.dart';
import '../../models/persona.dart';
import '../../models/persona_hobbies.dart';
import '../../models/persona_jobs.dart';
import '../../models/persona_personality.dart';
import '../../services/ollama_server_service.dart';
import '../../services/persona_service.dart';

class AddServerForm extends StatefulWidget {
  const AddServerForm({super.key});

  @override
  AddServerFormState createState() {
    return AddServerFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class AddServerFormState extends State<AddServerForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final ollamaService = context.read<OllamaServerService>();
    final ValueNotifier<String> name = ValueNotifier('');
    final ValueNotifier<String> url = ValueNotifier('');
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
                icon: const Icon(Icons.drive_file_rename_outline),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a server name';
                }
                return null;
              },
            ),
            TextFormField(
              onChanged: (value) => url.value = value,

              decoration: InputDecoration(
                label: Text(
                  'Url',
                  style: textTheme.titleSmall,
                ),
                icon: const Icon(Icons.link_sharp),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a server name';
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
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      progress();
                      final server = OllamaServer(name: name.value, url: url.value);
                      await ollamaService.addServer(server);
                      close();
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void close() {
    Navigator.pop(context);
  }

  void progress() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Persona Save'),
      ),
    );
  }
}
