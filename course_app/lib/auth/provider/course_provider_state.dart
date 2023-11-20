import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_app/auth/provider_model/course_model.dart';
import 'package:flutter/material.dart';

class CourseProviderState with ChangeNotifier  {
  
  final db= FirebaseFirestore.instance;

  

 Future<List<CourseModel>> getCourse()async{
  final snapshot= await db.collection("Course").get();

  final course= snapshot.docs.map((e) => CourseModel.fromSnapshot(e)).toList();

  return course;
  }
}