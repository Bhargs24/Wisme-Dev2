/// Conversation Models
/// Data models for conversational interactions and exchanges
library;

import 'dart:typed_data';

/// Speaker roles for conversation
enum SpeakerRole {
  narrator,
  expert,
  interviewer,
  interviewee,
  primary,
  secondary,
}

/// Exchange types for conversation parts
enum ExchangeType {
  introduction,
  mainContent,
  transition,
  summary,
  conclusion,
  question,
  answer,
}

/// Conversation format types
enum ConversationFormat {
  interview,
  dialogue,
  debate,
  narrative,
  educational,
  documentary,
}

/// Represents a single exchange in a conversation
class ConversationExchange {
  final String id;
  final String speakerId;
  final String text;
  final Duration timestamp;
  final SpeakerRole? speakerRole;
  final String? content;
  final ExchangeType? type;
  final Duration? estimatedDuration;
  final Map<String, dynamic> metadata;

  const ConversationExchange({
    required this.id,
    required this.speakerId,
    required this.text,
    required this.timestamp,
    this.speakerRole,
    this.content,
    this.type,
    this.estimatedDuration,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'speakerId': speakerId,
    'text': text,
    'timestamp': timestamp.inMilliseconds,
    'speakerRole': speakerRole?.name,
    'content': content,
    'type': type?.name,
    'estimatedDuration': estimatedDuration?.inMilliseconds,
    'metadata': metadata,
  };

  factory ConversationExchange.fromJson(Map<String, dynamic> json) {
    return ConversationExchange(
      id: json['id'] as String,
      speakerId: json['speakerId'] as String,
      text: json['text'] as String,
      timestamp: Duration(milliseconds: json['timestamp'] as int),
      speakerRole: json['speakerRole'] != null
          ? SpeakerRole.values.firstWhere(
              (role) => role.name == json['speakerRole'],
              orElse: () => SpeakerRole.primary,
            )
          : null,
      content: json['content'] as String?,
      type: json['type'] != null
          ? ExchangeType.values.firstWhere(
              (type) => type.name == json['type'],
              orElse: () => ExchangeType.mainContent,
            )
          : null,
      estimatedDuration: json['estimatedDuration'] != null
          ? Duration(milliseconds: json['estimatedDuration'] as int)
          : null,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
}

/// Represents an audio segment within a conversation
class ConversationAudioSegment {
  final String id;
  final String exchangeId;
  final Uint8List? audioData;
  final String? audioPath;
  final Duration duration;
  final String format;
  final Map<String, dynamic> metadata;

  const ConversationAudioSegment({
    required this.id,
    required this.exchangeId,
    this.audioData,
    this.audioPath,
    required this.duration,
    this.format = 'mp3',
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'exchangeId': exchangeId,
    'audioPath': audioPath,
    'duration': duration.inMilliseconds,
    'format': format,
    'metadata': metadata,
  };

  factory ConversationAudioSegment.fromJson(Map<String, dynamic> json) {
    return ConversationAudioSegment(
      id: json['id'] as String,
      exchangeId: json['exchangeId'] as String,
      audioPath: json['audioPath'] as String?,
      duration: Duration(milliseconds: json['duration'] as int),
      format: json['format'] as String? ?? 'mp3',
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
}

/// Represents a complete conversation with multiple speakers
class ConversationModel {
  final String id;
  final String title;
  final List<String> participantIds;
  final List<ConversationExchange> exchanges;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> metadata;

  const ConversationModel({
    required this.id,
    required this.title,
    required this.participantIds,
    required this.exchanges,
    required this.createdAt,
    required this.updatedAt,
    this.metadata = const {},
  });

  Duration get totalDuration {
    if (exchanges.isEmpty) return Duration.zero;
    return exchanges.last.timestamp;
  }

  int get exchangeCount => exchanges.length;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'participantIds': participantIds,
    'exchanges': exchanges.map((e) => e.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'metadata': metadata,
  };

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      participantIds: List<String>.from(json['participantIds']),
      exchanges: (json['exchanges'] as List)
          .map((e) => ConversationExchange.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
}

/// Speaker information for conversations
class ConversationSpeaker {
  final String id;
  final String name;
  final String voiceId;
  final String personality;
  final Map<String, dynamic> voiceSettings;

  const ConversationSpeaker({
    required this.id,
    required this.name,
    required this.voiceId,
    required this.personality,
    this.voiceSettings = const {},
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'voiceId': voiceId,
    'personality': personality,
    'voiceSettings': voiceSettings,
  };

  factory ConversationSpeaker.fromJson(Map<String, dynamic> json) {
    return ConversationSpeaker(
      id: json['id'] as String,
      name: json['name'] as String,
      voiceId: json['voiceId'] as String,
      personality: json['personality'] as String,
      voiceSettings: Map<String, dynamic>.from(json['voiceSettings'] ?? {}),
    );
  }
}

/// Voice characteristics for a speaker
class VoiceCharacteristics {
  final String pitch;
  final String speed;
  final String tone;
  final String accent;
  final Map<String, dynamic> additionalSettings;

  const VoiceCharacteristics({
    required this.pitch,
    required this.speed,
    required this.tone,
    this.accent = 'neutral',
    this.additionalSettings = const {},
  });

  Map<String, dynamic> toJson() => {
    'pitch': pitch,
    'speed': speed,
    'tone': tone,
    'accent': accent,
    'additionalSettings': additionalSettings,
  };

  factory VoiceCharacteristics.fromJson(Map<String, dynamic> json) {
    return VoiceCharacteristics(
      pitch: json['pitch'] as String,
      speed: json['speed'] as String,
      tone: json['tone'] as String,
      accent: json['accent'] as String? ?? 'neutral',
      additionalSettings: Map<String, dynamic>.from(json['additionalSettings'] ?? {}),
    );
  }
}

/// Speaker voice configuration
class SpeakerVoice {
  final String id;
  final String name;
  final SpeakerRole role;
  final String voiceId;
  final VoiceCharacteristics characteristics;
  final bool isActive;

  const SpeakerVoice({
    required this.id,
    required this.name,
    required this.role,
    required this.voiceId,
    required this.characteristics,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'role': role.name,
    'voiceId': voiceId,
    'characteristics': characteristics.toJson(),
    'isActive': isActive,
  };

  factory SpeakerVoice.fromJson(Map<String, dynamic> json) {
    return SpeakerVoice(
      id: json['id'] as String,
      name: json['name'] as String,
      role: SpeakerRole.values.firstWhere(
        (role) => role.name == json['role'],
        orElse: () => SpeakerRole.primary,
      ),
      voiceId: json['voiceId'] as String,
      characteristics: VoiceCharacteristics.fromJson(json['characteristics']),
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}

/// Generated conversation data
class GeneratedConversation {
  final String id;
  final String title;
  final ConversationFormat format;
  final List<ConversationExchange> exchanges;
  final List<SpeakerVoice> speakers;
  final Duration estimatedDuration;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  const GeneratedConversation({
    required this.id,
    required this.title,
    required this.format,
    required this.exchanges,
    required this.speakers,
    required this.estimatedDuration,
    required this.createdAt,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'format': format.name,
    'exchanges': exchanges.map((e) => e.toJson()).toList(),
    'speakers': speakers.map((s) => s.toJson()).toList(),
    'estimatedDuration': estimatedDuration.inMilliseconds,
    'createdAt': createdAt.toIso8601String(),
    'metadata': metadata,
  };

  factory GeneratedConversation.fromJson(Map<String, dynamic> json) {
    return GeneratedConversation(
      id: json['id'] as String,
      title: json['title'] as String,
      format: ConversationFormat.values.firstWhere(
        (format) => format.name == json['format'],
        orElse: () => ConversationFormat.dialogue,
      ),
      exchanges: (json['exchanges'] as List)
          .map((e) => ConversationExchange.fromJson(e))
          .toList(),
      speakers: (json['speakers'] as List)
          .map((s) => SpeakerVoice.fromJson(s))
          .toList(),
      estimatedDuration: Duration(milliseconds: json['estimatedDuration'] as int),
      createdAt: DateTime.parse(json['createdAt'] as String),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
}
