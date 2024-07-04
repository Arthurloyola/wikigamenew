import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'api_service.dart';

class GameMediaScreen extends StatefulWidget {
  final int gameId;

  const GameMediaScreen({Key? key, required this.gameId}) : super(key: key);

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
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            const Text('Mídia do Jogo', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 300,
            child: Image.network(
              screenshots.isNotEmpty
                  ? screenshots.first['image']
                  : '', // Usando a primeira imagem como principal
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: screenshots.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : CarouselSlider(
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
