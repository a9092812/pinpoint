
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinpoint/data/datasource/notes/note_service.dart';
import 'package:pinpoint/model/notes/notes.dart';
import 'package:pinpoint/repository/notes/note_repository.dart';
import 'package:pinpoint/viewModel/dio/dio_provider.dart';

final noteServiceProvider = Provider<NoteService>((ref) {
  return NoteService(ref.watch(dioProvider));
});

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepository(ref.watch(noteServiceProvider));
});

 
class NoteController extends AutoDisposeAsyncNotifier<List<Note>> {
  @override
  Future<List<Note>> build() async {
     final repository = ref.watch(noteRepositoryProvider);
    return repository.getAllNotes();
  }

   Future<void> createNote(String content) async {
    final repository = ref.read(noteRepositoryProvider);
     final newNote = Note(content: content);
 
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final tempNote = Note(id: tempId, content: content, createdAt: DateTime.now().toIso8601String());
    
    state = state.whenData((notes) => [tempNote, ...notes]);

     try {
      await repository.createNote(newNote);
       ref.invalidateSelf();
    } catch (e) {
       state = state.whenData((notes) => notes.where((n) => n.id != tempId).toList());
      print(e);  
      rethrow;
    }
  }

   Future<void> updateNote(Note updatedNote) async {
    final repository = ref.read(noteRepositoryProvider);
    try {
       state = state.whenData((notes) {
        return [
          for (final note in notes)
            if (note.id == updatedNote.id) updatedNote else note,
        ];
      });
      await repository.updateNote(updatedNote);
    } catch (e) {
      print(e);
       ref.invalidateSelf();
      rethrow;
    }
  }

   Future<void> deleteNote(String noteId) async {
    final repository = ref.read(noteRepositoryProvider);
    try {
       state = state.whenData(
        (notes) => notes.where((note) => note.id != noteId).toList(),
      );
      await repository.deleteNote(noteId);
    } catch (e) {
      print(e);
       ref.invalidateSelf();
      rethrow;
    }
  }
}

 final noteControllerProvider =
    AutoDisposeAsyncNotifierProvider<NoteController, List<Note>>(() {
  return NoteController();
});
