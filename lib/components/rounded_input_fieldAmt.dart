import 'package:flutter/material.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:competitive_exam_app/components/text_field_container.dart';

class RoundedInputFieldAmt extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> validator;
  final ValueNotifier<TextEditingValue> controllers;
  const RoundedInputFieldAmt({
    Key key,
    this.hintText,
    this.onChanged,
    this.controllers,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        controller: controllers,
        autofocus: true,
        showCursor: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
        validator: validator,
      ),
    );
  }
}
