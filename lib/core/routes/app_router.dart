import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../../features/people/presentation/pages/home_page.dart';
import '../../features/people/presentation/pages/person_details_page.dart';
import '../../features/image_viewer/presentation/views/image_viewer_screen.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/ai_assistant/presentation/pages/ai_assistant_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppConstants.detailsRoute:
        final personId = settings.arguments as int;
        return MaterialPageRoute(builder: (_) => PersonDetailsPage(personId: personId));
      case AppConstants.imageViewerRoute:
        final imageUrl = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ImageViewerScreen(imageUrl: imageUrl));
      case AppConstants.favoritesRoute:
        return MaterialPageRoute(builder: (_) => const FavoritesPage());
      case AppConstants.aiAssistantRoute:
        return MaterialPageRoute(builder: (_) => const AiAssistantPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
