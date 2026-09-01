import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_error.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/person_card.dart';
import '../../../../injection_container.dart';
import '../../../favorites/presentation/cubit/favorites_cubit.dart';
import '../../../favorites/presentation/cubit/favorites_state.dart';
import '../cubit/people_cubit.dart';
import '../cubit/people_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late PeopleCubit _peopleCubit;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _peopleCubit = sl<PeopleCubit>();
    _peopleCubit.fetchPopularPeople();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (_searchController.text.isEmpty) {
        _peopleCubit.fetchMorePopularPeople();
      }
    }
  }

  void _onSearchChanged(String query) {
    _peopleCubit.searchPeople(query);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _peopleCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(AppConstants.homeTitle, style: AppTextStyles.title),
              Text(AppConstants.homeSubtitle, style: AppTextStyles.subtitle.copyWith(color: AppColors.primaryBlue)),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  hintText: AppConstants.searchHint,
                  hintStyle: AppTextStyles.body.copyWith(color: AppColors.textGrey),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
                  filled: true,
                  fillColor: AppColors.searchBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<PeopleCubit, PeopleState>(
                builder: (context, state) {
                  if (state is PeopleLoading && _searchController.text.isEmpty) {
                    return const AppLoading();
                  } else if (state is SearchLoading) {
                    return const AppLoading();
                  } else if (state is PeopleError) {
                    return AppError(
                      message: state.message,
                      onRetry: () => _searchController.text.isEmpty
                          ? _peopleCubit.fetchPopularPeople()
                          : _peopleCubit.searchPeople(_searchController.text),
                    );
                  } else if (state is PeopleLoaded) {
                    return _buildGrid(state.people, state.hasReachedMax);
                  } else if (state is SearchLoaded) {
                    return _buildGrid(state.searchResults, true);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if (index == 1) {
              Navigator.pushNamed(context, AppConstants.aiAssistantRoute);
            } else if (index == 2) {
              Navigator.pushNamed(context, AppConstants.favoritesRoute);
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'AI Assistant'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorites'),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(List people, bool hasReachedMax) {
    if (people.isEmpty) {
      return Center(
        child: Text('No people found.', style: AppTextStyles.body),
      );
    }
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, favoritesState) {
        return GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: hasReachedMax ? people.length : people.length + 2,
          itemBuilder: (context, index) {
            if (index >= people.length) {
              return const Center(child: AppLoading());
            }
            final person = people[index];
            final isFavorite = context.read<FavoritesCubit>().isFavorite(person.id);
            return PersonCard(
              id: person.id,
              name: person.name,
              knownFor: person.knownForDepartment,
              profilePath: person.profilePath,
              isFavorite: isFavorite,
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
      },
    );
  }
}
