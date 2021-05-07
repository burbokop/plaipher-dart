

class Option<T> {
  final T value;
  final bool isDefined;
  final bool isEmpty;
  Option(T value, bool isDefined): value = value, isDefined = isDefined, isEmpty = !isDefined;
  factory Option.some(T value) => Option(value, true);
  factory Option.none() => Option(null, false);

  @override String toString() => isDefined ? 'Some($value)' : 'None';

  Option<B> map<B>(B Function(T) f) {
    if(isDefined) return Option(f(value), true);
    return Option(null, false);
  }

  T getOrElse(T def) {
    if (isDefined) return value;
    return def;
  }
}