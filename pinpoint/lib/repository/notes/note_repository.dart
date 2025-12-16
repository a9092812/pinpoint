
import 'package:dio/dio.dart';
import 'package:pinpoint/data/datasource/notes/note_service.dart';
import 'package:pinpoint/model/notes/notes.dart';

class NoteRepository {
  final NoteService _noteService;

  NoteRepository(this._noteService);

  /// Fetches a list of all notes.
  Future<List<Note>> getAllNotes() async {
    try {
      return await _noteService.getAllNotes();
    } on DioException catch (e) {
      throw Exception('Failed to fetch notes: ${e.message}');
    }
  }

  /// Creates a new note.
  Future<Note> createNote(Note note) async {
    try {
      return await _noteService.createNote(note);
    } on DioException catch (e) {
      throw Exception('Failed to create note: ${e.message}');
    }
  }

  /// Updates an existing note.
  Future<void> updateNote(Note note) async {
    try {
      await _noteService.updateNote(note);
    } on DioException catch (e) {
      throw Exception('Failed to update note: ${e.message}');
    }
  }

  /// Deletes a note by its ID.
  Future<void> deleteNote(String noteId) async {
    try {
      await _noteService.deleteNote(noteId);
    } on DioException catch (e) {
      throw Exception('Failed to delete note: ${e.message}');
    }
  }
}
