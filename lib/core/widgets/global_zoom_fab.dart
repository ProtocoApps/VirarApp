import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart' as provider;

import '../providers/text_scale_provider.dart';
import '../theme/app_theme.dart';

class GlobalZoomFAB extends StatelessWidget {
  final VoidCallback? onPressed;

  const GlobalZoomFAB({this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return provider.Consumer<TextScaleProvider>(
      builder: (context, textScale, _) {
        final isZoomed = !textScale.isDefault;
        return FloatingActionButton(
          heroTag: 'globalZoomFAB',
          backgroundColor: isZoomed ? AppColors.gold : AppColors.graphiteGray,
          foregroundColor: isZoomed ? AppColors.deepBlack : AppColors.gold,
          elevation: isZoomed ? 8 : 4,
          onPressed: () {
            onPressed?.call();
            _showZoomBottomSheet(context);
          },
          tooltip: 'Tamanho do texto',
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.text_fields, size: 26),
              if (isZoomed)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.deepBlack,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.gold, width: 1),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showZoomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => const _ZoomBottomSheet(),
    );
  }
}

class _ZoomBottomSheet extends StatefulWidget {
  const _ZoomBottomSheet();

  @override
  State<_ZoomBottomSheet> createState() => _ZoomBottomSheetState();
}

class _ZoomBottomSheetState extends State<_ZoomBottomSheet> {
  late double _initialScale;
  late double _sliderValue;

  @override
  void initState() {
    super.initState();
    final textScale = provider.Provider.of<TextScaleProvider>(context, listen: false);
    _initialScale = textScale.scale;
    _sliderValue = textScale.scale;
  }

  String get _percentLabel => '${(_sliderValue * 100).round()}%';

  String get _scaleLabel {
    if (_sliderValue <= 1.0) return 'Normal';
    if (_sliderValue <= 1.15) return 'Levemente maior';
    if (_sliderValue <= 1.3) return 'Médio';
    if (_sliderValue <= 1.4) return 'Grande';
    return 'Muito grande';
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkBrown,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: AppColors.gold, width: 0.5),
          left: BorderSide(color: AppColors.gold, width: 0.5),
          right: BorderSide(color: AppColors.gold, width: 0.5),
        ),
      ),
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottomPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Title row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.text_fields, color: AppColors.gold, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tamanho do texto',
                      style: TextStyle(
                        color: AppColors.softWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      'Ajusta textos menores para melhor leitura',
                      style: TextStyle(
                        color: AppColors.lightGray,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Preview box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.graphiteGray.withOpacity(0.5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.gold.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                // Small text preview
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Texto pequeno',
                        style: TextStyle(
                          color: AppColors.lightGray,
                          fontSize: 12 * _sliderValue,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Texto normal',
                        style: TextStyle(
                          color: AppColors.softWhite,
                          fontSize: 14 * _sliderValue,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                // Scale badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.gold.withOpacity(0.4)),
                  ),
                  child: Text(
                    _percentLabel,
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Slider row with A icons
          Row(
            children: [
              const Text(
                'A',
                style: TextStyle(
                  color: AppColors.lightGray,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.gold,
                    inactiveTrackColor: AppColors.gold.withOpacity(0.2),
                    thumbColor: AppColors.gold,
                    overlayColor: AppColors.gold.withOpacity(0.15),
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                    trackHeight: 4,
                    valueIndicatorColor: AppColors.gold,
                    valueIndicatorTextStyle: const TextStyle(
                      color: AppColors.deepBlack,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  child: Slider(
                    value: _sliderValue,
                    min: _initialScale,
                    max: TextScaleProvider.maxScale,
                    divisions: (((TextScaleProvider.maxScale - _initialScale) / 0.05).round()).clamp(1, 10),
                    label: _scaleLabel,
                    onChanged: _sliderValue >= TextScaleProvider.maxScale
                        ? null
                        : (v) {
                            HapticFeedback.selectionClick();
                            setState(() => _sliderValue = v);
                            provider.Provider.of<TextScaleProvider>(context, listen: false)
                                .setScale(v);
                          },
                  ),
                ),
              ),
              const Text(
                'A',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),

          // Scale label
          Center(
            child: Text(
              _scaleLabel,
              style: TextStyle(
                color: AppColors.softWhite.withOpacity(0.7),
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ),

          const SizedBox(height: 20),

          if (_sliderValue >= TextScaleProvider.maxScale)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.gold.withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, color: AppColors.gold, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Tamanho máximo atingido',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
