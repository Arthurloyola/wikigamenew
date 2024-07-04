// lib/game_list_screen.dart
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
  List filteredGames = [];
  int currentPage = 1;
  bool isLoading = false;
  bool isLastPage = false;
  ScrollController _scrollController = ScrollController();
  final int maxGames = 39;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchGames();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading &&
          !isLastPage) {
        fetchGames();
      }
    });
    searchController.addListener(_filterGames);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchGames() async {
    setState(() {
      isLoading = true;
    });
    try {
      final newGames = await apiService.fetchGames(page: currentPage);
      setState(() {
        games.addAll(newGames);
        filteredGames = games;
        currentPage++;
        if (newGames.length < 20 || games.length >= maxGames) {
          isLastPage =
              true; // Se menos de 20 jogos forem retornados, é a última página
        }
      });
    } catch (e) {
      // Handle the error
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterGames() {
    setState(() {
      filteredGames = games
          .where((game) => game['name']
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: games.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagem grande no topo
                  Image.network(
                    'https://images.pexels.com/photos/4836386/pexels-photo-4836386.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', // Substitua por uma URL válida
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
                  Padding( //Realizar pesquisa na propria API?
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Pesquisar jogos...',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Grid de jogos
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: filteredGames.length > maxGames
                          ? maxGames
                          : filteredGames.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GameDetailScreen(id: filteredGames[index]['id']),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: filteredGames[index]['background_image'] != null
                                          ? Image.network(
                                              filteredGames[index]['background_image'],
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
                                filteredGames[index]['name'],
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
                  if (isLoading)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
    );
  }
}
