import 'package:hive_flutter/hive_flutter.dart';

part 'contact.g.dart';

@HiveType(typeId: 0)
class Contact extends HiveObject {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? telephone;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? image;

  Contact({this.name, this.telephone, this.email, this.image});

  Contact.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    telephone = json['telephone'];
    email = json['email'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'telephone': telephone,
      'email': email,
      'image': image
    };
  }
}
