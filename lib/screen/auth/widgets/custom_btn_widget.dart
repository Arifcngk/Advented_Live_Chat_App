import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButtonWidget extends StatelessWidget {
  final String txt;
  final String imgPath;
  final Color txtColor;
  final Color cardColor;
  const CustomButtonWidget({
    super.key,
    required this.txt,
    required this.imgPath,
    required this.txtColor,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Tam genişlik
      height: 50,
      decoration: BoxDecoration(
        color: cardColor, // Google tarzı beyaz arka plan
        border: Border.all(color: Colors.grey.shade400), // İnce gri çerçeve
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Hafif gölge
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // İçerik ortada
        children: [
          Image.asset(
            imgPath,
            width: 28, // Google logosu boyutu küçültüldü
            height: 28,
          ),
          SizedBox(width: 18), // Logo ile yazı arası boşluk
          Text(
            txt,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: txtColor, // Hafif soluk hint rengi
            ),
          ),
        ],
      ),
    );
  }
}
