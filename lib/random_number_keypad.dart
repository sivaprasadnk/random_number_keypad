library random_number_keypad;

import 'dart:math';

import 'package:flutter/material.dart';

/// A widget that provides a custom numeric keypad with optionally randomized keys.
///
/// The keypad supports PIN input with separate boxes for each digit. It randomizes
/// the keys on each use to enhance security if enabled.
class RandomNumberKeypad extends StatefulWidget {
  /// The length of the PIN to be entered by the user.
  /// Defaults to 4 if not provided.
  final int pinLength;

  /// A callback function triggered when the user completes the PIN entry.
  /// The completed PIN is passed as a string to this function.
  final Function(String) onComplete;

  /// Determines whether the input should be visible or hidden (masked).
  /// Defaults to true (visible).
  final bool showInput;

  /// The background color of the keypad buttons.
  final Color buttonColor;

  /// The text style of the keypad button labels.
  final TextStyle buttonTextStyle;

  /// The shape of the input boxes (e.g., rounded rectangle, circle).
  final ShapeBorder inputShape;

  /// The text style of the input text.
  final TextStyle inputTextStyle;

  /// The fill color of the input boxes when filled.
  final Color inputFillColor;

  /// The background color of the keypad container.
  final Color keypadBackgroundColor;

  /// The text style of the "Done" button.
  final TextStyle doneButtonTextStyle;

  /// The text style of the "Clear" button.
  final TextStyle clearButtonTextStyle;

  /// Whether the keys should be randomized.
  /// Defaults to true (keys are randomized).
  final bool isRandom;

  /// Creates an instance of [RandomNumberKeypad].
  ///
  /// [pinLength] specifies the number of digits for the PIN.
  /// [onComplete] is required and triggers when the PIN entry is complete.
  /// [showInput] determines if the entered PIN is visible or masked.
  /// [buttonColor] sets the background color of the keypad buttons.
  /// [buttonTextStyle] sets the text style of the keypad button labels.
  /// [inputShape] defines the shape of the input boxes.
  /// [inputTextStyle] sets the text style of the input text.
  /// [inputFillColor] sets the fill color of input boxes when filled.
  /// [keypadBackgroundColor] sets the background color of the keypad container.
  /// [doneButtonTextStyle] sets the text style of the "Done" button.
  /// [clearButtonTextStyle] sets the text style of the "Clear" button.
  /// [isRandom] determines whether the keypad keys should be randomized.
  const RandomNumberKeypad({
    super.key,
    this.pinLength = 4,
    required this.onComplete,
    this.showInput = true,
    this.buttonColor = Colors.blueAccent,
    this.buttonTextStyle = const TextStyle(fontSize: 20, color: Colors.white),
    this.inputShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    this.inputTextStyle =
        const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    this.inputFillColor = Colors.blueAccent,
    this.keypadBackgroundColor = Colors.white,
    this.doneButtonTextStyle =
        const TextStyle(color: Colors.blue, fontSize: 18),
    this.clearButtonTextStyle =
        const TextStyle(color: Colors.red, fontSize: 18),
    this.isRandom = true,
  });

  @override
  State<RandomNumberKeypad> createState() => _RandomNumberKeypadState();
}

class _RandomNumberKeypadState extends State<RandomNumberKeypad> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _pinController = TextEditingController();
  OverlayEntry? _keyboardOverlay;
  List<String> _keys = [];

  @override
  void initState() {
    super.initState();
    _generateKeys();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Generates a list of numeric keys (0-9).
  /// If randomization is enabled, the keys are shuffled.
  void _generateKeys() {
    _keys = List.generate(10, (index) => index.toString());
    if (widget.isRandom) {
      _keys.shuffle(Random());
    }
  }

  /// Displays the custom numeric keypad as an overlay.
  void _showKeyboard() {
    if (_keyboardOverlay == null) {
      _keyboardOverlay = _createKeyboardOverlay();
      Overlay.of(context).insert(_keyboardOverlay!);
    }
  }

  /// Dismisses the custom numeric keypad and regenerates keys.
  void _dismissKeyboard() {
    _keyboardOverlay?.remove();
    _keyboardOverlay = null;
    _generateKeys();
  }

  /// Creates the overlay entry containing the numeric keypad.
  OverlayEntry _createKeyboardOverlay() {
    return OverlayEntry(
      builder: (context) => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Material(
          elevation: 4,
          child: Container(
            color: widget.keypadBackgroundColor,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    mainAxisExtent: 50,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  itemCount: 12, // 0-9, backspace
                  itemBuilder: (context, index) {
                    String value;
                    IconData? icon;

                    if (index < 9) {
                      value = _keys[index];
                    } else if (index == 9) {
                      value = 'Clear'; // Empty placeholder
                    } else if (index == 10) {
                      value = _keys.last; // "0"
                    } else {
                      icon = Icons.backspace;
                      value = '';
                    }

                    return GestureDetector(
                      onTap: () {
                        if (icon == Icons.backspace) {
                          if (_pinController.text.isNotEmpty) {
                            setState(() {
                              _pinController.text = _pinController.text
                                  .substring(0, _pinController.text.length - 1);
                            });
                          }
                        } else if (value.isNotEmpty && value != "Clear") {
                          if (_pinController.text.length < widget.pinLength) {
                            setState(() {
                              _pinController.text += value;
                            });

                            if (_pinController.text.length ==
                                widget.pinLength) {
                              widget.onComplete(_pinController.text);
                              _dismissKeyboard();
                            }
                          }
                        } else if (value == "Clear") {
                          setState(() {
                            _pinController.clear();
                          });
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: widget.buttonColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: icon != null
                            ? Icon(icon, size: 28, color: Colors.white)
                            : Text(value, style: widget.buttonTextStyle),
                      ),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _dismissKeyboard,
                      child: Text(
                        'Done',
                        style: widget.doneButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
        _showKeyboard();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.pinLength, (index) {
              bool filled = index < _pinController.text.length;
              return Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: ShapeDecoration(
                  shape: widget.inputShape,
                  color: filled ? widget.inputFillColor : widget.inputFillColor,
                ),
                alignment: Alignment.center,
                child: filled
                    ? Text(
                        widget.showInput ? _pinController.text[index] : '*',
                        style: widget.inputTextStyle,
                      )
                    : null,
              );
            }),
          ),
          const SizedBox(height: 10),
          TextField(
            focusNode: _focusNode,
            controller: _pinController,
            readOnly: true,
            decoration: const InputDecoration(border: InputBorder.none),
            style: const TextStyle(fontSize: 1), // Invisible field
          ),
        ],
      ),
    );
  }
}
