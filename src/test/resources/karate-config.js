function fn() {
  var env = karate.env;
  karate.log('Ambiente actual:', env);

  var config = {};

  if (!env) {
    env = 'dev';
  }

  if (env == 'dev') {
    config.baseUrl = 'https://serverest.desa';
  }

  else if (env == 'qa') {
    config.baseUrl = 'https://serverest.dev';
  }

  else if (env == 'prod') {
    config.baseUrl = 'https://serverest.prod';
  }

  return config;
}
