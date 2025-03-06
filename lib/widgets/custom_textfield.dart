import 'package:flutter/material.dart';
import 'package:in_and_co_portal/core/utils/validator.dart';

class CustomTextfield extends StatefulWidget{
  final String hintText;
  final bool isPassword;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextEditingController controller;

  const CustomTextfield({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.onChanged,
    this.onSubmitted,
    required this.controller
  });

  @override
  _CustomTextfieldState createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield>{
  bool _isObscure = true;

  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose(); // Giải phóng bộ nhớ khi không dùng nữa
    super.dispose();
  }

  @override
  Widget build(context){
    return SizedBox(
      height: 60,
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _isObscure : false,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide.none
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 35),
          errorStyle: const TextStyle(fontSize: 12, height: 0.7),
          suffixIcon: widget.isPassword ? IconButton(
            icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
            onPressed: (){
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          ) : null,
        ),
        validator: widget.isPassword
            ? Validator.validatePassword
            : Validator.validateEmail,
      )
    );
  }
}