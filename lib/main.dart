import 'package:contacts_buddy/models/contact.dart';
import 'package:contacts_buddy/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // init flutter
  await Hive.initFlutter();

  // register adapters
  Hive.registerAdapter(ContactAdapter());

  await Hive.openBox<Contact>('contacts');

  runApp(const ContactsBuddyApp());
}

class ContactsBuddyApp extends StatelessWidget {
  const ContactsBuddyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contact Buddy',
      home: const HomePage(title: 'Contact Buddy'),
      theme: ThemeData(
        primaryColor: Colors.amber.shade700,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.amber.shade700,
        ),
        primarySwatch: Colors.amber,
      ),
    );
  }
}
