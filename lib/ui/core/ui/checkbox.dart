import 'package:flutter/material.dart';

class AppCheckboxField extends FormField<bool> {
  AppCheckboxField({
    super.key,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color activeColor,
    required Widget label,
    String errorText = 'Você precisa aceitar os termos para continuar',
}) : super(
    initialValue: value,
    validator: (selected) {
      if (selected == null || !selected) return errorText;
      return null;
    },
    builder: (FormFieldState<bool> state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: state.value,
                activeColor: activeColor,
                onChanged: (newValue) {
                  onChanged(newValue ?? false);
                  state.didChange(newValue);
                },
              ),
              Flexible(child: label)
            ],
          ),
          if (state.hasError)
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                state.errorText!,
                style: Theme.of(state.context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(state.context).colorScheme.error,
                ),
              ),
            ),
        ],
      );
    },
  );
}