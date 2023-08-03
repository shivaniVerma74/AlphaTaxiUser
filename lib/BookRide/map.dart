import 'dart:async';
import 'dart:typed_data';
import 'package:cabira/Model/driver_model.dart';
import 'package:cabira/Model/my_ride_model.dart';
import 'package:cabira/Theme/style.dart';
import 'package:cabira/utils/ApiBaseHelper.dart';
import 'package:cabira/utils/Session.dart';
import 'package:cabira/utils/common.dart';
import 'package:cabira/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

const double CAMERA_TILT = 40;
const double CAMERA_BEARING = 30;

double driveLat = 0, driveLng = 0;

class MapPage extends StatefulWidget {
  bool status;
  LatLng? SOURCE_LOCATION;
  LatLng? DEST_LOCATION;
  String pick, dest;
  String? carType;
  List<DriverModel> driveList;
  MyRideModel? model;
  String? status1;
  bool live, zoomEnabled;
  String? id;
  double zoom;
  MapPage(this.status,
      {this.SOURCE_LOCATION,
      this.DEST_LOCATION,
      required this.driveList,
      required this.live,
      this.model,
      this.zoomEnabled = true,
      this.zoom = 15,
      this.id,
      this.pick = "",
      this.dest = "",
      this.carType,
      this.status1});

  @override
  State<StatefulWidget> createState() => MapPageState();
}

class MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  Completer<GoogleMapController> _controller = Completer();
  // this set will hold my markers
  Set<Marker> _markers = {};
  // this will hold the generated polylines
  Set<Polyline> _polylines = {};
  // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
  // this is the key object - the PolylinePoints
  // which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();
  //todo change google map api
  String googleAPIKey = "AIzaSyBRnd5Bpqec-SYN-wAYFECRw3OHd4vkfSA";
  // for my custom icons
  BitmapDescriptor? sourceIcon;
  BitmapDescriptor? driverIcon;
  BitmapDescriptor? destinationIcon;
  LatLng? SOURCE_LOCATION;
  LatLng? DEST_LOCATION;
  Timer? timer;
  double zoom = 0;
  String km = "", time = "";
  @override
  void initState() {
    super.initState();
    setSourceAndDestinationIcons();
    driveLat = 0;
    zoom = widget.zoom;
    driveLng = 0;
    if (widget.live) {
      timer = Timer.periodic(Duration(seconds: 5), (timer) {
        getDriver();
      });
    } else {}
  }

  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool acceptStatus = false;
  getDriver() async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "driver_id": widget.id.toString(),
        };
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl1 + "Payment/get_driver_details"), data);
        print(response);
        print(response);
        bool status = true;
        String msg = response['message'];
        // setSnackbar(msg, context);
        if (response['status']) {
          Map data = response['data'];
          driveLat = double.parse(data['latitude']);
          driveLng = double.parse(data['longitude']);
          if (!acceptStatus) {
            acceptStatus = true;
          }

          //      setSourceAndDestinationIcons();
          updatePinOnMap();
          //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> OfflinePage("")), (route) => false);
        } else {}
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, "WRONG")!, context);
      }
    } else {
      setSnackbar(getTranslated(context, "NO_INTERNET")!, context);
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  late LatLng latLng;
  getMarkers() async {
    final GoogleMapController controller = await _controller.future;

    final MarkerId markerId = MarkerId((widget.driveList[0].id).toString());
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: markers[markerId]!.position, zoom: 15),
      ),
    );
  }

  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: zoom,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(driveLat, driveLng),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition = LatLng(driveLat, driveLng);
      if (widget.model != null &&
          widget.model!.start_time != null &&
          widget.model!.start_time != "") {
        List<String> calTime = widget.model!.start_time!.split(":");
        DateTime firstTime = DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, int.parse(calTime[0]), int.parse(calTime[1]));
        print(calTime.toString());
        time =
            "00:" + DateTime.now().difference(firstTime).inMinutes.toString();
      }
      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere((m) => m.markerId.value == 'drivePin');
      _markers.add(Marker(
          markerId: MarkerId('drivePin'),
          position: pinPosition, // updated position
          icon: driverIcon!));
    });
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/driving_pin.png');
    if (widget.live) {
      if (widget.carType == "1") {
        driverIcon = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 0.2), 'assets/driving.png');
      } else {
        driverIcon = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 0.2), 'assets/driving.png');
      }
    }
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png');
    if (widget.status) {
      setState(() {
        SOURCE_LOCATION = widget.SOURCE_LOCATION;
        DEST_LOCATION = widget.DEST_LOCATION;
        setMapPins();
        setPolylines();
      });

      /* if (widget.live) {

      }*/
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (widget.live) timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialLocation = CameraPosition(
        zoom: zoom,
        bearing: CAMERA_BEARING,
        tilt: CAMERA_TILT,
        target: widget.SOURCE_LOCATION!);
    return GoogleMap(
        myLocationEnabled: true,
        compassEnabled: true,
        zoomControlsEnabled: false,
        tiltGesturesEnabled: false,
        scrollGesturesEnabled: widget.zoomEnabled,
        markers: _markers,
        polylines: _polylines,
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        onMapCreated: onMapCreated);
  }

  void onMapCreated(GoogleMapController controller) async {
    // controller.setMapStyle(Utils.mapStyles);
    _controller.complete(controller);
    var nLat, nLon, sLat, sLon;
    SOURCE_LOCATION = widget.SOURCE_LOCATION;
    DEST_LOCATION = widget.DEST_LOCATION;
    if (widget.status && SOURCE_LOCATION != null && DEST_LOCATION != null) {
      if (DEST_LOCATION!.latitude <= SOURCE_LOCATION!.latitude) {
        sLat = DEST_LOCATION!.latitude;
        nLat = SOURCE_LOCATION!.latitude;
      } else {
        sLat = SOURCE_LOCATION!.latitude;
        nLat = DEST_LOCATION!.latitude;
      }
      if (DEST_LOCATION!.longitude <= SOURCE_LOCATION!.longitude) {
        sLon = DEST_LOCATION!.longitude;
        nLon = SOURCE_LOCATION!.longitude;
      } else {
        sLon = SOURCE_LOCATION!.longitude;
        nLon = DEST_LOCATION!.longitude;
      }
      LatLngBounds bound = LatLngBounds(
          southwest: LatLng(sLat, sLon), northeast: LatLng(nLat, nLon));
      CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 150);
      controller.animateCamera(u2).then((void v) {});
    }
    if (widget.status) {
      //setMapPins();
      //setPolylines();
    }
  }

  void setMapPins() async {
    setState(() {
      // source pin
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: SOURCE_LOCATION!,
          infoWindow: InfoWindow(
            title: "Pickup Location",
            snippet: widget.pick,
          ),
          icon: sourceIcon!));
      if (widget.live) {
        _markers.add(Marker(
            markerId: MarkerId('drivePin'),
            infoWindow: InfoWindow(title: "Driver Location"),
            position: SOURCE_LOCATION!,
            icon: driverIcon!));
      }
      // destination pin
      _markers.add(Marker(
          markerId: MarkerId('destPin'),
          position: DEST_LOCATION!,
          infoWindow: InfoWindow(
            title: "Destination Location",
            snippet: widget.dest,
          ),
          icon: destinationIcon!));
    });
    if (widget.driveList.length > 0) {
      for (int i = 0; i < widget.driveList.length; i++) {
        if (widget.carType != null &&
            widget.carType == widget.driveList[i].car_type) {
          print("check1" + widget.carType.toString());
          var markerIdVal = markers.length + 1;
          String mar = (widget.driveList[i].id).toString();
          print(widget.driveList[i].latitude.toString());
          print(widget.driveList[i].longitude.toString());
          latLng = LatLng(double.parse(widget.driveList[i].latitude),
              double.parse(widget.driveList[i].longitude));
          Uint8List markerIcon;
          if (widget.carType == "1") {
            markerIcon = await getBytesFromAsset('assets/cars/car1.png', 100);
          } else {
            markerIcon = await getBytesFromAsset('assets/cars/car2.png', 50);
          }
          final MarkerId markerId = MarkerId(mar);
          final Marker marker = Marker(
            markerId: markerId,
            position: latLng,
            icon: BitmapDescriptor.fromBytes(markerIcon),
          );
          setState(() {
            _markers.add(marker);
          });
          print(markerId.toString() + "\n" + marker.toString());
          print(markers.length);
        } else {
          print("check2" + widget.carType.toString());
        }
      }
    }
  }

  setPolylines() async {
    _polylines.clear();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(SOURCE_LOCATION!.latitude, SOURCE_LOCATION!.longitude),
        PointLatLng(DEST_LOCATION!.latitude, DEST_LOCATION!.longitude),
        travelMode: TravelMode.driving,
        optimizeWaypoints: true);
    print("${result.points} >>>>>>>>>>>>>>>>..");
    print("$SOURCE_LOCATION >>>>>>>>>>>>>>>>..");
    print("$DEST_LOCATION >>>>>>>>>>>>>>>>..");
    print(result.errorMessage);
    if (result.points.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print("Failed");
    }
    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          width: 5,
          polylineId: PolylineId("poly"),
          color: AppTheme.primaryColor,
          points: polylineCoordinates);
      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    });
    /*if (widget.status1 != null &&
        widget.status1 == "1" &&
        driveLat != 0 &&
        widget.live) {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          googleAPIKey,
          PointLatLng(driveLat, driveLng),
          PointLatLng(SOURCE_LOCATION!.latitude, SOURCE_LOCATION!.longitude),
          travelMode: TravelMode.driving,
          optimizeWaypoints: true);
      print("${result.points} >>>>>>>>>>>>>>>>..");
      print("$SOURCE_LOCATION >>>>>>>>>>>>>>>>..");
      print("$DEST_LOCATION >>>>>>>>>>>>>>>>..");
      print(result.errorMessage);
      if (result.points.isNotEmpty) {
        // loop through all PointLatLng points and convert them
        // to a list of LatLng, required by the Polyline
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      } else {
        print("Failed");
      }
      setState(() {
        // create a Polyline instance
        // with an id, an RGB color and the list of LatLng pairs
        Polyline polyline = Polyline(
            width: 5,
            polylineId: PolylineId("poly"),
            color: AppTheme.primaryColor,
            points: polylineCoordinates);
        // add the constructed polyline as a set of points
        // to the polyline set, which will eventually
        // end up showing up on the map
        _polylines.add(polyline);
      });
    } else {

    }*/
  }
}

class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}
