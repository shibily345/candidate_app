import 'package:candidate_list_app/data/data_provider.dart';
import 'package:candidate_list_app/view/splash.dart';
import 'package:candidate_list_app/widgets/buttons/glass_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataForm extends ConsumerStatefulWidget {
  final String gen;
  final String scriptURL =
      "https://script.google.com/macros/s/AKfycbycijew0J_yh26xeObc07bZ1dRZ6H2lxmzvVmdsjOLIolvXVZJThbZNBNMg8puwIdSriw/exec";

  const DataForm(this.gen, {super.key});

  @override
  ConsumerState<DataForm> createState() => _DataFormState();
}

class _DataFormState extends ConsumerState<DataForm> {
  List<Map<String, dynamic>> categories = [];
  List<String> programs = [];

  @override
  void initState() {
    super.initState();
    loadCategoriesAndPrograms();
  }

  Future<void> loadCategoriesAndPrograms() async {
    final jsonString = await rootBundle.rootBundle.loadString(
      widget.gen == 'male'
          ? 'assets/programs_json.json'
          : 'assets/programs_girls.json',
    );
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    setState(() {
      categories = List<Map<String, dynamic>>.from(jsonData['categories']);
    });
  }

  void updatePrograms(String selectedCategory) {
    final category = categories.firstWhere(
      (cat) => cat['name'] == selectedCategory,
      orElse: () => {},
    );
    setState(() {
      programs =
          category != null ? List<String>.from(category['programs'] ?? []) : [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Submit Data")),
      floatingActionButton: GlassButton(
        icon: Icons.add,
        onPressed: () async {
          final body = {
            'gen': widget.gen,
            'name': data.name,
            'category': data.category,
            'phone': data.phone,
            'programs': jsonEncode(data.selectedPrograms),
          };

          final response = await http.post(
            Uri.parse(widget.scriptURL),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.statusCode.toString())),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SplashScreen()),
          );
          debugPrint(response.body);
          ref.read(dataProvider.notifier).reset();
        },

        label: "Submit to Google Sheet",
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (val) => ref.read(dataProvider.notifier).setName(val),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: data.category.isNotEmpty ? data.category : null,
              decoration: const InputDecoration(labelText: 'Category'),
              items:
                  categories
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e['name'] as String,
                          child: Text('${e['name']} (${e['description']})'),
                        ),
                      )
                      .toList(),
              onChanged: (val) {
                ref.read(dataProvider.notifier).setCategory(val ?? '');
                updatePrograms(val ?? '');
              },
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
              onChanged: (val) => ref.read(dataProvider.notifier).setPhone(val),
            ),
            const SizedBox(height: 20),
            const Text("Select up to 4 Programs:"),
            const SizedBox(height: 10),
            ...programs.map((program) {
              final isSelected = data.selectedPrograms.contains(program);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GlassButton(
                  label: program,
                  icon: isSelected ? Icons.check_circle : null,
                  color: isSelected ? Colors.green[700] : Colors.black,
                  // title: Text(program),
                  // trailing:
                  //     isSelected
                  //         ? const Icon(Icons.check_circle, color: Colors.green)
                  //         : null,
                  onPressed:
                      () => ref
                          .read(dataProvider.notifier)
                          .toggleProgram(program),
                ),
              );
            }),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
