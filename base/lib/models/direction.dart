import 'package:equatable/equatable.dart';

class Direction extends Equatable{

  final String? distanceText;
  final String? durationText;
  final String? encodedDirections;
  final int? distanceValue;
  final int? durationValue;

  const Direction(
      {this.distanceText,
        this.durationText,
        this.distanceValue,
        this.durationValue,
        this.encodedDirections});

  @override
  List<Object?> get props => [
    distanceText,
    durationText,
    distanceValue,
    durationValue,
    encodedDirections
  ];

}
