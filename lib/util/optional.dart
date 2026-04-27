/// A Wrapper for an optional value.
///
/// It allows to know if the value has been explicitely set to null
/// or if the value hasn't been set at all.
class Optional<T> {
  /// The object
  T? _obj;

  /// Whether it has been set or not
  bool _isSet;

  /// Check if the value has been set
  bool isSet() => _isSet;

  /// Runs a function if the item is present
  void ifSet(void Function(T?) setCallback) {
    if (isSet()) setCallback(_obj);
  }

  /// Runs a function if the item is set or another function if the item isn't set
  void ifSetOrElse(
      void Function(T?) setCallback, void Function() notSetCallback) {
    isSet() ? setCallback(_obj) : notSetCallback();
  }

  /// Check if the value has been set and isn't null
  bool isPresent() => _isSet && _obj != null;

  /// Runs a function if the item is present
  void ifPresent(void Function(T) presentCallback) {
    if (isPresent()) presentCallback(_obj as T);
  }

  /// Runs a function if the item is present or another function if the item isn't present
  void ifPresentOrElse(
      void Function(T) presentCallback, void Function() absentCallback) {
    isPresent() ? presentCallback(_obj as T) : absentCallback();
  }

  /// Get the object
  T? get() => _obj;

  /// Get if object is present or return something else
  T _orElse(T fallback) => isPresent() ? _obj! : fallback;

  /// Get if object is set or return something else
  T? _orElseNullable(T? fallback) => isSet() ? _obj : fallback;

  /// The constructor
  Optional._(this._obj, this._isSet);

  /// An optional of an object
  factory Optional.of(T? value) {
    return Optional._(value, true);
  }

  /// An empty optional
  factory Optional.empty() {
    return Optional._(null, false);
  }

  /// Sets the Optional to the object
  void set(T? obj) {
    _obj = obj;
    _isSet = true;
  }

  /// Unsets the object from the Optional
  void unset() {
    _obj = null;
    _isSet = false;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Optional<T> && (other._obj == _obj && other._isSet == _isSet);
  }

  @override
  int get hashCode => Object.hash(_obj, _isSet);
}

/// Used to make code work when Optional is null
extension OptionalExtension<T> on Optional<T>? {
  /// Get the value if Optional is set otherwise return a default value
  T? orElseNullable(T? fallback) {
    Optional<T>? self = this;
    if (self == null) return fallback;
    return self._orElseNullable(fallback);
  }

  /// Get the value if Optional isn't null and the value is present
  /// otherwise return a default value
  T orElse(T fallback) {
    Optional<T>? self = this;
    if (self == null) return fallback;
    return self._orElse(fallback);
  }
}
