import 'package:flutter/material.dart';
import 'api_service.dart';

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
        iconTheme: IconThemeData(
            color: Colors.white), // Define a cor da seta para branca
      ),
      body: gameDetails.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  gameDetails['background_image'] != null
                      ? Image.network(
                          gameDetails['background_image'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 300,
                        )
                      : Container(
                          color: Colors.grey,
                          width: double.infinity,
                          height: 300,
                        ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Classificação: ${gameDetails['rating']}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
