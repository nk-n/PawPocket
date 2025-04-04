import 'package:flutter/material.dart';

class MultipleLineTextFormField extends StatelessWidget {
  const MultipleLineTextFormField({
    super.key,
    required this.descController,
    required this.title,
    required this.textSize,
  });
  final TextEditingController descController;
  final String title;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == "" || value == null) {
          return "Please enter some text";
        }
        return null;
      },
      controller: descController,
      keyboardType: TextInputType.multiline,
      minLines: 5,
      maxLines: null,
      decoration: InputDecoration(
        errorStyle: TextStyle(color: Colors.redAccent, fontSize: textSize - 2),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.redAccent, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.redAccent, width: 2),
        ),
        hintText: title,
        hintStyle: TextStyle(color: Colors.grey[400]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[400] ?? Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue[600] ?? Colors.blue,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
