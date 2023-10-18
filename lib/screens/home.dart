import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/screens/edit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isTopExpanded = true;

  List<Note> filteredNotes = [];

  Note? selectedNote;
  BuildContext? contextApp;

  void selectNote(Note note) {
    setState(() {
      selectedNote = note;
    });
  }

  void deleteNote(int id) {
    setState(() {
      // Note note = filteredNotes[index];
      // sampleNotes.remove(note);
      // filteredNotes.removeAt(index);
      int indexToDelete =
          filteredNotes.indexWhere((element) => element.id == id);

      if (indexToDelete != -1) {
        // Verifica si se encontró una nota con el id y elimínala.
        filteredNotes.removeAt(indexToDelete);
      }
    });
  }

  int obtenerIdMayor(List<Note> notas) {
    int idMayor =
        0; // Inicializamos con un valor que garantiza que cualquier ID sea mayor.

    for (var nota in notas) {
      if (nota.id > idMayor) {
        idMayor = nota.id;
      }
    }

    return idMayor + 1;
  }

  void updateNote(Note updatedNote) {
    int index = filteredNotes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      setState(() {
        filteredNotes[index] = Note(
          id: updatedNote.id,
          title: updatedNote.title,
          content: updatedNote.content,
          modifiedTime: updatedNote.modifiedTime,
        );
      });
    } else {
      int newNoteId = obtenerIdMayor(filteredNotes);
      setState(() {
        filteredNotes.add(Note(
          id: newNoteId,
          title: updatedNote.title,
          content: updatedNote.content,
          modifiedTime: updatedNote.modifiedTime,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    filteredNotes = sampleNotes;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  isTopExpanded = !isTopExpanded;
                });
              },
              icon: isTopExpanded
                  ? const Icon(Icons.menu_open)
                  : const Icon(Icons.menu),
            ),
            const Text('Notas')
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              final noteAdd = Note(
                  id: 0, title: '', content: '', modifiedTime: DateTime.now());
              selectNote(noteAdd);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        constraints: const BoxConstraints(
          minWidth: 640,
          minHeight: 640,
        ),
        child: Row(
          children: [
            Expanded(
              flex: isTopExpanded ? 4 : 0, // 30% de la pantalla (visible o no)
              child: isTopExpanded
                  ? Container(
                      color: Colors.grey
                          .shade800, // Configura el color de fondo del ListView
                      child: ListView.builder(
                        itemCount: filteredNotes.length,
                        itemBuilder: (context, index) {
                          Note note = filteredNotes[index];
                          return SizedBox(
                              height:
                                  110, // Establece la altura fija deseada para cada tarjeta
                              child: Card(
                                elevation: 3,
                                margin: const EdgeInsets.all(6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ListTile(
                                    onTap: () async {
                                      //showEditDialog(context, note);
                                      selectNote(note);
                                    },
                                    title: RichText(
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${note.id} ${note.title}\n',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          TextSpan(
                                            text: note.content,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Edited: ${DateFormat('EEE MMM d, yyyy h:mm a').format(note.modifiedTime)}',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey.shade800),
                                      ),
                                    ),
                                    trailing: IconButton(
                                      onPressed: () async {
                                        final result = await confirmDialog(
                                            context, note.id);
                                        if (result != null && result) {
                                          deleteNote(note.id);
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Expanded(
              flex: isTopExpanded ? 7 : 10, // 70% de la pantalla
              child: Container(
                  color: Colors.grey.shade700,
                  child: selectedNote != null
                      ? EditScreen(
                          note: selectedNote,
                          updateNote: updateNote,
                          context: contextApp)
                      : const Center(child: Text('2% de la pantalla'))),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   elevation: 10,
      //   backgroundColor: Colors.grey.shade800,
      //   child: const Icon(Icons.save),
      // ),
    );
  }

  // Future<void> showEditDialog(BuildContext context, Note note) async {
  //   final result = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SizedBox(
  //         width: double.infinity,
  //         height: MediaQuery.of(context).size.height * 0.7,
  //         child: EditScreen(
  //             note: note), // Pasa la nota seleccionada a la vista de edición
  //       );
  //     },
  //   );

  //   if (result != null) {
  //     setState(() {
  //       sampleNotes.add(Note(
  //         id: obtenerIdMayor(sampleNotes),
  //         title: result[0],
  //         content: result[1],
  //         modifiedTime: DateTime.now(),
  //       ));
  //       filteredNotes = sampleNotes;
  //     });
  //   }
  // }
  Future<dynamic> confirmNote(BuildContext context, Note note) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade900,
            icon: const Icon(
              Icons.info,
              color: Colors.grey,
            ),
            title: Text(
              'Are you sure you want to delete? ${note.id}',
              style: const TextStyle(color: Colors.white),
            ),
            content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: const SizedBox(
                        width: 60,
                        child: Text(
                          'Yes',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const SizedBox(
                        width: 60,
                        child: Text(
                          'No',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ]),
          );
        });
  }

  Future<dynamic> confirmDialog(BuildContext context, int index) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade900,
            icon: const Icon(
              Icons.info,
              color: Colors.grey,
            ),
            title: Text(
              'Are you sure you want to delete? $index',
              style: const TextStyle(color: Colors.white),
            ),
            content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: const SizedBox(
                        width: 60,
                        child: Text(
                          'Yes',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const SizedBox(
                        width: 60,
                        child: Text(
                          'No',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ]),
          );
        });
  }
}
