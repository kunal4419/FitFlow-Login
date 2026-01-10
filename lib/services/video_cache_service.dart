import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

/// Service for managing video caching and downloads
class VideoCacheService {
  static final VideoCacheService _instance = VideoCacheService._internal();
  factory VideoCacheService() => _instance;
  VideoCacheService._internal();

  /// Directory where cached videos are stored
  Directory? _cacheDirectory;

  /// Initialize the cache directory
  Future<void> initialize() async {
    if (_cacheDirectory == null) {
      final directory = await getApplicationDocumentsDirectory();
      _cacheDirectory = Directory('${directory.path}/exercise_videos');
      
      // Create directory if it doesn't exist
      if (!await _cacheDirectory!.exists()) {
        await _cacheDirectory!.create(recursive: true);
      }
    }
  }

  /// Get the full path for a local video file
  Future<String> _getLocalPath(String fileName) async {
    await initialize();
    return '${_cacheDirectory!.path}/$fileName';
  }

  /// Check if a video exists in local cache
  Future<bool> isVideoCached(String fileName) async {
    final path = await _getLocalPath(fileName);
    return File(path).exists();
  }

  /// Get the local file path if cached, null otherwise
  Future<File?> getCachedVideo(String fileName) async {
    final path = await _getLocalPath(fileName);
    final file = File(path);
    
    if (await file.exists()) {
      return file;
    }
    return null;
  }

  /// Download video from URL and save to cache
  /// Returns the local file path on success, null on failure
  Future<File?> downloadAndCacheVideo({
    required String url,
    required String fileName,
    Function(double progress)? onProgress,
  }) async {
    try {
      final path = await _getLocalPath(fileName);
      final file = File(path);

      // If already cached, return it
      if (await file.exists()) {
        return file;
      }

      // Download the video
      final request = http.Request('GET', Uri.parse(url));
      final streamedResponse = await request.send();

      if (streamedResponse.statusCode != 200) {
        throw Exception('Failed to download video: ${streamedResponse.statusCode}');
      }

      final contentLength = streamedResponse.contentLength ?? 0;
      var downloadedBytes = 0;

      final sink = file.openWrite();
      
      await streamedResponse.stream.map((chunk) {
        downloadedBytes += chunk.length;
        
        // Report progress
        if (onProgress != null && contentLength > 0) {
          final progress = downloadedBytes / contentLength;
          onProgress(progress);
        }
        
        return chunk;
      }).pipe(sink);

      await sink.close();

      return file;
    } catch (e) {
      print('Error downloading video: $e');
      return null;
    }
  }

  /// Delete a cached video
  Future<bool> deleteCachedVideo(String fileName) async {
    try {
      final path = await _getLocalPath(fileName);
      final file = File(path);
      
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting cached video: $e');
      return false;
    }
  }

  /// Clear all cached videos
  Future<void> clearAllCache() async {
    await initialize();
    
    if (await _cacheDirectory!.exists()) {
      await _cacheDirectory!.delete(recursive: true);
      await _cacheDirectory!.create(recursive: true);
    }
  }

  /// Get total size of cached videos in bytes
  Future<int> getCacheSize() async {
    await initialize();
    
    if (!await _cacheDirectory!.exists()) {
      return 0;
    }

    int totalSize = 0;
    await for (final entity in _cacheDirectory!.list(recursive: true)) {
      if (entity is File) {
        totalSize += await entity.length();
      }
    }
    
    return totalSize;
  }

  /// Get cache directory path
  Future<String> getCacheDirectoryPath() async {
    await initialize();
    return _cacheDirectory!.path;
  }
}
