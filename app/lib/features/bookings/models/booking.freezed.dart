// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Booking _$BookingFromJson(Map<String, dynamic> json) {
  return _Booking.fromJson(json);
}

/// @nodoc
mixin _$Booking {
  String get id => throw _privateConstructorUsedError;
  String get slotId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  BookingSlotInfo? get slot => throw _privateConstructorUsedError;
  BookingVenueInfo? get venue => throw _privateConstructorUsedError;

  /// Serializes this Booking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingCopyWith<Booking> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingCopyWith<$Res> {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) then) =
      _$BookingCopyWithImpl<$Res, Booking>;
  @useResult
  $Res call({
    String id,
    String slotId,
    String status,
    String? userId,
    String? createdAt,
    BookingSlotInfo? slot,
    BookingVenueInfo? venue,
  });

  $BookingSlotInfoCopyWith<$Res>? get slot;
  $BookingVenueInfoCopyWith<$Res>? get venue;
}

/// @nodoc
class _$BookingCopyWithImpl<$Res, $Val extends Booking>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slotId = null,
    Object? status = null,
    Object? userId = freezed,
    Object? createdAt = freezed,
    Object? slot = freezed,
    Object? venue = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            slotId: null == slotId
                ? _value.slotId
                : slotId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            slot: freezed == slot
                ? _value.slot
                : slot // ignore: cast_nullable_to_non_nullable
                      as BookingSlotInfo?,
            venue: freezed == venue
                ? _value.venue
                : venue // ignore: cast_nullable_to_non_nullable
                      as BookingVenueInfo?,
          )
          as $Val,
    );
  }

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookingSlotInfoCopyWith<$Res>? get slot {
    if (_value.slot == null) {
      return null;
    }

    return $BookingSlotInfoCopyWith<$Res>(_value.slot!, (value) {
      return _then(_value.copyWith(slot: value) as $Val);
    });
  }

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookingVenueInfoCopyWith<$Res>? get venue {
    if (_value.venue == null) {
      return null;
    }

    return $BookingVenueInfoCopyWith<$Res>(_value.venue!, (value) {
      return _then(_value.copyWith(venue: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingImplCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$$BookingImplCopyWith(
    _$BookingImpl value,
    $Res Function(_$BookingImpl) then,
  ) = __$$BookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String slotId,
    String status,
    String? userId,
    String? createdAt,
    BookingSlotInfo? slot,
    BookingVenueInfo? venue,
  });

  @override
  $BookingSlotInfoCopyWith<$Res>? get slot;
  @override
  $BookingVenueInfoCopyWith<$Res>? get venue;
}

/// @nodoc
class __$$BookingImplCopyWithImpl<$Res>
    extends _$BookingCopyWithImpl<$Res, _$BookingImpl>
    implements _$$BookingImplCopyWith<$Res> {
  __$$BookingImplCopyWithImpl(
    _$BookingImpl _value,
    $Res Function(_$BookingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slotId = null,
    Object? status = null,
    Object? userId = freezed,
    Object? createdAt = freezed,
    Object? slot = freezed,
    Object? venue = freezed,
  }) {
    return _then(
      _$BookingImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        slotId: null == slotId
            ? _value.slotId
            : slotId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        slot: freezed == slot
            ? _value.slot
            : slot // ignore: cast_nullable_to_non_nullable
                  as BookingSlotInfo?,
        venue: freezed == venue
            ? _value.venue
            : venue // ignore: cast_nullable_to_non_nullable
                  as BookingVenueInfo?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingImpl implements _Booking {
  const _$BookingImpl({
    required this.id,
    required this.slotId,
    required this.status,
    this.userId,
    this.createdAt,
    this.slot,
    this.venue,
  });

  factory _$BookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingImplFromJson(json);

  @override
  final String id;
  @override
  final String slotId;
  @override
  final String status;
  @override
  final String? userId;
  @override
  final String? createdAt;
  @override
  final BookingSlotInfo? slot;
  @override
  final BookingVenueInfo? venue;

  @override
  String toString() {
    return 'Booking(id: $id, slotId: $slotId, status: $status, userId: $userId, createdAt: $createdAt, slot: $slot, venue: $venue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slotId, slotId) || other.slotId == slotId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.slot, slot) || other.slot == slot) &&
            (identical(other.venue, venue) || other.venue == venue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    slotId,
    status,
    userId,
    createdAt,
    slot,
    venue,
  );

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      __$$BookingImplCopyWithImpl<_$BookingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingImplToJson(this);
  }
}

abstract class _Booking implements Booking {
  const factory _Booking({
    required final String id,
    required final String slotId,
    required final String status,
    final String? userId,
    final String? createdAt,
    final BookingSlotInfo? slot,
    final BookingVenueInfo? venue,
  }) = _$BookingImpl;

  factory _Booking.fromJson(Map<String, dynamic> json) = _$BookingImpl.fromJson;

  @override
  String get id;
  @override
  String get slotId;
  @override
  String get status;
  @override
  String? get userId;
  @override
  String? get createdAt;
  @override
  BookingSlotInfo? get slot;
  @override
  BookingVenueInfo? get venue;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingSlotInfo _$BookingSlotInfoFromJson(Map<String, dynamic> json) {
  return _BookingSlotInfo.fromJson(json);
}

/// @nodoc
mixin _$BookingSlotInfo {
  String get date => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;

  /// Serializes this BookingSlotInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingSlotInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingSlotInfoCopyWith<BookingSlotInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingSlotInfoCopyWith<$Res> {
  factory $BookingSlotInfoCopyWith(
    BookingSlotInfo value,
    $Res Function(BookingSlotInfo) then,
  ) = _$BookingSlotInfoCopyWithImpl<$Res, BookingSlotInfo>;
  @useResult
  $Res call({String date, String startTime, String endTime});
}

/// @nodoc
class _$BookingSlotInfoCopyWithImpl<$Res, $Val extends BookingSlotInfo>
    implements $BookingSlotInfoCopyWith<$Res> {
  _$BookingSlotInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingSlotInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? startTime = null,
    Object? endTime = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as String,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookingSlotInfoImplCopyWith<$Res>
    implements $BookingSlotInfoCopyWith<$Res> {
  factory _$$BookingSlotInfoImplCopyWith(
    _$BookingSlotInfoImpl value,
    $Res Function(_$BookingSlotInfoImpl) then,
  ) = __$$BookingSlotInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String date, String startTime, String endTime});
}

/// @nodoc
class __$$BookingSlotInfoImplCopyWithImpl<$Res>
    extends _$BookingSlotInfoCopyWithImpl<$Res, _$BookingSlotInfoImpl>
    implements _$$BookingSlotInfoImplCopyWith<$Res> {
  __$$BookingSlotInfoImplCopyWithImpl(
    _$BookingSlotInfoImpl _value,
    $Res Function(_$BookingSlotInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingSlotInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? startTime = null,
    Object? endTime = null,
  }) {
    return _then(
      _$BookingSlotInfoImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as String,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingSlotInfoImpl implements _BookingSlotInfo {
  const _$BookingSlotInfoImpl({
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  factory _$BookingSlotInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingSlotInfoImplFromJson(json);

  @override
  final String date;
  @override
  final String startTime;
  @override
  final String endTime;

  @override
  String toString() {
    return 'BookingSlotInfo(date: $date, startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingSlotInfoImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, startTime, endTime);

  /// Create a copy of BookingSlotInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingSlotInfoImplCopyWith<_$BookingSlotInfoImpl> get copyWith =>
      __$$BookingSlotInfoImplCopyWithImpl<_$BookingSlotInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingSlotInfoImplToJson(this);
  }
}

abstract class _BookingSlotInfo implements BookingSlotInfo {
  const factory _BookingSlotInfo({
    required final String date,
    required final String startTime,
    required final String endTime,
  }) = _$BookingSlotInfoImpl;

  factory _BookingSlotInfo.fromJson(Map<String, dynamic> json) =
      _$BookingSlotInfoImpl.fromJson;

  @override
  String get date;
  @override
  String get startTime;
  @override
  String get endTime;

  /// Create a copy of BookingSlotInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingSlotInfoImplCopyWith<_$BookingSlotInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingVenueInfo _$BookingVenueInfoFromJson(Map<String, dynamic> json) {
  return _BookingVenueInfo.fromJson(json);
}

/// @nodoc
mixin _$BookingVenueInfo {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get sportType => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;

  /// Serializes this BookingVenueInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingVenueInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingVenueInfoCopyWith<BookingVenueInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingVenueInfoCopyWith<$Res> {
  factory $BookingVenueInfoCopyWith(
    BookingVenueInfo value,
    $Res Function(BookingVenueInfo) then,
  ) = _$BookingVenueInfoCopyWithImpl<$Res, BookingVenueInfo>;
  @useResult
  $Res call({String id, String name, String sportType, String? location});
}

/// @nodoc
class _$BookingVenueInfoCopyWithImpl<$Res, $Val extends BookingVenueInfo>
    implements $BookingVenueInfoCopyWith<$Res> {
  _$BookingVenueInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingVenueInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? sportType = null,
    Object? location = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            sportType: null == sportType
                ? _value.sportType
                : sportType // ignore: cast_nullable_to_non_nullable
                      as String,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookingVenueInfoImplCopyWith<$Res>
    implements $BookingVenueInfoCopyWith<$Res> {
  factory _$$BookingVenueInfoImplCopyWith(
    _$BookingVenueInfoImpl value,
    $Res Function(_$BookingVenueInfoImpl) then,
  ) = __$$BookingVenueInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String sportType, String? location});
}

/// @nodoc
class __$$BookingVenueInfoImplCopyWithImpl<$Res>
    extends _$BookingVenueInfoCopyWithImpl<$Res, _$BookingVenueInfoImpl>
    implements _$$BookingVenueInfoImplCopyWith<$Res> {
  __$$BookingVenueInfoImplCopyWithImpl(
    _$BookingVenueInfoImpl _value,
    $Res Function(_$BookingVenueInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingVenueInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? sportType = null,
    Object? location = freezed,
  }) {
    return _then(
      _$BookingVenueInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        sportType: null == sportType
            ? _value.sportType
            : sportType // ignore: cast_nullable_to_non_nullable
                  as String,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingVenueInfoImpl implements _BookingVenueInfo {
  const _$BookingVenueInfoImpl({
    required this.id,
    required this.name,
    required this.sportType,
    this.location,
  });

  factory _$BookingVenueInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingVenueInfoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String sportType;
  @override
  final String? location;

  @override
  String toString() {
    return 'BookingVenueInfo(id: $id, name: $name, sportType: $sportType, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingVenueInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sportType, sportType) ||
                other.sportType == sportType) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, sportType, location);

  /// Create a copy of BookingVenueInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingVenueInfoImplCopyWith<_$BookingVenueInfoImpl> get copyWith =>
      __$$BookingVenueInfoImplCopyWithImpl<_$BookingVenueInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingVenueInfoImplToJson(this);
  }
}

abstract class _BookingVenueInfo implements BookingVenueInfo {
  const factory _BookingVenueInfo({
    required final String id,
    required final String name,
    required final String sportType,
    final String? location,
  }) = _$BookingVenueInfoImpl;

  factory _BookingVenueInfo.fromJson(Map<String, dynamic> json) =
      _$BookingVenueInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get sportType;
  @override
  String? get location;

  /// Create a copy of BookingVenueInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingVenueInfoImplCopyWith<_$BookingVenueInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
