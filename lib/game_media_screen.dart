// lib/game_media_screen.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'api_service.dart';

class GameMediaScreen extends StatefulWidget {
  final int gameId;

  const GameMediaScreen({super.key, required this.gameId});

  @override
  _GameMediaScreenState createState() => _GameMediaScreenState();
}

class _GameMediaScreenState extends State<GameMediaScreen> {
  ApiService apiService = ApiService();
  List screenshots = [];
  String? backgroundImage;
  String? gameTitle;

  @override
  void initState() {
    super.initState();
    fetchGameMedia();
  }

  Future<void> fetchGameMedia() async {
    final media = await apiService.fetchGameMedia(widget.gameId);
    final gameDetails = await apiService.fetchGameDetails(widget.gameId);
    setState(() {
      screenshots = media['results'];
      // Pegar a primeira imagem como imagem de fundo principal
      if (screenshots.isNotEmpty) {
        backgroundImage = screenshots[0]['image'];
        screenshots.removeAt(0); // Remove a primeira imagem do carrossel
      }
      gameTitle = gameDetails['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            const Text('Mídia do Jogo', style: TextStyle(color: Colors.white)),
      ),
      body: screenshots.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (backgroundImage != null)
                    Image.network(
                      backgroundImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 300,
                    ),
                  if (gameTitle != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        gameTitle!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16.0),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Screenshots',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Image.network(
                                screenshot['image'],
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
