import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating; // Por ejemplo, 3.5
  final int maxRating;
  final Color color;

  const StarRating({
    Key? key,
    required this.rating,
    this.maxRating = 5,
    this.color = Colors.amber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: color));
    }
    if (hasHalfStar) {
      stars.add(Icon(Icons.star_half, color: color));
    }
    while (stars.length < maxRating) {
      stars.add(Icon(Icons.star_border, color: color));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }
}