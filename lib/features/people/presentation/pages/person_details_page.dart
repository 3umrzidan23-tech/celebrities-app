import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_error.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../injection_container.dart';
import '../../../favorites/presentation/cubit/favorites_cubit.dart';
import '../../../favorites/presentation/cubit/favorites_state.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/person_details.dart';
import '../../domain/entities/person_image.dart';
import '../../domain/entities/person_credit.dart';
import '../cubit/person_details_cubit.dart';
import '../cubit/person_details_state.dart';

class PersonDetailsPage extends StatefulWidget {
  final int personId;
  const PersonDetailsPage({super.key, required this.personId});

  @override
  State<PersonDetailsPage> createState() => _PersonDetailsPageState();
}

class _PersonDetailsPageState extends State<PersonDetailsPage> with SingleTickerProviderStateMixin {
  late PersonDetailsCubit _cubit;
  late TabController _tabController;
  bool _showFullBiography = false;

  @override
  void initState() {
    super.initState();
    _cubit = sl<PersonDetailsCubit>();
    _cubit.fetchPersonDetails(widget.personId);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildMobileHeader(PersonDetails details) {
    return Stack(
      children: [
        SizedBox(
          height: 400,
          width: double.infinity,
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
        Container(
          height: 400,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.transparent,
                AppColors.background.withValues(alpha: 0.8),
                AppColors.background,
              ],
              stops: const [0.0, 0.3, 0.8, 1.0],
            ),
          ),
        ),
        Positioned(
          bottom: 24,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    details.name,
                    style: AppTextStyles.heading.copyWith(fontSize: 28),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    details.popularity.toStringAsFixed(1),
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    details.knownForDepartment,
                    style: AppTextStyles.title.copyWith(color: AppColors.textGrey, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          child: _buildBackButton(),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          right: 16,
          child: _buildActionButtons(details),
        ),
      ],
    );
  }

  Widget _buildWideLeftPane(PersonDetails details) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBackButton(),
              _buildActionButtons(details),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: double.infinity,
              height: 450,
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
          ),
          const SizedBox(height: 24),
          Text(details.name, style: AppTextStyles.heading.copyWith(fontSize: 32)),
          const SizedBox(height: 8),
          Text(details.knownForDepartment, style: AppTextStyles.title.copyWith(color: AppColors.lightBlue)),
          const SizedBox(height: 32),
          Text('Personal Info', style: AppTextStyles.title),
          const SizedBox(height: 16),
          _buildInfoCard(Icons.cake, 'Birthday', details.birthday ?? 'Unknown'),
          _buildInfoCard(Icons.location_on, 'Place of Birth', details.placeOfBirth ?? 'Unknown'),
          _buildInfoCard(Icons.work, 'Known For', details.knownForDepartment),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _buildActionButtons(PersonDetails details) {
    return Row(
      children: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.share, color: Colors.white),
          ),
          onPressed: () {
            // Implement share functionality
          },
        ),
        BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, favoritesState) {
            final isFavorite = context.read<FavoritesCubit>().isFavorite(details.id);
            return IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.accentRed : Colors.white,
                ),
              ),
              onPressed: () {
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
        ),
      ],
    );
  }

  Widget _buildOverviewTab(PersonDetails details, List<PersonCredit> credits, {bool isWide = false}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isWide) ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Known for', style: AppTextStyles.caption.copyWith(color: AppColors.textGrey)),
                      const SizedBox(height: 4),
                      Text(details.knownForDepartment, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date of Birth', style: AppTextStyles.caption.copyWith(color: AppColors.textGrey)),
                      const SizedBox(height: 4),
                      Text(details.birthday ?? 'Unknown', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
          if (details.biography.isNotEmpty) ...[
            Text(
              details.biography,
              style: AppTextStyles.body.copyWith(color: AppColors.textGrey, height: 1.5),
              maxLines: _showFullBiography ? null : 4,
              overflow: _showFullBiography ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showFullBiography = !_showFullBiography;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _showFullBiography ? AppConstants.showLess : AppConstants.showMore,
                  style: AppTextStyles.body.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (credits.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Movies', style: AppTextStyles.title),
                Text('See all', style: AppTextStyles.body.copyWith(color: AppColors.lightBlue, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: credits.where((c) => c.mediaType == 'movie').length,
                itemBuilder: (context, index) {
                  final movie = credits.where((c) => c.mediaType == 'movie').toList()[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 110,
                        child: movie.posterPath != null
                            ? CachedNetworkImage(
                                imageUrl: '${ApiConstants.imageBaseUrl}${movie.posterPath}',
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(color: AppColors.searchBackground),
                                errorWidget: (context, url, error) => Container(color: AppColors.searchBackground, child: const Icon(Icons.movie, color: AppColors.textGrey)),
                              )
                            : Container(
                                color: AppColors.searchBackground,
                                child: const Icon(Icons.movie, color: AppColors.textGrey),
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.searchBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.lightBlue, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.textGrey)),
                const SizedBox(height: 4),
                Text(value, style: AppTextStyles.body),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosTab(List<PersonImage> images) {
    if (images.isEmpty) {
      return Center(
        child: Text('No photos available.', style: AppTextStyles.body),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.isCompact(context) ? 3 : 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.7,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppConstants.imageViewerRoute,
              arguments: {
                'images': images.map((img) => '${ApiConstants.imageBaseUrl}${img.filePath}').toList(),
                'initialIndex': index,
              },
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: '${ApiConstants.imageBaseUrl}${image.filePath}',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: AppColors.searchBackground),
              errorWidget: (context, url, error) => Container(color: AppColors.searchBackground, child: const Icon(Icons.error)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCreditsTab(List<PersonCredit> credits) {
    if (credits.isEmpty) {
      return Center(
        child: Text('No credits available.', style: AppTextStyles.body),
      );
    }

    // De-duplicate credits by ID
    final uniqueCredits = <int, PersonCredit>{};
    for (var credit in credits) {
      uniqueCredits[credit.id] = credit;
    }
    final deduplicatedCredits = uniqueCredits.values.toList();
    
    // Sort by release date descending
    deduplicatedCredits.sort((a, b) {
      if (a.releaseDate == null && b.releaseDate == null) return 0;
      if (a.releaseDate == null) return 1;
      if (b.releaseDate == null) return -1;
      if (a.releaseDate!.isEmpty) return 1;
      if (b.releaseDate!.isEmpty) return -1;
      return b.releaseDate!.compareTo(a.releaseDate!);
    });

    final movies = deduplicatedCredits.where((c) => c.mediaType == 'movie').toList();
    final tvShows = deduplicatedCredits.where((c) => c.mediaType == 'tv').toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (movies.isNotEmpty) ...[
          Text('Movies', style: AppTextStyles.title),
          const SizedBox(height: 16),
          ...movies.map((c) => _buildCreditItem(c)),
          const SizedBox(height: 24),
        ],
        if (tvShows.isNotEmpty) ...[
          Text('TV Shows', style: AppTextStyles.title),
          const SizedBox(height: 16),
          ...tvShows.map((c) => _buildCreditItem(c)),
        ],
      ],
    );
  }

  Widget _buildCreditItem(PersonCredit credit) {
    String year = '';
    if (credit.releaseDate != null && credit.releaseDate!.length >= 4) {
      year = credit.releaseDate!.substring(0, 4);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 60,
              height: 90,
              child: credit.posterPath != null
                  ? CachedNetworkImage(
                      imageUrl: '${ApiConstants.imageBaseUrl}${credit.posterPath}',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: AppColors.searchBackground),
                      errorWidget: (context, url, error) => Container(color: AppColors.searchBackground, child: const Icon(Icons.movie, color: AppColors.textGrey)),
                    )
                  : Container(
                      color: AppColors.searchBackground,
                      child: const Icon(Icons.movie, color: AppColors.textGrey),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(credit.title, style: AppTextStyles.subtitle),
                const SizedBox(height: 4),
                if (year.isNotEmpty) Text(year, style: AppTextStyles.caption.copyWith(color: AppColors.textGrey)),
                const SizedBox(height: 4),
                Text(credit.role, style: AppTextStyles.body.copyWith(color: AppColors.lightBlue)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(PersonDetailsLoaded state) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: _buildMobileHeader(state.details),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primaryBlue,
                labelColor: AppColors.textWhite,
                unselectedLabelColor: AppColors.textGrey,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Photos'),
                  Tab(text: 'Credits'),
                ],
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(state.details, state.credits, isWide: false),
          _buildPhotosTab(state.images),
          _buildCreditsTab(state.credits),
        ],
      ),
    );
  }

  Widget _buildWideLayout(PersonDetailsLoaded state) {
    return SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: AppColors.navBarBackground, // differentiate side pane slightly
              child: _buildWideLeftPane(state.details),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.primaryBlue,
                  labelColor: AppColors.textWhite,
                  unselectedLabelColor: AppColors.textGrey,
                  tabs: const [
                    Tab(text: 'Biography'),
                    Tab(text: 'Photos'),
                    Tab(text: 'Credits'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverviewTab(state.details, state.credits, isWide: true),
                      _buildPhotosTab(state.images),
                      _buildCreditsTab(state.credits),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
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
              final isCompact = ResponsiveHelper.isCompact(context);
              return isCompact ? _buildMobileLayout(state) : _buildWideLayout(state);
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: _cubit.state is PersonDetailsLoaded 
            ? FloatingActionButton(
                onPressed: () {
                  final details = (_cubit.state as PersonDetailsLoaded).details;
                  Navigator.pushNamed(
                    context,
                    AppConstants.aiAssistantRoute,
                    arguments: 'Tell me about ${details.name}',
                  );
                },
                backgroundColor: AppColors.primaryBlue,
                child: const Icon(Icons.auto_awesome, color: Colors.white),
              )
            : null,
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.background,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
