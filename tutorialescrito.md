Tutorial: Integrando Flutter com APIs REST
Neste tutorial, você aprenderá como integrar o Flutter com APIs REST utilizando o pacote http. Vamos cobrir a realização de requisições GET e POST, manipulação de dados em JSON e exibição desses dados em widgets do Flutter. Este guia inclui explicações detalhadas e comentários no código para facilitar o entendimento.
Pré-requisitos
•	Flutter instalado na sua máquina.
•	Um editor de código (como VS Code ou Android Studio).
•	Conhecimento básico de Flutter e Dart.
Passo 1: Criar um novo projeto Flutter
1.	Abra o terminal ou prompt de comando.
2.	Crie um novo projeto Flutter:
bash
flutter create api_integration_example
3.	Navegue até o diretório do projeto:
bash
cd api_integration_example
4.	Abra o projeto no seu editor de código.
Passo 2: Adicionar o pacote http
No arquivo pubspec.yaml, adicione a dependência http:
yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.3  # Verifique se esta é a versão mais recente
Após adicionar a dependência, execute o comando abaixo para instalar o pacote:
bash
flutter pub get
Passo 3: Estrutura do projeto
Vamos criar uma estrutura simples para o nosso aplicativo:
•	lib/main.dart: O ponto de entrada do aplicativo.
•	lib/api_service.dart: Classe para lidar com as requisições.
Passo 4: Implementar a classe ApiService
Crie um arquivo chamado api_service.dart na pasta lib e adicione o seguinte código:
import 'dart:convert'; // Importa a biblioteca para manipulação de dados JSON.
import 'package:http/http.dart' as http; // Importa o pacote http e atribui o alias 'http' para facilitar a referência.

class ApiService {
  final String baseUrl; // Declara uma variável final para armazenar a URL base da API.

  // Construtor que recebe a URL base e a inicializa.
  ApiService(this.baseUrl);

  // Método assíncrono para realizar uma requisição GET.
  Future<List<dynamic>> fetchData() async {
    // Realiza a requisição GET à URL base.
    final response = await http.get(Uri.parse(baseUrl));

    // Verifica se a resposta da requisição foi bem-sucedida (status code 200).
    if (response.statusCode == 200) {
      // Decodifica o corpo da resposta em formato JSON e o retorna como uma lista.
      return json.decode(response.body);
    } else {
      // Se a requisição falhar, lança uma exceção com uma mensagem de erro.
      throw Exception('Falha ao carregar dados');
    }
  }

  // Método assíncrono para realizar uma requisição POST.
  Future<http.Response> postData(Map<String, dynamic> data) async {
    // Realiza a requisição POST à URL base com os dados no corpo da requisição.
    final response = await http.post(
      Uri.parse(baseUrl), // Converte a URL base em um objeto URI.
      headers: {"Content-Type": "application/json"}, // Define o cabeçalho indicando que o corpo é em JSON.
      body: json.encode(data), // Codifica os dados recebidos em formato JSON.
    );

    // Retorna a resposta da requisição POST.
    return response;
  }
}

Explicação do código
•	Importações: Importamos as bibliotecas necessárias para manipular JSON e realizar requisições HTTP.
•	ApiService: Esta classe possui métodos para realizar requisições GET e POST.
•	fetchData: Realiza uma requisição GET e retorna os dados em formato de lista.
•	postData: Envia dados para a API em formato JSON.
Passo 5: Integrar no main.dart
Agora, vamos usar a classe ApiService no arquivo main.dart para fazer requisições e exibir os dados.
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

Explicação do código
•	MyApp: Configura o aplicativo e define a tela inicial.
•	ApiExample: Tela principal que usa a classe ApiService para buscar dados.
•	FutureBuilder: Um widget que constrói a interface de acordo com o estado da requisição (loading, erro ou sucesso).
•	ListView.builder: Cria uma lista dinâmica a partir dos dados recebidos.
•	FloatingActionButton: Permite enviar novos dados para a API e atualiza a lista após o envio.
Passo 6: Executar o aplicativo
Agora você pode executar o aplicativo usando o seguinte comando:
bash
flutter run
Conclusão
Neste tutorial, você aprendeu como integrar Flutter com APIs REST utilizando o pacote http. Vimos como realizar requisições GET e POST, manipular dados JSON e exibir informações em widgets do Flutter. O código está comentado para facilitar o entendimento e ajudar na sua implementação.
