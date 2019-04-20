import 'package:cloud_firestore/cloud_firestore.dart';

class Developer {
  final String firstName;
  final String lastName;
  final String imageUrl;
  final String about;
  final String place;
  final String facebookLink;
  final String githubLink;
  final String personalWebsite;

  Developer.data({
    this.firstName,
    this.lastName,
    this.about,
    this.facebookLink,
    this.githubLink,
    this.imageUrl,
    this.personalWebsite,
    this.place,
  });

  factory Developer.from(Map<String, dynamic> data) => Developer.data(
        firstName: data['firstName'],
        lastName: data['lastName'],
        imageUrl: data['imageUrl'],
        place: data['place'],
        about: data['about'],
        facebookLink: data['facebookLink'],
        githubLink: data['githubLink'],
        personalWebsite: data['personalWebsite'],
      );

  /// We don't need toMap() function. probably in future....
}
