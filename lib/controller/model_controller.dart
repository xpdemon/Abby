import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:ollama_dart/ollama_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../async_result.dart';

class ModelController {
  final _log = Logger('ModelController');

  final SharedPreferences prefs;

  late  OllamaClient client;

  final ValueNotifier<Model?> currentModel = ValueNotifier(null);

  final ValueNotifier<AsyncData<List<Model>>> models =
      ValueNotifier(const Data([]));

  final ValueNotifier<AsyncData<ModelInfo?>> modelInfo =
      ValueNotifier(const Data(null));

  ModelController({
    required this.client,
    required this.prefs,
  });

  Future<void> init() async {
    await loadModels();
  }

  void changeClientUrl(String url){
    client = OllamaClient(baseUrl: '$url/api');
  }


  Future<void> loadModels() async {
    models.value = const Pending();
    try {
      final response = await client.listModels();

      if (response.models?.isNotEmpty ?? false) {
        models.value = Data(List.unmodifiable(response.models!));

        final prefs = await SharedPreferences.getInstance();

        if (prefs.containsKey('currentModel')) {
          final lastModel = prefs.getString('currentModel');
          if (lastModel != null) {
            selectModel(
              response.models!.firstWhere(
                (element) => element.model == lastModel,
                orElse: () => response.models!.first,
              ),
            );
          }
          return;
        }
        selectModel(response.models!.first);
      } else {
        models.value = const Data([]);
      }
    } catch (err, stackTrace) {
      _log.severe('ERROR !!! loadModels $err\n$stackTrace');
      models.value = const DataError('Models listing error :s');
    }
  }

  Future<void> loadModelInfo(final Model model) async {
    try {
      modelInfo.value = const Pending();

      final info = await client.showModelInfo(
        request: ModelInfoRequest(model: model.model!),
      );
      modelInfo.value = Data(info);
    } catch (err) {
      _log.severe('ERROR !!! loadModelInfo $err');
      modelInfo.value = const DataError('Model info error :s');
    }
  }

  Future<void> selectModel(final Model? model) async {
    if (model == null) return;

    if (model.model != null) {
      (await SharedPreferences.getInstance())
          .setString('currentModel', model.model!);
    }

    currentModel.value = model;
    loadModelInfo(model);
  }

  Future<void> selectModelNamed(final String modelName) async {
    final newModel = models.value.data?.firstWhereOrNull(
      (element) => element.model?.startsWith(modelName) ?? false,
    );

    if (newModel != null) await selectModel(newModel);
  }

  Future<void> deleteModel(Model model) async {
    final name = model.model;
    if (name != null) {
      final request = DeleteModelRequest(model: name);
      await client.deleteModel(request: request);

      await loadModels();
    }
  }

  ValueNotifier<double?> pullProgress = ValueNotifier(null);

  Future<void> updateModel(Model model) async {
    if (model.model == null) return;

    await _downloadModel(model.model!);
    loadModelInfo(model);
  }

  Future<void> _downloadModel(String name) async {
    pullProgress.value = 0;

    try {
      final streamResponse = client.pullModelStream(
        request: PullModelRequest(
          model: name,
          stream: true,
        ),
      );

      await for (final chunk in streamResponse) {
        _log.info(
          'OllamaController.updateModel... ${chunk.completed}/${chunk.total}',
        );
        pullProgress.value =
            chunk.total != null ? (chunk.completed ?? 0) / chunk.total! : 0;
      }

      pullProgress.value = null;
    } catch (err) {
      rethrow;
    }

    await loadModels();
  }
}
