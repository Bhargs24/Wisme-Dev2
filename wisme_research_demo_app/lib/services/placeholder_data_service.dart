import '../models/journey_models.dart';

class PlaceholderDataService {
  // Placeholder audio URLs - using public domain or royalty-free samples
  static const String placeholderAudioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
  
  static List<Journey> getJourneys() {
    return [
      // DSA Journey
      Journey(
        id: 'dsa',
        title: 'Data Structures & Algorithms',
        description: 'Master DSA through engaging conversations',
        category: 'Technical',
        episodeIds: ['dsa_ep1', 'dsa_ep2', 'dsa_ep3', 'dsa_ep4', 'dsa_ep5'],
        totalDuration: 2700, // 45 minutes
        difficulty: 'Intermediate',
        iconName: 'code',
        colorHex: '#2196F3',
        metadata: {
          'targetAudience': 'Engineering students preparing for interviews',
          'learningObjectives': [
            'Understand time & space complexity',
            'Master fundamental data structures',
            'Learn basic sorting algorithms',
            'Apply problem-solving approaches'
          ]
        },
      ),
      
      // OS Journey
      Journey(
        id: 'os',
        title: 'Operating Systems',
        description: 'Understand OS concepts through real-world stories',
        category: 'Technical',
        episodeIds: ['os_ep1', 'os_ep2', 'os_ep3', 'os_ep4', 'os_ep5', 'os_ep6'],
        totalDuration: 3240, // 54 minutes
        difficulty: 'Advanced',
        iconName: 'computer',
        colorHex: '#FF9800',
        metadata: {
          'targetAudience': 'CS students and system administrators',
          'learningObjectives': [
            'Process management and scheduling',
            'Memory management concepts',
            'Deadlock detection and prevention',
            'File systems and I/O management'
          ]
        },
      ),
      
      // DBMS Journey
      Journey(
        id: 'dbms',
        title: 'Database Management',
        description: 'Learn database concepts through practical scenarios',
        category: 'Technical',
        episodeIds: ['dbms_ep1', 'dbms_ep2', 'dbms_ep3', 'dbms_ep4', 'dbms_ep5', 'dbms_ep6', 'dbms_ep7'],
        totalDuration: 3780, // 63 minutes
        difficulty: 'Intermediate',
        iconName: 'storage',
        colorHex: '#4CAF50',
        metadata: {
          'targetAudience': 'Backend developers and data engineers',
          'learningObjectives': [
            'ACID properties and transaction management',
            'Database design and normalization',
            'Indexing and query optimization',
            'NoSQL vs SQL databases'
          ]
        },
      ),
      
      // Personal Finance Journey
      Journey(
        id: 'finance',
        title: 'Personal Finance',
        description: 'Build wealth through smart financial decisions',
        category: 'Life Skills',
        episodeIds: ['finance_ep1', 'finance_ep2', 'finance_ep3', 'finance_ep4', 'finance_ep5', 'finance_ep6'],
        totalDuration: 3240, // 54 minutes
        difficulty: 'Beginner',
        iconName: 'account_balance',
        colorHex: '#9C27B0',
        metadata: {
          'targetAudience': 'Young professionals and students',
          'learningObjectives': [
            'Budgeting and expense tracking',
            'Investment fundamentals',
            'Insurance and risk management',
            'Retirement planning basics'
          ]
        },
      ),
    ];
  }

  static List<Episode> getEpisodesForJourney(String journeyId) {
    switch (journeyId) {
      case 'dsa':
        return _getDSAEpisodes();
      case 'os':
        return _getOSEpisodes();
      case 'dbms':
        return _getDBMSEpisodes();
      case 'finance':
        return _getFinanceEpisodes();
      default:
        return [];
    }
  }

  static List<Episode> _getDSAEpisodes() {
    return [
      Episode(
        id: 'dsa_ep1',
        journeyId: 'dsa',
        title: 'Big O Notation Mastery',
        description: 'Understanding algorithm efficiency through restaurant analogies',
        audioUrl: placeholderAudioUrl,
        duration: 540, // 9 minutes
        order: 1,
        keyPoints: ['O(1) constant time', 'O(n) linear time', 'O(log n) logarithmic'],
        metadata: {'hook': 'Ready to impress Amazon interviewers?'}
      ),
      Episode(
        id: 'dsa_ep2',
        journeyId: 'dsa',
        title: 'Arrays Deep Dive',
        description: 'Arrays as apartment buildings with direct access',
        audioUrl: placeholderAudioUrl,
        duration: 480, // 8 minutes
        order: 2,
        keyPoints: ['Memory layout', 'Fast access vs expensive insertions', 'CPU prefetch'],
        metadata: {'analogy': 'Apartment buildings with direct access'}
      ),
      Episode(
        id: 'dsa_ep3',
        journeyId: 'dsa',
        title: 'Linked Lists Unleashed',
        description: 'The treasure hunt approach to data storage',
        audioUrl: placeholderAudioUrl,
        duration: 600, // 10 minutes
        order: 3,
        keyPoints: ['Dynamic allocation', 'Pointer traversal', 'Memory management'],
        metadata: {'analogy': 'Treasure hunt with clues'}
      ),
      Episode(
        id: 'dsa_ep4',
        journeyId: 'dsa',
        title: 'Stacks & Queues in Action',
        description: 'From cafeteria plates to WhatsApp messages',
        audioUrl: placeholderAudioUrl,
        duration: 540, // 9 minutes
        order: 4,
        keyPoints: ['LIFO vs FIFO', 'Real-world applications', 'Browser back button'],
        metadata: {'realExample': 'WhatsApp message queue'}
      ),
      Episode(
        id: 'dsa_ep5',
        journeyId: 'dsa',
        title: 'Trees & Graph Fundamentals',
        description: 'From family trees to Google Maps',
        audioUrl: placeholderAudioUrl,
        duration: 540, // 9 minutes
        order: 5,
        keyPoints: ['Tree traversal', 'Graph connectivity', 'BFS vs DFS'],
        metadata: {'applications': 'File systems, Google Maps'}
      ),
    ];
  }

  static List<Episode> _getOSEpisodes() {
    return [
      Episode(
        id: 'os_ep1',
        journeyId: 'os',
        title: 'Process Management Mastery',
        description: 'Restaurant kitchen with multiple chefs',
        audioUrl: placeholderAudioUrl,
        duration: 540, // 9 minutes
        order: 1,
        keyPoints: ['Process states', 'Context switching', 'CPU scheduling'],
      ),
      Episode(
        id: 'os_ep2',
        journeyId: 'os',
        title: 'Memory Management Magic',
        description: 'Hotel room management system',
        audioUrl: placeholderAudioUrl,
        duration: 540, // 9 minutes
        order: 2,
        keyPoints: ['Virtual memory', 'Paging', 'Memory leaks'],
      ),
      Episode(
        id: 'os_ep3',
        journeyId: 'os',
        title: 'File Systems Decoded',
        description: 'Library organization system',
        audioUrl: placeholderAudioUrl,
        duration: 480, // 8 minutes
        order: 3,
        keyPoints: ['File allocation', 'Journaling', 'SSD vs HDD'],
      ),
      Episode(
        id: 'os_ep4',
        journeyId: 'os',
        title: 'Deadlock Prevention',
        description: 'Four-way traffic intersection solutions',
        audioUrl: placeholderAudioUrl,
        duration: 600, // 10 minutes
        order: 4,
        keyPoints: ['Deadlock conditions', 'Prevention strategies', 'Real examples'],
      ),
      Episode(
        id: 'os_ep5',
        journeyId: 'os',
        title: 'Scheduling Algorithms',
        description: 'Doctor\'s office appointment system',
        audioUrl: placeholderAudioUrl,
        duration: 540, // 9 minutes
        order: 5,
        keyPoints: ['FCFS', 'SJF', 'Round Robin', 'Priority scheduling'],
      ),
      Episode(
        id: 'os_ep6',
        journeyId: 'os',
        title: 'Synchronization Secrets',
        description: 'Shared bathroom coordination',
        audioUrl: placeholderAudioUrl,
        duration: 540, // 9 minutes
        order: 6,
        keyPoints: ['Mutex vs Semaphore', 'Producer-Consumer', 'Race conditions'],
      ),
    ];
  }

  static List<Episode> _getDBMSEpisodes() {
    return [
      Episode(
        id: 'dbms_ep1',
        journeyId: 'dbms',
        title: 'Relational Database Foundations',
        description: 'Organized filing cabinet system',
        audioUrl: placeholderAudioUrl,
        duration: 540, // 9 minutes
        order: 1,
        keyPoints: ['Tables & relationships', 'Primary keys', 'Normalization'],
      ),
      Episode(
        id: 'dbms_ep2',
        journeyId: 'dbms',
        title: 'SQL Query Mastery',
        description: 'Speaking to a very literal librarian',
        audioUrl: placeholderAudioUrl,
        duration: 540, // 9 minutes
        order: 2,
        keyPoints: ['JOIN operations', 'Query optimization', 'Complex queries'],
      ),
      Episode(
        id: 'dbms_ep3',
        journeyId: 'dbms',
        title: 'Indexing Intelligence',
        description: 'Book index vs reading every page',
        audioUrl: placeholderAudioUrl,
        duration: 480, // 8 minutes
        order: 3,
        keyPoints: ['B-Tree structure', 'Index trade-offs', 'Performance impact'],
      ),
      Episode(
        id: 'dbms_ep4',
        journeyId: 'dbms',
        title: 'Transaction Management',
        description: 'Bank money transfer process',
        audioUrl: placeholderAudioUrl,
        duration: 600, // 10 minutes
        order: 4,
        keyPoints: ['ACID properties', 'Isolation levels', 'Failure recovery'],
      ),
      Episode(
        id: 'dbms_ep5',
        journeyId: 'dbms',
        title: 'NoSQL Revolution',
        description: 'Flexible storage vs rigid filing system',
        audioUrl: placeholderAudioUrl,
        duration: 540, // 9 minutes
        order: 5,
        keyPoints: ['Document stores', 'Key-value stores', 'CAP theorem'],
      ),
      Episode(
        id: 'dbms_ep6',
        journeyId: 'dbms',
        title: 'Database Design Principles',
        description: 'Architectural blueprint for data',
        audioUrl: placeholderAudioUrl,
        duration: 540, // 9 minutes
        order: 6,
        keyPoints: ['Schema design', 'Denormalization', 'Best practices'],
      ),
      Episode(
        id: 'dbms_ep7',
        journeyId: 'dbms',
        title: 'Performance Optimization',
        description: 'Traffic optimization in a city',
        audioUrl: placeholderAudioUrl,
        duration: 540, // 9 minutes
        order: 7,
        keyPoints: ['Query profiling', 'Caching strategies', 'Monitoring tools'],
      ),
    ];
  }

  static List<Episode> _getFinanceEpisodes() {
    return [
      Episode(
        id: 'finance_ep1',
        journeyId: 'finance',
        title: 'Budgeting Breakthrough',
        description: 'College student\'s financial transformation',
        audioUrl: placeholderAudioUrl,
        duration: 540, // 9 minutes
        order: 1,
        keyPoints: ['50/30/20 rule', 'Expense tracking', 'Budget psychology'],
      ),
      Episode(
        id: 'finance_ep2',
        journeyId: 'finance',
        title: 'Investment Fundamentals',
        description: 'Planting seeds for future trees',
        audioUrl: placeholderAudioUrl,
        duration: 540, // 9 minutes
        order: 2,
        keyPoints: ['Risk vs return', 'Diversification', 'SIP calculations'],
      ),
      Episode(
        id: 'finance_ep3',
        journeyId: 'finance',
        title: 'Mutual Funds Decoded',
        description: 'Professional chef vs cooking yourself',
        audioUrl: placeholderAudioUrl,
        duration: 600, // 10 minutes
        order: 3,
        keyPoints: ['Fund types', 'Expense ratios', 'Direct vs regular'],
      ),
      Episode(
        id: 'finance_ep4',
        journeyId: 'finance',
        title: 'Stock Market Basics',
        description: 'Company ownership for beginners',
        audioUrl: placeholderAudioUrl,
        duration: 540, // 9 minutes
        order: 4,
        keyPoints: ['Bull vs bear markets', 'Fundamental analysis', 'Long-term mindset'],
      ),
      Episode(
        id: 'finance_ep5',
        journeyId: 'finance',
        title: 'Insurance Essentials',
        description: 'Umbrella before it rains',
        audioUrl: placeholderAudioUrl,
        duration: 480, // 8 minutes
        order: 5,
        keyPoints: ['Coverage types', 'Coverage calculation', 'Term vs whole life'],
      ),
      Episode(
        id: 'finance_ep6',
        journeyId: 'finance',
        title: 'Retirement Planning',
        description: 'Starting at 25 vs starting at 35',
        audioUrl: placeholderAudioUrl,
        duration: 540, // 9 minutes
        order: 6,
        keyPoints: ['Compound interest', 'EPF/PPF/NPS', 'Retirement corpus planning'],
      ),
    ];
  }
}
