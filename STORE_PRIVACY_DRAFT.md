# Draft răspunsuri — formulare de confidențialitate (App Store / Google Play)

Bazat pe codul actual al aplicației (19-20 august 2026). Verifică din nou înainte de submisie finală, dacă între timp mai adaugi funcționalități care colectează date noi (ex. IAP, notificări push server-side, analytics).

Confirmat în cod: **nicio bibliotecă de analytics, reclame sau crash-reporting** (fără Firebase Analytics, AdMob, Crashlytics, Facebook SDK etc.) — asta simplifică mult ambele formulare.

---

## Apple — App Privacy (Nutrition Labels), App Store Connect

Pentru fiecare categorie, Apple întreabă: (a) e colectată, (b) e legată de identitatea utilizatorului, (c) e folosită pentru tracking (publicitate cross-app/site).

| Categorie | Colectat? | Legat de identitate | Pentru tracking? | Detalii |
|---|---|---|---|---|
| **Contact Info** (email) | Da | Da | Nu | Emailul de la înregistrare (Firebase Auth) |
| **Health & Fitness** | Da | Da | Nu | Înălțime, greutate, vârstă, sex biologic, nivel activitate, obiectiv, jurnal alimente/calorii/macro, antrenamente, cântăriri (manuale, cântar Bluetooth, Apple Health) |
| **User Content** (fotografii) | Da, dar tranzitoriu | Nu (nu e stocată) | Nu | Poza farfuriei e trimisă la o funcție cloud (Anthropic Claude) pentru identificare alimente, apoi **nu e păstrată** — nu bifa "stocată" dacă formularul distinge |
| **Identifiers** (User ID) | Da | Da | Nu | UID Firebase, intern, nu vizibil utilizatorului |
| **Usage Data** | Nu | — | — | Fără analytics |
| **Diagnostics** | Nu | — | — | Fără crash reporting |
| **Purchases** | Nu (încă) | — | — | Actualizează dacă adaugi IAP |
| **Location** | Nu | — | — | — |
| **Contacts** | Nu | — | — | — |
| **Browsing/Search History** | Nu | — | — | — |

**ATT (App Tracking Transparency)**: nu e necesar — aplicația nu face tracking cross-app/site, deci nu trebuie afișat promptul de tracking.

**Third-party SDKs care ating date**: Firebase (Auth, Firestore, Cloud Functions) — al Google; Anthropic (identificare alimente din poză, tranzitoriu); Open Food Facts (interogare bază de date publică după nume/cod de bare — fără date personale trimise, doar textul căutării/codul de bare).

---

## Google Play — Data Safety form

Categorii relevante din formular:

**Personal info**
- Email address → Colectat, necesar pentru funcționarea contului, nu e partajat cu terți.

**Health and fitness**
- Health info → Colectat (greutate, calorii, macro-nutrienți, antrenamente) → necesar pentru funcționare, nu e partajat, utilizatorul poate cere ștergere.
- Fitness info → Colectat (antrenamente, calorii arse) → la fel.

**Photos and videos**
- Photos → Colectat dar **nu stocat** — trimis tranzitoriu către procesare, nu persistă. Google are o opțiune specifică "collected but not stored" / poți nota în descriere că se șterge imediat după procesare.

**App activity**
- Probabil **Nu** (fără analytics de utilizare trimis oriunde extern).

**Device or other IDs**
- Nu (nu colectăm identificatori de dispozitiv/publicitate).

Pentru toate categoriile bifate: marchează "Data is encrypted in transit" = **Da** (Firebase folosește TLS peste tot) și "Users can request data deletion" = **Da** (funcția din aplicație, meniul → Șterge cont definitiv).

**"Health Apps" declaration** (secțiune separată, obligatorie fiindcă aplicația citește/scrie date de sănătate prin Health Connect): trebuie completată explicit — descrie citirea greutății/pașilor/caloriilor active din Health Connect, fără scriere de date sensibile suplimentare, fără partajare cu terți.

---

## Politica de confidențialitate (deja live)

`https://calorii-fit-app.web.app/privacy-policy` — folosește acest link exact în ambele console-uri (Apple îl cere în App Store Connect, Google în Data Safety + Store Listing).

## Ce nu poate completa Claude

Ambele formulare cer autentificare în contul de dezvoltator plătit al fiecărei platforme — nu pot accesa App Store Connect sau Play Console direct. Acest document e gândit să fie copiat/adaptat rapid când ajungi la acele ecrane.
