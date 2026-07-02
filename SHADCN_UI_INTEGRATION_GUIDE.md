This file is mixing Material UI with shadcn_flutter.

Fix this file only.

Rules:
- Remove import 'package:flutter/material.dart' if possible.
- Use import 'package:flutter/widgets.dart' as fw for base Flutter widgets/layout/navigation.
- Keep shadcn_flutter as the main UI framework.
- Do not use MaterialPageRoute.
- Do not use InkWell.
- Do not use TextButton, ElevatedButton, OutlinedButton, FloatingActionButton, or DropdownButtonFormField.
- Do not use Material Dialogs or Material Scaffold.
- Use shadcn Scaffold, Card, TextField, PrimaryButton, SecondaryButton, OutlineButton, DestructiveButton, and AlertDialog.
- For clickable cards, use fw.GestureDetector around shadcn Card.
- For navigation, use fw.Navigator with fw.PageRouteBuilder or the existing project navigation helper.
- Do not change business logic.
- Do not change API logic.
- Do not change unrelated files.
- Apply changes directly to the workspace file.
- Do not paste full file contents in chat.