import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/premium_card.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = const [
    OnboardingPage(
      title: 'Música Terapéutica\nProfesional',
      subtitle:
          'Accede a una biblioteca curada de composiciones diseñadas específicamente para uso terapéutico',
      icon: Icons.music_note,
      gradient: AppTheme.primaryGradient,
    ),
    OnboardingPage(
      title: 'Organizada por\nCategorías',
      subtitle:
          'Encuentra rápidamente la música perfecta para cada sesión según técnica y objetivo terapéutico',
      icon: Icons.category_outlined,
      gradient: LinearGradient(
        colors: [AppTheme.secondaryColor, AppTheme.primaryColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    OnboardingPage(
      title: 'Disponible\nCuando Necesites',
      subtitle:
          'Streaming de alta calidad siempre disponible. Reproduce durante tus sesiones sin interrupciones',
      icon: Icons.cloud_done_outlined,
      gradient: LinearGradient(
        colors: [AppTheme.accentColor, Color(0xFF059669)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    OnboardingPage(
      title: 'Comienza Tu Prueba\nGratuita',
      subtitle:
          '14 días de acceso completo sin costo. Cancela cuando quieras, sin compromisos',
      icon: Icons.verified_user_outlined,
      gradient: LinearGradient(
        colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _completeOnboarding() {
    Navigator.of(context).pushReplacementNamed('/register');
  }

  void _skip() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _skip,
                  child: const Text(
                    'Omitir',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index], size);
                  },
                ),
              ),

              // Page indicator
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 32 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppTheme.primaryColor
                            : AppTheme.textTertiaryColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),

              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      Expanded(
                        child: PremiumOutlinedButton(
                          text: 'Anterior',
                          onPressed: _previousPage,
                        ),
                      ),
                    if (_currentPage > 0) const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: PremiumButton(
                        text: _currentPage == _pages.length - 1
                            ? 'Comenzar'
                            : 'Siguiente',
                        onPressed: _nextPage,
                        enableGlow: _currentPage == _pages.length - 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page, Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with gradient background
          Container(
            width: size.width * 0.5,
            height: size.width * 0.5,
            decoration: BoxDecoration(
              gradient: page.gradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Icon(
              page.icon,
              size: size.width * 0.25,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),

          // Title
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimaryColor,
              height: 1.2,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Subtitle
          Text(
            page.subtitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondaryColor,
              height: 1.5,
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;

  const OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}
