class City {
  String name;

  City(this.name);
  static List<City> getCity() {
    List<City> list = new List<City>();
    list.add(City('Mumbai '));
    list.add(City('Delhi'));
    list.add(City('Bangalore'));
    list.add(City('Hyderabad'));
    list.add(City('Chennai'));
    list.add(City('Chandigarh'));
    list.add(City('Pune'));
    list.add(City('Jaipur'));
    list.add(City('Rajasthan'));
    list.add(City('Kashmir'));
    list.add(City('Surat'));
    list.add(City('Thane'));
    list.add(City('Kanpur'));
    list.add(City('Nashik'));
    list.add(City('Nagpur'));
    return list;
  }
}
