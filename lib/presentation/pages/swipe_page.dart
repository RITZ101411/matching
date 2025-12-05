import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/swipe_provider.dart';
import '../widgets/swipe_card.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({super.key});

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;
  int _lastIndex = -1;
  bool _isSliding = false;
  bool _slideFromRight = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SwipeProvider>().loadProfiles();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('発見')),
      body: Consumer<SwipeProvider>(
        builder: (context, provider, _) {
          if (provider.profiles.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final currentIndex = provider.currentIndex;
          if (currentIndex >= provider.profiles.length) {
            return const Center(child: Text('プロフィールがありません'));
          }

          if (_lastIndex != currentIndex && _lastIndex != -1) {
            _slideFromRight = !provider.wasLiked;
            _slideAnimation = Tween<double>(
              begin: _slideFromRight ? 1.0 : -1.0,
              end: 0.0,
            ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
            
            _isSliding = true;
            _slideController.forward(from: 0).then((_) {
              setState(() {
                _isSliding = false;
              });
            });
          }
          _lastIndex = currentIndex;

          final screenWidth = MediaQuery.of(context).size.width;

          return Stack(
            children: [
              if (_isSliding)
                AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(screenWidth * _slideAnimation.value, 0),
                      child: child,
                    );
                  },
                  child: SwipeCard(
                    profile: provider.profiles[currentIndex],
                    isInteractive: false,
                  ),
                )
              else
                SwipeCard(
                  profile: provider.profiles[currentIndex],
                  isInteractive: true,
                ),
            ],
          );
        },
      ),
    );
  }
}
