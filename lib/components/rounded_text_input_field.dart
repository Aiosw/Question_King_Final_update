
import 'package:flutter/material.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:competitive_exam_app/components/text_field_container.dart';

class RoundedTextInputField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> validator;
  final ValueNotifier<TextEditingValue> controllers;
  final int maxleng;
  const RoundedTextInputField({
    Key key,
    this.hintText,
     this.onChanged,
    this.controllers,
    this.validator,
    this.maxleng,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        controller: controllers,
        maxLength: maxleng,
        autofocus: true,
        showCursor: true,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
        validator: validator,
      ),
    );
  }
}
