import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_error.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../injection_container.dart';
import '../../../favorites/presentation/cubit/favorites_cubit.dart';
import '../../../favorites/presentation/cubit/favorites_state.dart';
import '../../domain/entities/person.dart';
import '../cubit/person_details_cubit.dart';
import '../cubit/person_details_state.dart';

class PersonDetailsPage extends StatefulWidget {
  final int personId;
  const PersonDetailsPage({super.key, required this.personId});

  @override
  State<PersonDetailsPage> createState() => _PersonDetailsPageState();
}

class _PersonDetailsPageState extends State<PersonDetailsPage> {
  late PersonDetailsCubit _cubit;
  bool _showFullBiography = false;

  @override
  void initState() {
    super.initState();
    _cubit = sl<PersonDetailsCubit>();
    _cubit.fetchPersonDetails(widget.personId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: AppColors.textWhite),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            BlocBuilder<PersonDetailsCubit, PersonDetailsState>(
              builder: (context, detailsState) {
                if (detailsState is PersonDetailsLoaded) {
                  return BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, favoritesState) {
                      final isFavorite = context.read<FavoritesCubit>().isFavorite(widget.personId);
                      return IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.background.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? AppColors.accentRed : AppColors.textWhite,
                          ),
                        ),
                        onPressed: () {
                          final details = detailsState.details;
                          final person = Person(
                            id: details.id,
                            name: details.name,
                            profilePath: details.profilePath,
                            knownForDepartment: details.knownForDepartment,
                            popularity: 0.0,
                          );
                          context.read<FavoritesCubit>().toggleFavorite(person);
                        },
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<PersonDetailsCubit, PersonDetailsState>(
          builder: (context, state) {
            if (state is PersonDetailsLoading) {
              return const AppLoading();
            } else if (state is PersonDetailsError) {
              return AppError(
                message: state.message,
                onRetry: () => _cubit.fetchPersonDetails(widget.personId),
              );
            } else if (state is PersonDetailsLoaded) {
              final details = state.details;
              final images = state.images;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 400,
                      child: details.profilePath != null
                          ? CachedNetworkImage(
                              imageUrl: '${ApiConstants.imageBaseUrl}${details.profilePath}',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const AppLoading(),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            )
                          : Container(
                              color: AppColors.searchBackground,
                              child: const Icon(Icons.person, size: 100, color: AppColors.textGrey),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            details.name,
                            style: AppTextStyles.heading,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            details.knownForDepartment,
                            style: AppTextStyles.subtitle.copyWith(color: AppColors.primaryBlue),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16, color: AppColors.textGrey),
                              const SizedBox(width: 8),
                              Text(details.birthday ?? 'Unknown', style: AppTextStyles.caption),
                              const SizedBox(width: 16),
                              const Icon(Icons.location_on, size: 16, color: AppColors.textGrey),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  details.placeOfBirth ?? 'Unknown',
                                  style: AppTextStyles.caption,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(AppConstants.about, style: AppTextStyles.title),
                          const SizedBox(height: 8),
                          Text(
                            details.biography.isNotEmpty ? details.biography : 'No biography available.',
                            style: AppTextStyles.body,
                            maxLines: _showFullBiography ? null : 4,
                            overflow: _showFullBiography ? TextOverflow.visible : TextOverflow.ellipsis,
                          ),
                          if (details.biography.isNotEmpty)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _showFullBiography = !_showFullBiography;
                                });
                              },
                              child: Text(
                                _showFullBiography ? AppConstants.showLess : AppConstants.showMore,
                                style: AppTextStyles.body.copyWith(color: AppColors.primaryBlue),
                              ),
                            ),
                          const SizedBox(height: 24),
                          Text(AppConstants.imageGallery, style: AppTextStyles.title),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                final image = images[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppConstants.imageViewerRoute,
                                      arguments: '${ApiConstants.imageBaseUrl}${image.filePath}',
                                    );
                                  },
                                  child: Container(
                                    width: 100,
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider('${ApiConstants.imageBaseUrl}${image.filePath}'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
