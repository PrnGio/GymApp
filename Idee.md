App android e webApp obiettivo principale poter gestire le schede di allenamento e tenere traccia di quest'ultimi.





* Log attraverso codice randomico su mobile (primo accesso opzione nuovo utente ti da codice univoco/utente esistente inserisci codice)
* Log web inserire codice(utilizzabile solo se si ha App android)
* Database usare firebase per gestire la persistenza dei dati e il collegamento tra webApp e App, scopo principale fa funzionare l'app indipendentemente dalla connessione internet ma avere comunque la possibilità di creare comodamente esercizi/schede e tenere tracci degli esercizi svolti da pc e poi "inviarle" nel telefono (chiarimento per gestire in modo asincrono e senza lasciare schede inutili nel DB)
* funzioni uguali sia per app che web app:

  * crea scheda: permette di creare una scheda inserendo vari esercizi (serie repitizioni peso)
  * crea esercizio: di default ci sono molti esercizi ma in caso uno vuole fare un esercizio che non esiste da modo di crearlo ed inserirlo nella categoria inerente(es: Gambe Busto Braccia)
* ordine di funzionamento da definire
* meccaniche da definire







Multipiattaforma (+1 pt), Responsive (+2 pt) e Navigazione (+1–2 pt): Un solo progetto compilato per Android e Web. Usa un LayoutBuilder (soglia 600px) per mostrare una NavigationBar in basso su telefono verticale e una NavigationRail laterale su Web/orizzontale tra le 3 schermate (Calendario/Log, Schede, Esercizi).Persistenza locale (+2 pt) e Servizio Remoto (+2 pt): Usa shared\_preferences per salvare esercizi, schede e log offline sul dispositivo, e il pacchetto http verso Firebase Realtime Database (endpoint .json) per il codice univoco (FIT-XXXXXX), l'invio schede PC $\\rightarrow$ Mobile e la sincronizzazione dei log.State Management (+1 pt): Aggiungi il pacchetto provider (il più leggero e veloce da imparare) con un solo WorkoutProvider che contiene le liste in memoria e chiama notifyListeners() quando aggiungi un esercizio, una scheda o un log.Dettagli UX (+1 pt): Configura un ThemeData con ColorScheme.fromSeed, il pacchetto google\_fonts e due widget custom riutilizzabili (es. la card dell'esercizio e il box "Scorsa volta: XX kg").Repository e Consegna: Crea subito il repository GitHub pubblico, usa lo schema a 4 cartelle (models/, providers/, services/, screens/) e compila il README.md seguendo esattamente i punti A–E del bando con 2–3 screenshot finali presi da Chrome e Android.

