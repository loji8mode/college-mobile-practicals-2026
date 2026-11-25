# Практична № 15 Тестування Flutter

Буга Валентин, 32-ІСТ. Варіант 1: y = x − 1/x² + 1/x³, крок 1, Icons.person, заголовок 32-IST: Valentyn's last Flutter App.

flutter pub get

dart analyze lib test integration_test

flutter test --coverage

flutter test integration_test/counter_test.dart -d emulator-5556

flutter build apk --release

Модульні тести звіряють п’ять відомих значень, x=0, NaN/Infinity і переповнення. Три widget-тести перевіряють заголовок, іконку й кожен крок 0→5. Інтеграційний сценарій виконує ті самі натискання у повному Android-застосунку. coverage/lcov.info створюється реальною командою тестування.
