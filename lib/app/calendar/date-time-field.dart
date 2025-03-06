import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateTimeField extends StatefulWidget {
  const DateTimeField({
    super.key,
    required this.dateController,
    required this.timeController,
    required this.fontSize,
    required this.needTime,
  });

  final bool needTime;
  final double fontSize;
  final TextEditingController dateController;
  final TextEditingController timeController;

  @override
  State<DateTimeField> createState() => _DateTimeFieldState();
}

class _DateTimeFieldState extends State<DateTimeField> {
  DateTime time = DateTime.now();
  FocusNode _focusTime = FocusNode();
  bool showTimeSelect = false;

  @override
  void initState() {
    super.initState();
    _focusTime.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusTime.hasFocus) {
      setState(() {
        showTimeSelect = true;
      });
    } else {
      setState(() {
        showTimeSelect = false;
      });
    }
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (_picked != null) {
      setState(() {
        widget.dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Date", style: TextStyle(fontSize: widget.fontSize)),
                  SizedBox(height: 10),
                  TextFormField(
                    readOnly: true,
                    onTap: () {
                      _selectDate();
                    },
                    controller: widget.dateController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      prefixIcon: Icon(Icons.calendar_today),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[400] ?? Colors.grey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue[400] ?? Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: widget.needTime ? 20 : 0),
            widget.needTime
                ? Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Time", style: TextStyle(fontSize: widget.fontSize)),
                      SizedBox(height: 10),
                      TextFormField(
                        readOnly: true,
                        onTap: () {
                          setState(() {
                            showTimeSelect = !showTimeSelect;
                          });
                        },
                        focusNode: _focusTime,
                        controller: widget.timeController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          prefixIcon: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: ImageIcon(
                              AssetImage("assets/images/clock-icon.png"),
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[400] ?? Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue[400] ?? Colors.blue,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : Container(),
          ],
        ),
        SizedBox(height: 10),
        showTimeSelect
            ? SizedBox(
              height: 150,
              child: CupertinoDatePicker(
                initialDateTime: time,
                mode: CupertinoDatePickerMode.time,
                onDateTimeChanged: (dateTime) {
                  setState(() => time = dateTime);
                  widget.timeController.text =
                      "${dateTime.hour}:${dateTime.minute < 10 ? "0" : ""}${dateTime.minute}";
                },
              ),
            )
            : Container(),
      ],
    );
  }
}
