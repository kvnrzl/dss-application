import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // * Proses Sign In (SignIn)
  Future<void> addUserIntoDatabase(String userid, Map userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userid)
        .set(userInfoMap);
  }

  Future<void> addDataIntoDatabase(String username, Map data) async {
    await FirebaseFirestore.instance.collection("data").doc(username).set(data);
  }

  Future<void> updateDataInDatabase(String username, Map data) async {
    await FirebaseFirestore.instance
        .collection("data")
        .doc(username)
        .update(data);
  }

  Future<Stream<QuerySnapshot>> queryDataFromDatabase() async {
    return FirebaseFirestore.instance
        .collection("data")
        .snapshots();
  }

  Future<void> removeDataFromDatabase() async {
    FirebaseFirestore.instance.collection("data").get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
}
