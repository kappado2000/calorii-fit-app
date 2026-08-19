import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/recipe.dart';

/// `users/{uid}/recipes` — unlike foodLogs/hydrationEntries this isn't
/// date-scoped: a recipe is a reusable template, logged into the diary
/// (as a FoodLogEntry snapshot) each time it's eaten, not itself a diary
/// entry.
class RecipesFirestoreDataSource {
  RecipesFirestoreDataSource(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(_uid).collection('recipes');

  Stream<List<Recipe>> watchAll() {
    return _collection.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => Recipe.fromJson({...doc.data(), 'id': doc.id})).toList(growable: false),
    );
  }

  Future<void> save(Recipe recipe) => _collection.doc(recipe.id).set(recipe.toJson());

  Future<void> delete(String id) => _collection.doc(id).delete();
}
