import 'package:flutter/material.dart';

void main() => runApp(GradientApp());

class GradientApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gradient animation demo',
      theme: ThemeData(
        primaryColor: Colors.cyan,
        accentColor: Colors.white,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin<HomePage> {
  int _currentIndex = 0;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0
          ? ScrollableGradient(
              items: List<String>.generate(50, (i) => 'Item $i'),
              begin: LinearGradient(
                colors: [Colors.yellow, Colors.blue],
                stops: [0.0, 0.8],
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
              ),
              end: LinearGradient(
                colors: [Colors.blue[900], Colors.deepPurple[600]],
                stops: [0.0, 0.8],
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
              ),
            )
          : GradientAnimation(
              begin: LinearGradient(
                colors: [Colors.red, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              end: LinearGradient(
                colors: [Colors.yellow, Colors.purple],
              ),
              controller: _controller,
            ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              child: Icon(Icons.play_arrow),
              onPressed: () {
                if (!_controller.isAnimating) {
                  if (_controller.isCompleted) {
                    _controller.reverse();
                  } else {
                    _controller.forward();
                  }
                }
              },
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() => _currentIndex = index),
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('Scroll'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            title: Text('Animate'),
          ),
        ],
      ),
    );
  }
}

class ScrollableGradient extends StatefulWidget {
  final LinearGradient begin;
  final LinearGradient end;
  final List<String> items;

  const ScrollableGradient({
    Key key,
    @required this.begin,
    @required this.end,
    @required this.items,
  }) : super(key: key);

  @override
  _ScrollableGradientState createState() => _ScrollableGradientState();
}

class _ScrollableGradientState extends State<ScrollableGradient> {
  final _controller = ScrollController();
  LinearGradient _current;

  @override
  void initState() {
    _controller.addListener(_updateGradient);

    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_updateGradient);
    super.dispose();
  }

  void _updateGradient() {
    setState(() {
      _current = widget.begin.lerpTo(
        widget.end,
        _controller.offset / _controller.position.maxScrollExtent,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: _current ?? widget.begin,
      ),
      child: ListView.builder(
        controller: _controller,
        itemCount: widget.items.length,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        itemBuilder: (context, i) {
          return ListTile(
            title: Text(
              widget.items[i],
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          );
        },
      ),
    );
  }
}

class GradientAnimation extends StatefulWidget {
  final LinearGradient begin;
  final LinearGradient end;
  final AnimationController controller;

  const GradientAnimation({
    Key key,
    @required this.controller,
    @required this.begin,
    @required this.end,
  }) : super(key: key);

  @override
  _GradientAnimationState createState() => _GradientAnimationState();
}

class _GradientAnimationState extends State<GradientAnimation> {
  Animation<LinearGradient> _animation;

  @override
  void initState() {
    _animation = LinearGradientTween(
      begin: widget.begin,
      end: widget.end,
    ).animate(widget.controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: _animation.value,
          ),
        );
      },
    );
  }
}

/// An interpolation between two LinearGradients.
///
/// This class specializes the interpolation of [Tween] to use
/// [LinearGradient.lerp].
///
/// See [Tween] for a discussion on how to use interpolation objects.
class LinearGradientTween extends Tween<LinearGradient> {
  /// Provide a begin and end Gradient. To fade between.
  LinearGradientTween({
    LinearGradient begin,
    LinearGradient end,
  }) : super(begin: begin, end: end);

  @override
  LinearGradient lerp(double t) => LinearGradient.lerp(begin, end, t);
}
