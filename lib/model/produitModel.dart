class Produit {
  int id;
  String nom;
  String prix;

  Produit({this.id, this.nom, this.prix});
  Produit.SansId({ this.nom, this.prix});

  Map<String, dynamic> toMap() => {"id": id, "nom": nom, "prix": prix};
  Map<String, dynamic> toMapSansId() => { "nom": nom, "prix": prix};
}
