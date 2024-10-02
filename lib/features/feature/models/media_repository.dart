import 'package:mvvm_test/features/feature/models/media.dart';
import 'package:mvvm_test/features/feature/models/services/base_service.dart';
import 'package:mvvm_test/features/feature/models/services/media_service.dart';

class MediaRepository {
  final BaseService _mediaService = MediaService();

  Future<List<Media>> fetchMediaList(String value) async {
    dynamic response = await _mediaService.getResponse(value);
    final jsonData = response['results'] as List;
    List<Media> mediaList =
        jsonData.map((tagJson) => Media.fromJson(tagJson)).toList();
    return mediaList;
  }
}