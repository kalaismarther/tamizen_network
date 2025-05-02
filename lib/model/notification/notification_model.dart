class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String date;

  NotificationModel(
      {required this.id,
      required this.title,
      required this.message,
      required this.date});

  factory NotificationModel.fromJson(Map<dynamic, dynamic> json) =>
      NotificationModel(
        id: json['id']?.toString() ?? '',
        title: json['notification_subject']?.toString() ?? '',
        message: json['notification_content']?.toString() ?? '',
        date: json['is_date']?.toString() ?? '',
      );
}
