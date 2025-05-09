import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// ✅ Model
class ParticipantModel {
  final int id;
  final String name;
  final String category;
  final String phone;
  final List<String> selectedPrograms;

  ParticipantModel({
    required this.id,
    required this.name,
    required this.category,
    required this.phone,
    required this.selectedPrograms,
  });

  factory ParticipantModel.fromMap(Map<String, dynamic> map) {
    return ParticipantModel(
      id: int.tryParse(map['ID'].toString()) ?? 0,
      name: map['Name'] ?? '',
      category: map['Category'] ?? '',
      phone: map['Phone']?.toString() ?? '',
      selectedPrograms: map['Programs']?.toString().split(', ') ?? [],
    );
  }
}

// ✅ Notifier
class ParticipantNotifier
  extends StateNotifier<Map<String, List<ParticipantModel>>> {
  ParticipantNotifier() : super({'male': [], 'female': []});
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  Future<void> fetchParticipants() async {
  try {
    final url =
      'https://script.google.com/macros/s/AKfycbycijew0J_yh26xeObc07bZ1dRZ6H2lxmzvVmdsjOLIolvXVZJThbZNBNMg8puwIdSriw/exec';

    final response = await http.get(Uri.parse(url));
    debugPrint(response.body);
    final jsonResponse = json.decode(response.body);

    final maleList = List<Map<String, dynamic>>.from(
    jsonResponse['male'] ?? [],
    );
    final femaleList = List<Map<String, dynamic>>.from(
    jsonResponse['female'] ?? [],
    );

    state = {
    'male': maleList.map((e) => ParticipantModel.fromMap(e)).toList(),
    'female': femaleList.map((e) => ParticipantModel.fromMap(e)).toList(),
    };
    _isLoading = false;
  } catch (e) {
    print('Fetch failed: $e');
  }
  }
}

// ✅ Provider
final participantsProvider = StateNotifierProvider<
  ParticipantNotifier,
  Map<String, List<ParticipantModel>>
>((ref) => ParticipantNotifier());

// ✅ Loading Provider

