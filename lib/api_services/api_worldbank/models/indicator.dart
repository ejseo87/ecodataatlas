class Indicator {
  final String id;
  final String name;
  final String? sourceNote;

  const Indicator({required this.id, required this.name, this.sourceNote});

  factory Indicator.fromJson(Map<String, dynamic> json) {
    return Indicator(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      sourceNote: json['sourceNote']?.toString(),
    );
  }
}
