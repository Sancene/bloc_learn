import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitial());
}
