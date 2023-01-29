import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({Key? key}) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final textController = TextEditingController();
  late String inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: textController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (value) {
            addConcrete();
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: addConcrete,
                child: const Text('Search'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: addRandom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade500,
                ),
                child: const Text('Get random trivia'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void addConcrete() {
    context.read<NumberTriviaBloc>().add(GetTriviaForConcreteNumber(inputStr));
    textController.clear();
  }

  void addRandom() {
    context.read<NumberTriviaBloc>().add(GetTriviaForRandomNumber());
  }
}
