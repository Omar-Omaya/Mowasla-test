import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

String map_key = "AIzaSyBlPiWhfr2J9MInOzLxPZgLqanrqxtUV90";



late User currentfirebaseUser;

late StreamSubscription<Position> streamSubscription;