class CorsDefaults {
  const CorsDefaults._();

  static const allowOrigin = '*';
  static const allowMethods = 'GET,PUT,POST,PATCH,DELETE,OPTIONS';
  static const allowHeaders =
      'Origin,X-Requested-With,Content-Type,Accept,Authorization';
}
