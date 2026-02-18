import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

/// Remote Data Source for Auth (Firebase)
class AuthRemoteDataSource {
  final fb.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSource(
    this._firebaseAuth,
    this._firestore,
    this._googleSignIn,
  );

  CollectionReference get _usersCollection => _firestore.collection('users');

  /// Get current Firebase user
  fb.User? getCurrentFirebaseUser() {
    return _firebaseAuth.currentUser;
  }

  /// Get current user data from Firestore
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = getCurrentFirebaseUser();
    if (firebaseUser == null) return null;

    final doc = await _usersCollection.doc(firebaseUser.uid).get();
    if (!doc.exists) return null;

    return UserModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
  }

  /// Sign in with email and password
  Future<UserModel> signInWithEmail(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) throw Exception('Kullanıcı bulunamadı');

    // Get user data from Firestore
    final doc = await _usersCollection.doc(user.uid).get();
    if (!doc.exists) {
      // Create user document if it doesn't exist
      final newUser = UserModel(
        id: user.uid,
        email: user.email!,
        displayName: user.displayName,
        photoUrl: user.photoURL,
        isPremium: false,
        currency: 'TRY',
        distanceUnit: 'km',
        darkMode: true,
        createdAt: DateTime.now(),
      );
      await _usersCollection.doc(user.uid).set(newUser.toFirestore());
      return newUser;
    }

    return UserModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
  }

  /// Sign up with email and password
  Future<UserModel> signUpWithEmail(String email, String password) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) throw Exception('Kullanıcı oluşturulamadı');

    // Create user document in Firestore
    final newUser = UserModel(
      id: user.uid,
      email: user.email!,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      isPremium: false,
      currency: 'TRY',
      distanceUnit: 'km',
      darkMode: true,
      createdAt: DateTime.now(),
    );

    await _usersCollection.doc(user.uid).set(newUser.toFirestore());
    return newUser;
  }

  /// Sign in with Google
  Future<UserModel> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google ile giriş iptal edildi');

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = fb.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user == null) throw Exception('Kullanıcı bulunamadı');

    // Check if user exists in Firestore
    final doc = await _usersCollection.doc(user.uid).get();
    if (!doc.exists) {
      // Create new user document
      final newUser = UserModel(
        id: user.uid,
        email: user.email!,
        displayName: user.displayName,
        photoUrl: user.photoURL,
        isPremium: false,
        currency: 'TRY',
        distanceUnit: 'km',
        darkMode: true,
        createdAt: DateTime.now(),
      );
      await _usersCollection.doc(user.uid).set(newUser.toFirestore());
      return newUser;
    }

    return UserModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
  }

  /// Sign out
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  /// Update user profile
  Future<UserModel> updateProfile(UserModel user) async {
    await _usersCollection.doc(user.id).update(user.toFirestore());
    return user;
  }

  /// Delete account
  Future<void> deleteAccount() async {
    final user = getCurrentFirebaseUser();
    if (user == null) throw Exception('Kullanıcı bulunamadı');

    // Delete user data from Firestore
    await _usersCollection.doc(user.uid).delete();

    // Delete Firebase Auth account
    await user.delete();
  }

  /// Check if user is signed in
  bool isSignedIn() {
    return _firebaseAuth.currentUser != null;
  }

  /// Listen to auth state changes
  Stream<fb.User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
