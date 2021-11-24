import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify/services/analytics_events.dart';
import 'package:flutter_amplify/services/analytics_service.dart';

class GalleryScreen extends StatefulWidget {
  final StreamController<List<String>> imageUrlsController;
  final VoidCallback shouldLogOut;
  final VoidCallback shouldShowCamera;

  const GalleryScreen({
    Key? key,
    required this.imageUrlsController,
    required this.shouldLogOut, 
    required this.shouldShowCamera
  }) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.log( ViewGalleryEvent() );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( 'Galería' ),
        actions: [
          IconButton(
            onPressed: widget.shouldLogOut,
            icon: Icon( Icons.logout ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.shouldShowCamera,
        child: Icon( Icons.camera_alt ),
      ),
      body: Container(
        child: _galleryGrid(),
      ),
    );
  }

  Widget _galleryGrid() {
    return StreamBuilder<List<String>>(
      stream: widget.imageUrlsController.stream,
      builder: (context, snapshot) {
        if( snapshot.hasData ) {
          if( snapshot.data!.length > 0 ) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: ( context, index ) => CachedNetworkImage(
                imageUrl: snapshot.data![index],
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else {
            return Center( child: Text( 'No hay imágenes para mostrar.' ), );
          }
        } else {
          return Center( child: CircularProgressIndicator() );
        }
      }
    );
  }
}