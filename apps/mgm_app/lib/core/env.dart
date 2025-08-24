import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get insightsRegion =>
      dotenv.env['INSIGHTS_FUNCTION_REGION'] ?? '';

  static String? get insightsEndpointUrl =>
      dotenv.env['INSIGHTS_ENDPOINT_URL'];
}
