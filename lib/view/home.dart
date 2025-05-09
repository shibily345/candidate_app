import 'package:candidate_list_app/data/provide.dart';
import 'package:candidate_list_app/view/data_form_view.dart';
import 'package:candidate_list_app/view/widgets/list.dart';
import 'package:candidate_list_app/widgets/buttons/animated_press_button.dart';
import 'package:candidate_list_app/widgets/cards/glass_card.dart';
import 'package:candidate_list_app/widgets/cards/gradient_border_card.dart.dart';
import 'package:candidate_list_app/widgets/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    ref.read(participantsProvider.notifier).fetchParticipants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text('Dashboard'),
      ),
      body: ParticipantsGroupedView(),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // verticalSpaceLarge,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedPressButton(
                width: screenWidth(context),
                label: 'Add Candidate',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DataForm('male')),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedPressButton(
                width: screenWidth(context),
                label: 'Add Candidate Girls',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DataForm('fe')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
