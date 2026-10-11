import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/api_constants.dart';

class PersonCard extends StatelessWidget {
  final int id;
  final String name;
  final String knownFor;
  final String? profilePath;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const PersonCard({
    super.key,
    required this.id,
    required this.name,
    required this.knownFor,
    required this.profilePath,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.primaryBlue.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (profilePath != null)
              CachedNetworkImage(
                imageUrl: '${ApiConstants.imageBaseUrl}$profilePath',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.searchBackground,
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.searchBackground,
                  child: const Icon(Icons.person, color: AppColors.textGrey, size: 40),
                ),
              )
            else
              Container(
                color: AppColors.searchBackground,
                child: const Icon(Icons.person, color: AppColors.textGrey, size: 40),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                      Colors.black,
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.title.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textWhite,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      knownFor,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textGrey,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onFavoriteToggle,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? AppColors.accentRed : AppColors.textWhite,
                    size: 18,
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
