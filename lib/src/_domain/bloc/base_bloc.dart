import 'package:flutter_bloc/flutter_bloc.dart';

class BaseBloc<Event, State> extends Bloc<Event, State> {
  BaseBloc(super.initialState);
}
