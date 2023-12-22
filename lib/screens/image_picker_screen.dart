import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/image_picker_widget.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class ImagePickerScreen extends StatefulWidget {
  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  late List<XFile?> selectedImages;

  @override
  void initState() {
    super.initState();
    selectedImages = List.generate(6, (index) => null);
  }

  bool hasNonNullImages() {
    return selectedImages.any((image) => image != null);
  }

  Future<void> uploadImages(List<XFile?> imageFiles) async {
    // Your API endpoint URL
    final String apiUrl = 'https://example.com/upload';

    // Create a MultipartRequest
    final http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Add image files to the request
    for (int i = 0; i < imageFiles.length; i++) {
      XFile imageFile = imageFiles[i]!;
      String fileName = basename(imageFile.path);
      request.files.add(
        await http.MultipartFile.fromPath(
          'images', // Field name for the image
          imageFile.path,
          contentType: MediaType('image',
              'jpeg'), // Adjust the content type based on your image type
          filename: fileName,
        ),
      );
    }

    try {
      // Send the request and get the response
      final http.Response response =
          await http.Response.fromStream(await request.send());

      // Check the response
      if (response.statusCode == 200) {
        // Successful upload
        print('Upload successful');
        print(response.body);
      } else {
        // Handle error
        print('Error during upload: ${response.statusCode}');
        print(response.body);
      }
    } catch (error) {
      // Handle other errors
      print('Error: $error');
    }
  }

  void sendData(data) {
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C1D),
      body: Container(
        margin: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 10.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: Text(
                "And, how good you look",
                softWrap: true,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.0,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                  ),
                  itemCount: selectedImages.length,
                  itemBuilder: (context, index) {
                    return ImagePickerWidget(
                        image: selectedImages[index],
                        updateImage: (newImage) {
                          setState(() {
                            selectedImages[index] = newImage;
                          });
                        });
                  }),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (hasNonNullImages()) {
                        sendData(selectedImages);
                      }
                    },
                    child: Text(
                      'Start getting matches',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 22.0),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasNonNullImages()
                          ? Color(0xFFDE2530)
                          : Color.fromARGB(255, 214, 65, 75),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.all(16.0),
                      textStyle: TextStyle(
                        fontSize: 18.0,
                      ),
                      elevation: 0, // Remove the default elevation
                      minimumSize: Size(double.infinity,
                          48.0), // Make the button take full width
                      side: BorderSide.none, // Remove the default border
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
