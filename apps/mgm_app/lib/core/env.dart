class Env {
  static String get insightsRegion => const String.fromEnvironment(
              'INSIGHTS_FUNCTION_REGION',
              defaultValue: '')
          .isNotEmpty
      ? const String.fromEnvironment('INSIGHTS_FUNCTION_REGION')
      : (const String.fromEnvironment('DART_DEFINE_INSIGHTS_FUNCTION_REGION') ??
          '');
}
