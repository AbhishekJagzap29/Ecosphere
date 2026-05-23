import 'package:dw_echosphere_app/Api/ResponseModel/taluka_response_model.dart';
import 'package:dw_echosphere_app/View/Constant/app_color.dart';
import 'package:flutter/material.dart';

class TalukaSelector extends StatefulWidget {
  final TextEditingController controller;
  final List<TalukaData> talukas;
  final TalukaData? selectedTaluka;
  final ValueChanged<TalukaData> onSelected;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final bool enabled;

  const TalukaSelector({
    super.key,
    required this.controller,
    required this.talukas,
    required this.selectedTaluka,
    required this.onSelected,
    this.onChanged,
    this.hintText = 'Search and select taluka',
    this.enabled = true,
  });

  @override
  State<TalukaSelector> createState() => _TalukaSelectorState();
}

class _TalukaSelectorState extends State<TalukaSelector> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<TalukaData>(
      textEditingController: widget.controller,
      focusNode: _focusNode,
      optionsBuilder: (textEditingValue) {
        final query = textEditingValue.text.trim().toLowerCase();
        if (query.isEmpty) {
          return widget.talukas;
        }

        return widget.talukas.where(
          (taluka) => (taluka.name ?? '').toLowerCase().contains(query),
        );
      },
      displayStringForOption: (option) => option.name ?? '',
      onSelected: widget.onSelected,
      fieldViewBuilder: (
        context,
        textEditingController,
        focusNode,
        onFieldSubmitted,
      ) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          enabled: widget.enabled,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.words,
          style: const TextStyle(color: premiumTextColor),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: premiumMutedTextColor),
            prefixIcon: const Icon(
              Icons.location_on_outlined,
              color: primaryGreenColor,
            ),
            suffixIcon: const Icon(
              Icons.keyboard_arrow_down,
              color: premiumMutedTextColor,
            ),
            filled: true,
            fillColor: textFieldColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: premiumGoldBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: premiumGoldBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: primaryGreenColor),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: premiumBorderColor),
            ),
          ),
          onChanged: widget.onChanged,
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: premiumSurfaceTintColor,
            elevation: 8,
            borderRadius: BorderRadius.circular(14),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 220,
                maxWidth: 440,
              ),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  color: premiumBorderColor,
                ),
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);

                  return ListTile(
                    dense: true,
                    title: Text(
                      option.name ?? '',
                      style: const TextStyle(color: premiumTextColor),
                    ),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
