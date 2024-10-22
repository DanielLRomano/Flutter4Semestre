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
