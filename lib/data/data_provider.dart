import 'package:flutter_riverpod/flutter_riverpod.dart';

final dataProvider = StateNotifierProvider<DataNotifier, DataModel>((ref) {
  return DataNotifier();
});

class DataModel {
  final int id;
  final String name;
  final String category;
  final String phone;
  final List<String> selectedPrograms;

  DataModel({
    this.id = 0,
    this.name = '',
    this.category = '',
    this.phone = '',
    this.selectedPrograms = const [],
  });

  DataModel copyWith({
    int? id,
    String? name,
    String? category,
    String? phone,
    List<String>? selectedPrograms,
  }) {
    return DataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      phone: phone ?? this.phone,
      selectedPrograms: selectedPrograms ?? this.selectedPrograms,
    );
  }
}

class DataNotifier extends StateNotifier<DataModel> {
  DataNotifier() : super(DataModel());

  void setName(String value) => state = state.copyWith(name: value);
  void setCategory(String value) => state = state.copyWith(category: value);
  void setPhone(String value) => state = state.copyWith(phone: value);
  void toggleProgram(String program) {
    final list = [...state.selectedPrograms];
    if (list.contains(program)) {
      list.remove(program);
    } else if (list.length < 4) {
      list.add(program);
    }
    state = state.copyWith(selectedPrograms: list);
  }

  void reset() {
    state = DataModel();
  }
}
