import 'package:flutter/material.dart'; // Importa o pacote Flutter para a construção de interfaces de usuário.
import 'api_service.dart'; // Importa a classe ApiService, que contém métodos para interagir com a API.

void main() {
  runApp(
      MyApp()); // Função principal que inicia a aplicação, criando uma instância de MyApp.
}

class MyApp extends StatelessWidget {
  // Classe que representa o aplicativo. É um widget sem estado.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:
          'API Integration Example', // Título do aplicativo que será exibido na barra de título do dispositivo.
      home:
          ApiExample(), // Define a tela inicial do aplicativo, que será uma instância de ApiExample.
    );
  }
}

class ApiExample extends StatefulWidget {
  // Classe que representa a tela principal do aplicativo, que possui estado.
  @override
  _ApiExampleState createState() =>
      _ApiExampleState(); // Cria a instância do estado associado a este widget.
}

class _ApiExampleState extends State<ApiExample> {
  // Classe de estado que gerencia a lógica e a interface da ApiExample.
  late ApiService
      apiService; // Declara uma variável para a instância da classe ApiService.
  late Future<List<dynamic>>
      data; // Declara uma variável para armazenar os dados retornados da API.

  @override
  void initState() {
    super
        .initState(); // Chama o método da superclasse para garantir que a inicialização da classe pai ocorra corretamente.
    // Inicializa a instância da ApiService com a URL da API que será utilizada.
    apiService = ApiService('https://jsonplaceholder.typicode.com/posts');
    // Chama o método fetchData da ApiService para buscar os dados da API e armazena na variável data.
    data = apiService.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cria a estrutura básica da interface do usuário.
      appBar: AppBar(
        title: Text(
            'API Integration Example'), // Define o título da barra de aplicativos.
      ),
      body: FutureBuilder<List<dynamic>>(
        future:
            data, // Passa a Future que contém a lista de dados que será buscada.
        builder: (context, snapshot) {
          // Constrói a interface com base no estado da Future.
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Se a requisição ainda está em andamento, exibe um indicador de progresso.
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Se houve um erro na requisição, exibe uma mensagem de erro.
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Quando os dados são carregados com sucesso, cria uma lista de itens.
          return ListView.builder(
            itemCount: snapshot.data
                ?.length, // Define o número de itens a serem exibidos na lista.
            itemBuilder: (context, index) {
              // Constrói cada item da lista.
              final item = snapshot
                  .data![index]; // Obtém o item atual da lista usando o índice.
              return ListTile(
                // Cria um item de lista.
                title: Text(item['title']), // Exibe o título do item.
                subtitle: Text(item['body']), // Exibe o corpo do item.
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Cria um botão flutuante.
        onPressed: () async {
          // Define o que acontece ao pressionar o botão.
          // Envia um novo post para a API usando o método postData da ApiService.
          final response = await apiService.postData({
            'title': 'New Post', // Título do novo post a ser enviado.
            'body':
                'This is the body of the new post', // Corpo do novo post a ser enviado.
            'userId': 1, // ID do usuário associado ao novo post.
          });
          // Verifica se a resposta da API indica que o post foi criado com sucesso (código 201).
          if (response.statusCode == 201) {
            // Exibe uma mensagem de sucesso na forma de um Snackbar.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Post criado com sucesso!')),
            );
            setState(() {
              // Atualiza os dados ao refazer a chamada para a API para obter a lista atualizada.
              data = apiService.fetchData(); // Reexecuta a busca de dados.
            });
          }
        },
        child: Icon(Icons.add), // Define o ícone do botão flutuante.
      ),
    );
  }
}
