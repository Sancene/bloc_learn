import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'entities/map_place.dart';

abstract class MapPage extends StatelessWidget {
  const MapPage(this.title);

  final String title;
}

class ControlButton extends StatelessWidget {
  const ControlButton({Key? key, required this.onPressed, required this.title})
      : super(key: key);

  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(title, textAlign: TextAlign.center),
      ),
    );
  }
}

class ClusterizedPlacemarkCollectionPage extends MapPage {
  const ClusterizedPlacemarkCollectionPage()
      : super('ClusterizedPlacemarkCollection example');

  @override
  Widget build(BuildContext context) {
    return _ClusterizedPlacemarkCollectionExample();
  }
}

class _ClusterizedPlacemarkCollectionExample extends StatefulWidget {
  @override
  _ClusterizedPlacemarkCollectionExampleState createState() =>
      _ClusterizedPlacemarkCollectionExampleState();
}

class _ClusterizedPlacemarkCollectionExampleState
    extends State<_ClusterizedPlacemarkCollectionExample> {
  late YandexMapController controller;
  final animation =
      const MapAnimation(type: MapAnimationType.smooth, duration: 1.0);

  final List<MapObject> mapObjects = [];

  final List<MapPlace> points = testData;
  final int kPlacemarkCount = 500;
  final Random seed = Random();
  final MapObjectId clusterizedPlacemarkCollectionId =
      MapObjectId('clusterized_placemark_collection');
  final MapObjectId largeClusterizedPlacemarkCollectionId =
      MapObjectId('large_clusterized_placemark_collection');
  final MapObjectId testDataCollectionId =
      MapObjectId('test_data_placemark_collection');

  Future<Uint8List> _buildClusterAppearance(Cluster cluster) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final size = Size(200, 200);
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    final radius = 60.0;

    final textPainter = TextPainter(
        text: TextSpan(
            text: cluster.size.toString(),
            style: TextStyle(color: Colors.black, fontSize: 50)),
        textDirection: TextDirection.ltr);

    textPainter.layout(minWidth: 0, maxWidth: size.width);

    final textOffset = Offset((size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2);
    final circleOffset = Offset(size.height / 2, size.width / 2);

    canvas.drawCircle(circleOffset, radius, fillPaint);
    canvas.drawCircle(circleOffset, radius, strokePaint);
    textPainter.paint(canvas, textOffset);

    final image = await recorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
    final pngBytes = await image.toByteData(format: ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }

  double _randomDouble() {
    return (500 - seed.nextInt(1000)) / 1000;
  }

  Point getClusterCoordinates(Cluster cluster) {
    int size = cluster.placemarks.length;
    double latitude = 0;
    double longitude = 0;
    cluster.placemarks.forEach(
      (placemark) {
        latitude += placemark.point.latitude;
        longitude += placemark.point.longitude;
      },
    );
    return Point(latitude: latitude / size, longitude: longitude / size);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: YandexMap(
            mapObjects: mapObjects,
            logoAlignment: const MapAlignment(
              horizontal: HorizontalAlignment.left,
              vertical: VerticalAlignment.bottom,
            ),
            onMapCreated: (YandexMapController yandexMapController) async {
              controller = yandexMapController;

              setState(() {
                points.forEach((element) {
                  mapObjects.add(
                    Placemark(
                      mapId: MapObjectId('placemark_new'),
                      point: element.coordinates,
                    ),
                  );
                });
              });
              await controller.moveCamera(CameraUpdate.zoomTo(8));
              await controller.moveCamera(
                CameraUpdate.newCameraPosition(
                  const CameraPosition(
                    target: Point(latitude: 55.756, longitude: 37.618),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Set of $kPlacemarkCount placemarks'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ControlButton(
                        onPressed: () async {
                          if (mapObjects.any((el) =>
                              el.mapId ==
                              largeClusterizedPlacemarkCollectionId)) {
                            return;
                          }
                          final clusterizedPlacemarkCollection =
                              ClusterizedPlacemarkCollection(
                            mapId: largeClusterizedPlacemarkCollectionId,
                            radius: 45,
                            minZoom: 15,
                            onClusterAdded:
                                (ClusterizedPlacemarkCollection self,
                                    Cluster cluster) async {
                              return cluster.copyWith(
                                  appearance: cluster.appearance.copyWith(
                                      opacity: 0.75,
                                      icon: PlacemarkIcon.single(
                                          PlacemarkIconStyle(
                                              image: BitmapDescriptor.fromBytes(
                                                await _buildClusterAppearance(
                                                  cluster,
                                                ),
                                              ),
                                              scale: 1))));
                            },
                            onClusterTap: (ClusterizedPlacemarkCollection self,
                                Cluster cluster) async {
                              await controller.moveCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: getClusterCoordinates(cluster),
                                    zoom: await controller
                                        .getCameraPosition()
                                        .then((value) => value.zoom + 1),
                                  ),
                                ),
                                animation: animation,
                              );
                            },
                            placemarks:
                                List<Placemark>.generate(points.length, (i) {
                              return Placemark(
                                onTap: (placemark, point) {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 200,
                                        color: Colors.amber,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(points[i].name),
                                              ElevatedButton(
                                                child: const Text(
                                                    'Close BottomSheet'),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                mapId: MapObjectId('placemark_$i'),
                                point: points[i].coordinates,
                                icon: PlacemarkIcon.single(
                                  PlacemarkIconStyle(
                                      image: BitmapDescriptor.fromAssetImage(
                                          'assets/place.png'),
                                      scale: 1),
                                ),
                              );
                            }),
                          );

                          setState(() {
                            mapObjects.add(clusterizedPlacemarkCollection);
                          });
                        },
                        title: 'Add'),
                    ControlButton(
                        onPressed: () async {
                          setState(
                            () {
                              mapObjects.removeWhere((el) =>
                                  el.mapId ==
                                  largeClusterizedPlacemarkCollectionId);
                            },
                          );
                        },
                        title: 'Remove')
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
