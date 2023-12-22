import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gestion_contact/Modele/contact.class.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'gestion_contact.db');
    final db = await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
    return db;
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Contact (
        id INTEGER PRIMARY KEY,
        name TEXT,
        phoneNumber TEXT,
        email TEXT
      )
    ''');
  }

  Future<List<Contact>> readContacts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Contact');
    return List.generate(maps.length, (i) {
      return Contact(
        id: maps[i]['id'],
        name: maps[i]['name'],
        phoneNumber: maps[i]['phoneNumber'],
        email: maps[i]['email'],
      );
    });
  }

  Future<int> insertContact(Contact contact) async {
    final db = await database;
    return await db.insert('Contact', {
      'name': contact.name,
      'phoneNumber': contact.phoneNumber,
      'email': contact.email,
    });
  }

  Future<int> updateContact(int id, String name, String phoneNumber, String email) async {
    final db = await database;
    return await db.update(
      'Contact',
      {'name': name, 'phoneNumber': phoneNumber, 'email': email},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete(
      'Contact',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Contact>?> searchContacts(String query) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      "SELECT * FROM Contact WHERE name LIKE '%$query%' OR phoneNumber LIKE '%$query%'",
    );

    if (maps.isEmpty) {
      return null; // Aucun résultat trouvé, renvoie null
    }

    return List.generate(maps.length, (i) {
      return Contact(
        id: maps[i]['id'],
        name: maps[i]['name'],
        phoneNumber: maps[i]['phoneNumber'],
        email: maps[i]['email'],
      );
    });
  }

}
