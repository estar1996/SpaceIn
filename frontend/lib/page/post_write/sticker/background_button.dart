import 'package:flutter/material.dart';

class backgroundButton extends StatelessWidget {
  final String address;
  final changeBackgroundImage;
  final changeBackgroundType;

  const backgroundButton({
    super.key,
    required this.address,
    required this.changeBackgroundImage,
    required this.changeBackgroundType,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        changeBackgroundType(true);
        changeBackgroundImage(address);
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
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(address),
            fit: BoxFit.cover,
          )),
        ),
      ),
    );
  }
}
