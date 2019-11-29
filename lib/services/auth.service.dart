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

  Future < File > createUserKey(email) async {
		final file = await _localFile;
		return file.writeAsString(email);
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

	Future < File > deleteUserKey() async {
		final file = await _localFile;
		return file.writeAsString('false');
	}
}