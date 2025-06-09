mixin ApiMixin{
  static const String apiHost = String.fromEnvironment("API_HOST", defaultValue: '10.0.2.2');
  static const String apiSchema = String.fromEnvironment("API_SCHEMA", defaultValue: 'http');
  static const String apiPort = String.fromEnvironment("API_PORT", defaultValue: '3000');

  Uri generateUri(String path, {Map<String, dynamic>? params}){

    // Convert apiPort to an integer
    final int port = int.tryParse(apiPort) ?? 3000;

    return Uri(
      scheme: apiSchema,
      host: apiHost,
      port: port,
      path: path,
      queryParameters: params,
    );
  }
}