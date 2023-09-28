import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firnds/features/trip/data/firnds_repository.dart';
import 'package:firnds/models/ModelProvider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firnds_controller.g.dart';

@riverpod
class TripsListController extends _$TripsListController {
  Future<List<Trip>> _fetchTrips() async {
    final tripsRepository = ref.read(tripsRepositoryProvider);
    final trips = await tripsRepository.getTrips();
    return trips;
  }

  @override
  FutureOr<List<Trip>> build() async {
    return _fetchTrips();
  }

  Future<void> addTrip({
    required String name,
    required String destination,
    required String startDate,
    required String endDate,
  }) async {
    final trip = Trip(
      tripName: name,
      destination: destination,
      startDate: TemporalDate(DateTime.parse(startDate)),
      endDate: TemporalDate(DateTime.parse(endDate)),
    );

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final tripsRepository = ref.read(tripsRepositoryProvider);
      await tripsRepository.add(trip);
      return _fetchTrips();
    });
  }

  Future<void> removeTrip(Trip trip) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final tripsRepository = ref.read(tripsRepositoryProvider);
      await tripsRepository.delete(trip);

      return _fetchTrips();
    });
  }
}
