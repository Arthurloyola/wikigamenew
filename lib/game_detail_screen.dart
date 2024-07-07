import 'package:flutter/material.dart';
import 'api_service.dart';
import 'game_media_screen.dart';
import 'star_rating.dart';

class GameDetailScreen extends StatefulWidget {
  final int id;

  const GameDetailScreen({super.key, required this.id});

  @override
  _GameDetailScreenState createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  ApiService apiService = ApiService();
  Map<String, dynamic> gameDetails = {};
  Map<String, dynamic> gameDescription = {};
  bool isEnglish = true; 

  @override
  void initState() {
    super.initState();
    fetchGameDetails();
  }

  Future<void> fetchGameDetails() async {
    gameDetails = await apiService.fetchGameDetails(widget.id);
    gameDescription = await apiService.fetchGameDescription(widget.id);
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: gameDetails.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    gameDetails['background_image'] ?? '',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 300,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Classificação:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            StarRating(
                              rating: gameDetails['rating'],
                              size: 24.0,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              '${(gameDetails['rating']).toStringAsFixed(1)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            gameDetails['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        ToggleButtons(
                          isSelected: [isEnglish, !isEnglish],
                          onPressed: (int index) {
                            setState(() {
                              isEnglish = index == 0;
                            });
                          },
                          color: Colors.white,
                          selectedColor: Colors.amber,
                          fillColor: Colors.black,
                          borderColor: Colors.amber,
                          selectedBorderColor: Colors.amber,
                          borderRadius: BorderRadius.circular(8.0),
                          children: const <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text('EN', style: TextStyle(color: Colors.white)),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text('PT', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          isEnglish ? gameDescription['description'] : gameDescription['traducao'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 45, 0, 71),
                            padding: const EdgeInsets.all(16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GameMediaScreen(gameId: widget.id),
                              ),
                            );
                          },
                          child: const Text('Ver Mídia do Jogo'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
