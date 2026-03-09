class NotificationModel {
  final int notificationId;
  final String notificationTitle;
  final String notificationBody;
  final String? notificationType;
  final String? notificationReceivers;
  final int notificationSentCount;
  final int notificationReadCount;
  final double readRate;
  final String notificationStatus;
  final String notificationDatetime;

  NotificationModel({
    required this.notificationId,
    required this.notificationTitle,
    required this.notificationBody,
    this.notificationType,
    this.notificationReceivers,
    required this.notificationSentCount,
    required this.notificationReadCount,
    required this.readRate,
    required this.notificationStatus,
    required this.notificationDatetime,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: int.parse(json['notification_id'].toString()),
      notificationTitle: json['notification_title'] ?? "",
      notificationBody: json['notification_body'] ?? "",
      notificationType: json['notification_type'],
      notificationReceivers: json['notification_receivers'],
      notificationSentCount:
      int.parse(json['notification_sent_count'].toString()),
      notificationReadCount:
      int.parse(json['notification_read_count'].toString()),
      readRate: double.parse(json['read_rate'].toString()),
      notificationStatus: json['notification_status'] ?? "",
      notificationDatetime: json['notification_datetime'] ?? "",
    );
  }
}