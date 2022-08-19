import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:landing_web/views/background.dart';
import 'package:landing_web/views/video_scroll.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;
  var _breathe = 0.0;

  bool drawerOpened = false;
  late AnimationController _socialController;
  late Animation<Offset> _socialAnimation;

  late AnimationController whiteCircleAnimationController;
  late Animation<double> whiteCircleAnimation;

  late AnimationController orangeCircleAnimationController;
  late Animation<double> orangeCircleAnimation;

  late AnimationController blackCircleAnimationController;
  late Animation<double> blackCircleAnimation;
  bool blackCircleVisible = false;

  final List<Widget> _menuItems = [];

  final Tween<Offset> _offset =
      Tween(begin: const Offset(1, 0), end: const Offset(0, 0));

  @override
  void initState() {
    super.initState();

    whiteCircleAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    whiteCircleAnimation = Tween<double>(begin: 0.0, end: 1500).animate(
        CurvedAnimation(
            parent: whiteCircleAnimationController, curve: Curves.ease));

    orangeCircleAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    orangeCircleAnimation = Tween<double>(begin: 0.0, end: 2000).animate(
        CurvedAnimation(
            parent: orangeCircleAnimationController, curve: Curves.easeIn));

    blackCircleAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    blackCircleAnimation = Tween<double>(begin: 2000, end: 0).animate(
        CurvedAnimation(
            parent: blackCircleAnimationController, curve: Curves.easeIn));

    _breathingController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    _breathingAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut));
    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _breathingController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _breathingController.forward();
      }
    });

    _breathingController.addListener(() {
      setState(() {
        _breathe = _breathingAnimation.value;
      });
    });
    _breathingController.forward();

    _socialController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _socialAnimation =
        Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(
                parent: _socialController, curve: Curves.easeInOut));
  }

  Future<void> _addMenuItems() async {
    // get data from db
    List<String> menus = [
      'Kwai',
      'About Use',
      'For Good',
      'For Bad',
      'Safety Statement',
      'Business Use',
    ];

    Future ft = Future(() {});
    // ignore: avoid_function_literals_in_foreach_calls
    menus.forEach((String menu) {
      ft = ft.then((data) {
        return Future.delayed(const Duration(milliseconds: 100), () {
          _menuItems.add(_buildMenuItems(menu));
          _listKey.currentState!.insertItem(_menuItems.length - 1);
        });
      });
    });
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _socialController.dispose();
    whiteCircleAnimationController.dispose();
    orangeCircleAnimationController.dispose();
    blackCircleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  const Background(),
                  Container(
                    color: Colors.black.withOpacity(0.75),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 1.1,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 80, right: 80, top: 70),
                    child: Row(
                      children: [
                        Transform.translate(
                          offset: const Offset(50, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Capture\nthe world,\nShare\nyour story',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                    height: 1.4),
                              ),
                              const SizedBox(height: 40),
                              Image.asset(
                                'assets/images/apple-google.png',
                                width: 400,
                                height: 150,
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        Transform.translate(
                          offset: const Offset(0, -30),
                          child: const Padding(
                            padding: EdgeInsets.only(right: 250),
                            child: VideoScroll(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: drawerOpened,
                    child: customDrawer(context),
                  ),
                ],
              ),
            ),
          ),
          customAppbar(),
        ],
      ),
    );
  }

  Padding customAppbar() {
    return Padding(
      padding: const EdgeInsets.only(left: 90, right: 90, top: 70),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Icon(Icons.home, color: Colors.white, size: 40),
                Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                setState(() {
                  drawerOpened = !drawerOpened;
                });
                if (drawerOpened) {
                  whiteCircleAnimationController.forward().then((value) {
                    whiteCircleAnimationController.reset();
                  });
                  orangeCircleAnimationController.forward().then((value) {
                    orangeCircleAnimationController.reset();
                    _addMenuItems().then((value) {
                      Future.delayed(const Duration(milliseconds: 500), () {
                        _socialController.forward(from: 0);
                      });
                    });
                  });
                } else {
                  _socialController.reset();
                  setState(() {
                    blackCircleVisible = true;
                  });
                  blackCircleAnimationController.forward().then((value) {
                    blackCircleAnimationController.reset();
                    setState(() {
                      blackCircleVisible = false;
                    });
                  });
                  _menuItems.clear();
                }
              },
              child: drawerOpened
                  ? Stack(
                      children: [
                        AnimatedBuilder(
                            animation: whiteCircleAnimation,
                            child: Container(
                              height: 1,
                              width: 1,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(50),
                                border:
                                    Border.all(color: Colors.white, width: 0.2),
                              ),
                            ),
                            builder: (context, child) {
                              return Transform.scale(
                                scale: whiteCircleAnimation.value,
                                child: child,
                              );
                            }),
                        AnimatedBuilder(
                            animation: orangeCircleAnimation,
                            child: Container(
                              height: 1,
                              width: 1,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: const Color(0xffFF5000), width: 0.2),
                              ),
                            ),
                            builder: (context, child) {
                              return Transform.scale(
                                scale: orangeCircleAnimation.value,
                                child: child,
                              );
                            }),
                        Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: const Color(0xffFF5000),
                              borderRadius: BorderRadius.circular(20),
                            )),
                      ],
                    )
                  : Stack(
                      children: [
                        Visibility(
                          visible: blackCircleVisible,
                          child: AnimatedBuilder(
                              animation: blackCircleAnimation,
                              child: Container(
                                height: 1,
                                width: 1,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: blackCircleAnimation.value,
                                  child: child,
                                );
                              }),
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: _breathe * 4 + 2,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white,
                                  width: _breathe * 2 + 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Positioned customDrawer(BuildContext context) {
    return Positioned(
      top: 0,
      left: MediaQuery.of(context).size.width * 0.55,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Column(
            children: [
              Expanded(
                child: AnimatedList(
                    key: _listKey,
                    initialItemCount: _menuItems.length,
                    itemBuilder: (context, index, animation) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 50, bottom: 20),
                        child: SlideTransition(
                          position: animation.drive(_offset),
                          child: _menuItems[index],
                        ),
                      );
                    }),
              ),
              SlideTransition(
                position: _socialAnimation,
                child: Padding(
                  padding: const EdgeInsets.only(left: 70, bottom: 50),
                  child: Row(children: [
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          icon: const FaIcon(FontAwesomeIcons.facebookF,
                              color: Colors.white),
                          onPressed: () {},
                        )),
                    const SizedBox(width: 20),
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          icon: const FaIcon(FontAwesomeIcons.instagram,
                              color: Colors.white),
                          onPressed: () {},
                        )),
                    const SizedBox(width: 20),
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.mail, color: Colors.white),
                          onPressed: () {},
                        )),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItems(String title) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
      ),
    );
  }
}
