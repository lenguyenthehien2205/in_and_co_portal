import 'package:flutter/material.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class TextFieldCustom extends StatelessWidget {
  final String label;
  final String hintText;
  final Function(String)? onChanged;
  const TextFieldCustom({
    super.key,
    this.label = '',
    this.hintText = '',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.smallTitle(context)),
        SizedBox(height: 5),
        TextFormField(
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder( 
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder( 
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 1.5),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always, 
          ),
          onChanged: onChanged,
        ),
        SizedBox(height: 5),
      ],
    );
  }
}