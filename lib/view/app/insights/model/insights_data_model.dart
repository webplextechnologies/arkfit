class InsightsDataModel {
  bool? status;
  String? type;
  List<InsightsData>? data;
  BmiGauge? bmiGauge;

  InsightsDataModel({this.status, this.type, this.data, this.bmiGauge});

  InsightsDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    type = json['type'];
    if (json['data'] != null) {
      data = <InsightsData>[];
      json['data'].forEach((v) {
        data!.add(new InsightsData.fromJson(v));
      });
    }
    bmiGauge = json['bmi_gauge'] != null
        ? new BmiGauge.fromJson(json['bmi_gauge'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['type'] = this.type;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.bmiGauge != null) {
      data['bmi_gauge'] = this.bmiGauge!.toJson();
    }
    return data;
  }
}

class InsightsData {
  String? date;
  Calories? calories;
  int? burned;
  Steps? steps;
  Water? water;
  Weight? weight;
  Nutrition? nutrition;
 

  InsightsData(
      {this.date,
      this.calories,
      this.burned,
      this.steps,
      this.water,
      this.weight,
      this.nutrition
      });

  InsightsData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    calories = json['calories'] != null
        ? new Calories.fromJson(json['calories'])
        : null;
    burned = json['burned'];
    steps = json['steps'] != null ? new Steps.fromJson(json['steps']) : null;
    water = json['water'] != null ? new Water.fromJson(json['water']) : null;
    weight =
        json['weight'] != null ? new Weight.fromJson(json['weight']) : null;
    nutrition = json['nutrition'] != null
        ? new Nutrition.fromJson(json['nutrition'])
        : null;
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.calories != null) {
      data['calories'] = this.calories!.toJson();
    }
    data['burned'] = this.burned;
    if (this.steps != null) {
      data['steps'] = this.steps!.toJson();
    }
    if (this.water != null) {
      data['water'] = this.water!.toJson();
    }
    if (this.weight != null) {
      data['weight'] = this.weight!.toJson();
    }

     if (this.nutrition != null) {
      data['nutrition'] = this.nutrition!.toJson();
    }
   
    return data;
  }
}

class Nutrition {
  Protein? protein;
  Carbs? carbs;
  Fat? fat;
  Fiber? fiber;

  Nutrition({this.protein, this.carbs, this.fat, this.fiber});

  Nutrition.fromJson(Map<String, dynamic> json) {
    protein =
        json['protein'] != null ? new Protein.fromJson(json['protein']) : null;
    carbs = json['carbs'] != null ? new Carbs.fromJson(json['carbs']) : null;
    fat = json['fat'] != null ? new Fat.fromJson(json['fat']) : null;
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
    if (this.fat != null) {
      data['fat'] = this.fat!.toJson();
    }
    if (this.fiber != null) {
      data['fiber'] = this.fiber!.toJson();
    }
   
    return data;
  }
}

class Protein {
  num? takenG;
  num? goalG;

  Protein({this.takenG, this.goalG});

  Protein.fromJson(Map<String, dynamic> json) {
    takenG = json['taken_g']??0;
    goalG = json['goal_g']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taken_g'] = this.takenG;
    data['goal_g'] = this.goalG;
    return data;
  }
}

class Carbs {
  num? takenG;
  num? goalG;

  Carbs({this.takenG, this.goalG});

  Carbs.fromJson(Map<String, dynamic> json) {
    takenG = json['taken_g']??0;
    goalG = json['goal_g']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taken_g'] = this.takenG;
    data['goal_g'] = this.goalG;
    return data;
  }
}
class Fat {
  num? takenG;
  num? goalG;

  Fat({this.takenG, this.goalG});

  Fat.fromJson(Map<String, dynamic> json) {
    takenG = json['taken_g']??0;
    goalG = json['goal_g']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taken_g'] = this.takenG;
    data['goal_g'] = this.goalG;
    return data;
  }
}

class Fiber {
  num? takenG;
  num? goalG;

  Fiber({this.takenG, this.goalG});

  Fiber.fromJson(Map<String, dynamic> json) {
    takenG = json['taken_g'];
    goalG = json['goal_g'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taken_g'] = this.takenG;
    data['goal_g'] = this.goalG;
    return data;
  }
}


class Calories {
  int? taken;
  int? goal;

  Calories({this.taken, this.goal});

  Calories.fromJson(Map<String, dynamic> json) {
    taken = int.tryParse(json['taken'].toString()) ?? 0;
    goal = int.tryParse(json['goal'].toString()) ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'taken': taken,
      'goal': goal,
    };
  }
}

class Steps {
  int? count;
  int? goal;

  Steps({this.count, this.goal});

  Steps.fromJson(Map<String, dynamic> json) {
    count = json['count']??0;
    goal = json['goal']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['goal'] = this.goal;
    return data;
  }
}

class Water {
  int? takenMl;
  int? goalMl;

  Water({this.takenMl, this.goalMl});

  Water.fromJson(Map<String, dynamic> json) {
    takenMl = int.tryParse(json['taken_ml'].toString()) ?? 0;
    goalMl = int.tryParse(json['goal_ml'].toString()) ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'taken_ml': takenMl,
      'goal_ml': goalMl,
    };
  }
}

class Weight {
  double? value;
  double? goal;

  Weight({this.value, this.goal});

  Weight.fromJson(Map<String, dynamic> json) {
    value = double.tryParse(json['value']?.toString() ?? "0");
    goal = double.tryParse(json['goal']?.toString() ?? "0");
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'goal': goal,
    };
  }
}

class BmiGauge {
  num? value;
  String? category;

  BmiGauge({this.value, this.category});

  BmiGauge.fromJson(Map<String, dynamic> json) {
    value = json['value']??0.0;
    category = json['category']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['category'] = this.category;
    return data;
  }
}
