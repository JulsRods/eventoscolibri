class Info {
String name;
String subt;

Info({
  required this.name,
  required this.subt,
}
);
  
}

List<Info>listOfBags() {
  return[
  Info(name: "Somos tu \nmejor socio",subt: "Valores que \n nos rigen: \n Compromiso \n Atención \n personalizada"),
    Info(name: "Historia",subt: " Desde 2021 \n nos caracterizamos \n por brindar \n servicios completos \n de organizacion"),
    Info(name: "Mision" ,subt: "Crear experiencias \n extraordinarias"),
      Info(name: "Vision", subt: "Lideres en la \nindustria de \n eventos"),
  ];
  }