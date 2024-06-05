import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../async_result.dart';
import '../../services/ollama_server_service.dart';
import '../ollama_server/add_server_dialog.dart';

class ServerDropdown extends StatelessWidget {
  const ServerDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final OllamaServerService ollamaServerService =
        context.read<OllamaServerService>();
    final ValueNotifier<String> selectedServer =
        ollamaServerService.currentServer.value != null
            ? ValueNotifier(ollamaServerService.currentServer.value!.url)
            : ValueNotifier('');
    final textTheme = Theme.of(context).textTheme;

    return ListenableBuilder(
      listenable: Listenable.merge([
        ollamaServerService.ollamaServers,
        ollamaServerService.currentServer,
        selectedServer,
      ]),
      builder: (context, _) {
        final selection =
            selectedServer.value == '' ? 'Server' : selectedServer.value;
        final servers = ollamaServerService.ollamaServers.value;
        servers.data?.sort((a, b) => b.lastUse.compareTo(a.lastUse));
        return switch (servers) {
          Data(:final data) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                  width: 300,
                  child: DropdownButtonFormField(
                    focusColor: Theme.of(context).scaffoldBackgroundColor,
                    decoration: InputDecoration(
                      label: Text(
                        selection,
                        style: textTheme.titleSmall,
                      ),
                      icon: const Icon(Icons.settings_ethernet),
                    ),
                    items: data
                        .map(
                          (p) => DropdownMenuItem(
                            onTap: () => selectedServer.value = p.url,
                            value: p.url,
                            child: Text(p.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => ollamaServerService.selectServer(
                      ollamaServerService.ollamaServers.value.data
                          ?.where((p) => p.url == value)
                          .first,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a server';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 10),
                  child: IconButton.filledTonal(
                    icon: const Icon(Icons.add),
                    tooltip: 'Add a new server',
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return const AddServerDialog();
                        },
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
            )
        };
      },
    );
  }
}
