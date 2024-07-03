// lib/game_detail_screen.dart
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'game_media_screen.dart';
import 'star_rating.dart';
import 'star_rating.dart'; // Importe o widget StarRating aqui

class GameDetailScreen extends StatefulWidget {
  final int id;

  GameDetailScreen({required this.id});

  @override
  _GameDetailScreenState createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  ApiService apiService = ApiService();
  Map<String, dynamic> gameDetails = {};

  @override
  void initState() {
    super.initState();
    fetchGameDetails();
  }

  Future<void> fetchGameDetails() async {
    gameDetails = await apiService.fetchGameDetails(widget.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: gameDetails.isEmpty
          ? Center(child: CircularProgressIndicator())
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
                        Text(
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
                              rating: gameDetails['rating'] /
                                  2, // Ajuste para o valor das estrelas (ex: rating de 10 para 5 estrelas)
                              size: 24.0,
                              color: Colors.amber,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              '${gameDetails['rating']}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            gameDetails['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          gameDetails['description_raw'] ??
                              'Descrição indisponível',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GameMediaScreen(gameId: widget.id),
                              ),
                            );
                          },
                          child: Text('Ver Mídia do Jogo'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  } //teste commit
}
