import 'package:clase5/models/info.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BagItem extends StatelessWidget {
  final Info info;
  const BagItem({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFFF1F1F1),
        child: Stack(
          children: [
            Positioned(
                top: 20,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    Text(
                      info.name,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      info.subt,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Container(
                      height: 2,
                      width: 88,
                      color: Colors.black,
                    )
                  ],
                ))
          ],
        ));
  }
}
