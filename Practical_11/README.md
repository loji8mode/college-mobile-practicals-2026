# Практична № 12 — HTTP-запити через dio

Пункт LCloud 11. Окремий Flutter-проєкт на основі трьох валідованих форм. ApiService виконує JSON POST на власний Request Catcher:

https://valentyn32ist-lab12-20261123.requestcatcher.com/

Шляхи: /login, /signup, /reset. В AndroidManifest.xml задано INTERNET. Додано індикатор запиту, блокування повторного надсилання й SnackBar результату.

## Запуск

```sh
flutter pub get
flutter test
flutter run
```

Flutter 3.47.9, Dart 3.13.7, dio 5.11.1. Аналіз: `dart analyze lib test bin`.

## Порівняння http і dio

`dart run bin/compare.dart` надсилає той самий JSON на /compare обома бібліотеками. Заголовок X-Client позначає бібліотеку.

Тести: 8 валідаторів, 2 перевірки API (серіалізований UTF-8 JSON усіх трьох методів та HTTP 500), 5 widget-сценаріїв форм, повторного натискання і помилки з’єднання. Тести API використовують RecordingAdapter; фактичні мережеві запити перевіряються окремо в Android та на Request Catcher.

У прикладах використовуються демонстраційні дані. Логотип із шаблону Flutter, ліцензія — assets/FLUTTER_LICENSE.txt.
