import 'package:flutter/material.dart';

class RoundedDropdownField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final List items;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> validator;
  const RoundedDropdownField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.validator,
    this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton(
        value: onChanged,
        // cursorColor: kPrimaryColor,
        hint: Text('$hintText'),
        dropdownColor: Colors.white,
        icon: Icon(Icons.arrow_circle_down),
        iconSize: 30,
        isExpanded: true,
        style: TextStyle(color: Colors.black, fontSize: 22),
        items: items,
      ),
    );
  }
}
