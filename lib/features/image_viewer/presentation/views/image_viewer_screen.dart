import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection_container.dart';
import '../viewmodels/image_viewer_cubit.dart';
import '../viewmodels/image_viewer_state.dart';

class ImageViewerScreen extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const ImageViewerScreen({super.key, required this.images, required this.initialIndex});

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
          actions: [
            BlocConsumer<ImageViewerCubit, ImageViewerState>(
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
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: AppColors.textWhite, strokeWidth: 2),
                      ),
                    ),
                  );
                }
                return IconButton(
                  icon: const Icon(Icons.download, color: AppColors.textWhite),
                  onPressed: () {
                    final currentUrl = widget.images[_currentIndex];
                    context.read<ImageViewerCubit>().downloadImage(currentUrl);
                  },
                );
              },
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Center(
                  child: InteractiveViewer(
                    panEnabled: true,
                    minScale: 1.0,
                    maxScale: 4.0,
                    child: CachedNetworkImage(
                      imageUrl: widget.images[index],
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue)),
                      errorWidget: (context, url, error) => const Icon(Icons.error, color: AppColors.accentRed, size: 50),
                    ),
                  ),
                );
              },
            ),
            if (widget.images.length > 1)
              Positioned(
                bottom: MediaQuery.paddingOf(context).bottom + 16,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.images.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index ? AppColors.textWhite : AppColors.textGrey,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
