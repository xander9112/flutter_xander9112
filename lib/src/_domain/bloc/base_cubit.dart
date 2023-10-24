import 'package:flutter_bloc/flutter_bloc.dart';

class BaseCubit<T> extends Cubit<T> {
  BaseCubit(super.initialState);

  /// Сделано для того чтобы не вылетала ошибка
  /// если state обновляется после закрытия кубита
  @override
  void emit(T state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  @override
  Future<void> close() async {
    await super.close();
  }
}
