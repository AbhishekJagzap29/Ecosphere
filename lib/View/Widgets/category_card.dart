import 'package:echosphere/View/Constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? description;
  final Color color;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    required this.color,
    this.onTap,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.98 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Material(
        color: transparentColor,
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          borderRadius: BorderRadius.circular(18),
          splashColor: widget.color.withOpacity(0.08),
          highlightColor: widget.color.withOpacity(0.04),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: premiumSurfaceColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: _isPressed
                      ? categoryPressedOverlayColor
                      : premiumShadowColor,
                  blurRadius: _isPressed ? 10 : 22,
                  offset: Offset(0, _isPressed ? 3 : 10),
                ),
              ],
              border: Border.all(color: premiumGoldBorderColor),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                children: [
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: FaIcon(
                        widget.icon,
                        color: widget.color,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0,
                            color: cardTextColor,
                          ),
                        ),
                        if (widget.description != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            widget.description!,
                            style: const TextStyle(
                              fontSize: 13.5,
                            color: premiumMutedTextColor,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: grey400Color,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
