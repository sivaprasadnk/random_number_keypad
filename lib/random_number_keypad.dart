library random_number_keypad;

import 'dart:math';

import 'package:flutter/material.dart';

/// A widget that provides a custom numeric keypad with randomly positioned keys.
///
/// The keypad supports PIN input with separate boxes for each digit. It randomizes
/// the keys on each use to enhance security.
class RandomNumberKeypad extends StatefulWidget {
  /// The length of the PIN to be entered by the user.
  /// Defaults to 4 if not provided.
  final int pinLength;

  /// A callback function triggered when the user completes the PIN entry.
  /// The completed PIN is passed as a string to this function.
  final Function(String) onComplete;

  /// Creates an instance of [RandomNumberKeypad].
  ///
  /// [pinLength] specifies the number of digits for the PIN.
  /// [onComplete] is required and triggers when the PIN entry is complete.
  const RandomNumberKeypad({
    super.key,
    this.pinLength = 4,
    required this.onComplete,
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
    _generateRandomKeys();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Generates a randomized list of numeric keys (0-9).
  void _generateRandomKeys() {
    _keys = List.generate(10, (index) => index.toString());
    _keys.shuffle(Random());
  }

  /// Displays the custom numeric keypad as an overlay.
  void _showKeyboard() {
    if (_keyboardOverlay == null) {
      _keyboardOverlay = _createKeyboardOverlay();
      Overlay.of(context).insert(_keyboardOverlay!);
    }
  }

  /// Dismisses the custom numeric keypad and regenerates random keys.
  void _dismissKeyboard() {
    _keyboardOverlay?.remove();
    _keyboardOverlay = null;
    _generateRandomKeys();
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
            color: Colors.white,
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
                      value = ''; // Empty placeholder
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
                        } else if (value.isNotEmpty) {
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
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: icon != null
                            ? Icon(icon, size: 28, color: Colors.blue.shade900)
                            : Text(value, style: const TextStyle(fontSize: 20)),
                      ),
                    );
                  },
                ),
                TextButton(
                  onPressed: _dismissKeyboard,
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                )
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
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(8),
                  color: filled ? Colors.blue.shade100 : Colors.transparent,
                ),
                alignment: Alignment.center,
                child: filled
                    ? Text(
                        _pinController.text[index],
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
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
