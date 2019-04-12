import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_platter/data.dart';
import 'package:flutter_platter/page_transformer.dart';
import 'package:flutter_platter/styles.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int _currentPlatterIndex = 0;
  double _currentPlatterImageRotationRad = 0.0;
  List<Recipe> _orderPlatterList = [];

  AnimationController _firstPlatterAddedAnimationController;
  Animation<double> _firstPlatterAddedAnimation;

  final ScrollController _orderPlatterScrollController = new ScrollController();
  final GlobalKey<AnimatedListState> _orderPlatterListKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _firstPlatterAddedAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _firstPlatterAddedAnimation = CurvedAnimation(
      parent: _firstPlatterAddedAnimationController,
      curve: Curves.bounceOut,
    );
  }

  @override
  void dispose() {
    _firstPlatterAddedAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Recipe currentRecipe = recipeList[_currentPlatterIndex];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Transform.rotate(
                    angle: _currentPlatterImageRotationRad,
                    child: Image.asset(
                      currentRecipe.imageUrl,
                      width: 200.0,
                      height: 200.0,
                    ),
                  ),
                  Expanded(
                    child: PageTransformer(
                      onPageScrolling: _onPlatterPageScrolling,
                      pageView: PageView.builder(
                        onPageChanged: _onPlatterPageChanged,
                        controller:
                            PageController(initialPage: _currentPlatterIndex),
                        itemCount: recipeList.length,
                        itemBuilder: (context, index) {
                          return PlatterPageViewItem(recipe: recipeList[index]);
                        },
                      ),
                    ),
                  ),
                  OrderBottomBar(
                    animation: _firstPlatterAddedAnimation,
                    onOrderPressed: _orderPlatter,
                  ),
                ],
              ),
            ),
            _buildOrderList(),
          ],
        ),
      ),
    );
  }

  _onPlatterPageScrolling(PageVisibilityResolver pageVisibilityResolver) {
    final currentPageVisibility =
        pageVisibilityResolver.resolvePageVisibility(_currentPlatterIndex);
    final position = currentPageVisibility.pagePosition;

    double currentRotationRad = position * -2 * math.pi;

    setState(() {
      _currentPlatterImageRotationRad = currentRotationRad;
    });
  }

  void _onPlatterPageChanged(int index) {
    setState(() {
      _currentPlatterImageRotationRad = 0.0;
      _currentPlatterIndex = index;
    });
  }

  void _orderPlatter() {
    setState(() {
      _orderPlatterList = [];
      _firstPlatterAddedAnimationController.reset();
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Text("Order success!!!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrderList() {
    return Positioned(
      left: 20.0,
      right: 20.0,
      height: 60.0,
      bottom: 70.0,
      child: FractionalTranslation(
        translation: Offset(0.0, 0.35),
        child: AnimatedBuilder(
          animation: _firstPlatterAddedAnimation,
          builder: (context, child) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.tight,
                  flex: 100,
                  child: _firstPlatterAddedAnimation.value == 0
                      ? Container()
                      : AnimatedList(
                          key: _orderPlatterListKey,
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          controller: _orderPlatterScrollController,
                          initialItemCount: _orderPlatterList.length,
                          itemBuilder: (BuildContext context, int index,
                              Animation animation) {
                            Animation<double> rotateAnimation =
                                Tween(begin: math.pi / 2, end: 0.0).animate(
                                    CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.bounceOut));
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: orderPlatterItemPadding,
                              ),
                              child: AnimatedBuilder(
                                animation: rotateAnimation,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: rotateAnimation.value,
                                    child: child,
                                  );
                                },
                                child: Image.asset(
                                  _orderPlatterList[index].imageUrl,
                                  width: orderPlatterItemSize,
                                  height: orderPlatterItemSize,
                                ),
                              ),
                            );
                          },
                        ),
                ),
                SizedBox(width: 10.0),
                FloatingActionButton(
                  shape: CircleBorder(
                    side: BorderSide(
                      color: primaryDarkColor,
                      width: 2.0,
                    ),
                  ),
                  backgroundColor: backgroundColor,
                  onPressed: _onAddButtonPress,
                  child: Transform.rotate(
                    angle: _firstPlatterAddedAnimation.value * 2 * math.pi,
                    child: new Icon(
                      Icons.add,
                      color: primaryColor,
                    ),
                  ),
                ),
                Flexible(
                  flex: 100 - (_firstPlatterAddedAnimation.value * 100).floor(),
                  child: Container(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onAddButtonPress() {
    if (_orderPlatterList.length == 0) {
      _firstPlatterAddedAnimationController.forward(from: 0.0);
    }

    Future.delayed(Duration(milliseconds: 200), () {
      _orderPlatterList.add(recipeList[_currentPlatterIndex]);
      _orderPlatterListKey.currentState.insertItem(
        _orderPlatterList.length - 1,
        duration: Duration(milliseconds: 800),
      );

      final double currentOrderPlatterMaxScroll =
          _orderPlatterScrollController.position.maxScrollExtent +
              orderPlatterItemSize +
              orderPlatterItemPadding * 2;
      _orderPlatterScrollController.animateTo(
        currentOrderPlatterMaxScroll,
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
      );
    });
  }
}

class PlatterPageViewItem extends StatelessWidget {
  final Recipe recipe;

  PlatterPageViewItem({this.recipe});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            SvgPicture.asset(
              "images/veg.svg",
              width: 25.0,
              height: 25.0,
              color: recipe.isVeg ? Colors.green : Colors.red,
            ),
            SizedBox(height: 35.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Container(
                color: lightColor,
                child: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SizedBox(height: 35.0),
                        Text(
                          recipe.calories,
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 12.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          height: 1.5,
                          color: primaryDarkColor,
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          recipe.ingredients,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                    FractionalTranslation(
                      translation: Offset(0.0, -0.5),
                      child: Text(
                        recipe.name,
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 36.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              recipe.price,
              style: TextStyle(
                color: accentColor,
                fontSize: 18.0,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class OrderBottomBar extends AnimatedWidget {
  final VoidCallback onOrderPressed;

  OrderBottomBar({Listenable animation, this.onOrderPressed})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation animation = listenable as Animation;

    return Container(
      width: double.infinity,
      height: 70.0,
      color: lightColor,
      child: FractionalTranslation(
        translation: Offset(0.0, 1.0 - animation.value),
        child: Container(
          child: Center(
            child: GestureDetector(
              onTap: () {
                if (onOrderPressed != null) onOrderPressed();
              },
              child: Text(
                "Order Now",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 22.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
