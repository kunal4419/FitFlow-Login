import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../models/exercise.dart';
import '../services/video_cache_service.dart';

/// Hybrid video player that plays from cache if available, otherwise streams and downloads
class HybridVideoPlayer extends StatefulWidget {
  final Exercise exercise;

  const HybridVideoPlayer({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  State<HybridVideoPlayer> createState() => _HybridVideoPlayerState();
}

class _HybridVideoPlayerState extends State<HybridVideoPlayer> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  final VideoCacheService _cacheService = VideoCacheService();
  
  bool _isLoading = true;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _errorMessage;
  bool _isPlayingFromCache = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  /// Initialize the video player with hybrid logic
  Future<void> _initializePlayer() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Check if video is cached locally
      final cachedVideo = await _cacheService.getCachedVideo(widget.exercise.localFileName);

      if (cachedVideo != null) {
        // Play from cache
        await _initializeFromFile(cachedVideo);
        setState(() {
          _isPlayingFromCache = true;
        });
      } else {
        // Stream from network and download in background
        await _initializeFromNetwork();
        _downloadInBackground();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load video: $e';
        _isLoading = false;
      });
    }
  }

  /// Initialize video player from local file
  Future<void> _initializeFromFile(File file) async {
    _videoPlayerController = VideoPlayerController.file(file);
    await _setupChewieController();
  }

  /// Initialize video player from network URL
  Future<void> _initializeFromNetwork() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.exercise.videoUrl),
    );
    await _setupChewieController();
  }

  /// Setup Chewie controller with video player
  Future<void> _setupChewieController() async {
    try {
      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: true,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        autoInitialize: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFF6366F1),
          handleColor: const Color(0xFF6366F1),
          backgroundColor: Colors.grey.shade800,
          bufferedColor: Colors.grey.shade700,
        ),
        placeholder: Container(
          color: const Color(0xFF111111),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
            ),
          ),
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize video: $e';
        _isLoading = false;
      });
    }
  }

  /// Download video in background for future offline use
  Future<void> _downloadInBackground() async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    final file = await _cacheService.downloadAndCacheVideo(
      url: widget.exercise.videoUrl,
      fileName: widget.exercise.localFileName,
      onProgress: (progress) {
        if (mounted) {
          setState(() {
            _downloadProgress = progress;
          });
        }
      },
    );

    if (mounted) {
      setState(() {
        _isDownloading = false;
      });

      if (file != null) {
        // Video successfully cached
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Video saved for offline viewing'),
            duration: Duration(seconds: 2),
            backgroundColor: Color(0xFF6366F1),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.exercise.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_isPlayingFromCache)
              const Text(
                'Playing from cache',
                style: TextStyle(
                  color: Color(0xFF6366F1),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
        actions: [
          if (_isDownloading)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    value: _downloadProgress,
                    strokeWidth: 2,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
            ),
            SizedBox(height: 16),
            Text(
              'Loading video...',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _initializePlayer,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Player
          if (_chewieController != null)
            AspectRatio(
              aspectRatio: _videoPlayerController!.value.aspectRatio,
              child: Chewie(controller: _chewieController!),
            ),

          // Exercise Information
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                if (widget.exercise.description.isNotEmpty) ...[
                  Text(
                    widget.exercise.description,
                    style: const TextStyle(
                      color: Color(0xFFa1a1aa),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Sets and Reps
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        'Sets',
                        widget.exercise.sets,
                        Icons.repeat_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoCard(
                        'Reps',
                        widget.exercise.reps,
                        Icons.fitness_center_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Target Muscles
                if (widget.exercise.targetMuscles.isNotEmpty) ...[
                  const Text(
                    'Target Muscles',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.exercise.targetMuscles.map((muscle) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF6366F1).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          muscle,
                          style: const TextStyle(
                            color: Color(0xFF6366F1),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                // Exercise Tips
                if (widget.exercise.exerciseTips.isNotEmpty) ...[
                  const Text(
                    'Exercise Tips',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...widget.exercise.exerciseTips.map((tip) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 6.0),
                            child: Icon(
                              Icons.check_circle,
                              color: Color(0xFF6366F1),
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              tip,
                              style: const TextStyle(
                                color: Color(0xFFa1a1aa),
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF18181b),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6366F1), size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFa1a1aa),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
