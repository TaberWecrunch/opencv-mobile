import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:opencv_4/factory/pathfrom.dart';
import 'package:opencv_4/opencv_4.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _imageFile;
  img.Image? _originalImage;
  Uint8List? _filteredImage;
  var pickedFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _originalImage = img.decodeImage(_imageFile!.readAsBytesSync());
      });
    }
  }

  void _applyFilter() async {
    if (_originalImage == null) return;

    // Apply a simple grayscale filter
    _filteredImage = await Cv2.filter2D(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: pickedFile.path,
      outputDepth: -1,
      kernelSize: [2, 2],
    );

    setState(() {
      _filteredImage;
    });

    setState(() {
      _filteredImage;
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _imageFile != null
                  ? InkWell(onTap: _pickImage, child: Image.file(_imageFile!))
                  : ElevatedButton(
                      onPressed: _pickImage, child: const Icon(Icons.image)),
            ),
          ),
          ElevatedButton(
            onPressed: _applyFilter,
            child: const Text('Apply Filter'),
          ),
          Expanded(
            child: Center(
              child: _filteredImage != null
                  ? Image.memory(_filteredImage!)
                  : const Text('Apply the filter to see the result.'),
            ),
          ),
        ],
      ),
    );
  }
}
