import 'package:flutter/material.dart';
import 'package:link_text/link_text.dart';
import 'package:ollama_dart/ollama_dart.dart';
import 'package:provider/provider.dart';

import '../../async_result.dart';
import '../../controller/model_controller.dart';
import '../../services/ollama_server_service.dart';
import '../../widgets/ollama_model/add_model_dialog.dart';
import '../../widgets/ollama_server/add_server_dialog.dart';

class ErrorScreen extends StatelessWidget {
  final String msg;

  final VoidCallback errorAction;

  final IconData errorActionIcon;

  final String errorActionLabel;
  final Widget child;

  const ErrorScreen({
    super.key,
    required this.msg,
    required this.errorAction,
    required this.errorActionIcon,
    required this.errorActionLabel,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.warning, color: Colors.deepOrange),
                ),
                Center(
                  child: LinkText(msg),
                ),
              ],
            ),
            child,
            TextButton.icon(
              onPressed: errorAction,
              icon: Icon(errorActionIcon),
              label: Text(errorActionLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class NollamaScreen extends StatelessWidget {
  const NollamaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modelController = context.read<ModelController>();
    final ValueNotifier<String> selectedServer = ValueNotifier('');
    final OllamaServerService ollamaServerService =
        context.read<OllamaServerService>();
    final textTheme = Theme.of(context).textTheme;

    return ErrorScreen(
      msg:
          "Error : can't load models. Install and launch Ollama https://ollama.com/download ",
      errorAction: () => modelController
        ..changeClientUrl(ollamaServerService.currentServer.value!.url)
        ..loadModels(),
      errorActionLabel: 'Retry',
      errorActionIcon: Icons.refresh,
      child: ListenableBuilder(
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
                  IconButton.filledTonal(
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
      ),
    );
  }
}

class NoModelErrorScreen extends StatelessWidget {
  const NoModelErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modelController = context.read<ModelController>();

    return ErrorScreen(
      msg: '',
      errorAction: () async {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Provider(
            create: (context) => AddModelController(
              context.read(),
              onDownloadComplete: modelController.loadModels,
            ),
            child: AddModelDialog(),
          ),
        );
      },
      errorActionLabel: 'Pull a Model',
      errorActionIcon: Icons.download,
      child: const Text('No model available'),
    );
  }
}
