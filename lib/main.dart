import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_localization/flutter_localization.dart';

void main() {
  runApp(MaterialApp(
    title: 'Contact App',
    home: ContactApp(),
    supportedLocales: [
      // Add the supported locales for your app
      const Locale('en', 'US'),
      const Locale('es', 'ES'),
    ],
  ));
}

class Contact {
  String name;
  String phoneNumber;

  Contact({required this.name, required this.phoneNumber});
}

class ContactApp extends StatefulWidget {
  @override
  _ContactAppState createState() => _ContactAppState();
}

class _ContactAppState extends State<ContactApp> {
  List<Contact> contacts = [];

  void _addContact(Contact contact) {
    setState(() {
      contacts.add(contact);
    });
  }

  void _deleteContact(Contact contact) {
    setState(() {
      contacts.remove(contact);
    });
  }

  void _dialCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to dial call.'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _showAddContactDialog(BuildContext context) {
    String name = '';
    String phoneNumber = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Contact'),
          content: Column(
            children: [
              TextField(
                onChanged: (value) => name = value,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                onChanged: (value) => phoneNumber = value,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (name.isNotEmpty && phoneNumber.isNotEmpty) {
                  _addContact(Contact(name: name, phoneNumber: phoneNumber));
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Contacts'),
        ),
        body: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(contacts[index].name),
              subtitle: Text(contacts[index].phoneNumber),
              trailing: IconButton(
                icon: Icon(Icons.phone),
                onPressed: () => _dialCall(contacts[index].phoneNumber),
              ),
              onLongPress: () => _deleteContact(contacts[index]),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddContactDialog(context),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
