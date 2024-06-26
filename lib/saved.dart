import 'package:beauty_center/screens/gallery_test.dart';
import 'package:beauty_center/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beauty_center/details.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:beauty_center/screens/navigation_menu.dart';

class SavedImages extends StatefulWidget {
  const SavedImages({super.key});

  @override
  _SavedImagesState createState() => _SavedImagesState();
}

class _SavedImagesState extends State<SavedImages> {
  List<SImageDetails> _likedImages = [];

  @override
  void initState() {
    super.initState();
    _fetchLikedImages();
  }

  Future<void> _fetchLikedImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    if (userId == null) return;

    try {
      var response = await http.get(Uri.parse('http://172.20.10.5/senior/get_liked_images.php?user_id=$userId'));
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        List<dynamic> likedImageIds = json.decode(response.body);
        var likedImagesResponse = await http.post(
          Uri.parse('http://172.20.10.5/senior/get_gallery_images_by_ids.php'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'image_ids': likedImageIds.map((image) => image['image_id']).toList()}),
        );
        print('Liked images response body: ${likedImagesResponse.body}');
        if (likedImagesResponse.statusCode == 200) {
          List<dynamic> likedImagesList = json.decode(likedImagesResponse.body);
          setState(() {
            _likedImages = likedImagesList.map((image) {
              return SImageDetails(
                imageId: int.parse(image['id']),
                imagePath: image['image'] ?? '',
                details: image['details'] ?? '',
                speciality: image['speciality'] ?? '',
                title: image['title'] ?? '',
              );
            }).toList();
          });
        } else {
          print('Failed to load liked images details');
        }
      } else {
        print('Failed to load liked images');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[700],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        FontAwesomeIcons.longArrowAltLeft,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Saved Images',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return RawMaterialButton(
                      onPressed: () {
                        Get.to(() => SGalleryDetails(
                          imagePath: _likedImages[index].imagePath,
                          title: _likedImages[index].title,
                          speciality: _likedImages[index].speciality,
                          details: _likedImages[index].details,
                          index: index,
                        ));

                      },
                      child: Hero(
                        tag: 'logo$index',
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: _likedImages[index].imagePath.isNotEmpty
                                  ? NetworkImage('http://172.20.10.5/senior/${_likedImages[index].imagePath}')
                                  : const AssetImage('images/default.jpg') as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: _likedImages.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SImageDetails {
  final int imageId;
  final String imagePath, speciality, title, details;

  SImageDetails({
    required this.imageId,
    required this.imagePath,
    required this.details,
    required this.speciality,
    required this.title,
  });
}
