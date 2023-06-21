import 'package:flutter/material.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  required VoidCallback function,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
      child:  MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  void Function(String)? onSubmit,
  void Function(String)? onChange,
  VoidCallback? onTap,
  bool isPassword = false,
  required String? Function(String?) validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  VoidCallback? suffixPressed,
  bool isClickable = true,

}) =>
    TextFormField(
      enabled: isClickable,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null ? IconButton(
               onPressed: suffixPressed,
                 icon: Icon(
                  suffix,
                 ),
        ) : null,
        border: const OutlineInputBorder(),
      ),
    );


Widget buildTaskItem(tasks)=>Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children: [
       CircleAvatar(
        radius: 40.0,
        child: Text('${tasks['time']}'),
      ),
      const SizedBox(
        width: 20.0,
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           Text(
            '${tasks['title']}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
           Text(
            '${tasks['date']}',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    ],
  ),
);