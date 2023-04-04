// @dart=2.9

import 'dart:convert';

class WarningAttachModel {
  int id;
  String attached_filename;
  String attachment;
  WarningAttachModel({
    this.id,
    this.attached_filename,
    this.attachment,
  });

  WarningAttachModel copyWith({
    int id,
    String attached_filename,
    String attachment,
  }) {
    return WarningAttachModel(
      id: id ?? this.id,
      attached_filename: attached_filename ?? this.attached_filename,
      attachment: attachment ?? this.attachment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'attached_filename': attached_filename,
      'attachment': attachment,
    };
  }

  factory WarningAttachModel.fromMap(Map<String, dynamic> map) {
    return WarningAttachModel(
      id: map['id']?.toInt() ?? 0,
      attached_filename: map['attached_filename'] ?? '',
      attachment: map['attachment'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WarningAttachModel.fromJson(String source) =>
      WarningAttachModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'WarningAttachModel(id: $id, attached_filename: $attached_filename, attachment: $attachment)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WarningAttachModel &&
        other.id == id &&
        other.attached_filename == attached_filename &&
        other.attachment == attachment;
  }

  @override
  int get hashCode =>
      id.hashCode ^ attached_filename.hashCode ^ attachment.hashCode;
}
