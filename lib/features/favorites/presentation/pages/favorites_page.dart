import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/person_card.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().loadFavorites();
  }

  void _onNavigationTap(int index) {
    if (index == _currentIndex) return;
    if (index == 0) {
      Navigator.pushReplacementNamed(context, AppConstants.homeRoute);
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, AppConstants.aiAssistantRoute);
    }
  }

  Widget _buildSideNavigation() {
    return NavigationRail(
      selectedIndex: _currentIndex,
      onDestinationSelected: _onNavigationTap,
      backgroundColor: AppColors.navBarBackground,
      unselectedIconTheme: const IconThemeData(color: AppColors.textGrey),
      selectedIconTheme: const IconThemeData(color: AppColors.lightBlue),
      unselectedLabelTextStyle: AppTextStyles.caption,
      selectedLabelTextStyle: AppTextStyles.caption.copyWith(color: AppColors.lightBlue),
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text('Home')),
        NavigationRailDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: Text('AI')),
        NavigationRailDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: Text('Favorites')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isCompact(context)
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {},
              ),
              title: Text(AppConstants.favorites, style: AppTextStyles.title),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                ),
              ],
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            if (!ResponsiveHelper.isCompact(context)) _buildSideNavigation(),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxContentWidth()),
                  child: Column(
                    children: [
                      if (!ResponsiveHelper.isCompact(context))
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Text(AppConstants.favorites, style: AppTextStyles.heading),
                        ),
                      Expanded(
                        child: BlocBuilder<FavoritesCubit, FavoritesState>(
                          builder: (context, state) {
                            if (state is FavoritesLoading) {
                              return const AppLoading();
                            } else if (state is FavoritesError) {
                              return AppError(
                                message: state.message,
                                onRetry: () => context.read<FavoritesCubit>().loadFavorites(),
                              );
                            } else if (state is FavoritesLoaded) {
                              if (state.favorites.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const AppEmptyState(
                                        title: AppConstants.noFavoritesYet,
                                        description: AppConstants.noFavoritesDesc,
                                        icon: Icons.favorite_border,
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () => Navigator.pushReplacementNamed(context, AppConstants.homeRoute),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primaryBlue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text('Go to Discovery', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              final columns = ResponsiveHelper.getGridColumns(context);
                              return GridView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columns,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemCount: state.favorites.length,
                                itemBuilder: (context, index) {
                                  final person = state.favorites[index];
                                  return PersonCard(
                                    id: person.id,
                                    name: person.name,
                                    knownFor: person.knownForDepartment,
                                    profilePath: person.profilePath,
                                    isFavorite: true,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppConstants.detailsRoute,
                                        arguments: person.id,
                                      );
                                    },
                                    onFavoriteToggle: () {
                                      context.read<FavoritesCubit>().toggleFavorite(person);
                                    },
                                  );
                                },
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ResponsiveHelper.isCompact(context)
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onNavigationTap,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'AI Assistant'),
                BottomNavigationBarItem(icon: Icon(Icons.favorite_border), activeIcon: Icon(Icons.favorite), label: 'Favorites'),
              ],
            )
          : null,
    );
  }
}
