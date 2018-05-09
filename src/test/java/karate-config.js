function() {

  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 5000);

  var config = {
    baseUrl: 'https://explore.api.aai.ebi.ac.uk',
  };
  for(var property in karate.properties) {
    if(property.contains("AAP_")) {
      config[property] = karate.properties[property];
    }
  }

  return config;
}