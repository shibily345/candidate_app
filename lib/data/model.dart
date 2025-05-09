class ParticipantData {
  final int id;
  final String name;
  final String category;
  final String phone;
  final List<String> programs;

  ParticipantData({
    required this.id,
    required this.name,
    required this.category,
    required this.phone,
    required this.programs,
  });

  // Added copyWith for easier modification of data.
  ParticipantData copyWith({
    int? id,
    String? name,
    String? category,
    String? phone,
    List<String>? programs,
  }) {
    return ParticipantData(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      phone: phone ?? this.phone,
      programs: programs ?? this.programs,
    );
  }

  // Added toList() method for converting to the format required by google_sheets_api
    List<String> toList() {
    return [
      id.toString(),
      name,
      category,
      phone,
      programs.join(', '), // Join programs with a comma
    ];
  }

  @override
  String toString() {
    return 'ParticipantData{id: $id, name: $name, category: $category, phone: $phone, programs: $programs}';
  }
}