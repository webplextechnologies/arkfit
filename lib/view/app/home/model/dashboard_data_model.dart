/* class DashboardDataModel {
  bool? status;
  String? date;
  Calories? calories;
  Macros? macros;
  Steps? steps;
  //Null? weight;

  DashboardDataModel(
      {this.status,
      this.date,
      this.calories,
      this.macros,
      this.steps,
      //this.weight
      });

  DashboardDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    date = json['date'];
    calories = json['calories'] != null
        ? new Calories.fromJson(json['calories'])
        : null;
    macros =
        json['macros'] != null ? new Macros.fromJson(json['macros']) : null;
    steps = json['steps'] != null ? new Steps.fromJson(json['steps']) : null;
   // weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['date'] = this.date;
    if (this.calories != null) {
      data['calories'] = this.calories!.toJson();
    }
    if (this.macros != null) {
      data['macros'] = this.macros!.toJson();
    }
    if (this.steps != null) {
      data['steps'] = this.steps!.toJson();
    }
   
    // data['weight'] = this.weight;
    return data;
  }
}

class Calories {
  int? target;
  int? consumed;
  int? burned;
  int? remaining;

  Calories({this.target, this.consumed, this.burned, this.remaining});

  Calories.fromJson(Map<String, dynamic> json) {
    target = json['target']??0;
    consumed = json['consumed']??0;
    burned = json['burned']??0;
    remaining = json['remaining']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['target'] = this.target;
    data['consumed'] = this.consumed;
    data['burned'] = this.burned;
    data['remaining'] = this.remaining;
    return data;
  }
}

class Macros {
  double? protein;
  double? carbs;
  double? fats;

  Macros({this.protein, this.carbs, this.fats});

  Macros.fromJson(Map<String, dynamic> json) {
    protein = (json['protein'] ?? 0).toDouble();
    carbs = (json['carbs'] ?? 0).toDouble();
    fats = (json['fats'] ?? 0).toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
    };
  }
}

class Steps {
  int? count;
  int? caloriesBurned;

  Steps({this.count, this.caloriesBurned});

  Steps.fromJson(Map<String, dynamic> json) {
    count = json['count']??0;
    caloriesBurned = json['calories_burned']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['calories_burned'] = this.caloriesBurned;
    return data;
  }
} */

class DashboardDataModel {
  bool? status;
  String? date;
  Calories? calories;
  Meals? meals;
  Macros? macros;
  Micronutrients? micronutrients;
  Activities? activities;
  Steps? steps;
  //Water? water;
  //Weight? weight;

  DashboardDataModel(
      {this.status,
      this.date,
      this.calories,
      this.meals,
      this.macros,
      this.micronutrients,
      this.activities,
      this.steps,
    //  this.water,
    //  this.weight
      });

  DashboardDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    date = json['date'];
    calories = json['calories'] != null
        ? new Calories.fromJson(json['calories'])
        : null;
    meals = json['meals'] != null ? new Meals.fromJson(json['meals']) : null;
    macros =
        json['macros'] != null ? new Macros.fromJson(json['macros']) : null;
    micronutrients = json['micronutrients'] != null
        ? new Micronutrients.fromJson(json['micronutrients'])
        : null;
    activities = json['activities'] != null
        ? new Activities.fromJson(json['activities'])
        : null;
    steps = json['steps'] != null ? new Steps.fromJson(json['steps']) : null;
   // water = json['water'] != null ? new Water.fromJson(json['water']) : null;
   // weight =
   //     json['weight'] != null ? new Weight.fromJson(json['weight']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['date'] = this.date;
    if (this.calories != null) {
      data['calories'] = this.calories!.toJson();
    }
    if (this.meals != null) {
      data['meals'] = this.meals!.toJson();
    }
    if (this.macros != null) {
      data['macros'] = this.macros!.toJson();
    }
    if (this.micronutrients != null) {
      data['micronutrients'] = this.micronutrients!.toJson();
    }
    if (this.activities != null) {
      data['activities'] = this.activities!.toJson();
    }
    if (this.steps != null) {
      data['steps'] = this.steps!.toJson();
    }
   /*  if (this.water != null) {
      data['water'] = this.water!.toJson();
    }
    if (this.weight != null) {
      data['weight'] = this.weight!.toJson();
    } */
    return data;
  }
}

class Calories {
  num? target;
  num? consumed;
  num? burned;
  num? remaining;
  num? percentage;

  Calories(
      {this.target,
      this.consumed,
      this.burned,
      this.remaining,
      this.percentage});

  Calories.fromJson(Map<String, dynamic> json) {
    target = json['target']??0.0;
    consumed = json['consumed']??0.0;
    burned = json['burned']??0.0;
    remaining = json['remaining']??0.0;
    percentage = json['percentage']??0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['target'] = this.target;
    data['consumed'] = this.consumed;
    data['burned'] = this.burned;
    data['remaining'] = this.remaining;
    data['percentage'] = this.percentage;
    return data;
  }
}

class Meals {
  Breakfast? breakfast;
  Lunch? lunch;
  Snacks? snacks;
  Dinner? dinner;

  Meals({this.breakfast, this.lunch, this.snacks, this.dinner});

  Meals.fromJson(Map<String, dynamic> json) {
    breakfast = json['breakfast'] != null
        ? new Breakfast.fromJson(json['breakfast'])
        : null;
    lunch = json['lunch'] != null ? new Lunch.fromJson(json['lunch']) : null;
    snacks = json['snacks'] != null ? new Snacks.fromJson(json['snacks']) : null;
    dinner = json['dinner'] != null ? new Dinner.fromJson(json['dinner']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.breakfast != null) {
      data['breakfast'] = this.breakfast!.toJson();
    }
    if (this.lunch != null) {
      data['lunch'] = this.lunch!.toJson();
    }
    if (this.snacks != null) {
      data['snacks'] = this.snacks!.toJson();
    }
    if (this.dinner != null) {
      data['dinner'] = this.dinner!.toJson();
    }
    return data;
  }
}

class Breakfast {
  num? consumed;
  num? required;
  num? percentage;

  Breakfast({this.consumed, this.required, this.percentage});

  Breakfast.fromJson(Map<String, dynamic> json) {
    consumed = json['consumed']??0.0;
    required = json['required']??0.0;
    percentage = json['percentage']??0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['consumed'] = this.consumed;
    data['required'] = this.required;
    data['percentage'] = this.percentage;
    return data;
  }
}

class Lunch {
  num? consumed;
  num? required;
  num? percentage;

  Lunch({this.consumed, this.required,this.percentage});

  Lunch.fromJson(Map<String, dynamic> json) {
     consumed = json['consumed']??0.0;
    required = json['required']??0.0;
    percentage = json['percentage']??0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['consumed'] = this.consumed;
    data['required'] = this.required;
    data['percentage'] = this.percentage;

    return data;
  }
}
class Snacks {
  num? consumed;
  num? required;
  num? percentage;

  Snacks({this.consumed, this.required});

  Snacks.fromJson(Map<String, dynamic> json) {
    consumed = json['consumed']??0.0;
    required = json['required']??0.0;
    percentage = json['percentage']??0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['consumed'] = this.consumed;
    data['required'] = this.required;
        data['percentage'] = this.percentage;

    return data;
  }
}

class Dinner {
  num? consumed;
  num? required;
  num? percentage;

  Dinner({this.consumed, this.required});

  Dinner.fromJson(Map<String, dynamic> json) {
     consumed = json['consumed']??0.0;
    required = json['required']??0.0;
    percentage = json['percentage']??0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['consumed'] = this.consumed;
    data['required'] = this.required;
    data['percentage'] = this.percentage;

    return data;
  }
}


class Macros {
  Protein? protein;
  Protein? carbs;
  Protein? fats;
  Fiber? fiber;

  Macros({this.protein, this.carbs, this.fats, this.fiber});

  Macros.fromJson(Map<String, dynamic> json) {
    protein =
        json['protein'] != null ? new Protein.fromJson(json['protein']) : null;
    carbs = json['carbs'] != null ? new Protein.fromJson(json['carbs']) : null;
    fats = json['fats'] != null ? new Protein.fromJson(json['fats']) : null;
    fiber = json['fiber'] != null ? new Fiber.fromJson(json['fiber']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.protein != null) {
      data['protein'] = this.protein!.toJson();
    }
    if (this.carbs != null) {
      data['carbs'] = this.carbs!.toJson();
    }
    if (this.fats != null) {
      data['fats'] = this.fats!.toJson();
    }
    if (this.fiber != null) {
      data['fiber'] = this.fiber!.toJson();
    }
    return data;
  }
}

class Protein {
  num? consumed;
  num? target;
  num? percentage;

  Protein({this.consumed, this.target, this.percentage});

  Protein.fromJson(Map<String, dynamic> json) {
    consumed = json['consumed']??0.0;
    target = json['target']??0.0;
    percentage = json['percentage']??0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['consumed'] = this.consumed;
    data['target'] = this.target;
    data['percentage'] = this.percentage;
    return data;
  }
}

class Fiber {
  num? consumed;
  num? target;
  num? percentage;

  Fiber({this.consumed, this.target, this.percentage});

  Fiber.fromJson(Map<String, dynamic> json) {
    consumed = json['consumed'];
    target = json['target'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['consumed'] = this.consumed;
    data['target'] = this.target;
    data['percentage'] = this.percentage;
    return data;
  }
}

class Micronutrients {
  num? fiber;
  num? sodium;
  num? potassium;
  num? calcium;
  num? iron;
  num? vitaminA;
  num? vitaminC;

  Micronutrients(
      {this.fiber,
      this.sodium,
      this.potassium,
      this.calcium,
      this.iron,
      this.vitaminA,
      this.vitaminC});

  Micronutrients.fromJson(Map<String, dynamic> json) {
    fiber = json['fiber'];
    sodium = json['sodium'];
    potassium = json['potassium'];
    calcium = json['calcium'];
    iron = json['iron'];
    vitaminA = json['vitamin_a'];
    vitaminC = json['vitamin_c'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fiber'] = this.fiber;
    data['sodium'] = this.sodium;
    data['potassium'] = this.potassium;
    data['calcium'] = this.calcium;
    data['iron'] = this.iron;
    data['vitamin_a'] = this.vitaminA;
    data['vitamin_c'] = this.vitaminC;
    return data;
  }
}

class Activities {
  num? caloriesBurned;

  Activities({this.caloriesBurned});

  Activities.fromJson(Map<String, dynamic> json) {
    caloriesBurned = json['calories_burned'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['calories_burned'] = this.caloriesBurned;
    return data;
  }
}

class Steps {
  int? count;
  num? caloriesBurned;

  Steps({this.count, this.caloriesBurned});

  Steps.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    caloriesBurned = json['calories_burned'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['calories_burned'] = this.caloriesBurned;
    return data;
  }
}
