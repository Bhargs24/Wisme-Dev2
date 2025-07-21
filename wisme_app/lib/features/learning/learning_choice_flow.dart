import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../shared/shared.dart';
import '../../models/models.dart';
import 'phase1_learning_flow.dart';

/// Phase 1 Learning Choice Flow - Updated Implementation
/// Uses the new Phase 1 approach with 60 knowledge levels and predetermined voice pairs
class SmartLearningChoiceFlow extends StatefulWidget {
  final String selectedTopic;
  final String? personalContext;
  final Function(Map<String, dynamic>) onChoicesComplete;

  const SmartLearningChoiceFlow({
    super.key,
    required this.selectedTopic,
    this.personalContext,
    required this.onChoicesComplete,
  });

  @override
  State<SmartLearningChoiceFlow> createState() => _SmartLearningChoiceFlowState();
}

class _SmartLearningChoiceFlowState extends State<SmartLearningChoiceFlow> {
  @override
  Widget build(BuildContext context) {
    // Use the new Phase 1 learning flow
    return Phase1LearningFlow(
      selectedTopic: widget.selectedTopic,
      personalContext: widget.personalContext,
      onJourneyCreated: widget.onChoicesComplete,
    );
  }
}
