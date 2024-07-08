// lib/game_list_screen.dart
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'game_detail_screen.dart';

class GameListScreen extends StatefulWidget {
  const GameListScreen({super.key});

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
  final ScrollController _scrollController = ScrollController();
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
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagem grande no topo
                  Image.network(
                    'https://scontent-gig4-2.xx.fbcdn.net/v/t39.30808-6/450332502_3352243118405642_165983867684789867_n.jpg?stp=dst-jpg_p180x540&_nc_cat=104&ccb=1-7&_nc_sid=127cfc&_nc_ohc=hRRJTWy703cQ7kNvgG-9yd8&_nc_ht=scontent-gig4-2.xx&oh=00_AYCisxow4GJcNwp0yo_GnPEl5Z92m8GIUDEX6rGFy00dyg&oe=6691D4AD', // Substitua por uma URL válida
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                  const SizedBox(height: 16.0),
                  // Título "Biblioteca"
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Biblioteca',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    //Realizar pesquisa na propria API?
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Pesquisar jogos...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Grid de jogos
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                                builder: (context) => GameDetailScreen(
                                    id: filteredGames[index]['id']),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: filteredGames[index]
                                              ['background_image'] !=
                                          null
                                      ? Image.network(
                                          filteredGames[index]
                                              ['background_image'],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        )
                                      : Container(
                                          color: Colors.grey,
                                          width: double.infinity,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                filteredGames[index]['name'],
                                style: const TextStyle(color: Colors.white),
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
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
    );
  }
}
