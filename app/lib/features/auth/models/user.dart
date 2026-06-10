import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// User model — maps to the hardcoded users in the backend.
///
/// Simple: just id + name. No auth complexity.
/// The id is sent as X-User-Id header with every request.
@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String name,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
