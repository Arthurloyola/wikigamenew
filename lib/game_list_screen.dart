import 'package:flutter/material.dart';
import 'api_service.dart';
import 'game_detail_screen.dart';

class GameListScreen extends StatefulWidget {
  @override
  _GameListScreenState createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreen> {
  ApiService apiService = ApiService();
  List games = [];

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  Future<void> fetchGames() async {
    games = await apiService.fetchGames();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: games.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagem grande no topo
                  Image.network(
                    'https://images3.alphacoders.com/136/1363581.png', // Substitua por uma URL válida
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                  SizedBox(height: 16.0),
                  // Título "Biblioteca"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Biblioteca',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Grid de jogos
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      physics:
                          NeverScrollableScrollPhysics(), // Para permitir rolagem no SingleChildScrollView
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: games.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GameDetailScreen(id: games[index]['id']),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child:
                                      games[index]['background_image'] != null
                                          ? Image.network(
                                              games[index]['background_image'],
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            )
                                          : Container(
                                              color: Colors.grey,
                                              width: double.infinity,
                                            ),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                games[index]['name'],
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
