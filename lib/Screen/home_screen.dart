import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todoapp/Screen/note_screen.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/widget/notes_items.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  String onSearch = '';

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFEEEFF5),
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Notes',
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
            ),
            IconButton(
              color: Colors.black38,
              onPressed: () {},
              icon: const Icon(
                Icons.sort,
                color: Colors.black,
                size: 30,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget searchBox(StateSetter setState) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) {
          onSearch = value;
          setState(() {});
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(Icons.search, size: 20),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
        ),
      ),
    );
  }

  Widget allNotes() {
    return ValueListenableBuilder<Box<NoteModel>>(
      valueListenable: Hive.box<NoteModel>('Notes').listenable(),
      builder: (context, Box<NoteModel> box, _) {
        if (box.isEmpty) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Center(
                child: Text(
                  'Try Adding Notes',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        } else {
          List<NoteModel> filteredNote = box.values.where((note) {
            final title = note.tital.toLowerCase();
            final description = note.description.toLowerCase();
            final query = onSearch.toLowerCase();
            return title.contains(query) || description.contains(query);
          }).toList();

          if (filteredNote.isEmpty) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Center(
                  child: Text(
                    'No matching notes found',
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          }

          return ListView.builder(
            itemCount: filteredNote.length,
            itemBuilder: (context, index) {
              //List<Widget> noteItems = [];
              final note = filteredNote[index];
              // noteItems.add(
              //   NotesItems(
              //     note: filteredNote[index],
              //     delete: delete,
              //     index: index,
              //   ),
              // );
             // return Column(children: noteItems);

              return NotesItems(
                note: note,
                delete: delete,
                index: index,
                backgroundColor: note.backgroundColor, // Pass the background color here
              );
            },
          );
          //return Column(children: noteItems);
        }
      },
    );
  }

  void delete(NoteModel note) {
    note.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEFF5),
      appBar: _buildAppBar(),
      body: StatefulBuilder(
        builder: (context, setState) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              searchBox(setState),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: allNotes(),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NoteScreen(
              noteContent: null,
              contentIndex: null,
            ),
          ));
        },
        backgroundColor: Colors.blueGrey,
        elevation: 10,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
