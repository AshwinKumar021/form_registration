import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_registration/constant/constant.dart';
import 'package:form_registration/database/database.helper.dart';
import 'package:form_registration/model/registration_model.dart';

class Userlist extends HookWidget {
  List<Registrationform> mlist;
  Userlist({required this.mlist, super.key});

  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper.instance;

    void _loadNotes() async {
      logger.i('Creating Db...');
      List<Registrationform> notes = await dbHelper.getAllNotes();
      mlist = notes;
    }

    void _deleteNote(int index) async {
      await dbHelper.delete(mlist[index].id!);

      mlist.removeAt(index);
      _loadNotes();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter SQLite CRUD'),
      ),
      body: ListView.builder(
        itemCount: mlist.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(mlist[index].name!),
            subtitle: Text(mlist[index].mobileno!),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteNote(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
