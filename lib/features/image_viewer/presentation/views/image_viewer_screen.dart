import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection_container.dart';
import '../viewmodels/image_viewer_cubit.dart';
import '../viewmodels/image_viewer_state.dart';

class ImageViewerScreen extends StatelessWidget {
  final String imageUrl;

  const ImageViewerScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ImageViewerCubit>(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.textWhite),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 1.0,
            maxScale: 4.0,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue)),
              errorWidget: (context, url, error) => const Icon(Icons.error, color: AppColors.accentRed, size: 50),
            ),
          ),
        ),
        floatingActionButton: BlocConsumer<ImageViewerCubit, ImageViewerState>(
          listener: (context, state) {
            if (state is ImageDownloadSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.green),
              );
            } else if (state is ImageDownloadError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: AppColors.accentRed),
              );
            }
          },
          builder: (context, state) {
            if (state is ImageDownloadLoading) {
              return const FloatingActionButton(
                onPressed: null,
                backgroundColor: AppColors.primaryBlue,
                child: CircularProgressIndicator(color: AppColors.textWhite),
              );
            }
            return FloatingActionButton(
              onPressed: () {
                context.read<ImageViewerCubit>().downloadImage(imageUrl);
              },
              backgroundColor: AppColors.primaryBlue,
              child: const Icon(Icons.download, color: AppColors.textWhite),
            );
          },
        ),
      ),
    );
  }
}
