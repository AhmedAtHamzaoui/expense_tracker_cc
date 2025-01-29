import 'package:flutter_bloc/flutter_bloc.dart';

// Define the navigation events
abstract class NavigationEvent {}

class TabChanged extends NavigationEvent {
  final int index;
  TabChanged(this.index);
}

// Define the navigation state
class NavigationState {
  final int selectedIndex;
  NavigationState(this.selectedIndex);
}

// Bloc to manage navigation
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState(0)) {
    on<TabChanged>((event, emit) {
      emit(NavigationState(event.index));
    });
  }
}
