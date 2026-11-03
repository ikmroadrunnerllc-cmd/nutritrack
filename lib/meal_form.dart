import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'meal.dart';

const MEAL_TYPES = ['breakfast', 'lunch', 'dinner', 'snack'];

class MealForm extends StatefulWidget {
  final Meal? existing;
  MealForm({super.key, this.existing});

  @override
  State<MealForm> createState() => _MealFormState();
}

class _MealFormState extends State<MealForm> {
  late final nameCtrl = TextEditingController(text: widget.existing?.name);
  late final calsCtrl = TextEditingController(text: widget.existing?.calories.toString());
  late String type = widget.existing?.type ?? 'breakfast';

  String _today() {
    var d = DateTime.now();
    return '${d.year}-${d.month}-${d.day}';
  }

  void _save() {
    var cals = int.tryParse(calsCtrl.text);
    if (nameCtrl.text.isEmpty || cals == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('need a name and a number for calories')));
      return;
    }

    var uid = FirebaseAuth.instance.currentUser!.uid;
    var mealsRef = FirebaseFirestore.instance.collection('users').doc(uid).collection('meals');
    var tmpMeal = Meal('', nameCtrl.text, cals, type, widget.existing?.date ?? _today());

    if (widget.existing == null) {
      mealsRef.add(tmpMeal.toMap());
    } else {
      mealsRef.doc(widget.existing!.id).set(tmpMeal.toMap());
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Add meal' : 'Edit meal'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'Name')),
            TextField(
              controller: calsCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Calories'),
            ),
            SizedBox(height: 12),
            DropdownButton<String>(
              value: type,
              isExpanded: true,
              items: [for (var t in MEAL_TYPES) DropdownMenuItem(value: t, child: Text(t))],
              onChanged: (newVal) => setState(() => type = newVal!),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: Text('Save')),
          ],
        ),
      ),
    );
  }
}
