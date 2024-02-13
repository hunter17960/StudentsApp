import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  signInWithGoogle() async { 
    await _googleSignIn.signOut();
    final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    UserCredential userCredential =await FirebaseAuth.instance.signInWithCredential(credential);

    await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userCredential.user?.uid)
                            .set({
                          'name': gUser.displayName,
                          'photoURL': gUser.photoUrl,
                        });
    User? user = userCredential.user;
    return user;
  }
}
