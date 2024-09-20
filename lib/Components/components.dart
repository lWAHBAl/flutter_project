import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/cubit/app_cubit.dart';
import 'package:flutter_project/cubit/app_states.dart';
import 'package:photo_view/photo_view.dart';

class SideNavigationBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback fun;
  final bool isSelected;

  const SideNavigationBarItem({
    super.key,
    required this.fun,
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: fun,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle, // Makes the container circular
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  blurRadius: 5.0,
                  spreadRadius: 2.0,
                  offset: const Offset(0, 3), // Adds shadow effect
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                color: isSelected ? Colors.green : Colors.grey,
                size: 30, // Size of the icon
              ),
            ),
          ),
        ),
        const SizedBox(height: 8), // Spacing between the button and label
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }
}

class DefaultTextField extends StatelessWidget {
  DefaultTextField({
    super.key,
    required this.type,
    required this.label,
    required this.controller,
    this.textInputAction = TextInputAction.next,
    required this.errStr,
    this.enabled = true,
    this.isPassword = false,
    this.onChanged,
    this.onSubmit,
    this.suffixIcon,
    this.maxLength,
    this.maxLines,
    this.height,
    this.textAlign,
  });
  TextInputType? type;
  TextEditingController controller;
  String label;
  String errStr;
  TextInputAction textInputAction;
  Widget? suffixIcon;
  bool isPassword;
  bool enabled;
  int? maxLength;

  int? maxLines;
  void Function(String)? onSubmit;
  void Function(String)? onChanged;
  TextAlign? textAlign;
  double? height;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, Appstates>(builder: (context, state) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: TextFormField(
          onFieldSubmitted: onSubmit,
          enabled: enabled,
          textAlign: textAlign ?? TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          maxLength: maxLength,
          keyboardType: type,
          controller: controller,
          maxLines: maxLines ?? 1,
          onChanged: onChanged,
          validator: (value) {
            if (value!.isEmpty) {
              return '$errStr is required';
            }
            return null;
          },
          obscureText: isPassword,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsetsDirectional.symmetric(
              horizontal: 12.0,
              vertical: height ?? 12,
            ),
            hintText: (label),
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            suffixIcon: suffixIcon,
            border: InputBorder.none,
          ),
        ),
      );
    });
  }
}

class FullScreenImageViewer extends StatelessWidget {
  String? imageUrl;
  File? img;
  final bool type;
  FullScreenImageViewer(this.imageUrl, this.img,
      {super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32.0),
            Expanded(
              child: type
                  ? PhotoView(
                      imageProvider: NetworkImage(
                        imageUrl!,
                      ),
                    )
                  : Image.file(img!),
            ),
          ],
        ),
      ),
    );
  }

  static void showFullImage(BuildContext context, String? imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FullScreenImageViewer(imageUrl!, null, type: true),
      ),
    );
  }

  static void showFullImage2(BuildContext context, File? img) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer("", img, type: false),
      ),
    );
  }
}
