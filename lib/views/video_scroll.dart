import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

class VideoScroll extends StatefulWidget {
  const VideoScroll({
    Key? key,
    this.testingController,
  }) : super(key: key);

  // This is a parameter to support testing in this repo
  final Controller? testingController;

  @override
  State<VideoScroll> createState() => _VideoScrollState();
}

class _VideoScrollState extends State<VideoScroll>
    with TickerProviderStateMixin {
  late Controller controller;

  late AnimationController hoveringController;
  late Animation<Offset> hoveringAnimation;

  late AnimationController hoveringController2;
  late Animation<Offset> hoveringAnimation2;

  var _currentVideoIndex = 0;

  @override
  void initState() {
    controller = widget.testingController ?? Controller()
      ..addListener((event) {
        _handleCallbackEvent(event.direction, event.success);
      });
    super.initState();

    hoveringController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat(reverse: true);
    hoveringAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, 0.5)).animate(
            CurvedAnimation(
                parent: hoveringController, curve: Curves.easeInOut));

    hoveringController2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat(reverse: true);
    hoveringAnimation2 =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.5)).animate(
            CurvedAnimation(
                parent: hoveringController2, curve: Curves.easeInOut));
  }

  late List<MaterialColor> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              if (_currentVideoIndex > 0) {
                setState(() {
                  _currentVideoIndex--;
                });
              } else {
                setState(() {
                  _currentVideoIndex = colors.length - 1;
                });
              }
              controller.animateToPosition(_currentVideoIndex);
            },
            icon: SlideTransition(
              position: hoveringAnimation,
              child: Transform.rotate(
                  angle: 90 * pi / 180,
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  )),
            )),
        const SizedBox(height: 30),
        Center(
          child: SizedBox(
            height: 500,
            width: 250,
            child: Stack(
              children: [
                SizedBox(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.19,
                    height: MediaQuery.of(context).size.height * 0.775,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: TikTokStyleFullPageScroller(
                        contentSize: colors.length,
                        swipePositionThreshold: 0.2,
                        // ^ the fraction of the screen needed to scroll
                        swipeVelocityThreshold: 2000,
                        // ^ the velocity threshold for smaller scrolls
                        animationDuration: const Duration(milliseconds: 400),
                        // ^ how long the animation will take
                        controller: controller,
                        // ^ registering our own function to listen to page changes
                        builder: (BuildContext context, int index) {
                          return Container(
                            color: colors[index],
                            child: Stack(
                              children: [
                                Center(
                                  child: Text(
                                    '$index',
                                    key: Key('$index-text'),
                                    style: const TextStyle(
                                        fontSize: 48, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  height: 500,
                  width: 250,
                ),
                Transform.translate(
                  offset: const Offset(2.5, 0),
                  child: Transform.scale(
                    scale: 1.15,
                    child: Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/mockup_phone.png'))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        IconButton(
          onPressed: () {
            if (_currentVideoIndex < colors.length - 1) {
              setState(() {
                _currentVideoIndex++;
              });
            } else {
              setState(() {
                _currentVideoIndex = 0;
              });
            }

            controller.animateToPosition(_currentVideoIndex);
          },
          icon: SlideTransition(
            position: hoveringAnimation2,
            child: Transform.rotate(
              angle: -90 * pi / 180,
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleCallbackEvent(ScrollDirection direction, ScrollSuccess success,
      {int? currentIndex}) {
    // ignore: avoid_print
    print(
        "Scroll callback received with data: {direction: $direction, success: $success and index: ${currentIndex ?? 'not given'}}");
  }
}
