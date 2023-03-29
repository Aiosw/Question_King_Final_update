import 'package:flutter/material.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:competitive_exam_app/components/text_field_container.dart';

class roundedPasswordField extends StatelessWidget {
  bool obSecure = true;
  Icon icon = Icon(Icons.visibility);
  final ValueChanged<String> onChanged;
  final ValueChanged<String> validator;
  final ValueChanged<String> onpress;
  roundedPasswordField({
    Key key,
    this.onChanged,
    this.validator,
    this.onpress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: obSecure,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          // suffixIcon: Icon(
          //   Icons.visibility,
          //   color: kPrimaryColor,
          // ),
          suffixIcon: IconButton(
              onPressed: () {
                
              },
              icon: icon),
        ),
        validator: validator,
      ),
    );
  }

}
