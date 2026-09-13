import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'constants/app_colors.dart';
import 'injection_container.dart';
import 'pages/categories_tab.dart';
import 'pages/contact_tab.dart';
import 'pages/home_screen.dart';
import 'presentation/blocs/categories/categories_bloc.dart';
import 'presentation/blocs/categories/categories_event.dart';
import 'presentation/blocs/gold_rates/gold_rates_bloc.dart';
import 'presentation/blocs/gold_rates/gold_rates_event.dart';
import 'presentation/blocs/jewellery/jewellery_bloc.dart';
import 'presentation/blocs/jewellery/jewellery_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.init();
  runApp(const KrishnaJewellersApp());
}

class KrishnaJewellersApp extends StatelessWidget {
  const KrishnaJewellersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GoldRatesBloc>(
          create: (_) => ServiceLocator.createGoldRatesBloc()
            ..add(StartGoldRatesStream()),
        ),
        BlocProvider<CategoriesBloc>(
          create: (_) => ServiceLocator.createCategoriesBloc()
            ..add(LoadCategoriesEvent()),
        ),
        BlocProvider<JewelleryBloc>(
          create: (_) => ServiceLocator.createJewelleryBloc()
            ..add(const LoadJewelleryEvent(category: 'All')),
        ),
      ],
      child: MaterialApp(
        title: 'Krishna Jewellers',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.white,
          primaryColor: AppColors.gold,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.gold,
            primary: AppColors.gold,
            secondary: AppColors.goldDark,
            surface: AppColors.white,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.black,
            foregroundColor: AppColors.gold,
            elevation: 0,
          ),
        ),
        home: const MainNavigationShell(),
      ),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    CategoriesTab(),
    ContactTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.black,
          border: Border(top: BorderSide(color: Color(0x66D4AF37), width: 1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (idx) => setState(() => _currentIndex = idx),
          backgroundColor: AppColors.black,
          selectedItemColor: AppColors.gold,
          unselectedItemColor: const Color(0xFF888888),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              activeIcon: Icon(Icons.storefront),
              label: 'Store & Contact',
            ),
          ],
        ),
      ),
    );
  }
}
