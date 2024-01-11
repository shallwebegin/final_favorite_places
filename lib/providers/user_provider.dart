import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newnew_favorite_places/models/places.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT) ');
    },
    version: 1,
  );
  return db;
}

class UserPlaceNotifier extends StateNotifier<List<Place>> {
  UserPlaceNotifier() : super(const []);
  Future<void> loadPlace() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
              latitude: row['lat'] as double,
              longitude: row['lng'] as double,
              address: row['address'] as String,
            ),
          ),
        )
        .toList();
    state = places;
  }

  Future<void> deletePlace(String placeId) async {
    final db = await _getDatabase();
    await db.delete('user_places', where: 'id = ?', whereArgs: [placeId]);

    // Silinen öğeyi güncellemek için state'i güncelle
    state = state.where((place) => place.id != placeId).toList();
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filename');
    final addPlace =
        Place(title: title, image: copiedImage, location: location);
    final db = await _getDatabase();
    db.insert('user_places', {
      'id': addPlace.id,
      'title': addPlace.title,
      'image': addPlace.image.path,
      'lat': addPlace.location.latitude,
      'lng': addPlace.location.longitude,
      'address': addPlace.location.address,
    });
    state = [addPlace, ...state];
  }
}

final userPlaceProvider = StateNotifierProvider<UserPlaceNotifier, List<Place>>(
    (ref) => UserPlaceNotifier());
