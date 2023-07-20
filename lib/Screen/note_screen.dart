import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/constraint/colors.dart';
import 'package:todoapp/model/note_model.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({
    super.key,
    required this.noteContent,
    required this.contentIndex,
  });
  final NoteModel? noteContent;
  final int? contentIndex;
  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.noteContent != null && widget.contentIndex != null) {
      //To update
      _titlecontroller = TextEditingController(text: widget.noteContent!.tital);
      _descriptioncontroller =
          TextEditingController(text: widget.noteContent!.description);
    }
  }

  var _descriptioncontroller = TextEditingController();
  var _titlecontroller = TextEditingController();
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.noteContent != null
          ? widget.noteContent!.backgroundColor
          : const Color(0xFFEEEFF5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    color: Colors.black38,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white60,
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    TextField(
                      controller: _titlecontroller,
                      style: GoogleFonts.robotoSlab(fontSize: 30),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Title',
                        hintStyle: TextStyle(fontSize: 30, color: Colors.grey),
                      ),
                    ),
                    TextField(
                      controller: _descriptioncontroller,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type Something Here',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final randomColor =
              backgoundColor[Random().nextInt(backgoundColor.length)];

          if (widget.contentIndex == null) {
            //null means we have to add new value
            if (_titlecontroller.text.isNotEmpty &&
                _descriptioncontroller.text.isNotEmpty) {
              final addNote = NoteModel(
                tital: _titlecontroller.text,
                description: _descriptioncontroller.text,
                time: DateTime.now(),
                backgroundColor: randomColor,
              );
              final box = Hive.box<NoteModel>('Notes');
              box.add(addNote);
              _titlecontroller.clear();
              _descriptioncontroller.clear();
              Navigator.of(context).pop();
              Fluttertoast.showToast(
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.grey.shade300,
                msg: "Note Has Been Added!",
                timeInSecForIosWeb: 3,
                textColor: Colors.black,
              );

              //this is condition to add value
            } else if (_titlecontroller.text.isEmpty &&
                _descriptioncontroller.text.isNotEmpty) {
              final addNote = NoteModel(
                tital: _descriptioncontroller.text.substring(0, 30),
                description: _descriptioncontroller.text,
                time: DateTime.now(),
                backgroundColor: randomColor,
              );
              final box = Hive.box<NoteModel>('Notes');
              box.add(addNote);
              _titlecontroller.clear();
              _descriptioncontroller.clear();
              Navigator.of(context).pop();
              Fluttertoast.showToast(
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.grey.shade300,
                msg: "Note Has Been Added!",
                timeInSecForIosWeb: 3,
                textColor: Colors.black,
              );

              //add value if title is empty
            } else if (_titlecontroller.text.isEmpty &
                _descriptioncontroller.text.isEmpty) {
              Fluttertoast.showToast(
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.grey.shade300,
                msg: "Please Add Note",
                timeInSecForIosWeb: 3,
                textColor: Colors.black,
              );
            } else if (_titlecontroller.text.isNotEmpty &&
                _descriptioncontroller.text.isEmpty) {
              Fluttertoast.showToast(
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.grey.shade300,
                msg: "Plaese Add Description",
                timeInSecForIosWeb: 3,
                textColor: Colors.black,
              );
            }
          } else if (widget.contentIndex != null) {
            //To update the note

            if (_titlecontroller.text.isNotEmpty &&
                _descriptioncontroller.text.isNotEmpty) {
              final addNote = NoteModel(
                tital: _titlecontroller.text.substring(0, 30),
                description: _descriptioncontroller.text,
                time: DateTime.now(),
                backgroundColor: widget.noteContent!.backgroundColor,
              );
              final box = Hive.box<NoteModel>('Notes');
              box.putAt(widget.contentIndex!, addNote);
              Fluttertoast.showToast(
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.grey.shade300,
                msg: "Note Has Been Updated!",
                timeInSecForIosWeb: 3,
                textColor: Colors.black,
              );
            } else {
              Fluttertoast.showToast(
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.grey.shade300,
                msg: "Please Fill All The Fields",
                timeInSecForIosWeb: 3,
                textColor: Colors.black,
              );
            }
            //this is code of update
          }
        },
        backgroundColor: Colors.blueGrey,
        elevation: 10,
        child: const Icon(
          Icons.save,
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }
}
