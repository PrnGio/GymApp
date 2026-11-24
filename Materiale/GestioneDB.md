Come funziona il collegamento automatico e asincrono

Per far sì che qualsiasi esercizio o scheda creata su PC compaia in automatico sul telefono (e viceversa) senza bloccare l'uso offline in palestra, applichi a tutte le entità la stessa regola basata sull'orario di modifica:



Tre campi tecnici su ogni dato (Esercizio, Scheda, Log):



* id: codice univoco dell'elemento (es. il timestamp di creazione).



* ultimaModifica: l'orario esatto in millisecondi in cui l'elemento è stato creato o modificato.



* eliminato: true o false (serve per far viaggiare anche le cancellazioni tra i dispositivi senza errori).



Uso Offline su Android (nessuna attesa):

* In palestra (anche senza internet) puoi creare un nuovo esercizio, modificare una scheda o registrare un allenamento. Il telefono salva subito tutto nella sua memoria interna (SharedPreferences), imposta ultimaModifica all'istante attuale e segna l'elemento come sincronizzato = false.



Allineamento Asincrono (quando c'è connessione):

* All'avvio dell'app (o premendo un tasto Sincronizza / quando torna internet), il telefono esegue due passaggi in background tramite chiamate http verso Firebase:

  * Invia (PUT): Carica online tutti gli esercizi, le schede e i log creati o modificati sul telefono mentre eri offline.
  * Scarica e Confronta (GET): Legge i dati presenti online. Se trova un esercizio o una scheda nuova (creata da PC) oppure con un ultimaModifica più recente rispetto a quella salvata sul telefono, aggiorna la memoria locale.



Uso su PC (Web App):

* Quando crei un esercizio o una scheda dal computer, la Web App salva su Firebase con ultimaModifica aggiornato. Appena apri l'app sul telefono con connessione attiva, te li ritrovi automaticamente pronti anche in locale.



Un piccolo accorgimento pratico per la palestra

Con questo sistema, se modifichi una Scheda sul telefono (es. cambi la Panca Piana con le Spinte Manubri), la modifica si aggiornerà anche sul PC.



Se invece sei in palestra e vuoi cambiare esercizio solo per oggi perché il macchinario è occupato, ti basta avviare la scheda e modificare gli esercizi direttamente dentro il Log di oggi: in questo modo registri ciò che hai fatto realmente senza alterare la scheda salvata.

