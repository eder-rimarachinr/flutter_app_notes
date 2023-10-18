import 'package:flutter/material.dart';

import '../models/note.dart';

class EditScreen extends StatefulWidget {
  final Note? note;
  final Function(Note) updateNote;
  final BuildContext? context;

  const EditScreen(
      {Key? key,
      required this.note,
      required this.updateNote,
      required this.context})
      : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    if (widget.note != null) {
      _titleController = TextEditingController(text: widget.note!.title);
      _contentController = TextEditingController(text: widget.note!.content);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(EditScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.note != null) {
      // Actualizar los controladores con los nuevos datos de la nota
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  void saveChanges() {
    String updatedTitle = _titleController.text;
    String updatedContent = _contentController.text;

    // Crea una nueva instancia de Note con los datos actualizados.
    Note updatedNote = Note(
      id: widget.note!.id,
      title: updatedTitle,
      content: updatedContent,
      modifiedTime: DateTime.now(),
    );
    // Llama a la función de actualización para actualizar la nota en el HomeScreen.
    widget.updateNote(updatedNote);
  }

  @override
  Widget build(BuildContext contextApp) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     IconButton(
          //         onPressed: () {
          //           print('Actualizando nota en EditScreen');
          //         },
          //         padding: const EdgeInsets.all(0),
          //         icon: Container(
          //           width: 40,
          //           height: 40,
          //           decoration: BoxDecoration(
          //               color: Colors.grey.shade800.withOpacity(.8),
          //               borderRadius: BorderRadius.circular(10)),
          //           child: const Icon(
          //             Icons.arrow_back_ios_new,
          //             color: Colors.white,
          //           ),
          //         ))
          //   ],
          // ),
          Expanded(
              child: ListView(
            children: [
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white, fontSize: 30),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 30)),
              ),
              TextField(
                controller: _contentController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                maxLines: null,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type something here',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    )),
              ),
            ],
          ))
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveChanges,
        elevation: 10,
        backgroundColor: Colors.grey.shade800,
        child: const Icon(Icons.save),
      ),
    );
  }
}
