import 'package:contacts_buddy/models/contact.dart';
import 'package:contacts_buddy/pages/add_contact_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/contacts_search.dart';
import 'contact_details_page.dart';
import 'edit_contact_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final _searchFormKey = GlobalKey<FormState>(debugLabel: 'search_form');

  // from https://pub.dev/packages/url_launcher/example
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), elevation: 0, actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const AddContactPage();
                },
              ),
            );
          },
          icon: const Icon(
            Icons.person_add_alt_sharp,
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSearch(context: context, delegate: ContactsSearch());
        },
        child: const Icon(Icons.search),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<Contact>('contacts').listenable(),
              builder: (context, Box<Contact> box, _) {
                if (box.values.isEmpty) {
                  return const Center(
                    child: Text("¯\\_(ツ)_/¯\n\nNo contacts available.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 32.0)),
                  );
                }

                return ListView.separated(
                  itemBuilder: (context, index) {
                    Contact? currentContact = box.getAt(index);

                    return ContactListItem(
                      currentContact: currentContact!,
                      onPress: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return ContactDetailsPage(
                                selectedContact: currentContact);
                          },
                        ));
                      },
                      onLongPress: () {},
                      onDelete: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              icon: const Icon(Icons.delete),
                              title: const Text('Delete Contact'),
                              content: Text(
                                  'Your are going to delete ${currentContact?.name} permanently.\nAre you sure?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      currentContact?.delete();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Ok')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel')),
                              ],
                            );
                          },
                        );
                      },
                      onEdit: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return EditContactPage(
                              contact: currentContact!,
                            );
                          },
                        ));
                      },
                      onCall: () async {
                        await _makePhoneCall(currentContact.telephone!);
                      },
                      onShare: () {},
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(height: 16.0);
                  },
                  itemCount: box.values.length,
                );
              },
            ),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
