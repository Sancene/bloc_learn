import 'dart:math';

import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapPlace {
  final Point coordinates;
  final String openingHours;
  final String name;
  final String address;
  final int id;

  MapPlace(this.coordinates, this.openingHours, this.name, this.address, this.id);
}

double _randomDouble() {
  final seed = Random();
  return (500 - seed.nextInt(1000)) / 1000;
}

final List<MapPlace> testData = [
  MapPlace(
    Point(
      latitude: 55.756 + _randomDouble(),
      longitude: 37.618 + _randomDouble(),
    ),
    "8:00-17:45",
    "Boston cafee",
    "Улица Пушкина, Дом Колотушкина",
    1,
  ),
  MapPlace(
    Point(
      latitude: 55.756 + _randomDouble(),
      longitude: 37.618 + _randomDouble(),
    ),
    "9:00-12:45",
    "Boston arolfer",
    "Улица Пушкина, Дом Колотушкина",
    2,
  ),
  MapPlace(
    Point(
      latitude: 55.756 + _randomDouble(),
      longitude: 37.618 + _randomDouble(),
    ),
    "8:15-17:35",
    "American cafee",
    "Улица Пушкина, Дом Колотушкина",
    3,
  ),
  MapPlace(
    Point(
      latitude: 55.756 + _randomDouble(),
      longitude: 37.618 + _randomDouble(),
    ),
    "8:00-17:45",
    "Mega cafee",
    "Улица Пушкина, Дом Колотушкина",
    4,
  ),
  MapPlace(
    Point(
      latitude: 55.756 + _randomDouble(),
      longitude: 37.618 + _randomDouble(),
    ),
    "8:00-17:45",
    "Boston cafee",
    "Улица Пушкина, Дом Колотушкина",
    5,
  ),
];
