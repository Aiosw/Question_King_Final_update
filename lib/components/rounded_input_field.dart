import 'package:flutter/material.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:competitive_exam_app/components/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> validator;
  final ValueNotifier<TextEditingValue> controllers;
  final int maxleng;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
    this.controllers,
    this.validator,
    this.maxleng,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        enableSuggestions: true,
        //  maxLengthEnforced: false,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        controller: controllers,
        maxLength: maxleng,
        autofocus: true,
        showCursor: true,
        decoration: InputDecoration(
          // fillColor: Colors.white54,
          // counter: SizedBox.shrink(),
          counterStyle: TextStyle(
            height: double.minPositive,
          ),
          counter: Offstage(),
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
        validator: validator,
      ),
    );
  }
}
