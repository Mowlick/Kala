import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/kala_colors.dart';

class KalaSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final double height;

  const KalaSearchBar({
    super.key,
    this.hintText = 'Search...',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon = const Icon(Icons.search, color: KalaColors.mediumGrey),
    this.suffixIcon,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Material(
        type: MaterialType.transparency,
        child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        style: GoogleFonts.inter(fontSize: 14, color: KalaColors.charcoal),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            color: KalaColors.mediumGrey,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          fillColor: Colors.white,
          filled: true,
          contentPadding: contentPadding,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(height / 2),
            borderSide: const BorderSide(
              color: KalaColors.softBeige,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(height / 2),
            borderSide: const BorderSide(
              color: KalaColors.softBeige,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(height / 2),
            borderSide: const BorderSide(
              color: KalaColors.burntOrange,
              width: 1.5,
            ),
          ),
          ),
        ),
      ),
    );
  }
}
