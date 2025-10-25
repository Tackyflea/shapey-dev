// define your context menu entries
import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

// just to test all the options
final TestMenuEntries = <ContextMenuEntry>[
  const MenuHeader(text: "Context Menu"),
  MenuItem(
    label: 'Add ',
    icon: Icons.add,
    onSelected: () {
      // implement copy
    },
  ),
  MenuItem(
    label: 'Remove ',
    icon: Icons.remove,
    onSelected: () {
      // implement cut
    },
  ),
  MenuItem(
    label: 'Paste',
    icon: Icons.paste,
    onSelected: () {
      // implement paste
    },
  ),
  const MenuDivider(),
  MenuItem.submenu(
    label: 'Edit',
    icon: Icons.edit,
    items: [
      MenuItem(
        label: 'Undo',
        value: "Undo",
        icon: Icons.undo,
        onSelected: () {
          // implement undo
        },
      ),
      MenuItem(
        label: 'Redo',
        value: 'Redo',
        icon: Icons.redo,
        onSelected: () {
          // implement redo
        },
      ),
    ],
  ),
];
