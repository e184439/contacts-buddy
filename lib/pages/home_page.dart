import 'package:contacts_buddy/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/contacts_search.dart';
import '../widgets/contact_list_item.dart';
import 'add_contact_page.dart';
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
  Future<void> triggerCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Image.asset('assets/logo.png', height: 48.0),
          centerTitle: true,
          elevation: 0,
          actions: [
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
                color: Colors.white,
              ),
            ),
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSearch(context: context, delegate: ContactsSearch());
        },
        child: const Icon(Icons.search, color: Colors.white),
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
                  return const Center();
                }

                return ListView.separated(
                  itemBuilder: (context, index) {
                    Contact? contactEntry = box.getAt(index);

                    return ContactListTile(
                      currentContact: contactEntry!,
                      onPress: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return ContactDetailsPage(
                                selectedContact: contactEntry);
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
                              title: const Text('Delete'),
                              content: const Text(
                                  'Are you sure you want to delete?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      contactEntry?.delete();
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
                              contact: contactEntry!,
                            );
                          },
                        ));
                      },
                      onCall: () async {
                        await triggerCall(contactEntry.telephone!);
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
