import 'package:flutter/material.dart';

class EachFormField extends StatefulWidget {
  const EachFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.textSize,
  });
  final String label;
  final TextEditingController controller;
  final double textSize;

  @override
  State<EachFormField> createState() => _EachFormFieldState();
}

class _EachFormFieldState extends State<EachFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: TextStyle(fontSize: widget.textSize)),
          SizedBox(height: 10),
          TextFormField(
            validator: (value) {
              if (value == "" || value == null) {
                return "Please enter some text";
              }
              return null;
            },
            controller: widget.controller,
            decoration: InputDecoration(
              errorStyle: TextStyle(
                color: Colors.redAccent,
                fontSize: widget.textSize - 2,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.redAccent, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.redAccent, width: 2),
              ),
              hintText: widget.label,
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
          ),
        ],
      ),
    );
  }
}
