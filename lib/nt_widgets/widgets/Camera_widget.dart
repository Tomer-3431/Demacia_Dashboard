import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demacia_dashboard/nt_widgets/widgets/nt_widget.dart';

class CameraWidget extends NtWidget {
  final String? initialUrl;

  const CameraWidget({
    super.key,
    required int id,
    required super.size,
    required super.title,
    this.initialUrl,
    super.topic,
  });

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  String _streamUrl = '';
  bool _isConnected = false;
  bool _showSettings = false;
  String _error = '';
  int _fps = 0;

  StreamController<Uint8List>? _streamController;
  StreamSubscription? _streamSubscription;
  Timer? _fpsTimer;
  int _frameCount = 0;

  final TextEditingController _urlController = TextEditingController();

  // Common FRC camera URLs - these will be populated with team number
  List<Map<String, String>> _presetUrls = [];

  @override
  void initState() {
    super.initState();
    _initializeUrls();
    _loadSettings();
    _startFpsCounter();
  }

  void _initializeUrls() {
    _presetUrls = [
      {
        'name': 'RoboRIO Camera (1181)',
        'url': 'http://roborio-5635-frc.local:1181/stream.mjpg'
      },
      {
        'name': 'RoboRIO Camera (1182)',
        'url': 'http://roborio-5635-frc.local:1182/stream.mjpg'
      },
      {
        'name': 'Static IP Camera (1181)',
        'url': 'http://10.56.35.11:1181/stream.mjpg'
      },
      {
        'name': 'Static IP Camera (1182)',
        'url': 'http://10.56.35.11:1182/stream.mjpg'
      },
    ];
  }

  Future<void> _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedUrl = prefs.getString('camera_${widget.hashCode}_url') ??
        widget.initialUrl ??
        'http://roborio-5635-frc.local:1181/stream.mjpg';

    setState(() {
      _streamUrl = savedUrl;
      _urlController.text = savedUrl;
    });

    // Auto-connect to saved URL
    if (savedUrl.isNotEmpty &&
        savedUrl != 'http://roborio-5635-frc.local:1181/stream.mjpg') {
      _connectToStream(savedUrl);
    }
  }

  Future<void> _saveSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('camera_${widget.hashCode}_url', _streamUrl);
  }

  @override
  void dispose() {
    _disconnectStream();
    _fpsTimer?.cancel();
    _urlController.dispose();
    super.dispose();
  }

  void _startFpsCounter() {
    _fpsTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _fps = _frameCount;
          _frameCount = 0;
        });
      }
    });
  }

  Future<void> _connectToStream(String url) async {
    _disconnectStream();

    setState(() {
      _streamUrl = url;
      _error = '';
      _isConnected = false;
    });

    _saveSettings();

    try {
      _streamController = StreamController<Uint8List>();

      final request = http.Request('GET', Uri.parse(url));
      request.headers['Connection'] = 'keep-alive';
      final response = await request.send();

      if (response.statusCode == 200) {
        setState(() {
          _isConnected = true;
        });

        _streamSubscription = response.stream.listen(
          (data) {
            _processMJPEGData(data);
          },
          onError: (error) {
            if (mounted) {
              setState(() {
                _error = 'Stream error: $error';
                _isConnected = false;
              });
            }
          },
          onDone: () {
            if (mounted) {
              setState(() {
                _isConnected = false;
              });
            }
          },
        );
      } else {
        setState(() {
          _error = 'HTTP ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Connection failed';
        _isConnected = false;
      });
    }
  }

  List<int> _buffer = [];
  void _processMJPEGData(List<int> data) {
    _buffer.addAll(data);

    const startMarker = [0xFF, 0xD8];
    const endMarker = [0xFF, 0xD9];

    int startIndex = -1;
    int endIndex = -1;

    for (int i = 0; i < _buffer.length - 1; i++) {
      if (_buffer[i] == startMarker[0] && _buffer[i + 1] == startMarker[1]) {
        startIndex = i;
        break;
      }
    }

    if (startIndex == -1) return;

    for (int i = startIndex + 2; i < _buffer.length - 1; i++) {
      if (_buffer[i] == endMarker[0] && _buffer[i + 1] == endMarker[1]) {
        endIndex = i + 2;
        break;
      }
    }

    if (endIndex == -1) return;

    final frameData = Uint8List.fromList(_buffer.sublist(startIndex, endIndex));
    _streamController?.add(frameData);
    _frameCount++;

    _buffer = _buffer.sublist(endIndex);
  }

  void _disconnectStream() {
    _streamSubscription?.cancel();
    _streamController?.close();
    _streamController = null;
    _streamSubscription = null;
  }

  void _refreshStream() {
    if (_streamUrl.isNotEmpty) {
      _connectToStream(_streamUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size * 3, // 3 grid units wide
      height: widget.size * 2, // 2 grid units tall
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: Colors.deepPurple, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: const BoxDecoration(
              color: Color(0xFF2A2A2A),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _isConnected ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_isConnected) ...[
                  Text(
                    '$_fps FPS',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                GestureDetector(
                  onTap: _refreshStream,
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white70,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showSettings = !_showSettings;
                    });
                  },
                  child: const Icon(
                    Icons.settings,
                    color: Colors.white70,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),

          // Settings Panel
          if (_showSettings)
            Container(
              padding: const EdgeInsets.all(8),
              color: const Color(0xFF2A2A2A),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Stream URL',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 24,
                          child: TextField(
                            controller: _urlController,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                            decoration: const InputDecoration(
                              hintText:
                                  'http://roborio-5635-frc.local:1181/stream.mjpg',
                              hintStyle: TextStyle(
                                  color: Colors.white38, fontSize: 10),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 0),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white38),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      SizedBox(
                        height: 24,
                        child: ElevatedButton(
                          onPressed: () {
                            _connectToStream(_urlController.text);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: const Text(
                            'Connect',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...(_presetUrls.map(
                    (preset) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: SizedBox(
                        width: double.infinity,
                        height: 20,
                        child: TextButton(
                          onPressed: () {
                            _urlController.text = preset['url']!;
                            _connectToStream(preset['url']!);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFF3A3A3A),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                          child: Text(
                            preset['name']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),

          // Camera Stream Display
          Expanded(
            child: Container(
              color: Colors.black,
              child: _buildStreamDisplay(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreamDisplay() {
    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              _error,
              style: const TextStyle(color: Colors.red, fontSize: 10),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _refreshStream,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      );
    }

    if (!_isConnected) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Connecting...',
              style: TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        ),
      );
    }

    if (_streamController == null) {
      return const Center(
        child: Text(
          'No stream',
          style: TextStyle(color: Colors.white70, fontSize: 10),
        ),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(6),
        bottomRight: Radius.circular(6),
      ),
      child: StreamBuilder<Uint8List>(
        stream: _streamController!.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data!,
              fit: BoxFit.contain,
              gaplessPlayback: true,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.red,
                    size: 24,
                  ),
                );
              },
            );
          }
          return const Center(
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.deepPurple,
              ),
            ),
          );
        },
      ),
    );
  }
}
