import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth.dart';
import 'meal.dart';
import 'meal_form.dart';

const DAILY_GOAL = 2000;

class DiaryScreen extends StatelessWidget {
  // TODO: let the user look at other days
  String _today() {
    var d = DateTime.now();
    return '${d.year}-${d.month}-${d.day}';
  }

  @override
  Widget build(BuildContext context) {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var mealsRef = FirebaseFirestore.instance.collection('users').doc(uid).collection('meals');

    return Scaffold(
      appBar: AppBar(
        title: Text('Today'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        actions: [IconButton(icon: Icon(Icons.logout), onPressed: signOut)],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => MealForm())),
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: mealsRef.where('date', isEqualTo: _today()).snapshots(),
        builder: (c, s) {
          if (s.hasError) return Center(child: Text('${s.error}'));
          if (!s.hasData) return Center(child: CircularProgressIndicator());

          List<Meal> meals = [];
          int total = 0;
          s.data!.docs.forEach((d) {
            var m = Meal.fromDoc(d);
            meals.add(m);
            total += m.calories;
          });

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Text('$total / $DAILY_GOAL kcal', style: TextStyle(fontSize: 22)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: meals.length,
                  itemBuilder: (c, i) {
                    var m = meals[i];
                    return Dismissible(
                      key: Key(m.id),
                      background: Container(color: Colors.red),
                      onDismissed: (_) => mealsRef.doc(m.id).delete(),
                      child: ListTile(
                        title: Text(m.name),
                        subtitle: Text('${m.type} - ${m.calories} kcal'),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => MealForm(existing: m))),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
