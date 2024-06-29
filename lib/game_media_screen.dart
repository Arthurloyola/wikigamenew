// lib/game_media_screen.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'api_service.dart';

class GameMediaScreen extends StatefulWidget {
  final int gameId;

  GameMediaScreen({required this.gameId});

  @override
  _GameMediaScreenState createState() => _GameMediaScreenState();
}

class _GameMediaScreenState extends State<GameMediaScreen> {
  ApiService apiService = ApiService();
  List screenshots = [];

  @override
  void initState() {
    super.initState();
    fetchGameMedia();
  }

  Future<void> fetchGameMedia() async {
    final media = await apiService.fetchGameMedia(widget.gameId);
    setState(() {
      screenshots = media['results'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Mídia do Jogo', style: TextStyle(color: Colors.white)),
      ),
      body: screenshots.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Screenshots',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Expanded(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 400.0,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      autoPlay: true,
                    ),
                    items: screenshots.map((screenshot) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Image.network(
                            screenshot['image'],
                            fit: BoxFit.cover,
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }
}
