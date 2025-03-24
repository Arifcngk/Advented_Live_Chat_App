import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFieldCardWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final double cardHeight;
  final Color textColor;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  const CustomTextFieldCardWidget({
    Key? key,
    required this.controller,
    required this.hintText,
    this.cardHeight = 64,
    this.textColor = Colors.black,
    this.onTap,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
  }) : super(key: key);

  @override
  _CustomTextFieldCardWidgetState createState() =>
      _CustomTextFieldCardWidgetState();
}

class _CustomTextFieldCardWidgetState extends State<CustomTextFieldCardWidget> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.cardHeight,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFCED3DB), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                keyboardType: widget.keyboardType,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                    height: 16 / 12,
                    letterSpacing: 0,
                    color: widget.textColor,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: widget.textColor,
                ),
                onTap: widget.onTap,
              ),
            ),
            if (widget.obscureText) // Eğer şifre gizliyse
              GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
