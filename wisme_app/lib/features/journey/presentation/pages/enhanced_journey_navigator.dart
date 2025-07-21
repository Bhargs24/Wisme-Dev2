import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/learning_journey.dart';
import '../../../../models/episode.dart';
import '../../../../shared/components/modern_card.dart';
import '../../../audio/presentation/pages/enhanced_audio_player_system.dart';
import 'journey_completion_screen.dart';

class EnhancedJourneyNavigator extends StatefulWidget {
  final LearningJourney journey;
  final Function(LearningJourney) onJourneyUpdate;
  
  const EnhancedJourneyNavigator({
    super.key,
    required this.journey,
    required this.onJourneyUpdate,
  });

  @override
  State<EnhancedJourneyNavigator> createState() => _EnhancedJourneyNavigatorState();
}

class _EnhancedJourneyNavigatorState extends State<EnhancedJourneyNavigator> {
  late LearningJourney _currentJourney;

  @override
  void initState() {
    super.initState();
    _currentJourney = widget.journey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WismeColors.backgroundSecondary,
      appBar: AppBar(
        title: Text(_currentJourney.title),
        backgroundColor: WismeColors.surface,
        foregroundColor: WismeColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showJourneyInfo,
          ),
        ],
      ),
      body: Column(
        children: [
          // Journey Progress Header
          _buildJourneyProgress(),
          
          // Current Episode Card
          _buildCurrentEpisodeCard(),
          
          // Episode List
          Expanded(
            child: _buildEpisodeList(),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyProgress() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: WismeColors.surface,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Episode ${_currentJourney.currentEpisodeIndex + 1} of ${_currentJourney.episodes.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: WismeColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '${(_currentJourney.completionPercentage * 100).toInt()}% Complete',
                style: const TextStyle(
                  fontSize: 14,
                  color: WismeColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: _currentJourney.completionPercentage,
            backgroundColor: WismeColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(
              _currentJourney.isCompleted 
                ? WismeColors.success
                : WismeColors.primaryBlue,
            ),
          ),
          if (_currentJourney.isCompleted) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.celebration,
                  color: WismeColors.success,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Journey Complete! ${_currentJourney.rewardIcon} Badge Earned',
                  style: const TextStyle(
                    color: WismeColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrentEpisodeCard() {
    if (_currentJourney.isCompleted) {
      return _buildCompletionCard();
    }

    final currentEpisode = _currentJourney.currentEpisode;
    if (currentEpisode == null) return const SizedBox();

    return Container(
      margin: const EdgeInsets.all(16),
      child: ModernCard(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: WismeColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'UP NEXT',
                      style: TextStyle(
                        color: WismeColors.primaryBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${currentEpisode.durationMinutes} min',
                    style: const TextStyle(
                      color: WismeColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                currentEpisode.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: WismeColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                currentEpisode.content,
                style: const TextStyle(
                  fontSize: 14,
                  color: WismeColors.textSecondary,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => _playEpisode(currentEpisode),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Continue Learning'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WismeColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
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

  Widget _buildCompletionCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: ModernCard(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.celebration,
                color: WismeColors.success,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Journey Complete!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: WismeColors.success,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You\'ve earned the ${_currentJourney.rewardBadge?.toUpperCase() ?? 'LEARNER'} badge!',
                style: const TextStyle(
                  fontSize: 16,
                  color: WismeColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _showCompletionCelebration,
                  icon: const Icon(Icons.emoji_events),
                  label: const Text('View Achievement'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WismeColors.success,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
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

  Widget _buildEpisodeList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _currentJourney.episodes.length,
      itemBuilder: (context, index) {
        final episode = _currentJourney.episodes[index];
        final isCurrentEpisode = index == _currentJourney.currentEpisodeIndex;
        final isUnlocked = index <= _currentJourney.currentEpisodeIndex;
        
        return _buildEpisodeListItem(episode, index, isCurrentEpisode, isUnlocked);
      },
    );
  }

  Widget _buildEpisodeListItem(
    Episode episode,
    int index,
    bool isCurrentEpisode,
    bool isUnlocked,
  ) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (episode.isCompleted) {
      statusColor = WismeColors.success;
      statusIcon = Icons.check_circle;
      statusText = 'Completed';
    } else if (episode.isInProgress) {
      statusColor = WismeColors.warning;
      statusIcon = Icons.play_circle;
      statusText = '${(episode.completionPercentage * 100).toInt()}% Complete';
    } else if (isUnlocked) {
      statusColor = WismeColors.primaryBlue;
      statusIcon = Icons.play_circle_outline;
      statusText = 'Ready to start';
    } else {
      statusColor = WismeColors.textSecondary;
      statusIcon = Icons.lock_outline;
      statusText = 'Locked';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ModernCard(
        backgroundColor: isCurrentEpisode 
          ? WismeColors.primaryBlue.withOpacity(0.05)
          : null,
        child: InkWell(
          onTap: isUnlocked ? () => _playEpisode(episode) : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: episode.isCompleted
                      ? Icon(
                          Icons.check,
                          color: statusColor,
                          size: 20,
                        )
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        episode.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isUnlocked 
                            ? WismeColors.textPrimary 
                            : WismeColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            statusIcon,
                            size: 14,
                            color: statusColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 12,
                              color: statusColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${episode.durationMinutes} min',
                            style: const TextStyle(
                              fontSize: 12,
                              color: WismeColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _playEpisode(Episode episode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnhancedAudioPlayerSystem(
          episode: {
            'title': episode.title,
            'content': episode.content,
            'category': episode.category,
            'knowledgeType': episode.knowledgeType,
            'audioUrl': episode.audioUrl,
          },
          coachName: episode.coachPersonality,
          onCompleted: () => _onEpisodeComplete(episode),
        ),
      ),
    );
  }

  void _onEpisodeComplete(Episode episode) {
    setState(() {
      // Mark episode as completed
      final episodeIndex = _currentJourney.episodes.indexWhere((e) => e.id == episode.id);
      if (episodeIndex != -1) {
        _currentJourney.episodes[episodeIndex] = episode.copyWith(
          isCompleted: true,
          completionPercentage: 1.0,
        );

        // Update journey progress
        final completedCount = _currentJourney.episodes.where((e) => e.isCompleted).length;
        final newCompletionPercentage = completedCount / _currentJourney.episodes.length;
        final isJourneyComplete = newCompletionPercentage >= 1.0;

        // Advance to next episode if not completed
        int newCurrentEpisodeIndex = _currentJourney.currentEpisodeIndex;
        if (!isJourneyComplete && episodeIndex == _currentJourney.currentEpisodeIndex) {
          newCurrentEpisodeIndex = episodeIndex + 1;
        }

        _currentJourney = _currentJourney.copyWith(
          completionPercentage: newCompletionPercentage,
          currentEpisodeIndex: newCurrentEpisodeIndex,
          isCompleted: isJourneyComplete,
          completedAt: isJourneyComplete ? DateTime.now() : null,
          rewardBadge: isJourneyComplete ? _getBadgeForJourney() : null,
        );

        // Call update callback
        widget.onJourneyUpdate(_currentJourney);

        // Show completion celebration if journey is complete
        if (isJourneyComplete) {
          Future.delayed(const Duration(milliseconds: 500), () {
            _showCompletionCelebration();
          });
        }
      }
    });
  }

  String _getBadgeForJourney() {
    switch (_currentJourney.knowledgeType.toLowerCase()) {
      case 'beginner':
        return 'beginner';
      case 'intermediate':
        return 'intermediate';
      case 'advanced':
        return 'advanced';
      case 'expert':
        return 'expert';
      default:
        return 'learner';
    }
  }

  void _showCompletionCelebration() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JourneyCompletionScreen(
          journey: _currentJourney,
        ),
      ),
    );
  }

  void _showJourneyInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_currentJourney.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_currentJourney.description),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.schedule, size: 16),
                const SizedBox(width: 8),
                Text('${_currentJourney.formattedDuration} total'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.school, size: 16),
                const SizedBox(width: 8),
                Text(_currentJourney.knowledgeType.toUpperCase()),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.play_circle, size: 16),
                const SizedBox(width: 8),
                Text('${_currentJourney.episodes.length} episodes'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
