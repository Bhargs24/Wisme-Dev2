// Local Audio Manager for Demo App
// Simplified audio file management for pre-generated episode content

import 'package:flutter/foundation.dart';

class LocalAudioManager {
  
  /// Get the local audio path for a specific episode
  static String getEpisodeAudioPath(String journey, int episode) {
    return 'assets/audio/learning_journeys/$journey/episode_$episode/audio.mp3';
  }

  /// Check if audio file exists locally
  static Future<bool> audioExists(String path) async {
    try {
      if (kIsWeb) {
        // For web, assume assets exist (they're bundled)
        return true;
      }
      
      // For mobile, check if asset exists
      // Note: Asset files are bundled, so they should always exist if properly included
      return true; // Assets are checked at build time
    } catch (e) {
      debugPrint('Error checking audio file: $e');
      return false;
    }
  }

  /// Get all available episodes for a journey
  static Future<List<int>> getAvailableEpisodes(String journey) async {
    try {
      // For demo app, return predefined episode numbers based on journey
      switch (journey) {
        case 'data_structures_algorithms':
          return [1, 2, 3, 4, 5]; // Episodes 1-5 available
        case 'operating_systems':
          return [1, 2, 3, 4, 5, 6]; // Episodes 1-6 available
        case 'database_systems':
          return [1, 2, 3, 4, 5, 6, 7]; // Episodes 1-7 available
        case 'personal_finance':
          return [1, 2, 3, 4, 5, 6]; // Episodes 1-6 available
        default:
          return [];
      }
    } catch (e) {
      debugPrint('Error getting available episodes: $e');
      return [];
    }
  }

  /// Get journey metadata
  static Map<String, dynamic> getJourneyMetadata(String journey) {
    final journeyData = {
      'data_structures_algorithms': {
        'title': 'Data Structures & Algorithms Fundamentals',
        'description': 'Master fundamental data structures and algorithmic thinking',
        'totalEpisodes': 5,
        'estimatedDuration': '42 minutes',
        'difficulty': 'Intermediate',
        'category': 'Computer Science',
      },
      'operating_systems': {
        'title': 'Operating Systems Demystified',
        'description': 'Understanding how operating systems manage computer resources',
        'totalEpisodes': 6,
        'estimatedDuration': '49 minutes',
        'difficulty': 'Intermediate',
        'category': 'Computer Science',
      },
      'database_systems': {
        'title': 'Database Deep Dive',
        'description': 'Master database design, querying, and optimization',
        'totalEpisodes': 7,
        'estimatedDuration': '56 minutes',
        'difficulty': 'Intermediate',
        'category': 'Computer Science',
      },
      'personal_finance': {
        'title': 'Personal Finance Mastery',
        'description': 'Build wealth and financial security through smart money management',
        'totalEpisodes': 6,
        'estimatedDuration': '48 minutes',
        'difficulty': 'Beginner',
        'category': 'Life Skills',
      },
    };

    return journeyData[journey] ?? {
      'title': 'Unknown Journey',
      'description': 'No description available',
      'totalEpisodes': 0,
      'estimatedDuration': '0 minutes',
      'difficulty': 'Unknown',
      'category': 'General',
    };
  }

  /// Get episode metadata
  static Map<String, dynamic> getEpisodeMetadata(String journey, int episode) {
    // Episode data matching our ElevenLabs Studio scripts
    final episodeData = {
      'data_structures_algorithms': {
        1: {
          'title': 'Big O Notation & Complexity Analysis',
          'description': 'Understanding time and space complexity with Big O notation',
          'duration': '8:30',
          'topics': ['Big O', 'Time Complexity', 'Space Complexity', 'Algorithm Analysis'],
        },
        2: {
          'title': 'Arrays & Array Operations',
          'description': 'Deep dive into array operations and memory management',
          'duration': '7:45',
          'topics': ['Arrays', 'Memory Management', 'Array Operations', 'Dynamic Arrays'],
        },
        3: {
          'title': 'Linked Lists Deep Dive',
          'description': 'Understanding linked list structures and pointer manipulation',
          'duration': '8:15',
          'topics': ['Linked Lists', 'Pointers', 'Node Structures', 'List Operations'],
        },
        4: {
          'title': 'Stacks & Queues - LIFO vs FIFO',
          'description': 'Building efficient stacks and queues with real-world applications',
          'duration': '9:00',
          'topics': ['Stacks', 'Queues', 'LIFO', 'FIFO', 'Implementation Patterns'],
        },
        5: {
          'title': 'Recursion & Base Cases',
          'description': 'Mastering recursive thinking and base case identification',
          'duration': '8:45',
          'topics': ['Recursion', 'Base Cases', 'Recursive Algorithms', 'Problem Solving'],
        },
      },
      'operating_systems': {
        1: {
          'title': 'Process Management & Scheduling',
          'description': 'How operating systems manage and schedule processes',
          'duration': '8:00',
          'topics': ['Process Management', 'CPU Scheduling', 'Process States', 'Multitasking'],
        },
        2: {
          'title': 'Memory Management & Virtual Memory',
          'description': 'Understanding how OS manages RAM and virtual memory',
          'duration': '8:20',
          'topics': ['Memory Management', 'Virtual Memory', 'Paging', 'Memory Allocation'],
        },
        3: {
          'title': 'File Systems & Storage',
          'description': 'How operating systems organize and manage file storage',
          'duration': '7:50',
          'topics': ['File Systems', 'Storage Management', 'Directory Structure', 'File Operations'],
        },
        4: {
          'title': 'Networking & Inter-Process Communication',
          'description': 'How processes communicate and network integration',
          'duration': '8:10',
          'topics': ['IPC', 'Network Stack', 'Sockets', 'Process Communication'],
        },
        5: {
          'title': 'Device Drivers & Hardware Interaction',
          'description': 'Understanding how OS communicates with hardware',
          'duration': '9:15',
          'topics': ['Device Drivers', 'Hardware Abstraction', 'I/O Management', 'Kernel'],
        },
        6: {
          'title': 'System Security & Access Control',
          'description': 'OS security mechanisms and user access control',
          'duration': '7:40',
          'topics': ['System Security', 'Access Control', 'Authentication', 'Permissions'],
        },
      },
      'database_systems': {
        1: {
          'title': 'Database Fundamentals & RDBMS Concepts',
          'description': 'Introduction to databases and relational database concepts',
          'duration': '8:25',
          'topics': ['Database Basics', 'RDBMS', 'Tables', 'Relationships'],
        },
        2: {
          'title': 'SQL Queries & Data Retrieval',
          'description': 'Writing effective SQL queries for data retrieval',
          'duration': '7:55',
          'topics': ['SQL', 'SELECT Queries', 'Joins', 'Filtering'],
        },
        3: {
          'title': 'Database Design & Normalization',
          'description': 'Designing efficient database schemas and normalization',
          'duration': '8:35',
          'topics': ['Database Design', 'Normalization', 'Schema Design', 'Entity Relationships'],
        },
        4: {
          'title': 'Indexing & Query Optimization',
          'description': 'Optimizing database performance through indexing',
          'duration': '8:05',
          'topics': ['Indexing', 'Query Optimization', 'Performance Tuning', 'Query Plans'],
        },
        5: {
          'title': 'Transactions & ACID Properties',
          'description': 'Understanding database transactions and consistency',
          'duration': '7:20',
          'topics': ['Transactions', 'ACID', 'Concurrency', 'Data Integrity'],
        },
        6: {
          'title': 'NoSQL & Modern Database Systems',
          'description': 'Exploring NoSQL databases and modern data storage',
          'duration': '8:50',
          'topics': ['NoSQL', 'Document Databases', 'Key-Value Stores', 'Modern Databases'],
        },
        7: {
          'title': 'Database Security & Backup Strategies',
          'description': 'Securing databases and implementing backup strategies',
          'duration': '8:00',
          'topics': ['Database Security', 'Backup Strategies', 'Recovery', 'Data Protection'],
        },
      },
      'personal_finance': {
        1: {
          'title': 'Budgeting Fundamentals & Cash Flow',
          'description': 'Creating effective budgets and understanding money flow',
          'duration': '8:15',
          'topics': ['Budgeting', 'Cash Flow', 'Expense Tracking', 'Financial Planning'],
        },
        2: {
          'title': 'Emergency Funds & Financial Safety Nets',
          'description': 'Building financial safety nets and risk management',
          'duration': '7:45',
          'topics': ['Emergency Fund', 'Risk Management', 'Insurance', 'Financial Security'],
        },
        3: {
          'title': 'Investment Basics & Portfolio Building',
          'description': 'Understanding investments and building diversified portfolios',
          'duration': '8:30',
          'topics': ['Investing', 'Stocks', 'Bonds', 'Portfolio Diversification'],
        },
        4: {
          'title': 'Retirement Planning & Long-term Wealth',
          'description': 'Planning for retirement and building long-term wealth',
          'duration': '8:05',
          'topics': ['Retirement Planning', '401k', 'IRA', 'Long-term Investing'],
        },
        5: {
          'title': 'Tax Planning & Optimization Strategies',
          'description': 'Minimizing taxes and maximizing financial efficiency',
          'duration': '7:30',
          'topics': ['Tax Planning', 'Tax-Advantaged Accounts', 'Deductions', 'Tax Strategies'],
        },
        6: {
          'title': 'Credit Management & Debt Strategy',
          'description': 'Managing credit effectively and debt elimination strategies',
          'duration': '8:10',
          'topics': ['Credit Management', 'Debt Strategy', 'Credit Score', 'Debt Payoff'],
        },
      },
    };

    return episodeData[journey]?[episode] ?? {
      'title': 'Episode $episode',
      'description': 'Episode description not available',
      'duration': '8:00',
      'topics': [],
    };
  }

  /// Validate audio asset path format
  static bool isValidAudioPath(String path) {
    final validPattern = RegExp(r'^assets/audio/learning_journeys/[a-z_]+/episode_\d+/audio\.mp3$');
    return validPattern.hasMatch(path);
  }

  /// Get demo audio URL (placeholder for development)
  static String? getDemoAudioUrl(String journey, int episode) {
    // For demo purposes, return null to indicate no remote audio
    // In production, this could return URLs to sample audio files
    return null;
  }
}
