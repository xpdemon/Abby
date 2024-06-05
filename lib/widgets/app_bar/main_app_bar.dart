import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/model_controller.dart';
import '../../util/theme.dart';
import '../ollama_model/model_info_view.dart';
import '../settings/settings_dialog.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ModelController>();

    return AppBar(
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0,
      title: Row(
        children: [
          Image.asset('assets/app_icons/abbylogo.png', width: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Abby',
              style: TextStyle(color: Colors.blueGrey.shade700),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: controller.currentModel,
            builder: (final context, currentModel, _) => currentModel != null
                ? Row(

                    children: [
                      Text(
                        currentModel.model ?? '/',
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                      IconButton(
                        tooltip: 'Show model infos',
                        onPressed: () => showDialog(
                          context: context,
                          builder: (final context) =>
                              ModelInfoView(model: currentModel),
                        ),
                        icon: const Icon(Icons.info),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
          IconButton(
            onPressed: Scaffold.of(context).openDrawer,
            icon: const Icon(Icons.psychology_sharp),
            tooltip: 'Switch or pull model',
          ),
          IconButton(
            onPressed: Scaffold.of(context).openEndDrawer,
            icon: const Icon(Icons.accessibility_new_outlined),
            tooltip: 'switch or create persona',
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Settings',
          onPressed: () => showDialog(
              context: context,
              builder: (final context) => const SettingsDialog()),
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }
}
