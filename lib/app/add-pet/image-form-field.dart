import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageFormField extends StatefulWidget {
  const ImageFormField({
    super.key,
    required this.selectedImage,
    required this.title,
    required this.isPictureError,
    required this.setSelectedImage,
    required this.width,
    required this.height,
  });

  final String title;
  final String? selectedImage;
  final bool isPictureError;
  final double width;
  final double height;

  final Function setSelectedImage;

  @override
  State<ImageFormField> createState() => _ImageFormFieldState();
}

class _ImageFormFieldState extends State<ImageFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color:
                  widget.isPictureError ? Colors.redAccent : Colors.grey[400]!,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.selectedImage == ""
                    ? Container(
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset("assets/images/gallery_icon.png"),
                      ),
                    )
                    : SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 30),
                                  clipBehavior: Clip.antiAlias,
                                  height: widget.height,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child:
                                      widget.selectedImage != null
                                          ? Image.network(
                                            widget.selectedImage!,
                                            alignment: Alignment.center,
                                            fit: BoxFit.cover,
                                          )
                                          : Image.asset(""),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: ImageIcon(
                        AssetImage("assets/images/picture_icon.png"),
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () async {
                        final returnedImage = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        if (returnedImage == null) return;
                        widget.setSelectedImage(returnedImage.path);
                      },
                      style: ElevatedButton.styleFrom(
                        overlayColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 66, 133, 244),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      icon: ImageIcon(
                        AssetImage("assets/images/camera_icon.png"),
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () async {
                        final returnedImage = await ImagePicker().pickImage(
                          source: ImageSource.camera,
                        );
                        if (returnedImage == null) return;
                        widget.setSelectedImage(returnedImage.path);
                      },
                      style: ElevatedButton.styleFrom(
                        overlayColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 66, 133, 244),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
