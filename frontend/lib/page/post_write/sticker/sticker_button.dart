import 'package:flutter/material.dart';

class stickerButton extends StatelessWidget {
  final String address;
  final addSticker;

  const stickerButton({
    super.key,
    required this.address,
    required this.addSticker,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        addSticker(address);
      },
      child: Container(
        height: 55,
        width: 55,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 2),
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(address),
            fit: BoxFit.contain,
          )),
        ),
      ),
    );
  }
}
