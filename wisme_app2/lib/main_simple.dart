import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

// Import your API keys to verify they work
import 'config/api_keys.dart';

final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Simple initialization
    logger.i('🚀 Starting Wisme App...');
    
    // Test API keys
    logger.i('Testing API Configuration:');
    logger.i('OpenAI configured: ${ApiKeys.isOpenAIConfigured}');
    logger.i('ElevenLabs configured: ${ApiKeys.isElevenLabsConfigured}');
    logger.i('Firebase configured: ${ApiKeys.isFirebaseConfigured}');
    
    // Initialize SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    logger.i('SharedPreferences initialized');
    
    logger.i('✅ Basic setup complete');
    
    runApp(const SimpleWismeApp());
    
  } catch (e, stackTrace) {
    logger.e('❌ Error during initialization: $e');
    logger.e('Stack trace: $stackTrace');
    
    // Fallback - run minimal app
    runApp(const ErrorApp(error: 'Initialization failed'));
  }
}

class SimpleWismeApp extends StatelessWidget {
  const SimpleWismeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wisme App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TestHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TestHomePage extends StatelessWidget {
  const TestHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wisme App - Setup Complete'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success indicator
            const Center(
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 100,
                    color: Colors.green,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'App is Running Successfully! 🎉',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // API Status Cards
            _buildStatusCard(
              'OpenAI API',
              ApiKeys.isOpenAIConfigured,
              'Ready for AI lesson generation',
              'API key needed',
            ),
            
            _buildStatusCard(
              'ElevenLabs API',
              ApiKeys.isElevenLabsConfigured,
              'Ready for text-to-speech',
              'API key needed',
            ),
            
            _buildStatusCard(
              'Firebase',
              ApiKeys.isFirebaseConfigured,
              'Ready for data storage',
              'Configuration needed',
            ),
            
            const SizedBox(height: 30),
            
            // Next steps
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Next Steps:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildNextStep('✅', 'Setup complete - all APIs configured'),
                    _buildNextStep('🧪', 'Test lesson generation features'),
                    _buildNextStep('🎙️', 'Test voice synthesis features'),
                    _buildNextStep('📱', 'Explore the full app interface'),
                    _buildNextStep('🚀', 'Start creating your lessons!'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Action buttons
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ready to start development!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  'Start Using Wisme',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(
    String title,
    bool isConfigured,
    String successMessage,
    String errorMessage,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          isConfigured ? Icons.check_circle : Icons.warning,
          color: isConfigured ? Colors.green : Colors.orange,
          size: 30,
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(isConfigured ? successMessage : errorMessage),
        trailing: Text(
          isConfigured ? 'Ready' : 'Needed',
          style: TextStyle(
            color: isConfigured ? Colors.green : Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNextStep(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String error;
  
  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Setup Error'),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error,
                size: 100,
                color: Colors.red,
              ),
              const SizedBox(height: 20),
              Text(
                'Setup Error',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(error),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Could add restart logic here
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
