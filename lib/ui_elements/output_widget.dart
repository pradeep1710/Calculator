import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic.dart';

class OutputWidget extends StatelessWidget {
  const OutputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    getSize(String input) {
      final standardSize = Theme.of(context).textTheme.headlineLarge!.fontSize!;
      if (input.length < 13) {
        return standardSize;
      } else {
        final overflowSize = input.length - 13;
        if (overflowSize < 5) {
          return standardSize - (overflowSize * 1.7);
        } else {
          return standardSize - 8;
        }
      }
    }

    return FutureBuilder(
        future: Provider.of<Calculation>(context, listen: false).fetchData(),
        builder: (context, snapshot) {
          return SizedBox(
            width: double.infinity,
            child: Consumer<Calculation>(
              builder: (context, value, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics:
                          const ScrollPhysics(parent: BouncingScrollPhysics()),
                      reverse: true,
                      child: Text(
                        value.input.isNotEmpty ? value.input : '|',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          fontSize: getSize(value.input),
                        ),
                      ),
                    ),
                    if (value.output.isNotEmpty)
                      FittedBox(
                        child: Text(
                          value.output,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 26),
                        ),
                      ),
                    const SizedBox(height: 65),
                  ],
                );
              },
            ),
          );
        });
  }
}
