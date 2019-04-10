class JsonModel {
  // Create Field
  int id;
  String barcode;

//   // Constructor
//   JsonModel(
//       int idInt, String nameString, String userString, String passwordString) {
// //     id=idInt;
// // name =nameString;
// // user =userString;
// // password = passwordString;
//   }

  JsonModel(this.id, this.barcode);

JsonModel.fromJson(Map<String, dynamic> parseJSON){
  id = int.parse(parseJSON['id']);
  barcode = parseJSON['Barcode'];
  
  
}
}
