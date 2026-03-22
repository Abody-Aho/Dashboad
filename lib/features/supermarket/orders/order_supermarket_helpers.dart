import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/app_delete_dialog.dart';
import 'orders_supermarket_controller.dart';

mixin OrderSupermarketHelpers on GetxController{
  OrdersSupermarketController get controller;

  Widget infoRow(String title, String value) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      ),
    );
  }

  String mapStatus(dynamic s) {
    switch (s.toString()) {
      case "0":
        return "pending";

      case "1":
        return "accepted";

      case "2":
        return "ready";

      case "3":
        return "on_delivery";

      case "4":
        return "delivered";

      case "5":
        return "cancelled";

      default:
        return "-";
    }
  }

  String mapPayment(dynamic p) {
    switch (p.toString()) {
      case "0":
        return "cash";
      case "1":
        return "card";
      default:
        return "-";
    }
  }

  DataCell textCell(String? text, double width) {
    return DataCell(
      Tooltip(
        message: text ?? '-',
        child: SizedBox(
          width: width,
          child: Text(text ?? '-', overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }

  DataCell statusCell(String? status) {
    Color color;

    switch (status) {
      case "pending":
        color = Colors.orange;
        break;

      case "accepted":
        color = Colors.blue;
        break;

      case "ready":
        color = Colors.teal;
        break;

      case "on_delivery":
        color = Colors.deepPurple;
        break;

      case "delivered":
        color = Colors.green;
        break;

      case "cancelled":
        color = Colors.red;
        break;

      default:
        color = Colors.grey;
    }

    return DataCell(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          status ?? '',
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  DataCell actionCell(Map<String, dynamic> data) {
    return DataCell(
      SizedBox(
        width: 100,
        child: Row(
          children: [
            Flexible(
              child: IconButton(
                icon: const Icon(Icons.visibility, color: Colors.grey),
                onPressed: () async {
                  var items = await controller.getOrderItems(
                    int.parse(data['id']),
                  );
                  print("items = $items"); // أضف هذا

                  controller.showOrderDetailsDialog(order: data, items: items);
                },
                padding: EdgeInsets.zero,
              ),
            ),
            Flexible(
              child: IconButton(
                icon: const Icon(Icons.delivery_dining),
                onPressed: () {
                  controller.showStatusDialog(
                    int.parse(data['id']),
                    int.parse(data['status_raw'].toString()),
                    controller,
                  );
                },
                padding: EdgeInsets.zero,
              ),
            ),
            Flexible(
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  AppDeleteDialog.show(
                    title: "حذف الطلب",
                    message: "هل أنت متأكد من حذف الطلب رقم",
                    itemName: "#${data['id']}",
                    icon: Icons.delete_outline,
                    color: Colors.red,
                    onConfirm: () {
                      controller.deleteOrder(int.parse(data['id']));
                    },
                  );
                },
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
