import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth?>((ref) => kIsWeb ? null : FirebaseAuth.instance);

// Mock auth state for web platform
final mockAuthStateProvider =
    StateNotifierProvider<MockAuthNotifier, User?>((ref) {
  return MockAuthNotifier();
});

final authStateProvider = StreamProvider<User?>((ref) {
  if (kIsWeb) {
    // Use mock auth for web - convert to stream
    final mockUser = ref.watch(mockAuthStateProvider);
    return Stream.value(mockUser);
  } else {
    // Use real Firebase auth for mobile
    final auth = ref.watch(firebaseAuthProvider)!;
    return auth.authStateChanges();
  }
});

final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.asData?.value != null;
});

class MockAuthNotifier extends StateNotifier<User?> {
  MockAuthNotifier() : super(null);

  Future<void> signInWithEmailPassword(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    state = MockUser(email: email, uid: 'mock-${email.hashCode}');
  }

  Future<void> signOut() async {
    state = null;
  }
}

class AuthRepository {
  AuthRepository(this._auth, this._ref);
  final FirebaseAuth? _auth;
  final Ref _ref;

  Future<UserCredential?> signInWithEmailPassword(
      String email, String password) async {
    if (kIsWeb) {
      await _ref
          .read(mockAuthStateProvider.notifier)
          .signInWithEmailPassword(email, password);
      return null;
    }

    try {
      return await _auth!
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (_) {
      return await _auth!
          .createUserWithEmailAndPassword(email: email, password: password);
    }
  }

  Future<void> signOut() async {
    if (kIsWeb) {
      await _ref.read(mockAuthStateProvider.notifier).signOut();
      return;
    }
    await _auth!.signOut();
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
    (ref) => AuthRepository(ref.read(firebaseAuthProvider), ref));

// Mock User implementation for web demo
class MockUser implements User {
  @override
  final String email;
  @override
  final String uid;

  MockUser({required this.email, required this.uid});

  @override
  String? get displayName => email.split('@')[0];

  @override
  bool get emailVerified => true;

  @override
  bool get isAnonymous => false;

  @override
  UserMetadata get metadata => MockUserMetadata();

  @override
  String? get phoneNumber => null;

  @override
  String? get photoURL => null;

  @override
  List<UserInfo> get providerData => [];

  @override
  String? get refreshToken => 'mock-refresh-token';

  @override
  String? get tenantId => null;

  // Required method implementations (simplified for demo)
  @override
  Future<void> delete() async {}

  @override
  Future<String> getIdToken([bool forceRefresh = false]) async => 'mock-token';

  @override
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) async =>
      MockIdTokenResult();

  @override
  Future<UserCredential> linkWithCredential(AuthCredential credential) async =>
      throw UnimplementedError();

  @override
  Future<ConfirmationResult> linkWithPhoneNumber(String phoneNumber,
          [RecaptchaVerifier? verifier]) async =>
      throw UnimplementedError();

  @override
  Future<UserCredential> linkWithPopup(AuthProvider provider) async =>
      throw UnimplementedError();

  @override
  Future<void> linkWithRedirect(AuthProvider provider) async =>
      throw UnimplementedError();

  @override
  Future<UserCredential> linkWithProvider(AuthProvider provider) async =>
      throw UnimplementedError();

  @override
  Future<UserCredential> reauthenticateWithProvider(
          AuthProvider provider) async =>
      throw UnimplementedError();

  @override
  Future<UserCredential> reauthenticateWithCredential(
          AuthCredential credential) async =>
      throw UnimplementedError();

  @override
  Future<UserCredential> reauthenticateWithPopup(AuthProvider provider) async =>
      throw UnimplementedError();

  @override
  Future<void> reauthenticateWithRedirect(AuthProvider provider) async =>
      throw UnimplementedError();

  @override
  Future<void> reload() async {}

  @override
  Future<void> sendEmailVerification(
      [ActionCodeSettings? actionCodeSettings]) async {}

  @override
  Future<User> unlink(String providerId) async => this;

  @override
  Future<void> updateDisplayName(String? displayName) async {}

  @override
  Future<void> updateEmail(String newEmail) async {}

  @override
  Future<void> updatePassword(String newPassword) async {}

  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential phoneCredential) async {}

  @override
  Future<void> updatePhotoURL(String? photoURL) async {}

  @override
  Future<void> updateProfile({String? displayName, String? photoURL}) async {}

  @override
  Future<void> verifyBeforeUpdateEmail(String newEmail,
      [ActionCodeSettings? actionCodeSettings]) async {}

  @override
  MultiFactor get multiFactor => throw UnimplementedError();
}

class MockUserMetadata implements UserMetadata {
  @override
  DateTime? get creationTime =>
      DateTime.now().subtract(const Duration(days: 30));

  @override
  DateTime? get lastSignInTime => DateTime.now();
}

class MockIdTokenResult implements IdTokenResult {
  @override
  Map<String, dynamic> get claims => {'email': 'mock@example.com'};

  @override
  DateTime? get expirationTime => DateTime.now().add(const Duration(hours: 1));

  @override
  DateTime? get issuedAtTime => DateTime.now();

  @override
  String? get signInProvider => 'password';

  String? get signInSecondFactor => null;

  @override
  String get token => 'mock-token';

  @override
  DateTime? get authTime => DateTime.now();
}
