import 'package:flutter/material.dart';

import '../../util/theme.dart';
import '../ollama_server/add_server_form.dart';
import '../server/server_dropdown.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

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
                  'Settings',
                  style: textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(height: 18),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  Text(
                    'Server connection',
                    style: textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            const Divider(height: 8),
            const Row(
              children: [
                ServerDropdown(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  Text(
                    'Theme',
                    style: textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            const Divider(height: 8),
            const Row(
              children: [
                ThemeButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
