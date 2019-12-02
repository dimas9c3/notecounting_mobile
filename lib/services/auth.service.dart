import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AuthService {

	Future < String > get _localPath async {
		final directory = await getApplicationDocumentsDirectory();
		return directory.path;
	}

	Future < File > get _localFile async {
		final path = await _localPath;
		return File('$path/userkey.txt');
	}

  Future < File > get _localFileEmail async {
		final path = await _localPath;
		return File('$path/useremail.txt');
	}

  Future < File > get _localFileName async {
		final path = await _localPath;
		return File('$path/username.txt');
	}

  Future < File > get _localFileUserImage async {
		final path = await _localPath;
		return File('$path/userimage.txt');
	}

  Future < File > createUserKey(token) async {
		final file = await _localFile;
		return file.writeAsString(token);
	}

  Future < File > createUserEmail(email) async {
		final file = await _localFileEmail;
		return file.writeAsString(email);
	}

  Future < File > createUserName(name) async {
		final file = await _localFileName;
		return file.writeAsString(name);
	}

  Future < File > createUserImage(image) async {
		final file = await _localFileUserImage;
		return file.writeAsString(image);
	}

	Future < String > readUserKey() async {
		try {
			final file = await _localFile;
			String contents = await file.readAsString();
			return contents;
		} catch (e) {
			return 'Error!';
		}
	}

  Future < String > readUserEmail() async {
		try {
			final file = await _localFileEmail;
			String contents = await file.readAsString();
			return contents;
		} catch (e) {
			return 'Error!';
		}
	}

  Future < String > readUserName() async {
		try {
			final file = await _localFileName;
			String contents = await file.readAsString();
			return contents;
		} catch (e) {
			return 'Error!';
		}
	}

  Future < String > readUserImage() async {
		try {
			final file = await _localFileUserImage;
			String contents = await file.readAsString();
			return contents;
		} catch (e) {
			return 'Error!';
		}
	}

	Future < File > deleteUserKey() async {
		final file = await _localFile;
		return file.writeAsString('false');
	}
}