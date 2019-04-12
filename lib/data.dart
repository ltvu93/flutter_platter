class Recipe {
  final int id;
  final String imageUrl;
  final String name;
  final String price;
  final bool isVeg;
  final String calories;
  final String ingredients;

  Recipe({
    this.id,
    this.imageUrl,
    this.name,
    this.price,
    this.isVeg,
    this.calories,
    this.ingredients,
  });
}

final List<Recipe> recipeList = [
  Recipe(
      id: 1,
      imageUrl: "images/taco_salad.png",
      name: "Taco Salad",
      price: "₹120",
      isVeg: true,
      calories: "141 Kcal",
      ingredients: "Tomatos, Cheese, Lettuce,\n Chips, Tacos, Dessing"),
  Recipe(
      id: 2,
      imageUrl: "images/pork.png",
      name: "Pork Schnitzel",
      price: "₹220",
      isVeg: false,
      calories: "287 Kcal",
      ingredients: "Pork, Almonds, Eggs, Lemons,\n Garlic, Pepper, Rosemary"),
  Recipe(
      id: 3,
      imageUrl: "images/chicken.png",
      name: "Grilled Chicken",
      price: "₹120",
      isVeg: false,
      calories: "226 Kcal",
      ingredients: "Chicken Breast, Grill Sauce,\n Dressing")
];
