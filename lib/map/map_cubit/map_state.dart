part of 'map_cubit.dart';

abstract class MapState extends Equatable {
  const MapState();
}

class MapInitial extends MapState {
  @override
  List<Object> get props => [];
}

class IconClicked extends MapState {
  final MapObjectId mapid;
  final Point point;

  const IconClicked({required this.mapid, required this.point});

  @override
  List<Object> get props => [];
}
