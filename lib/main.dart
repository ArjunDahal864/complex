import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Complex Animation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const CustomDrawer(),
    );
  }
}

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _iconController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    // _iconController.forward().then((value) => _iconController.reverse());
    _iconController.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void _toggleAnimation() =>
      _controller.isDismissed ? _controller.forward() : _controller.reverse();

  final double _translateX = 225.0;

  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    Widget _yellowSection = Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              _toggleAnimation();
            },
            icon: const Icon(Icons.menu),
          ),
          title: const Text("Complex Animation"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ValueListenableBuilder(
                valueListenable: _counter,
                builder: (BuildContext context, int count, Widget? child) {
                  return Center(
                      child: Text(
                    "You have pushed the button this many times:,",
                    style: TextStyle(
                        color: _counter.value > 10 ? Colors.red : null),
                  ));
                }),
            ValueListenableBuilder(
              valueListenable: _counter,
              builder: (BuildContext context, int count, Widget? child) {
                return Text(
                  '$count',
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
           const SizedBox(height: 175,),
            AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  var _slideX = _controller.value * 55.0;
                  return CustomPaint(
                    size:  Size(_slideX, _slideX),
                    painter: MyCustomShape(),
                  );
                })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: AnimatedIcon(
            progress: _iconController,
            icon: AnimatedIcons.ellipsis_search,
            color: Colors.white,
          ),
          // AnimatedIcon(icon: AnimatedIcon.play,color: Colors.white,progress: ,)
          // const Icon(Icons.add),

          onPressed: _counter.value < 10
              ? () {
                  _counter.value += 1;
                  if (_counter.value > 10) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "This is too much press man ${_counter.value}")));
                  }
                  // _toggleAnimation();
                }
              : null,
          // ),
        ));
    Widget _blueSection = Scaffold(
      backgroundColor: Colors.blue,
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.white,
              ),
              title: Text(
                "Home",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.white,
              ),
              title: Text(
                "Profile",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              title: Text(
                "Logout",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          var _slideX = _controller.value * _translateX;
          var _scale = 1 - (_controller.value * .2);
          // print(_scale);

          return Stack(
            children: [
              _blueSection,
              Transform(
                transform: Matrix4.identity()
                  ..translate(_slideX)
                  ..scale(_scale),
                alignment: Alignment.centerLeft,
                child: _yellowSection,
              ),
            ],
          );
        });
  }
}

class MyCustomShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Paint line = Paint()..color = Colors.red..strokeWidth = 1..strokeCap = StrokeCap.butt..strokeWidth=5;
    Paint complete = Paint()
      ..color = Colors.greenAccent
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    Paint line = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    Offset center = const Offset(0 , 0  );
    double radius = min(size.width *2, size.height * 2);
    canvas.drawCircle(center, radius, line);

    double arcAngle = 2 * pi * (100 / 100);

    canvas.drawArc(Rect.fromCircle(center: const Offset(0, 0), radius: 75),
        -pi / 2, arcAngle, false, complete);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
    // throw UnimplementedError();
  }
}
