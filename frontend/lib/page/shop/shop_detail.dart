import 'package:flutter/material.dart';
import 'package:frontend/page/shop/shop_bottom.dart';

class shopDetail extends StatefulWidget {
  final bool type;
  final int point;
  final List<String> imageList;

  const shopDetail({
    super.key,
    required this.point,
    required this.type,
    required this.imageList,
  });

  @override
  State<shopDetail> createState() => _shopDetailState();
}

class _shopDetailState extends State<shopDetail> {
  late List<Widget> ImageBtn = [];
  int thisPoint = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (String ads in widget.imageList) {
      ImageBtn.add(
        EachImage(
          address: ads,
          type: widget.type,
          having: false,
          buyItem: buyItem,
        ),
      );
    }

    thisPoint = widget.point;
  }

  void buyItem(int price) {
    setState(() {
      thisPoint -= price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        toolbarHeight: 65,
        elevation: 0,
        titleTextStyle: const TextStyle(
            color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
        toolbarTextStyle: const TextStyle(
            color: Colors.black87, fontSize: 17, fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
        title: widget.type ? const Text('배경색') : const Text('스티커'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Center(child: Text('🌟 $thisPoint')),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: 8,
        ),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: ImageBtn,
        ),
      ),
    );
  }
}

class EachImage extends StatelessWidget {
  final String address;
  final bool type;
  final bool having;
  final buyItem;

  const EachImage({
    super.key,
    required this.address,
    required this.type,
    required this.having,
    required this.buyItem,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )),
          backgroundColor: const Color.fromARGB(255, 190, 112, 201),
          context: context,
          builder: (BuildContext context) {
            return shopBottom(
              address: address,
              buyItem: buyItem,
              price: 10,
            );
          },
        );
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
            fit: type ? BoxFit.cover : BoxFit.fitWidth,
            image: AssetImage(address),
          ),
        ),
        child: Stack(
          children: [
            // if (!imageHaveList[index])
            Opacity(
              opacity: 0.5,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
            // if (!imageHaveList[index])
            const Center(
              child: Text(
                '🌟 10',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
