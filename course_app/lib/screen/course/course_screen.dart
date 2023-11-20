import 'package:course_app/auth/provider/course_provider_state.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../constant/constant.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: bgColor,
        flexibleSpace: Column(
          children: [
            SizedBox(
              height: 6,
            ),
            _appbar()
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [_listCard()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // widgets

  Widget _listCard() {
    final provider = Provider.of<CourseProviderState>(context, listen: true);
   
    List<Color> color = [
      color1,
      flutterColor,
      vueColor1,
      blue,
      laravelColor,
      primColor,
    ];

    return FutureBuilder(
      future: provider.getCourse(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return ListView.separated(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) => SizedBox(
                height: 10,
              ),
              itemBuilder: (context, index) {
                final courseData = snapshot.data![index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  padding: EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: color[index],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        child: Image.network(courseData.imageUrl.toString()),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            courseData.title.toString(),
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                          width: 260,
                            child: Text(
                              courseData.subTitle.toString(),
                              style: GoogleFonts.poppins(
                                color: Colors.white54,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          _progresIndicator(),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return SizedBox.shrink();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  // linear progres indicator
  Widget _progresIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Completed 50%",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        LinearPercentIndicator(
            width: 200.0,
            lineHeight: 8.0,
            percent: 0.5,
            addAutomaticKeepAlive: true,
            animateFromLastPercent: true,
            animationDuration: 1,
            barRadius: Radius.circular(20),
            backgroundColor: Colors.white,
            padding: EdgeInsets.only(right: 10),
            progressColor: Colors.amberAccent),
      ],
    );
  }

  // appbar
  Widget _appbar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            IconlyLight.arrow_left,
            color: black,
          ),
          Text(
            "My Course",
            style: GoogleFonts.poppins(
                color: black, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Icon(
            Icons.favorite,
            color: black,
          ),
        ],
      ),
    );
  }
}
