
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'UI/insert_contact.dart';
import 'UI/update_contact.dart';
import 'UI/liste_contact.dart';
import 'package:gestion_contact/Modele/contact.class.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await openDatabase(
    join(await getDatabasesPath(), 'cat_database.db'),
    onCreate: (db, version) {

    },
    version: 1,
  );

  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final Database database;

  MyApp({required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestion_Contact',
      initialRoute: '/liste_contact', // Utilisez / pour spécifier la route initiale

      routes: {
        '/liste_contact': (context) => ListeContact() , // Page d'accueil

      },
    );
  }
}


