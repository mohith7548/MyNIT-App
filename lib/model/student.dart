import 'package:nit_andhra/model/user.dart';

class Student extends User {
  String type = "student";
  String branch;
  int rollNo;
  int regNo;

  Student.data({
    String fullName,
    String displayName,
    String dateOfBirth,
    String bio,
    int phoneNo,
    String photoUrl,
    String thumbPhotoUrl,
    String sex,
    String deviceTokenId,
    int dailyBlogLimit,
    this.regNo,
    this.rollNo,
    this.branch,
  }) : super(
          fullName: fullName,
          displayName: displayName,
          dateOfBirth: dateOfBirth,
          bio: bio,
          phoneNo: phoneNo,
          photoUrl: photoUrl,
          thumbPhotoUrl: thumbPhotoUrl,
          sex: sex,
          deviceTokenId: deviceTokenId,
          dailyBlogLimit: dailyBlogLimit,
        );

  factory Student.from(Map<String, dynamic> data) => Student.data(
        fullName: data['fullName'],
        displayName: data['displayName'],
        dateOfBirth: data['dateOfBirth'],
        bio: data['bio'],
        phoneNo: data['phoneNo'],
        photoUrl: data['photoUrl'],
        thumbPhotoUrl: data['thumbPhotoUrl'],
        sex: data['sex'],
        deviceTokenId: data['deviceTokenId'],
        regNo: data['regNo'],
        rollNo: data['rollNo'],
        branch: data['branch'],
        dailyBlogLimit: data['dailyBlogLimit'],
      );

  Map<String, dynamic> toMap() {
    return {
      'type: ': 'student',
      'fullName': this.fullName,
      'displayName': this.displayName,
      'dateOfBirth': this.dateOfBirth,
      'dailyBlogLimit': this.dailyBlogLimit,
      'phoneNo': this.phoneNo,
      'photoUrl': this.photoUrl,
      'thumbPhotoUrl': this.thumbPhotoUrl,
      'sex': this.sex,
      'deviceTokenId': this.deviceTokenId,
      'regNo': this.regNo,
      'rollNo': this.rollNo,
      'branch': this.branch,
    };
  }
}
