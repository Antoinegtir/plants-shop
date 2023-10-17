class PlantModel {
  String? pot;
  String? title;
  String? price;
  String? height;
  String? plantId;
  String? temperature;
  String? description;
  String? imageUrl;
  List<String>? like;

  PlantModel({
    this.pot,
    this.like,
    this.title,
    this.price,
    this.height,
    this.plantId,
    this.imageUrl,
    this.description,
    this.temperature,
  });

  PlantModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    pot = map['pot'];
    title = map['title'];
    price = map['price'];
    height = map['height'];
    plantId = map['plantId'];
    description = map['description'];
    temperature = map['temperature'];
    imageUrl = map['imageUrl'];
    if (map['like'] != null) {
      like = <String>[];
      map['like'].forEach(
        (String value) {
          like!.add(value);
        },
      );
    }
  }
  toJson() {
    return <String, Object?>{
      'pot': pot,
      'height': height,
      'like': like,
      'title': title,
      'price': price,
      'plantId': plantId,
      'imageUrl': imageUrl,
      'description': description,
      'temperature': temperature,
    };
  }

  PlantModel copyWith({
    String? title,
    String? price,
    String? pot,
    String? height,
    String? temperature,
    String? plantId,
    String? imageUrl,
    String? description,
    List<String>? like,
  }) {
    return PlantModel(
      pot: pot ?? this.pot,
      like: like ?? this.like,
      title: title ?? this.title,
      price: price ?? this.price,
      height: height ?? this.height,
      plantId: plantId ?? this.plantId,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      temperature: temperature ?? this.temperature,
    );
  }
}
