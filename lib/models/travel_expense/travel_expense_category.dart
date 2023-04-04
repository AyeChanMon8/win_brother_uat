// @dart=2.9
import 'dart:convert';

class TravelExpenseCategory {
  int id;
  String display_name;
  bool out_of_pocket_expense;
  bool travel_expense;
  bool trip_expense;
  bool is_vehicle_selected;
  TravelExpenseCategory({
    this.id,
    this.display_name,
    this.out_of_pocket_expense,
    this.travel_expense,
    this.trip_expense,
    this.is_vehicle_selected
  });

  TravelExpenseCategory copyWith({
    int id,
    String display_name,
    bool out_of_pocket_expense,
    bool travel_expense,
    bool trip_expense,
  }) {
    return TravelExpenseCategory(
      id: id ?? this.id,
      display_name: display_name ?? this.display_name,
      out_of_pocket_expense:
          out_of_pocket_expense ?? this.out_of_pocket_expense,
      travel_expense: travel_expense ?? this.travel_expense,
      trip_expense: trip_expense ?? this.trip_expense,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'display_name': display_name,
      'out_of_pocket_expense': out_of_pocket_expense,
      'travel_expense': travel_expense,
      'trip_expense': trip_expense,
    };
  }

  factory TravelExpenseCategory.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TravelExpenseCategory(
      id: map['id'],
      display_name: map['display_name'],
      out_of_pocket_expense: map['out_of_pocket_expense'],
      travel_expense: map['travel_expense'],
      trip_expense: map['trip_expense'],
      is_vehicle_selected: map['is_vehicle_selected'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TravelExpenseCategory.fromJson(String source) =>
      TravelExpenseCategory.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TravelExpenseCategory(id: $id, display_name: $display_name, out_of_pocket_expense: $out_of_pocket_expense, travel_expense: $travel_expense, trip_expense: $trip_expense)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TravelExpenseCategory &&
        o.id == id &&
        o.display_name == display_name &&
        o.out_of_pocket_expense == out_of_pocket_expense &&
        o.travel_expense == travel_expense &&
        o.trip_expense == trip_expense;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        display_name.hashCode ^
        out_of_pocket_expense.hashCode ^
        travel_expense.hashCode ^
        trip_expense.hashCode;
  }
}
