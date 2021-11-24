import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify/services/analytics_events.dart';
import 'package:flutter_amplify/services/analytics_service.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  // 1
  final CameraDescription camera;
  // 2
  final ValueChanged didProvideImagePath;

  CameraScreen({Key? key, required this.camera, required this.didProvideImagePath})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // 3
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          // 4
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(this._controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      // 5
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera), onPressed: _takePicture),
    );
  }

  // 6
  void _takePicture() async {
    try {
      await _initializeControllerFuture;

      final tmpDirectory = await getTemporaryDirectory();
      final filePath = '${DateTime.now().millisecondsSinceEpoch}.png';
      final path = join(tmpDirectory.path, filePath);

      final picture = await _controller.takePicture();
      picture.saveTo( path );

      widget.didProvideImagePath(path);
      AnalyticsService.log( 
        TakePictureEvent( cameraDirection: widget.camera.lensDirection.toString() ) 
      );
    } catch (e) {
      print(e);
    }
  }

  // 7
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}