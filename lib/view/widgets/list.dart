import 'package:candidate_list_app/data/provide.dart';
import 'package:candidate_list_app/widgets/cards/expandable_card.dart';
import 'package:candidate_list_app/widgets/cards/glass_card.dart';
import 'package:candidate_list_app/widgets/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParticipantsGroupedView extends ConsumerWidget {
  const ParticipantsGroupedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(participantsProvider);
    final maleList = data['male'] ?? [];
    final femaleList = data['female'] ?? [];

    return ref.watch(participantsProvider.notifier).isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Participants',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            verticalSpaceMedium,
            ...maleList.map(
              (p) => ExpandableCard(
                title: '${p.name} ${p.category}',
                child: Text(p.selectedPrograms.toString()),
              ),
            ),
            const SizedBox(height: 24),
            // const Text(
            //   'Female Participants',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            ...femaleList.map(
              (p) => ExpandableCard(
                title: '${p.name} ${p.category}',
                child: Text(p.selectedPrograms.toString()),
              ),
            ),
          ],
        );
  }
}
