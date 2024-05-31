enum PersonaJob {
  aviateur('Pilote de ligne'),
  ops('Administrateur systemes et reseaux informatique'),
  developpeur('developpeur informatique'),
  medecin('medecin'),
  financier('trader'),
  pompier('pompier'),
  policier('policier'),
  millitaire('millitaire');

  const PersonaJob(this.label);

  final String label;
}
