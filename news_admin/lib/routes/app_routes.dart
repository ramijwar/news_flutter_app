import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/add_news_article/add_news_article.dart';
import '../presentation/admin_dashboard/admin_dashboard.dart';
import '../presentation/news_feed/news_feed.dart';
import '../presentation/admin_settings/admin_settings.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String addNewsArticle = '/add-news-article';
  static const String adminDashboard = '/admin-dashboard';
  static const String newsFeed = '/news-feed';
  static const String adminSettings = '/admin-settings';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const NewsFeed(),
    loginScreen: (context) => const LoginScreen(),
    addNewsArticle: (context) => const AddNewsArticle(),
    adminDashboard: (context) => const AdminDashboard(),
    newsFeed: (context) => const NewsFeed(),
    adminSettings: (context) => const AdminSettings(),
    // TODO: Add your other routes here
  };
}
