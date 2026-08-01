class SlotModel {
  final String id;
  final String slotLabel;
  final bool isFilled;
  final String? medicineName;

  SlotModel({
    required this.id,
    required this.slotLabel,
    required this.isFilled,
    this.medicineName,
  });

  int get slotNumber => slotLabel.codeUnitAt(0) - 64;

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      id: json['id'] as String,
      slotLabel: json['slot_label'] as String,
      isFilled: json['is_filled'] as bool,
      medicineName: json['medicine_name'] as String?,
    );
  }
}
