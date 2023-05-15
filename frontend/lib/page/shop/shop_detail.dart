import 'package:flutter/material.dart';

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
            child: Center(child: Text('🌟 ${widget.point}')),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        // children: widget.imageList,
      ),
    );
  }
}
