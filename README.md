# RandomNumberKeypad

`RandomNumberKeypad`  is a customizable Flutter widget that provides a secure numeric keypad for PIN input. It features an optional randomization of keys to enhance user security, shuffling the keypad layout after every use when enabled. The widget supports masked or visible PIN entry, allows various PIN lengths, and provides extensive customization options for appearance and behavior.

## Features
- Numeric keypad with random key positions.
- Customizable PIN length (default is 4).
- Option to show or hide PIN input (masked input).
- Other customisation options.

## Installation

Add the widget file `random_number_keypad.dart` to your project and import it:

```dart
import 'package:random_number_keypad/random_number_keypad.dart';
```

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:random_number_keypad/random_number_keypad.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Random Number Keypad')),
        body: Center(
          child: RandomNumberKeypad(
            pinLength: 4,
            onComplete: (pin) {
              print('Entered PIN: $pin');
            },
            showInput: false, // Set to true to show PIN input
          ),
        ),
      ),
    );
  }
}
```

### Parameters

| Parameter   | Type                   | Default | Description |
|-------------|------------------------|---------|-------------|
| `pinLength` | `int`                 | `4`     | The length of the PIN to be entered. |
| `buttonColor` | `Color`                 | `Colors.blueAccent`     | Sets the background color of the keypad buttons. |
| `buttonTextStyle` | `TextStyle`                 | `TextStyle(fontSize: 20, color: Colors.white)`     | Sets the text style of the keypad button labels. |
| `inputShape` | `TextStyle`                 | `TextStyle(fontSize: 20, color: Colors.white)`     | Defines the shape of the input boxes. |
| `inputTextStyle` | `TextStyle`                 | `TextStyle(fontSize: 20, color: Colors.white)`     | Sets the text style of the input text. |
| `inputFillColor` | `TextStyle`                 | `TextStyle(fontSize: 20, color: Colors.white)`     | sets the fill color of input boxes when filled. |
| `keypadBackgroundColor` | `TextStyle`                 | `TextStyle(fontSize: 20, color: Colors.white)`     | sets the background color of the keypad container. |
| `doneButtonTextStyle` | `TextStyle`                 | `TextStyle(fontSize: 20, color: Colors.white)`     | Sets the text style of the "Done" button. |
| `onComplete`| `Function(String)`    | Required| A callback function triggered when the user completes the PIN entry. The entered PIN is passed as a string. |
| `showInput` | `bool`                | `true`  | Determines whether the entered PIN should be visible (`true`) or masked (`false`). |
| `isRandom` | `bool`                | `true`  |  Determines whether the keypad keys should be randomized. |

## Customization

- **Randomized Keys:** Each time the keyboard is shown, the numeric keys are shuffled to ensure secure PIN entry.
- **Keyboard Overlay:** The keyboard appears as a dismissible overlay, ensuring it doesn't interfere with the app's layout.

### Example of Masked Input

To hide the PIN input, set `showInput` to `false`:

```dart
RandomNumberKeypad(
  pinLength: 6,
  onComplete: (pin) {
    print('Entered PIN: $pin');
  },
  showInput: false,
)
```

## Contributions

Feel free to contribute by submitting issues or pull requests. All contributions are welcome!

## License

This widget is released under the MIT License.

---

Happy coding with `RandomNumberKeypad`! 🎉
