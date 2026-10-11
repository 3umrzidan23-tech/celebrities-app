import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_error.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/person_card.dart';
import '../../../../core/utils/responsive_helper.dart';
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
  Timer? _debounce;
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _peopleCubit = sl<PeopleCubit>();
    _peopleCubit.fetchPopularPeople();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(() {
       setState(() {
         _isSearching = _searchController.text.isNotEmpty;
       });
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (_searchController.text.isEmpty) {
        _peopleCubit.fetchMorePopularPeople();
      }
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _peopleCubit.searchPeople(query);
    });
  }
  
  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    _peopleCubit.fetchPopularPeople();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _peopleCubit,
      child: Scaffold(
        appBar: ResponsiveHelper.isCompact(context)
            ? AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {},
                ),
                title: Text(AppConstants.homeTitle, style: AppTextStyles.title),
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
                            padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                            child: Text(AppConstants.homeTitle, style: AppTextStyles.heading),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 600),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      focusNode: _searchFocusNode,
                                      onChanged: _onSearchChanged,
                                      style: AppTextStyles.body,
                                      textInputAction: TextInputAction.search,
                                      onSubmitted: (val) {
                                        _searchFocusNode.unfocus();
                                      },
                                      decoration: InputDecoration(
                                        hintText: AppConstants.searchHint,
                                        hintStyle: AppTextStyles.body.copyWith(color: AppColors.textGrey, fontSize: 14),
                                        prefixIcon: const Icon(Icons.search, color: AppColors.textGrey, size: 20),
                                        suffixIcon: _isSearching
                                            ? IconButton(
                                                icon: const Icon(Icons.close, color: AppColors.textGrey, size: 20),
                                                onPressed: _clearSearch,
                                              )
                                            : null,
                                        filled: true,
                                        fillColor: AppColors.searchBackground,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.searchBackground,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.tune, color: AppColors.textWhite, size: 20),
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Trending People', style: AppTextStyles.title),
                              Text('See all', style: AppTextStyles.body.copyWith(color: AppColors.lightBlue, fontSize: 12)),
                            ],
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
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'AI Assistant'),
                  BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorites'),
                ],
              )
            : null,
      ),
    );
  }

  void _onNavigationTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 1) {
      Navigator.pushNamed(context, AppConstants.aiAssistantRoute);
    } else if (index == 2) {
      Navigator.pushNamed(context, AppConstants.favoritesRoute);
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
        NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
        NavigationRailDestination(icon: Icon(Icons.chat_bubble_outline), label: Text('AI')),
        NavigationRailDestination(icon: Icon(Icons.favorite_border), label: Text('Favorites')),
      ],
    );
  }

  Widget _buildGrid(List people, bool hasReachedMax) {
    if (people.isEmpty) {
      return Center(
        child: Text('No people found.', style: AppTextStyles.body),
      );
    }
    
    final columns = ResponsiveHelper.getGridColumns(context);
    
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, favoritesState) {
        return GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: hasReachedMax ? people.length : people.length + columns,
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
