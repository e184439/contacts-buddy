import 'package:contacts_buddy/models/contact.dart';
import 'package:contacts_buddy/pages/contact_details_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ContactsSearch extends SearchDelegate<Contact> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          }),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Contact>('contacts').listenable(),
      builder: (context, Box<Contact> contactsBox, _) {
        // find items
        var results = query.isEmpty
            ? contactsBox.values.toList() // whole list
            : contactsBox.values
                .where((c) => c.name!.toLowerCase().contains(query))
                .toList();

        // build no results
        if (results.isEmpty) {
          return const Center(
            child: Text('No contacts matching your search'),
          );
        }

        // build the list
        return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final Contact contactAtIndex = results[index];

              return ListTile(
                title: Text(contactAtIndex.name!),
                subtitle: Text(contactAtIndex.telephone!),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) {
                        return ContactDetailsPage(
                          selectedContact: contactAtIndex,
                        );
                      },
                    ),
                  );
                },
              );
            });
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }
}
