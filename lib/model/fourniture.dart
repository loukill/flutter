class fourniture {
  fourniture({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.rate,
    required this.quantity,
    required this.disponibility,
    required this.description,
  });

  String id;
  String image;
  String name;
  int price;
  double rate;
  String quantity;
  String disponibility;
  String description;

  factory fourniture.fromJson(Map<String, dynamic> json) => fourniture(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        price: json["price"],
        rate: json["rate"].toDouble(),
        quantity: json["quantity"],
        disponibility: json["disponibility"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "price": price,
        "rate": rate,
        "quantity": quantity,
        "disponibility": disponibility,
        "description": description,
      };
}

final dummyfourniture = [
  fourniture(
    id: '1',
    image: 'asset/regle.png',
    name: 'Regle coloré',
    price: 15,
    rate: 4.5,
    quantity: '100',
    disponibility: 'En_Stocke',
    description:
        'La règle de lecture est faite en combinaison de plastique opaque et transparent pour souligner le texte et le mettre en évidence dans une teinte de couleur. Il suffit de lire le texte à travers les bandes de plastique teinté de la couleur choisie.',
  ),
  fourniture(
    id: '2',
    image: 'asset/clavier coloré type.webp',
    name: 'Clavier Lumineuse',
    price: 20,
    rate: 4.5,
    quantity: '100',
    disponibility: 'En_Stocke',
    description:
        'cette clavier offre une expérience de frappe adaptée et confortable. Cette innovation en matière de claviers offre une gamme de couleurs attrayantes et une configuration spatiale qui permet une utilisation ergonomique et agréable. Les touches du clavier sont conçues pour offrir une bonne prise et une durée de vie maximale, tout en assurant une réponse instantanée et une grande fluidité lors de la frappe. De plus, ce clavier est doté de capacités tactiles et sonores.',
  ),
  fourniture(
    id: '3',
    image: 'asset/rapid.png',
    name: 'Rapid',
    price: 10,
    rate: 4,
    quantity: '20',
    disponibility: 'En_Stocke',
    description:
        'Rapid est une application intelligente conçue pour améliorer la lecture de textes en langue naturelle. Grâce à sa technologie avancée, cette application est capable de lire rapidement et précisément le texte. Les utilisateurs peuvent ajuster les paramètres de lecture, tels que la vitesse, le ton et la voix, pour adapter la lecture à leurs besoins spécifiques. Rapid offre également des fonctionnalités de synchronisation entre différents appareils',
  ),
  fourniture(
      id: '4',
      image: 'asset/dragon.PNG',
      name: 'Dragon',
      price: 12,
      rate: 4.8,
      quantity: '60',
      disponibility: 'En_Stocke',
      description:
          'Dragon est une application intelligente qui permet de lire des textes avec une grande police et des couleurs attrayantes. Ce design est conçu pour offrir une expérience de lecture optimale, en facilitant la navigation et en assurant une bonne visibilité pour tous les utilisateurs. Avec Dragon les utilisateurs peuvent personnaliser la taille, la couleur et le style du texte en fonction de leurs besoins et de leurs préférences, En somme, Dragon offre une solution pratique et adaptée pour améliorer la lecture des textes en grande police et couleurée.'),
];
