class Ride {
  final String driverName;
  final String destination;
  final String fromCity; // ⬅️ جديد
  final String time;
  final double price;
  final double rating;
  final DateTime departureDateTime;

  Ride({
    required this.driverName,
    required this.destination,
    required this.fromCity, // ⬅️ جديد
    required this.time,
    required this.price,
    required this.rating,
    required this.departureDateTime,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      driverName: json['driverName'] ?? '',
      destination: json['destination'] ?? '',
      fromCity: json['fromCity'] ?? '', // ⬅️ جديد
      time: json['time'] ?? '',
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      departureDateTime: json['departureDateTime'] != null
          ? DateTime.parse(json['departureDateTime'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverName': driverName,
      'destination': destination,
      'fromCity': fromCity, // ⬅️ جديد
      'time': time,
      'price': price,
      'rating': rating,
      'departureDateTime': departureDateTime.toIso8601String(),
    };
  }
}
