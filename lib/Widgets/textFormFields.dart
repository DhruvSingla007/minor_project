import 'package:flutter/material.dart';

Widget buildTextFormsField({String errorMessage, String hintText, TextEditingController editingController, Icon preIcon, String initialValue}){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      initialValue: initialValue,
      validator: (value) {
        if (value.isEmpty) {
          return errorMessage;
        }
        return null;
      },
      controller: editingController,
      decoration: InputDecoration(
        prefixIcon: preIcon,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    ),
  );
}