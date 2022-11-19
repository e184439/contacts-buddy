import 'dart:io';

import 'package:contacts_buddy/models/contact.dart';
import 'package:contacts_buddy/pages/add_contact_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
      appBar: AppBar(
          title: Text(widget.title),
          elevation: 0,
          centerTitle: true,
          leading: const Icon(Icons.contact_phone),
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
              ),
            ),
          ]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _searchFormKey,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16.0),
                            border: InputBorder.none,
                            hintText: 'Search contacts'),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.search,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<Contact>('contacts').listenable(),
                builder: (context, Box<Contact> box, _) {
                  if (box.values.isEmpty) {
                    return const Center(
                      child: Text("No contacts"),
                    );
                  }

                  return ListView.separated(
                    itemBuilder: (context, index) {
                      Contact? currentContact = box.getAt(index);
                      print(currentContact?.image);
                      return Slidable(
                        startActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
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
                              icon: Icons.delete_outline,
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.all(8.0),
                              foregroundColor: Colors.white,
                              autoClose: true,
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return EditContactPage(
                                      contact: currentContact!,
                                    );
                                  },
                                ));
                              },
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
                              onPressed: (context) {},
                              icon: Icons.share,
                              backgroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.all(8.0),
                              foregroundColor: Colors.white,
                              autoClose: true,
                            ),
                          ],
                        ),
                        child: ListTile(
                          onTap: () {},
                          onLongPress: () {
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
                          },
                          leading: currentContact!.image == null
                              ? const Icon(Icons.person)
                              : CircleAvatar(
                                  radius: 48.0,
                                  backgroundColor: Colors.red,
                                  backgroundImage: FileImage(
                                    File('${currentContact.image}'),
                                  ),
                                ),
                          title: Text('${currentContact.name}'),
                          subtitle: Text('${currentContact.telephone}'),
                          trailing: IconButton(
                            onPressed: () async {
                              _makePhoneCall(currentContact.telephone!);
                            },
                            icon: const Icon(Icons.call),
                          ),
                        ),
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
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
