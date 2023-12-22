import 'dart:io'; // Import the 'File' class from dart:io
import 'dart:ui'; // Import the 'File' class from dart:io

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  final ImagePicker _imagePicker = ImagePicker();
  final XFile? image;
  final Function(XFile?) updateImage;

  ImagePickerWidget({required this.image, required this.updateImage});

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedImage = await _imagePicker.pickImage(source: source);
      if (pickedImage != null) {
        updateImage(pickedImage);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _showImageOptions(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 220,
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.transparent, // Transparent background
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0), bottom: Radius.circular(20.0)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 10.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(
                      0.2), // Semi-transparent white color for glassmorphism effect
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          Text(
                            'Upload your picture',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Make sure your face is visible in the picture.',
                            style: TextStyle(
                                color: Color(0x7F7F7F80),
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1.0,
                      color: Colors.white10,
                    ),
                    ListTile(
                      title: Text(
                        'Take a picture',
                        style: TextStyle(
                            color: Color(0xFF0A84FF),
                            fontWeight: FontWeight.w400,
                            fontSize: 17.0),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.pop(context); // Close the modal
                        _pickImage(ImageSource.camera); // Open the gallery
                      },
                    ),
                    Container(
                      height: 1.0,
                      color: Colors.white10,
                    ),
                    ListTile(
                      title: Text(
                        'Upload from your camera roll',
                        style: TextStyle(
                            color: Color(0xFF0A84FF),
                            fontWeight: FontWeight.w400,
                            fontSize: 17.0),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.pop(context); // Close the modal
                        _pickImage(ImageSource.gallery); // Open the camera
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showImageReplaceOptions(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 220,
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.transparent, // Transparent background
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0), bottom: Radius.circular(20.0)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(
                      0.2), // Semi-transparent white color for glassmorphism effect
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          Text(
                            'Replace Picture',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Replace or delete picture from your profile',
                            style: TextStyle(
                                color: Color(0x7F7F7F80),
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1.0,
                      color: Colors.white10,
                    ),
                    ListTile(
                      title: Text(
                        'Replace Picture',
                        style: TextStyle(
                            color: Color(0xFF0A84FF),
                            fontWeight: FontWeight.w400,
                            fontSize: 17.0),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.pop(context); // Close the modal
                        _pickImage(ImageSource.gallery); // Open the gallery
                      },
                    ),
                    Container(
                      height: 1.0,
                      color: Colors.white10,
                    ),
                    ListTile(
                      title: Text(
                        'Delete Image',
                        style: TextStyle(
                            color: Color(0xFFFF453A),
                            fontWeight: FontWeight.w400,
                            fontSize: 17.0),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.pop(context); // Close the modal
                        updateImage(null); // Open the camera
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (image == null) {
          _showImageOptions(context);
        } else {
          _showImageReplaceOptions(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white, // Border color
            width: 2.0, // Border width
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: image == null
            ? Center(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white, // Border color
                      width: 2.0, // Border width
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 40.0,
                    color: Colors.white,
                  ),
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.file(
                  File(image!.path),
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
