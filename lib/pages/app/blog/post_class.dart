import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final DocumentReference reference;
  int postLikes;
  final String postOwnerImageUrl;
  final String postOwner;
  final String postDescription;
  final String postImageUrl;
  final DateTime postTime;

  Post.data(
      this.reference,
      this.postImageUrl,
      this.postOwner,
      this.postDescription,
      this.postOwnerImageUrl,
      this.postTime,
      this.postLikes);

  factory Post.from(DocumentSnapshot snapshot) => Post.data(
        snapshot.reference,
        snapshot.data['postImageUrl'],
        snapshot.data['postOwner'],
        snapshot.data['postDescription'],
        snapshot.data['postOwnerImageUrl'],
        (snapshot.data['postTime'] as Timestamp).toDate(),
        snapshot.data['postLikes'],
      );

  Map<String, dynamic> toMap() {
    return {
      'postOwner': this.postOwner,
      'postOwnerImageUrl': this.postOwnerImageUrl,
      'postTime': this.postTime,
      'postImageUrl': this.postImageUrl,
      'postDescription': this.postDescription,
    };
  }
}
