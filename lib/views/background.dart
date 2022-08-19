import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: MediaQuery.of(context).size.width * 0.4,
      child: Row(
        children: [
          Column(
            children: [
              Transform.translate(
                offset: const Offset(0, -100),
                child: verticalVideo(context, Colors.green),
              ),
              Transform.translate(
                offset: const Offset(0, -60),
                child: verticalVideo(context, Colors.red),
              ),
            ],
          ),
          const SizedBox(width: 60),
          Column(
            children: [
              Transform.translate(
                offset: const Offset(0, -360),
                child: verticalVideo(context, Colors.blue),
              ),
              Transform.translate(
                offset: const Offset(0, 300),
                child: verticalVideo(context, Colors.orange),
              ),
            ],
          ),
          const SizedBox(width: 60),
          Column(
            children: [
              Transform.translate(
                offset: const Offset(0, -120),
                child: verticalVideo(context, Colors.amber),
              ),
              Transform.translate(
                offset: const Offset(0, -70),
                child: verticalVideo(context, Colors.teal),
              ),
            ],
          ),
          const SizedBox(width: 60),
          Column(
            children: [
              Transform.translate(
                offset: const Offset(0, 50),
                child: verticalVideo(context, Colors.amber),
              ),
              Transform.translate(
                offset: const Offset(0, 90),
                child: verticalVideo(context, Colors.teal),
              ),
            ],
          )
        ],
      ),
    );
  }
}

Widget verticalVideo(BuildContext context, Color color) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.575,
    width: MediaQuery.of(context).size.width * 0.15,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
    ),
  );
}
