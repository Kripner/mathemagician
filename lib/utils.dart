typedef bool Predicate<T>(T value);

O doNothing<I, O>(I importantValueToBeProcessedCarefully) {
  return null; // so lazy
}

typedef void Action();

typedef void Consumer<T>(T value);