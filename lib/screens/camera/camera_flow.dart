import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify/screens/camera/camera_screen.dart';
import 'package:flutter_amplify/screens/camera/gallery_screen.dart';
import 'package:flutter_amplify/services/storage_service.dart';

class CameraFlow extends StatefulWidget {
  final VoidCallback shouldLogout;

  CameraFlow({Key? key, required this.shouldLogout,}) : super(key: key);

  @override
  _CameraFlowState createState() => _CameraFlowState();
}

class _CameraFlowState extends State<CameraFlow> {
  late CameraDescription _camera;
  bool _shouldShowCamera = false;
  late StorageService _storageService;

  List<MaterialPage> get _pages => [
    MaterialPage( 
      child: GalleryScreen(
        imageUrlsController: _storageService.imageUrlsController,
        shouldLogOut: widget.shouldLogout,
        shouldShowCamera: () => _toggleCameraOpen( true ),
      ),
    ),
    if( _shouldShowCamera )
      MaterialPage( 
        child: CameraScreen(
          camera: _camera,
          didProvideImagePath: (imagePath) {
            this._toggleCameraOpen( false );
            log( imagePath );
            this._storageService.uploadImageAtPath( imagePath );
          },
        )
      ),
  ];

  @override
  void initState() {
    super.initState();
    _getCamera();
    _storageService = StorageService();
    _storageService.getImages();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: _pages,
      onPopPage: (route, result) => route.didPop( result ),
    );
  }

  void _toggleCameraOpen( bool isOpen ) {
    setState(() {
      this._shouldShowCamera = isOpen;
    });
  }

  void _getCamera() async {
    final camerasList = await availableCameras();
    setState(() {
      final firstCamera = camerasList.first;
      this._camera = firstCamera;
    });
  }
}