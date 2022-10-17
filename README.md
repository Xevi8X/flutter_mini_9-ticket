# Nine-Euro-Ticket holder

## O 9€ Ticket

Nine-euro-ticket to specjalny bilet kolejowy wprowadzony przez zrzeszonych przewoźników w terenie Niemiec. Bilet skierowany jest dla turystów, obejmuję wszystkie połączenie lokalne, obowiązuje przez dany miesiąc kalendarzowy (czerwiec lipiec sierpien) i dla danego miesiaca kosztuje dokładnie 9€.

Bilet można kupić u każdego z zrzeszonych przewoźników oraz w internecie toteż nie ma on stałej szaty graficznej. Każdy przewoźnik używa swojego wzoru biletu. Z tego powodu trudno o ujednolicenie. Jako identyfikator biletu używa się pary - numer seryjny + Imie i nazwisko podróżującego.

Podczas kontroli bilet pokazuje się z dokumentem tożsamości. Własciwie pokazanie biletu jest opcjonalne, bo kontroler odczytuje z niego numer seryjny + imie i nazwisko i wprowadza je do sprawdzarki. W zwrotce dostaje czy bilet istnieje oraz czy jest on ważny. Z tego powodu przepisy dopuszają, aby numer ten po prostu podać (mieć zapisany na kartce, w notatkach, emailu itp).

## Pomysł

Nimniejsza aplikacja ma stanowic lekki holder/wallet dla powyższego biletu. 

Jako że istnieje mnóstwo kanałów sprzedaż, w tym internetowej, aplikacja nie prowadzi sprzedaży biletów. Aplikacja ma za zadanie jedynie umożliwić wprowadzenie biletu, przechywywać bilety i pokazywać je do kontroli. Zakup może pojawić się w apk ale tylko w postaci webview istniejącej już strony do sprzedaży biletów.

Use cases:

Jako użytkownik mogę
* otworzyć aplikację oraz dodać bilet (podając serial + imie i nazwisko). Bilet zostanie przechowany w pamięci urządzenia. 
* wykonywać pozostałe operacje CRUD na bilecie. 
* wygenerować QR kod lub nfc tag do kontroli
* otrzymać powiadomienie, gdy zbliżać się koniec ważności biletu
* Otworzyć stronę do zakupu biletu w WebView.
* Wykonać zapytanie do api rest sprawdzającego czy bilet jest w bazie (mock)

Jako użytkownik zarejestrowany i zalogowany mogę to samo co użytkownik oraz:
* moje bilety synchronizowane są dodatkowo przechowywane w chmurze (oraz przechowywane offline)
* (?) Wypełnic dane w formularzu zakupowym (O ile da się przesledzic i podłączyc do DB (Deustche Bahn) )


Planowane punkty dodatkowe:
* Android/iOS/ może web
* UX/Animacje
* Accessibility - zmiana rozmiaru czcionki i kolorów w ustawieniach
* Custom Painting - analogicznie j. w.
* WebView - wyświetlenie zewnętrzenej strony DB z zakupem biletu
* Offline - bilety przechowywane są również w Shared Preferences
* Z informacji o bilecie generowany jest QR code i jeśli znajdę odpowiedni package to generowany bedzie również JSON przesyłany przez NFC
* Internationalization
* Validation - formularz rejestracji i logowania
* Testy? CICD?



