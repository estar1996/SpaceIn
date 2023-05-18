import 'package:flutter/material.dart';
import 'package:frontend/page/shop/shop_bottom.dart';

import 'package:dio/dio.dart';

import 'package:frontend/common/secure_storage.dart';

class shopDetail extends StatefulWidget {
  final bool type;
  final int point;
  final List<dynamic> imageList;

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
  final dio = Dio();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print('이건 shopdetail의 imagelist ${widget.imageList}');
    for (Map<String, dynamic> dt in widget.imageList) {
      ImageBtn.add(
        EachImage(
          // .itemName
          address: dt['itemFileName'],
          type: widget.type,
          // .havItem
          having: dt['haveItem'],
          price: dt['itemPrice'],
          buyItem: buyItem,
          itemId: dt['itemId'],
        ),
      );
    }

    thisPoint = widget.point;
  }

  // int itemId
  void buyItem(int price, int itemId, bool type) async {
    Map<String, int> requestBody = {
      'itemId': itemId,
    };

    for (int i = 0; i < widget.imageList.length; i++) {
      if (widget.imageList[i]['itemId'] == itemId) {
        setState(() {
          ImageBtn.removeAt(i);
        });
      }
    }

    final token = await SecureStorage().getAccessToken();
    Response response =
        await dio.post('http://k8a803.p.ssafy.io:8080/shop/buyitem',
            data: requestBody,
            options: Options(
              headers: {'Authorization': token},
            ));

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
  final int price;
  final int itemId;
  final buyItem;

  const EachImage({
    super.key,
    required this.address,
    required this.type,
    required this.having,
    required this.buyItem,
    required this.price,
    required this.itemId,
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
              price: price,
              itemId: itemId,
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
            image: type
                ? AssetImage('assets/background/$address')
                : AssetImage('assets/$address'),
          ),
        ),
        child: Stack(
          children: [
            if (!having)
              Opacity(
                opacity: 0.5,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            if (!having)
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
