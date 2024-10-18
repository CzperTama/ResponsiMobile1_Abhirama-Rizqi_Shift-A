class ApiUrl {
  static const String baseUrl = 'http://responsi.webwizards.my.id/api/pariwisata';
  static const String login = 'http://responsi.webwizards.my.id/api/login';
  static const String registrasi = 'http://responsi.webwizards.my.id/api/registrasi';
  static const String createReview = '$baseUrl/ulasan';

  static String updateReview(int id) => '$baseUrl/ulasan/$id/update';

  static String showReview(int id) => '$baseUrl/ulasan/$id';

  static String deleteReview(int id) => '$baseUrl/ulasan/$id/delete';
}