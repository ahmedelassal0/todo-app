import 'package:flutter/material.dart';

Widget regularButton({
  double width = double.infinity,
  Color color = Colors.blue,
  required VoidCallback function,
  required String text,
}) {
  return Container(
    width: width,
    color: color,
    child: MaterialButton(
      onPressed: function,
      child: Text(
        '${text.toUpperCase()}',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
    ),
  );
}

Widget regularTextFormField({
  required controller,
  var keyboardType,
  required String text,
  required IconData icon,
  var validator,
  IconData? suffix,
  bool isPassword = false,
  var suffixPress,
  var onTap,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType != null ? keyboardType : null,
    decoration: InputDecoration(
      labelText: '$text',
      border: OutlineInputBorder(),
      prefixIcon: Icon(
        icon,
      ),
      suffixIcon: suffix != null
          ? IconButton(
              icon: Icon(suffix),
              onPressed: suffixPress,
            )
          : null,
    ),
    validator: validator,
    obscureText: isPassword,
    onTap: onTap,
  );
}
