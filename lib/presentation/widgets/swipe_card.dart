import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/profile.dart';
import '../providers/swipe_provider.dart';
import '../pages/profile_detail_page.dart';

class SwipeCard extends StatefulWidget {
  final Profile profile;
  final bool isInteractive;

  const SwipeCard({
    super.key,
    required this.profile,
    this.isInteractive = true,
  });

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> with SingleTickerProviderStateMixin {
  double _dragX = 0;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateSwipe(bool isLike) async {
    final screenWidth = MediaQuery.of(context).size.width;
    final targetX = isLike ? screenWidth * 1.5 : -screenWidth * 1.5;
    
    setState(() => _isAnimating = true);
    
    _animation = Tween<double>(begin: _dragX, end: targetX).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() {
        if (mounted) {
          setState(() {
            _dragX = _animation.value;
          });
        }
      });
    
    await _controller.forward();
    
    if (mounted) {
      if (isLike) {
        context.read<SwipeProvider>().like();
      } else {
        context.read<SwipeProvider>().skip();
      }
      _controller.reset();
      if (mounted) {
        setState(() {
          _dragX = 0;
          _isAnimating = false;
        });
      }
    }
  }

  void _animateBack() async {
    setState(() => _isAnimating = true);
    
    _animation = Tween<double>(begin: _dragX, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() {
        if (mounted) {
          setState(() {
            _dragX = _animation.value;
          });
        }
      });

    await _controller.forward(from: 0);
    
    if (mounted) {
      setState(() {
        _isAnimating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isInteractive) {
      return _buildCard();
    }

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return ProfileDetailPage(profile: widget.profile);
          },
        );
      },
      onPanUpdate: (details) {
        if (!_isAnimating) {
          setState(() {
            _dragX += details.delta.dx;
          });
        }
      },
      onPanEnd: (details) {
        if (!_isAnimating) {
          if (_dragX.abs() > 100) {
            _animateSwipe(_dragX > 0);
          } else {
            _animateBack();
          }
        }
      },
      child: Transform.translate(
        offset: Offset(_dragX, 0),
        child: _buildCard(),
      ),
    );
  }

  Widget _buildCard() {
    return Card(
      margin: const EdgeInsets.all(20),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Image.network(
            widget.profile.imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.profile.name}, ${widget.profile.age}',
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  if (widget.isInteractive) ...[
                    const SizedBox(height: 4),
                    const Text('タップで詳細', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ],
              ),
            ),
          ),
          if (widget.isInteractive && _dragX > 50)
            Positioned(
              top: 50,
              left: 50,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('LIKE', style: TextStyle(color: Colors.green, fontSize: 32, fontWeight: FontWeight.bold)),
              ),
            ),
          if (widget.isInteractive && _dragX < -50)
            Positioned(
              top: 50,
              right: 50,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('SKIP', style: TextStyle(color: Colors.red, fontSize: 32, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }
}
