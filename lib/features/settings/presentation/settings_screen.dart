import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/providers/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _accentColors = [
  Color(0xFFE8A020),
  Color(0xFF4CAF50),
  Color(0xFF2196F3),
  Color(0xFFE91E63),
  Color(0xFF9C27B0),
  Color(0xFFFF5722),
  Color(0xFF00BCD4),
  Color(0xFFFFEB3B),
];

const _cardColors = [
  Color(0xFF1C1D22),
  Color(0xFFE8A020),
  Color(0xFF1565C0),
  Color(0xFF2E7D32),
  Color(0xFFB71C1C),
  Color(0xFF4A148C),
  Color(0xFF37474F),
  Color(0xFF212121),
  Color(0xFF795548),
];

const _digitColors = [
  Color(0xFFF2F2F2),
  Color(0xFFFFFFFF),
  Color(0xFFFFF176),
  Color(0xFFB3E5FC),
  Color(0xFFA5D6A7),
  Color(0xFFFFCCBC),
  Color(0xFFD1C4E9),
  Color(0xFFFFCDD2),
  Color(0xFFB0BEC5),
];

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final is24h = ref.watch(clockFormatProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Settings'),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: 'APPEARANCE',
            children: [
              _ColorRow(
                label: 'Accent Color',
                colors: _accentColors,
                selected: theme.accentColor,
                onSelected: notifier.updateAccentColor,
              ),
              _ColorRow(
                label: 'Card Color',
                colors: _cardColors,
                selected: theme.cardColor,
                onSelected: notifier.updateCardColor,
              ),
              _ColorRow(
                label: 'Digit Color',
                colors: _digitColors,
                selected: theme.cardTextColor,
                onSelected: notifier.updateCardTextColor,
              ),
              _SliderTile(
                label: 'Card Border Radius',
                value: theme.cardBorderRadius,
                min: 0,
                max: 28,
                divisions: 28,
                onChanged: notifier.setCardBorderRadius,
              ),
              _ToggleTile(
                label: 'Card Glow',
                value: theme.glowEnabled,
                onChanged: notifier.setGlowEnabled,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'ANIMATION',
            children: [
              _SliderTile(
                label: 'Flip Speed (ms)',
                value: theme.flipDurationMs,
                min: 150,
                max: 1200,
                divisions: 14,
                displayValue: '${theme.flipDurationMs.toInt()}ms',
                onChanged: notifier.setFlipDuration,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'CLOCK',
            children: [
              _ToggleTile(
                label: '24-Hour Format',
                value: is24h,
                onChanged: (v) =>
                    ref.read(clockFormatProvider.notifier).set24h(v),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'GENERAL',
            children: [
              ListTile(
                tileColor: Colors.white.withOpacity(0.05),
                title: const Text(
                  'Reset to Defaults',
                  style: TextStyle(color: Colors.red),
                ),
                trailing: const Icon(Icons.restore, color: Colors.red),
                onTap: () {
                  notifier.resetToDefaults();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings reset')),
                  );
                },
              ),
              const ListTile(
                tileColor: Color(0x0DFFFFFF),
                title: Text(
                  'Version',
                  style: TextStyle(color: Colors.white70),
                ),
                trailing: Text(
                  '1.0.0',
                  style: TextStyle(color: Colors.white38),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Card(
          color: Colors.white.withOpacity(0.07),
          margin: EdgeInsets.zero,
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ColorRow extends StatelessWidget {
  const _ColorRow({
    required this.label,
    required this.colors,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final List<Color> colors;
  final Color selected;
  final ValueChanged<Color> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: colors.map((c) {
              final isSelected = c.value == selected.value;
              return GestureDetector(
                onTap: () => onSelected(c),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: Colors.white, width: 3)
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    this.displayValue,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
  final String? displayValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Text(
                displayValue ?? value.toStringAsFixed(1),
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            activeColor: const Color(0xFFE8A020),
            inactiveColor: Colors.white24,
          ),
        ],
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(label, style: const TextStyle(color: Colors.white70)),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFFE8A020),
    );
  }
}
