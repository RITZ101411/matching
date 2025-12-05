import 'package:flutter/material.dart';
import '../../domain/entities/profile.dart';

class ProfileDetailPage extends StatefulWidget {
  final Profile profile;

  const ProfileDetailPage({super.key, required this.profile});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double _dragOffset = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (_scrollController.hasClients && _scrollController.offset <= 0) {
          setState(() {
            _dragOffset += details.delta.dy;
            if (_dragOffset < 0) _dragOffset = 0;
          });
        }
      },
      onVerticalDragEnd: (details) {
        if (_dragOffset > 100) {
          Navigator.pop(context);
        } else {
          _animation = Tween<double>(begin: _dragOffset, end: 0).animate(
            CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
          )..addListener(() {
              setState(() {
                _dragOffset = _animation.value;
              });
            });
          _animationController.forward(from: 0);
        }
      },
      child: Transform.translate(
        offset: Offset(0, _dragOffset),
        child: Container(
          margin: const EdgeInsets.only(top: 64),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Image.network(widget.profile.imageUrl, height: 400, fit: BoxFit.cover),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${widget.profile.name}, ${widget.profile.age}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          const Text('自己紹介', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text('こんにちは！よろしくお願いします。'),
                          const SizedBox(height: 24),
                          const Text('趣味', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: ['旅行', '映画', '料理'].map((hobby) => Chip(label: Text(hobby))).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 8,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
