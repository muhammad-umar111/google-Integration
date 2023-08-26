// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PlaceSuggestion {
  String placeId;
String description;
  PlaceSuggestion({
    required this.placeId,
    required this.description,
  });
 
 

  PlaceSuggestion copyWith({
    String? placeId,
    String? description,
  }) {
    return PlaceSuggestion(
      placeId: placeId ?? this.placeId,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'placeId': placeId,
      'description': description,
    };
  }

  factory PlaceSuggestion.fromMap(Map<String, dynamic> map) {
    return PlaceSuggestion(
      placeId: map['placeId'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaceSuggestion.fromJson(String source) => PlaceSuggestion.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PlaceSuggestion(placeId: $placeId, description: $description)';

  @override
  bool operator ==(covariant PlaceSuggestion other) {
    if (identical(this, other)) return true;
  
    return 
      other.placeId == placeId &&
      other.description == description;
  }

  @override
  int get hashCode => placeId.hashCode ^ description.hashCode;
 }
