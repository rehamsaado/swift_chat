import 'package:flutter/material.dart';

class EditableInfoTile extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final Function(String)? onSave;

  const EditableInfoTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.onSave,
  });

  @override
  State<EditableInfoTile> createState() => _EditableInfoTileState();
}

class _EditableInfoTileState extends State<EditableInfoTile> {
  bool _isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant EditableInfoTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isReadOnly = widget.onSave == null;

    return ListTile(
      leading: Icon(widget.icon, color: Colors.blueAccent),
      title: Text(
        widget.label,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      subtitle: _isEditing && !isReadOnly
          ? TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                isDense: true,
              ),
            )
          : Text(
              widget.value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
      trailing: isReadOnly
          ? null
          : IconButton(
              icon: Icon(_isEditing ? Icons.check : Icons.edit, color: Colors.green),
              onPressed: () {
                if (_isEditing) {
                  widget.onSave!(_controller.text);
                }
                setState(() => _isEditing = !_isEditing);
              },
            ),
    );
  }
}
