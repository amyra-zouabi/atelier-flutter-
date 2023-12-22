import 'dart:async'; // Importez la bibliothèque async

import 'package:flutter/material.dart';
import 'package:gestion_contact/DB/sqlDatabase.dart';
import 'package:gestion_contact/Modele/contact.class.dart';
import 'liste_contact.dart'; // Assurez-vous d'importer correctement la page ListeContact

class InsertContact extends StatefulWidget {
  @override
  _InsertContact createState() => _InsertContact();
}

class _InsertContact extends State<InsertContact> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  void _insertContact() async {
    String name = nameController.text;// récupération du données saisie par user
    String phoneNumber = phoneNumberController.text;
    String email = emailController.text;

    Contact newContact = Contact(id: 1, name: name, phoneNumber: phoneNumber, email: email);

    DatabaseHelper sqlDatabase = DatabaseHelper();//Insertion du nouveau contact dans la base de données :
    int result = await sqlDatabase.insertContact(newContact);

    nameController.clear();
    phoneNumberController.clear();
    emailController.clear();

    if (result > 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Contact inséré avec succès!'),
      ));


      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ListeContact(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insérer un Contact'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset('img/Avatar.png'),


            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Numéro de Téléphone'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _insertContact,
              child: Text('Ajouter le Contact'),
            ),
          ],
        ),
      ),
    );
  }
}
