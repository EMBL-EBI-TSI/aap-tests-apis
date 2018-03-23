function() {

  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 5000);

  return { baseUrl: 'https://explore.api.aai.ebi.ac.uk' };

}