// App-wide configuration constants.
// Update baseUrl to your deployed domain before printing QR codes.
class AppConfig {
  /// The public web URL where QuickBite is hosted.
  /// This is encoded into all table QR codes.
  /// Change this to your actual Vercel / GitHub Pages / Firebase Hosting URL.
  static const String baseUrl = 'https://quickbite-app.vercel.app';

  /// Kitchen PIN — change this to your desired PIN before going live.
  static const String kitchenPin = '1234';

  /// Total number of tables in your restaurant.
  static const int totalTables = 10;
}
