import 'package:nit_andhra/model/user.dart';

class Faculty extends User {
  String type = "faculty";
  String dept;

  Faculty.data({
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
    this.dept,
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

  factory Faculty.from(Map<String, dynamic> data) => Faculty.data(
        fullName: data['fullName'],
        displayName: data['displayName'],
        dateOfBirth: data['dateOfBirth'],
        bio: data['bio'],
        phoneNo: data['phoneNo'],
        photoUrl: data['photoUrl'],
        thumbPhotoUrl: data['thumbPhotoUrl'],
        sex: data['sex'],
        deviceTokenId: data['deviceTokenId'],
        dept: data['dept'],
        dailyBlogLimit: data['dailyBlogLimit'],
      );

  Map<String, dynamic> toMap() {
    return {
      'type: ': 'faculty',
      'fullName': this.fullName,
      'displayName': this.displayName,
      'dateOfBirth': this.dateOfBirth,
      'dailyBlogLimit': this.dailyBlogLimit,
      'phoneNo': this.phoneNo,
      'photoUrl': this.photoUrl,
      'thumbPhotoUrl': this.thumbPhotoUrl,
      'sex': this.sex,
      'deviceTokenId': this.deviceTokenId,
      'dept': this.dept,
    };
  }
}
