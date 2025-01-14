import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:maps_toolkit/maps_toolkit.dart' as map_tool;
import 'package:geocoding/geocoding.dart'; // Import geocoding package
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shopez/constants/global_variables.dart';
import 'package:shopez/location/location_popup.dart';

class SetLocation extends StatefulWidget {
  static const String routeName = '/setLocation';
  const SetLocation({super.key});

  @override
  State<SetLocation> createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {
  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  LatLng markerPosition =
      const LatLng(18.654823, 73.780309); // Track marker position
  LatLng initialLocation = const LatLng(18.654823, 73.780309);
  bool isInSelectedArea = false;
  String polygonName = "Unknown Area"; // Variable to store the polygon name
  String? markerAddress; // Variable to store the address or coordinates
  loc.LocationData? currentLocation;
  loc.Location location = loc.Location();
  double lat = 0;
  double lan = 0;

  List<LatLng> polygonPoints = const [
    LatLng(18.686870, 73.892841), // North-West point of Pimpri
    LatLng(18.687832, 73.900281), // North-East point of Pimpri
    LatLng(18.685969, 73.905329), // South-East point of Chinchwad
    LatLng(18.679977, 73.909327), // South-West point of Chinchwad
    LatLng(18.674513, 73.910048), // Near Pimpri
    LatLng(18.667309, 73.906378), // Near Pimpri
    LatLng(18.663241, 73.896119), // Near Chinchwad
    LatLng(18.664638, 73.886680), // Near Chinchwad
    LatLng(18.669451, 73.885270), // Closing the polygon
    LatLng(18.674047, 73.884451),
    LatLng(18.681250, 73.886024),
    LatLng(18.682044, 73.893910),
  ];

  List<LatLng> puneJunctionArea = const [
    LatLng(18.518507, 73.876751), // Approximate point near Pune Junction
    LatLng(18.518507, 73.883469), // Approximate point near Pune Junction
    LatLng(18.513619, 73.883469), // Approximate point near Pune Junction
    LatLng(18.513619, 73.876751), // Approximate point near Pune Junction
    LatLng(18.511928, 73.876751), // Approximate point near Pune Junction
    LatLng(18.511928, 73.883469), // Approximate point near Pune Junction
    LatLng(18.516546, 73.883469), // Approximate point near Pune Junction
    LatLng(18.516546, 73.876751), // Approximate point near Pune Junction
    LatLng(18.518507, 73.876751), // Closing the polygon
  ];

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      await checkLocationPermissionAndServices();
      setCustomMarkerIcon();
      getCurrentLocation();
      if (currentLocation != null) {
        updateMarkerLocation(LatLng(
          currentLocation!.latitude!,
          currentLocation!.longitude!,
        ));
      } else {
        updateMarkerLocation(initialLocation);
      }
    } catch (e) {
      print('Initialization error: $e');
      // Handle initialization error gracefully
      if (mounted) {
        setState(() {
          markerPosition = initialLocation;
        });
      }
    }
  }

  Future<void> checkLocationPermissionAndServices() async {
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled && mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) => const LocationPopup(),
          );
          return;
        }
      }

      var permissionGranted = await location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          print('Location permission not granted.');
          return;
        }
      }
    } catch (e) {
      print('Permission check error: $e');
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      final locationData = await location.getLocation();
      if (mounted) {
        setState(() {
          currentLocation = locationData;
        });
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void checkUpdatedLocation(LatLng pointLatLng) {
    List<map_tool.LatLng> convertedPolygonPoints = polygonPoints
        .map(
          (point) => map_tool.LatLng(point.latitude, point.longitude),
        )
        .toList();

    List<map_tool.LatLng> convertedPuneJunctionArea = puneJunctionArea
        .map(
          (point) => map_tool.LatLng(point.latitude, point.longitude),
        )
        .toList();

    setState(() {
      bool isInsidePimpriChinchwad = map_tool.PolygonUtil.containsLocation(
          map_tool.LatLng(pointLatLng.latitude, pointLatLng.longitude),
          convertedPolygonPoints,
          false);

      bool isInsidePuneJunction = map_tool.PolygonUtil.containsLocation(
          map_tool.LatLng(pointLatLng.latitude, pointLatLng.longitude),
          convertedPuneJunctionArea,
          false);

      isInSelectedArea = isInsidePimpriChinchwad || isInsidePuneJunction;

      if (isInsidePimpriChinchwad) {
        polygonName = "Pimpri-Chinchwad";
      } else if (isInsidePuneJunction) {
        polygonName = "Pune Station";
      } else {
        polygonName = " ";
      }

      if (isInSelectedArea) {
        updateMarkerLocation(pointLatLng);
      } else {
        markerAddress = null; // Clear address if outside any polygon
      }
    });
  }

Future<void> setCustomMarkerIcon() async {
    try {
      final icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(1000, 1000)),
        'images/mark.png',
      );
      if (mounted) {
        setState(() {
          markerIcon = icon;
        });
      }
    } catch (e) {
      print('Error setting marker icon: $e');
    }
  }

  Future<String> getAddressFromLatLng(LatLng position) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=YOUR_API_KEY';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          return data['results'][0]['formatted_address'];
        } else {
          return 'Unknown location';
        }
      } else {
        print('Geocoding API error: ${response.statusCode}');
        print('Response body: ${response.body}');
        return 'Failed to get address';
      }
    } catch (e) {
      print('Error occurred while fetching address: $e');
      return 'Failed to get address';
    }
  }

  void updateMarkerLocation(LatLng position) async {
    if (!mounted) return;

    setState(() {
      markerPosition = position;
      lat = position.latitude;
      lan = position.longitude;
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      setState(() {
        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks.first;
          markerAddress =
              "${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
        } else {
          markerAddress = "Unknown location";
        }
      });
    } catch (e) {
      print('Error getting address: $e');
      if (mounted) {
        setState(() {
          markerAddress = "Failed to get address";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: currentLocation == null
                    ? const Center(child: Text('Loading..'))
                    : GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(currentLocation!.latitude!,
                              currentLocation!.longitude!),
                          zoom: 15.6746,
                        ),
                        onMapCreated: (controller) {
                          _controller.complete(controller);
                        },
                        onCameraMove: (CameraPosition position) {
                          updateMarkerLocation(
                              position.target); // Update marker location
                        },
                        onCameraIdle: () {
                          checkUpdatedLocation(markerPosition);
                        },
                        markers: {
                          Marker(
                              markerId: const MarkerId('1'),
                              icon: markerIcon,
                              position: markerPosition,
                              infoWindow: const InfoWindow(
                                title: "Your order will be delivered here",
                                snippet: "Move the pin to your exact location",
                              )),
                        },
                        circles: {
                          Circle(
                            circleId: const CircleId('marker_circle'),
                            center: LatLng(currentLocation!.latitude!,
                                currentLocation!.longitude!),
                            radius: 20, // Radius in meters
                            strokeColor: const Color.fromARGB(255, 255, 0, 0),
                            strokeWidth: 4,
                            fillColor: const Color.fromARGB(255, 5, 2, 196),
                          )
                        },
                        polygons: {
                          Polygon(
                            polygonId: const PolygonId('pimpri-chinchwad'),
                            points: polygonPoints,
                            strokeWidth: 2,
                            strokeColor: Colors.blue,
                            fillColor: Colors.blue.withOpacity(0.2),
                          ),
                          Polygon(
                            polygonId: const PolygonId('pune-junction'),
                            points: puneJunctionArea,
                            strokeWidth: 2,
                            strokeColor: Colors.red,
                            fillColor: Colors.red.withOpacity(0.2),
                          ),
                        },
                      ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isInSelectedArea)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (polygonName.isNotEmpty)
                            Text(
                              "Your Location: $polygonName",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SemiBold',
                              ),
                            ),
                        ],
                      ),
                    ),
                  if (isInSelectedArea)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                padding: const EdgeInsets.all(5),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  markerAddress ?? "Fetching address...",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  if (!isInSelectedArea)
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Sorry, we're not here yet!",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SemiBold',
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'farcon is not available at this location at the momennt,',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Regular',
                          ),
                        ),
                        Text(
                          'please try a different location',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Regular',
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         HomeScreen(shopCode: '123456'),
                          //   ),
                          // );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(Icons.close, color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // if (isInSelectedArea)
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => FarmerListScreen(
                              //             area: 'Alandi',
                              //             type: 'admin',
                              //           )),
                              // );

                            // final userProvider = Provider.of<UserProvider>(
                            //     context,
                            //     listen: false);
                            // userProvider.setLocation(lat, lan);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isInSelectedArea
                                  ? GlobalVariables.greenColor
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.only(
                                  top: 5, right: 5, left: 5, bottom: 5),
                              child: Center(
                                child: Text(
                                  "Confirm Location",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Regular',
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.my_location,
          size: 30,
          color: Colors.black,
        ),
        onPressed: () async {
          try {
            // Get the current location
            loc.LocationData currentLocation = await location.getLocation();

            // Get the controller
            final GoogleMapController controller = await _controller.future;

            // Animate the camera to the current location
            controller.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(
                      currentLocation.latitude!, currentLocation.longitude!),
                  zoom: 15,
                ),
              ),
            );

            // Update the marker position
            setState(() {
              markerPosition =
                  LatLng(currentLocation.latitude!, currentLocation.longitude!);
              updateMarkerLocation(markerPosition);
            });
          } catch (e) {
            print('Error getting current location: $e');
          }
        },
      ),
    );
  }
}
