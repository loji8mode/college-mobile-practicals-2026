# Практична № 13 Нотатки SQLite

Буга Валентин, група 32-ІСТ. Окремий practical13.

Модель Note, репозиторій NotesDatabase, валідація порожнього тексту, завантаження на старті та оновлення після вставки. SQLite зберігає UTC у мікросекундах, список LIFO: created_at DESC, id DESC. Дата інтерфейсу відображається у локальному часовому поясі.

Команди: flutter pub get; dart analyze lib test; flutter test; flutter run; flutter build apk --release. Android/iOS sqflite використовує справжню локальну базу. Unit-тести виконують фактичні SQL-запити через sqflite_common_ffi у тимчасовій базі; UI-тести використовують окреме сховище в пам’яті.
