enum PersonaJob {
  aviator('Pilote de ligne'),
  ops('Administrateur systemes et reseaux '),
  developpeur('developpeur informatique'),
  medecin('medecin'),
  financier('trader'),
  pompier('pompier'),
  policier('policier'),
  millitaire('millitaire');

  const PersonaJob(this.label);

  final String label;
}
