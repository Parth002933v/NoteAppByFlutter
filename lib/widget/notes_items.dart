import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/Screen/note_screen.dart';
import 'package:todoapp/model/note_model.dart';

class NotesItems extends StatelessWidget {
  NotesItems({
    super.key,
    required this.note,
    required this.delete,
    required this.index,
    required this.backgroundColor, // Add the backgroundColor parameter here
  });

  final int index;
  final NoteModel note;
  final void Function(NoteModel note) delete;
  final Color backgroundColor; // Add the backgroundColor field here

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor, // Use the backgroundColor here

      elevation: 3,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        style: ListTileStyle.drawer,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  NoteScreen(noteContent: note, contentIndex: index),
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.tital,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis,
                height: 1.5,
              ),
              maxLines: 1,
            ),
            Text(
              note.description,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                overflow: TextOverflow.ellipsis,
                height: 1.5,
              ),
              maxLines: 2,
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Last edited : ${formatDate(
              note.time,
              [dd, '/', mm, '/', yyyy, ' ', hh, ':', nn, ' ', am],
            )}',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontStyle: FontStyle.italic,
              fontSize: 10,
            ),
          ),
        ),
        trailing: IconButton(
            onPressed: () {
              delete(note);
            },
            icon: const Icon(Icons.delete)),
      ),
    );
  }
}
