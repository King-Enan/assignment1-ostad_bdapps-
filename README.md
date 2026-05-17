# Product Management Shop

A Flutter product management app created in the same in-memory `List<Map<String, dynamic>>` style as the provided student list manager project.

## Features

- Home page with Product Add button
- Quantity sorting button
- Add product page using `TextEditingController`
- Update product page using `TextEditingController`
- Products stored as `Map<String, dynamic>` objects inside a list
- `ListView.builder` product card listing
- Product quantity shown in red when below 10 kg, green otherwise
- Delete and update buttons on every card

## How to use

Create a Flutter project, replace the generated `lib` folder with this `lib` folder, then run:

```bash
flutter pub get
flutter run
```
