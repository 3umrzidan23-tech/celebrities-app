import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../injection_container.dart';
import '../cubit/ai_cubit.dart';
import '../cubit/ai_state.dart';
import '../widgets/chat_bubble.dart';

class AiAssistantPage extends StatefulWidget {
  const AiAssistantPage({super.key});

  @override
  State<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends State<AiAssistantPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final int _currentIndex = 1;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(BuildContext context) {
    final text = _controller.text;
    if (text.trim().isNotEmpty) {
      context.read<AiCubit>().sendUserMessage(text);
      _controller.clear();
    }
  }

  void _onNavigationTap(int index) {
    if (index == _currentIndex) return;
    if (index == 0) {
      Navigator.pushReplacementNamed(context, AppConstants.homeRoute);
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, AppConstants.favoritesRoute);
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

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: AppTextStyles.body.copyWith(color: AppColors.textWhite),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: AppTextStyles.body.copyWith(color: AppColors.textGrey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onSubmitted: (_) => _sendMessage(context),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppColors.primaryBlue,
            child: IconButton(
              icon: const Icon(Icons.send, color: AppColors.textWhite),
              onPressed: () => _sendMessage(context),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = ResponsiveHelper.isCompact(context);
    return BlocProvider(
      create: (_) => sl<AiCubit>(),
      child: Scaffold(
        appBar: isCompact
            ? AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {},
                ),
                title: Text(AppConstants.aiAssistant, style: AppTextStyles.title),
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
              if (!isCompact) _buildSideNavigation(),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxContentWidth()),
                    child: Builder(
                      builder: (context) {
                        return Column(
                          children: [
                            if (!isCompact)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24.0),
                                child: Text(AppConstants.aiAssistant, style: AppTextStyles.heading),
                              ),
                            Expanded(
                              child: BlocBuilder<AiCubit, AiState>(
                                builder: (context, state) {
                                  final messages = state is AiLoading
                                      ? state.messages
                                      : state is AiLoaded
                                          ? state.messages
                                          : state is AiError
                                              ? state.messages
                                              : [];
                
                                  if (messages.isEmpty) {
                                    return Center(
                                      child: Text(
                                        'How can I help you today?',
                                        style: AppTextStyles.body,
                                      ),
                                    );
                                  }
                
                                  return ListView.builder(
                                    reverse: true,
                                    controller: _scrollController,
                                    itemCount: messages.length,
                                    itemBuilder: (context, index) {
                                      return ChatBubble(message: messages[index]);
                                    },
                                  );
                                },
                              ),
                            ),
                            BlocBuilder<AiCubit, AiState>(
                              builder: (context, state) {
                                if (state is AiLoading) {
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(color: AppColors.primaryBlue),
                                  );
                                } else if (state is AiError) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      state.errorMessage,
                                      style: AppTextStyles.body.copyWith(color: AppColors.accentRed),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                            _buildMessageInput(context),
                          ],
                        );
                      }
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: isCompact
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
      ),
    );
  }
}
