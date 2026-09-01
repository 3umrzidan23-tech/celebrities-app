import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/download_image.dart';
import 'image_viewer_state.dart';

class ImageViewerCubit extends Cubit<ImageViewerState> {
  final DownloadImage downloadImageUseCase;

  ImageViewerCubit({required this.downloadImageUseCase}) : super(ImageViewerInitial());

  Future<void> downloadImage(String url) async {
    emit(ImageDownloadLoading());
    try {
      final success = await downloadImageUseCase(url);
      if (success) {
        emit(const ImageDownloadSuccess('Image downloaded successfully!'));
      } else {
        emit(const ImageDownloadError('Failed to download image.'));
      }
    } catch (e) {
      emit(ImageDownloadError(e.toString()));
    }
  }
}
