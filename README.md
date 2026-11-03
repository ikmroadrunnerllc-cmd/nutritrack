# NutriTrack

Simple calorie diary made with Flutter and Firebase. You sign up with email and password,
log what you ate today, and it adds up the calories against a 2000 kcal goal.

## What it does

- sign up / log in with email + password (Firebase Auth)
- add a meal with a name, calories and type (breakfast, lunch, dinner, snack)
- tap a meal to edit it
- swipe a meal to delete it
- only shows today's meals, and each user only sees their own

Meals are saved in Firestore under `users/{uid}/meals`. The rules in `firestore.rules`
only let a signed in user read and write their own meals.

## Files

- `lib/main.dart` - firebase setup and the login screen
- `lib/auth.dart` - sign in, sign up, sign out
- `lib/diary.dart` - today's list and the total
- `lib/meal_form.dart` - add / edit screen
- `lib/meal.dart` - the meal class

## Running it

You need Flutter and a Firebase project with Email/Password sign in and Firestore turned on.

```
flutter pub get
flutterfire configure
flutter run
```

To push the Firestore rules:

```
firebase deploy --only firestore:rules
```
