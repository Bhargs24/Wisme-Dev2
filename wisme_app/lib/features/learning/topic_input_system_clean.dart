import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Advanced Topic Input System with Personalization Context
/// Enhanced with AI-powered suggestions and real-time classification
class TopicInputSystem extends StatefulWidget {
  final Function(String topic, String? personalContext) onTopicSubmitted;
  final bool showBackButton;

  const TopicInputSystem({
    super.key,
    required this.onTopicSubmitted,
    this.showBackButton = false,
  });

  @override
  State<TopicInputSystem> createState() => _TopicInputSystemState();
}

class _TopicInputSystemState extends State<TopicInputSystem> 
    with TickerProviderStateMixin {
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _contextController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _contextFocusNode = FocusNode();
  
  bool _isProcessing = false;
  bool _showSuggestions = false;
  bool _showContextField = false;
  String _currentInput = '';
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> _topicSuggestions = [
    'Machine Learning fundamentals',
    'Stock market investing', 
    'Creative writing techniques',
    'Photography composition',
    'Public speaking skills',
    'Time management strategies',
    'Nutrition and healthy eating',
    'Digital marketing basics',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(_animationController);
    _slideAnimation = Tween<Offset>(
        begin: const Offset(0, 0.1), 
        end: Offset.zero
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _topicController.dispose();
    _contextController.dispose();
    _focusNode.dispose();
    _contextFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _processTopicInput() async {
    if (_topicController.text.trim().isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      widget.onTopicSubmitted(
        _topicController.text.trim(), 
        _contextController.text.trim().isEmpty 
            ? null 
            : _contextController.text.trim()
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing topic: $e'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _onTopicChanged(String value) {
    setState(() {
      _currentInput = value;
      _showSuggestions = value.isNotEmpty && _focusNode.hasFocus;
    });
  }

  void _onTopicSubmitted() {
    if (_topicController.text.trim().isNotEmpty && !_showContextField) {
      setState(() {
        _showContextField = true;
      });
      _contextFocusNode.requestFocus();
    } else {
      _processTopicInput();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: widget.showBackButton ? AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ) : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const SizedBox(height: 40),
              Text(
                'What would you like\nto learn today?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Tell us any topic and we\'ll create a personalized learning experience',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary.withOpacity(0.8),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // Topic Input Field
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: TextField(
                  controller: _topicController,
                  focusNode: _focusNode,
                  onChanged: _onTopicChanged,
                  onSubmitted: (_) => _onTopicSubmitted(),
                  decoration: InputDecoration(
                    hintText: 'e.g., "Machine learning for beginners"',
                    hintStyle: TextStyle(
                        color: AppColors.textSecondary.withOpacity(0.6)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(20),
                    suffixIcon: _isProcessing
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : IconButton(
                            icon: Icon(
                              _showContextField ? Icons.done : Icons.arrow_forward,
                              color: AppColors.primary,
                            ),
                            onPressed: _onTopicSubmitted,
                          ),
                  ),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                ),
              ),
              
              // Context Field (appears after topic is entered)
              if (_showContextField) ...[
                const SizedBox(height: 20),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    _animationController.forward();
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppColors.border.withOpacity(0.5), 
                                width: 1
                            ),
                          ),
                          child: TextField(
                            controller: _contextController,
                            focusNode: _contextFocusNode,
                            onSubmitted: (_) => _processTopicInput(),
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Optional: Tell us about your specific situation or goals\ne.g., "I\'m building a startup" or "I need this for my job"',
                              hintStyle: TextStyle(
                                  color: AppColors.textSecondary.withOpacity(0.6)
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(20),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.send, color: AppColors.primary),
                                onPressed: _processTopicInput,
                              ),
                            ),
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
              
              // Suggestions
              if (_showSuggestions && _currentInput.length > 2) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border.withOpacity(0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Suggestions',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...(_topicSuggestions
                          .where((suggestion) => suggestion.toLowerCase()
                              .contains(_currentInput.toLowerCase()))
                          .take(3)
                          .map((suggestion) => GestureDetector(
                                onTap: () {
                                  _topicController.text = suggestion;
                                  _processTopicInput();
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    suggestion,
                                    style: TextStyle(
                                      color: AppColors.textPrimary.withOpacity(0.8),
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ))),
                    ],
                  ),
                ),
              ],
              
              const Spacer(),
              
              // Popular Topics
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Popular Topics',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _topicSuggestions.take(6).map((topic) => 
                        GestureDetector(
                          onTap: () {
                            _topicController.text = topic;
                            _onTopicSubmitted();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: AppColors.primary.withOpacity(0.2)),
                            ),
                            child: Text(
                              topic,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      ).toList(),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
