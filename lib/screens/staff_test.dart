import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:beauty_center/details.dart';


class SStaffTest extends StatefulWidget {
  const SStaffTest({super.key});

  @override
  State<SStaffTest> createState() => _SStaffTestState();
}

class _SStaffTestState extends State<SStaffTest> {
  List<SImageDetails> _images = [];

  @override
  void initState() {
    super.initState();
    _fetchStaff();
  }

  Future<void> _fetchStaff() async {
    try {
      var response = await http.get(Uri.parse('http://192.168.1.10/senior/get_all_staff.php'));
      if (response.statusCode == 200) {
        List<dynamic> staffList = json.decode(response.body);
        setState(() {
          _images = staffList.map((staff) {
            return SImageDetails(
              imagePath: staff['image'] ?? '',
              details: staff['note'] ?? '',
              speciality: staff['specialty'] ?? '',
              title: staff['name'] ?? '',
            );
          }).toList();
        });
      } else {
        print('Failed to load staff');
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
                height: 40,
              ),
              const Text(
                'Staff Members',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
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
                        topRight: Radius.circular(30)),
                  ),
                  child: GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return RawMaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SGalleryDetails(
                                imagePath: _images[index].imagePath,
                                title: _images[index].title,
                                speciality: _images[index].speciality,
                                details: _images[index].details,
                                index: index,
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'logo$index',
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: _images[index].imagePath.isNotEmpty
                                    ? NetworkImage('http://192.168.1.10/senior/${_images[index].imagePath}')
                                    : AssetImage('images/default.jpg') as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: _images.length,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class SImageDetails {
  final String imagePath, speciality, title, details;

  SImageDetails({
    required this.imagePath,
    required this.details,
    required this.speciality,
    required this.title,
  });
}