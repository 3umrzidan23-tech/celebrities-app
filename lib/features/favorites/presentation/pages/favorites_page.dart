import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/person_card.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.favorites, style: AppTextStyles.title),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
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
              return const AppEmptyState(
                title: AppConstants.noFavoritesYet,
                description: AppConstants.noFavoritesDesc,
                icon: Icons.favorite_border,
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == _currentIndex) return;
          
          if (index == 0) {
            Navigator.pushReplacementNamed(context, AppConstants.homeRoute);
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, AppConstants.aiAssistantRoute);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'AI Assistant'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), activeIcon: Icon(Icons.favorite), label: 'Favorites'),
        ],
      ),
    );
  }
}
