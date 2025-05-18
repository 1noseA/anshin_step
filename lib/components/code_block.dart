import 'package:flutter/material.dart';

class CodeBlock extends StatelessWidget {
  final String code;
  const CodeBlock({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FA),
        borderRadius: BorderRadius.circular(6),
      ),
      child: SelectableText(
        code,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              color: const Color(0xFF1A1A1A),
            ),
      ),
    );
  }
}
