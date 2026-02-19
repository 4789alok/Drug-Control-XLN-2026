import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String? text;
  final double? height;
  final double? width;
  final Decoration? decoration;
  final TextStyle? textStyle;
  final Color color;
  final VoidCallback onTap;
  final bool isLoading;
  const RoundButton({
    Key? key,
    required this.text,
    this.height = 30,
    this.width = 60,
    this.decoration,
    this.color = Colors.purple,
    required this.onTap,
    this.isLoading = false,
    this.textStyle,
    CircularProgressIndicator? child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          )
        : InkWell(
            onTap: onTap,
            child: Container(
              height: height,
              width: width,
              decoration: decoration,
              child: Center(
                child: Text(text!, style: textStyle),
              ),
            ),
          );
  }
}
