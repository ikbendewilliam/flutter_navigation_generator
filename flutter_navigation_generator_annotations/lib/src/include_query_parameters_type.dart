/// Whether to use query parameters to provide the arguments
enum IncludeQueryParametersType {
  /// Always include query parameters
  always,

  /// Only include query parameters on web (uses kIsWeb check)
  onlyOnWeb,

  /// Never use query parameters
  /// Note: This will throw an error if the route has non-nullable
  /// arguments and the user is navigating directly to the route on web
  never,
}
