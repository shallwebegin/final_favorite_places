import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newnew_favorite_places/providers/user_provider.dart';
import 'package:newnew_favorite_places/screens/add_place.dart';
import 'package:newnew_favorite_places/widgets/place_list.dart';

class PlaceScreen extends ConsumerStatefulWidget {
  const PlaceScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PlaceScreenState();
  }
}

class _PlaceScreenState extends ConsumerState<PlaceScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userPlaceProvider.notifier).loadPlace();
  }

  @override
  Widget build(BuildContext context) {
    final newPlace = ref.watch(userPlaceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddPlaceScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: newPlace.length,
                      itemBuilder: (context, index) {
                        final place = newPlace[index];
                        return ListTile(
                          title: Text(place.title),
                          subtitle: Text(place.location.address),
                          leading: Image.file(place.image),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              // Silme işlemini gerçekleştir
                              await ref
                                  .read(userPlaceProvider.notifier)
                                  .deletePlace(place.id);
                            },
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
