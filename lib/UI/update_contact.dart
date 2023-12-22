import 'package:flutter/material.dart';
import 'package:gestion_contact/DB/sqlDatabase.dart';
import 'package:gestion_contact/Modele/contact.class.dart';

class UpdateContact extends StatefulWidget {
  final Contact contact;

  UpdateContact({required this.contact});

  @override
  _UpdateContact createState() => _UpdateContact();
}

class _UpdateContact extends State<UpdateContact> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    nameController.text = widget.contact.name;  //les valeurs atuctuelles
    phoneNumberController.text = widget.contact.phoneNumber;
    emailController.text = widget.contact.email;
  }

  void _updateContact() async {
    String name = nameController.text; // recupration du champ
    String phoneNumber = phoneNumberController.text;
    String email = emailController.text;

    // l'ID du contact existant à partir de widget.contact
    int id = widget.contact.id;


    DatabaseHelper sqlDatabase = DatabaseHelper();


    int result = await sqlDatabase.updateContact(id, name, phoneNumber, email);


    if (result > 0) {

      Contact updatedContact = Contact(
        id: id,
        name: name,
        phoneNumber: phoneNumber,
        email: email,
      );


      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Contact mis à jour avec succès!'),
      ));


      await Future.delayed(Duration(seconds: 1));


      Navigator.of(context).pop(updatedContact);// nav vers listecontact


    } else {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('La mise à jour du contact a échoué.'),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mettre à Jour le Contact'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
              onPressed: _updateContact,
              child: Text('update'),
            ),
          ],
        ),
      ),
    );
  }
}
