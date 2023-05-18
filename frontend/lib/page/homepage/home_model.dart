class Planet {
  String name;
  String image;

  Planet({
    required this.name,
    required this.image,
  });
}

List<Planet> planetList = [
  Planet(name: '지도', image: 'assets/Planet-2.png'),
  Planet(name: '상점', image: 'assets/SolarSystem.png'),
  Planet(name: '프로필', image: 'assets/Astronaut-3.png'),
  Planet(name: '글쓰기', image: 'assets/Planet-Rocket.png'),
];
