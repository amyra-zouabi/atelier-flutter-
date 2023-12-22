import 'package:flutter/material.dart';
import 'package:gestion_contact/DB/sqlDatabase.dart';
import 'package:gestion_contact/Modele/contact.class.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gestion_contact/UI/insert_contact.dart';
import 'package:gestion_contact/UI/update_contact.dart';

class ListeContact extends StatefulWidget {
  @override
  _ListeContactState createState() => _ListeContactState();
}

class _ListeContactState extends State<ListeContact> {
  Contact? updatedContact; // Variable pour stocker le contact mis à jour
  TextEditingController searchController = TextEditingController(); // cont pour champ de recherche
  List<Contact> contacts = []; // Liste des contacts à afficher

  @override
  void initState() {
    super.initState();

    loadContacts();
  }


  void loadContacts() async {
    final allContacts = await DatabaseHelper().readContacts();
    setState(() {
      contacts = allContacts;
    });
  }


  void _makePhoneCall(Contact contact) async {
    final phoneNumber = contact.phoneNumber;
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Impossible d\'effectuer un appel téléphonique vers $phoneNumber';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Contacts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: onSearchTextChanged,
              decoration: InputDecoration(
                labelText: 'Rechercher un contact',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                Contact contact = contacts[index];
                return ListTile(
                  title: Text(contact.name),
                  subtitle: Text(contact.phoneNumber),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  IconButton(
                  icon: Icon(Icons.call), // Icône d'appel téléphonique
                  onPressed: () {
                    _makePhoneCall(contact); // Appeler la fonction _makePhoneCall avec le contact
                  },
                ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateContact(contact: contact),
                            ),
                          );
                          if (result != null && result is Contact) {
                            updatedContact = result;
                            loadContacts();
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          DatabaseHelper sqlDatabase = DatabaseHelper();
                          sqlDatabase.deleteContact(contact.id).then((result) {
                            if (result > 0) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Contact supprimé avec succès!'),
                              ));
                              loadContacts();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InsertContact(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  // Fonction appelée lorsque l'utilisateur tape dans le champ de recherche
  void onSearchTextChanged(String query) {
    setState(() {
      searchContacts(query);
    });
  }

  // Fonction pour rechercher des contacts dans bd
  void searchContacts(String query) {
    DatabaseHelper().searchContacts(query).then((result) {
      setState(() {
        contacts = result ?? [];
      });
    });
  }
}
