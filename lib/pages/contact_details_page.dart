import 'dart:io';

import 'package:contacts_buddy/models/contact.dart';
import 'package:contacts_buddy/widgets/details_tile.dart';
import 'package:flutter/material.dart';

class ContactDetailsPage extends StatefulWidget {
  final Contact selectedContact;
  const ContactDetailsPage({Key? key, required this.selectedContact})
      : super(key: key);

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details of ${widget.selectedContact.name}'),
      ),
      body: Column(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 400.00,
          child: Hero(
            tag: 'image',
            child: Image.file(
              fit: BoxFit.cover,
              File(widget.selectedContact.image!),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailsTile(
                  text: widget.selectedContact.name!,
                  label: 'Name',
                ),
                const SizedBox(height: 16.0),
                DetailsTile(
                  text: widget.selectedContact.telephone!,
                  label: 'Telephone No',
                ),
                const SizedBox(height: 16.0),
                DetailsTile(
                  text: widget.selectedContact.email!,
                  label: 'Email',
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
