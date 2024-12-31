/// Change settings for a given field, add this either to the field or in the constructor
///
/// Example:
/// ```
/// @FlutterRoute(routeName: '/user/:id')
/// class UserDetailPage extends StatelessWidget {
///  final String id; // Fallback when user is null
///
///   @FlutterRouteField(queryName: 'user_id', addToJson: false)
///   final User? user; // user is not added to the json
///
///   UserDetailPage({
///     required this.id,
///     this.user,
///     @FlutterRouteField(ignore: true) super.key, // Note: key is ignored by default
///   });
class FlutterRouteField {
  /// The name of the variable in the query, defaults
  /// to the variable name
  final String? queryName;

  /// Ignore this field completely. May break your code if the field is required
  /// Defaults to false (except for Key? key field)
  final bool? ignore;

  /// default true, add this to the json serialization, only useful for web,
  /// set to false to add cached values, but prevent the user from overriding them
  ///
  /// Example:
  /// ```
  /// @FlutterRoute(routeName: '/user/:id')
  /// class UserDetailPage extends StatelessWidget {
  ///   final String id; // Fallback when user is null
  ///
  ///   @FlutterRouteField(addToJson: false)
  ///   final User? user; // user is not added to the json
  /// ```
  final bool addToJson;

  const FlutterRouteField({
    this.queryName,
    this.ignore,
    this.addToJson = true,
  });
}
