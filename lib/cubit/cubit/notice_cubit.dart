import 'package:bloc/bloc.dart';

part 'notice_state.dart';

class NoticeCubit extends Cubit<NoticeState> {
  NoticeCubit() : super(NoticeState(0));

  void DataChanged() {
    emit(NoticeState(state.index + 1));
  }
}
