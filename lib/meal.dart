import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  String id;
  String name;
  int calories;
  String type;
  String date;

  Meal(this.id, this.name, this.calories, this.type, this.date);

  static Meal fromDoc(DocumentSnapshot d) {
    var raw = d.data() as Map<String, dynamic>;
    return Meal(
      d.id,
      raw['name'] ?? '',
      raw['calories'] ?? 0,
      raw['type'] ?? 'snack',
      raw['date'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'calories': calories,
        'type': type,
        'date': date,
      };
}
