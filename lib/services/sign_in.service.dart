import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:notecounting/utils/globals.dart';
import 'package:notecounting/services/auth.service.dart';

AuthService appAuth = new AuthService();

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String name;
String email;
String imageUrl;

Future < String > signInWithGoogle() async {
	final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
	final GoogleSignInAuthentication googleSignInAuthentication =
		await googleSignInAccount.authentication;

	final AuthCredential credential = GoogleAuthProvider.getCredential(
		accessToken: googleSignInAuthentication.accessToken,
		idToken: googleSignInAuthentication.idToken,
	);

	final AuthResult authResult = await _auth.signInWithCredential(credential);
	final FirebaseUser user = authResult.user;

	// Checking if email and name is null
	assert(user.email != null);
	assert(user.displayName != null);
	assert(user.photoUrl != null);

	name = user.displayName;
	email = user.email;
	imageUrl = user.photoUrl;

  var url = Globals.apiUrl + "jwt/generateToken";
            
  try {
    Response response = await Dio().post(url, data: {
      'email': email,
    });

    if (response.data["result"] == 1) {
      // Only taking the first part of the name, i.e., First Name
      if (name.contains(" ")) {
        name = name.substring(0, name.indexOf(" "));
      }

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      appAuth.createUserKey("?token=" + response.data["data"]);
      appAuth.createUserEmail(email);
      appAuth.createUserName(name);
      appAuth.createUserImage(imageUrl);

      return "signInWithGoogle succeeded: $user";
    } else {
      return "signInWithGoogle failed";
    }
  } catch (e) {
    return "signInWithGoogle failed, reason: $e";
  }
}

void signOutGoogle() async {
	await googleSignIn.signOut();

	print("User Sign Out");
}