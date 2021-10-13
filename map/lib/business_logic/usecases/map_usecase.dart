import 'package:base/base.dart';
import 'package:map/business_logic/data/datasource.dart';
import 'package:map/business_logic/viewstate.dart';

class MapUseCase {

  final MapDataSource _dataSource;

  MapUseCase(this._dataSource);

  Stream<ViewState> listenToTheAvailableTrips(ViewState viewstate){
    return _dataSource.listenToRequestedTrips(Location(latitude: viewstate.myLocation!.latitude, longitude: viewstate.myLocation!.longitude)).map((trips) {
      print("trips : "+ trips.length.toString());
      return viewstate.copy(tripsData: trips , loading: false , myPreviousCentralLocation: viewstate.myLocation);
    });
  }

  Future acceptAtrip(TripData tripData , ViewState viewState) async {
    try{
      await _dataSource.acceptTheTrip(tripData , Location(latitude: viewState.myLocation!.latitude, longitude: viewState.myLocation!.longitude));
      return viewState.copy(loading: false , error: "" , acceptedTrip: tripData);
    } catch(e){
      return viewState.copy(loading: false , error: "" , acceptedTrip: const TripData());
    }
  }

}