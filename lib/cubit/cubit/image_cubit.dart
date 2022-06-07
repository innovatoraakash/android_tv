import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'image_state.dart';

class ImageCubit extends Cubit<bool> {
  ImageCubit() : super(false);

  togleImageView() {
    emit(state == true ? false : true);
  }
}
