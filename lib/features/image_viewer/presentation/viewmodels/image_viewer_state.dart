import 'package:equatable/equatable.dart';

abstract class ImageViewerState extends Equatable {
  const ImageViewerState();

  @override
  List<Object> get props => [];
}

class ImageViewerInitial extends ImageViewerState {}

class ImageDownloadLoading extends ImageViewerState {}

class ImageDownloadSuccess extends ImageViewerState {
  final String message;
  const ImageDownloadSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ImageDownloadError extends ImageViewerState {
  final String message;
  const ImageDownloadError(this.message);

  @override
  List<Object> get props => [message];
}
