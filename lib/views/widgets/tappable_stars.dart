import 'package:flutter/material.dart';

class TappableStars extends StatelessWidget {
  static const pointsPerStar = 1.0;
  static const pointsPerHalfStar = 0.5;

  //Set halfStarWidth which is a pixel value we will use to determine if user
  // clicked a half star or full star.
  static const halfStarWidth = 10;

  final Function(double) setRating;
  final double rating;

  const TappableStars({@required this.rating, @required this.setRating});

  GestureDetector addTapEvent(Widget child, int index) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) => handleTapDown(details, index),
      child: child,
    );
  }

  void handleTapDown(TapDownDetails details, int index) {
    double updatedRating = index.toDouble();

    if (details.localPosition.dx < halfStarWidth) {
      updatedRating -= pointsPerHalfStar;
    }
    setRating(updatedRating);
  }

  Widget tappableFilledStar(int index) {
    return addTapEvent(Icon(Icons.star), index);
  }

  Widget tappableHalfStar(int index) {
    return addTapEvent(Icon(Icons.star_half), index);
  }

  Widget tappableEmptyStar(int index) {
    return addTapEvent(Icon(Icons.star_border), index);
  }

  List<Widget> buildStarRating() {
    //Minimum number of stars is 1, and our rating system is 0 indexed, so
    // add points per star to the rating to determine how many stars to add.
    var starsToAdd = rating + pointsPerStar;
    var starsAdded = 0;
    var stars = List<Widget>();

    while (starsAdded < 5) {
      if (starsToAdd >= pointsPerStar) {
        stars.add(tappableFilledStar(starsAdded));
      } else if (starsToAdd > 0) {
        stars.add(tappableHalfStar(starsAdded));
      } else {
        stars.add(tappableEmptyStar(starsAdded));
      }

      starsToAdd -= pointsPerStar;
      starsAdded++;
    }
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: buildStarRating(),
    ));
  }
}
