class Config {
  static bool get isProduction {
    return const bool.fromEnvironment('dart.vm.product');
  }
}
