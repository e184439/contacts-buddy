import 'package:flutter/material.dart';

class DetailsTile extends StatelessWidget {
  const DetailsTile({
    Key? key,
    required this.text,
    required this.label,
  }) : super(key: key);

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 24.0,
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }
}
