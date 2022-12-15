import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:contacts_buddy/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ContactListItem extends StatelessWidget {
  final Contact currentContact;
  final VoidCallback onPress;
  final VoidCallback onLongPress;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onCall;
  final VoidCallback onShare;

  const ContactListItem({
    Key? key,
    required this.currentContact,
    required this.onPress,
    required this.onLongPress,
    required this.onDelete,
    required this.onEdit,
    required this.onCall,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onEdit(),
            icon: Icons.edit,
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.all(8.0),
            foregroundColor: Colors.white,
            autoClose: true,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onDelete(),
            icon: Icons.delete_outline,
            backgroundColor: Colors.red,
            padding: const EdgeInsets.all(8.0),
            foregroundColor: Colors.white,
            autoClose: true,
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          onPress();
        },
        onLongPress: () async {
          FlutterClipboard.copy(currentContact.telephone!).then((value) {
            ScaffoldMessenger.of(context).showMaterialBanner(
              MaterialBanner(
                content: const Text('Phone number copied'),
                actions: [
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .removeCurrentMaterialBanner();
                    },
                    child: const Text('OK'),
                  ),
                ],
                elevation: 1.0,
              ),
            );
          });
        },
        leading: currentContact!.image == null
            ? const Hero(tag: 'image', child: Icon(Icons.person))
            : Hero(
                tag: 'image',
                child: CircleAvatar(
                  radius: 48.0,
                  backgroundColor: Colors.red,
                  backgroundImage: FileImage(
                    File('${currentContact.image}'),
                  ),
                ),
              ),
        title: Text('${currentContact.name}'),
        subtitle: Text('${currentContact.telephone}'),
        trailing: IconButton(
          onPressed: () => onCall(),
          icon: const Icon(
            Icons.call,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
