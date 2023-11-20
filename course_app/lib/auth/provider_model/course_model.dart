import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  String? id;
  String? imageUrl;
  String? title;
  String? subTitle;
  

  CourseModel({this.id,this.imageUrl,this.title,this.subTitle});

  toJson(){
    return {
     "image_url": imageUrl,
     "title":title,
     "sub_title":subTitle
    };
  }

  factory CourseModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data= document.data();

  return CourseModel(
    id: document.id,
    imageUrl: data!["image_url"],
    title: data["title"],
    subTitle: data['sub_title'],
  );
  }

}