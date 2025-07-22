import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../services/placeholder_data_service.dart';
import '../models/journey_models.dart';
import '../core/research_metrics_provider.dart';
import 'package:provider/provider.dart';

class JourneySelectionScreen extends StatefulWidget {
  const JourneySelectionScreen({super.key});

  @override
  State<JourneySelectionScreen> createState() => _JourneySelectionScreenState();
}

class _JourneySelectionScreenState extends State<JourneySelectionScreen> 
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  List<Journey> _journeys = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _loadJourneys();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadJourneys() {
    setState(() {
      _journeys = PlaceholderDataService.getJourneys();
    });
  }

  Color _getColorFromHex(String colorHex) {
    return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'code': return Icons.code;
      case 'computer': return Icons.computer;
      case 'storage': return Icons.storage;
      case 'account_balance': return Icons.account_balance;
      default: return Icons.school;
    }
  }

  void _onJourneySelected(Journey journey) {
    // Navigate to audio player with journey data
    Navigator.pushNamed(
      context, 
      '/audio_player',
      arguments: journey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Modern app bar
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.backgroundDark,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Choose Your Journey',
                  style: AppTextStyles.heading2.copyWith(fontSize: 18),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primaryBlue.withOpacity(0.1),
                        AppColors.backgroundDark,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Journey grid
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= _journeys.length) return null;
                    
                    final journey = _journeys[index];
                    return _buildJourneyCard(journey, index);
                  },
                  childCount: _journeys.length,
                ),
              ),
            ),

            // Research progress indicator
            SliverToBoxAdapter(
              child: Consumer<ResearchMetricsProvider>(
                builder: (context, research, _) {
                  final completedCount = research.completedJourneys.length;
                  return Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundCard.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryBlue.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Research Progress',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: completedCount / 4, // 4 total journeys
                          backgroundColor: AppColors.backgroundCard,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$completedCount of 4 journeys completed',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJourneyCard(Journey journey, int index) {
    final color = _getColorFromHex(journey.colorHex);
    final icon = _getIconFromName(journey.iconName);
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final animationValue = Curves.easeOutBack.transform(
          ((_animationController.value - (index * 0.1)).clamp(0.0, 1.0)),
        );
        
        return Transform.scale(
          scale: animationValue,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - animationValue)),
            child: Opacity(
              opacity: animationValue,
              child: GestureDetector(
                onTap: () => _onJourneySelected(journey),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withOpacity(0.15),
                        color.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: color.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon and difficulty badge
                      Row(
                        children: [
                          Icon(icon, size: 40, color: color),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              journey.difficulty,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const Spacer(),
                      
                      // Title and description
                      Text(
                        journey.title,
                        style: AppTextStyles.heading2.copyWith(
                          fontSize: 16,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      
                      Text(
                        '${journey.episodeIds.length} episodes • ${(journey.totalDuration / 60).round()} min',
                        style: AppTextStyles.caption.copyWith(
                          color: color.withOpacity(0.8),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Progress indicator
                      Consumer<ResearchMetricsProvider>(
                        builder: (context, research, _) {
                          final isCompleted = research.completedJourneys
                              .any((j) => j['journeyId'] == journey.id);
                          
                          if (isCompleted) {
                            return Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: AppColors.accentGreen,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Completed',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.accentGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            );
                          }
                          
                          return Row(
                            children: [
                              Icon(
                                Icons.play_circle_outline,
                                size: 16,
                                color: color,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Start Journey',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
