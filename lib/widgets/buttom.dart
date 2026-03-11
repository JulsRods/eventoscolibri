import 'package:flutter/material.dart';

class MyButtons extends StatelessWidget {
  final VoidCallback onTab;
  final String text;
  const MyButtons({
    super.key,
    required this.onTab,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(88),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
                color: Colors.blue),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
