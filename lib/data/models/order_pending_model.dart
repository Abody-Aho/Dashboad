class OrderPendingModel {
  int? ordersId;
  int? ordersUserid;
  int? ordersAddress;
  int? ordersType;
  int? ordersPriceDelivery;
  int? ordersPrice;
  int? ordersTotalPrice;
  int? ordersCoupon;
  String? ordersDatetime;
  int? ordersPaymentMethod;
  int? ordersStatus;

  OrderPendingModel(
      {this.ordersId,
        this.ordersUserid,
        this.ordersAddress,
        this.ordersType,
        this.ordersPriceDelivery,
        this.ordersPrice,
        this.ordersTotalPrice,
        this.ordersCoupon,
        this.ordersDatetime,
        this.ordersPaymentMethod,
        this.ordersStatus});

  OrderPendingModel.fromJson(Map<String, dynamic> json) {
    ordersId = json['orders_id'];
    ordersUserid = json['orders_usersid'];
    ordersAddress = json['orders_address'];
    ordersType = json['orders_type'];
    ordersPriceDelivery = json['orders_pricedelivery'];
    ordersPrice = json['orders_price'];
    ordersTotalPrice = json['orders_totalprice'];
    ordersCoupon = json['orders_coupon'];
    ordersDatetime = json['orders_datetime'];
    ordersPaymentMethod = json['orders_paymentmethod'];
    ordersStatus = json['orders_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orders_id'] = this.ordersId;
    data['orders_usersid'] = this.ordersUserid;
    data['orders_address'] = this.ordersAddress;
    data['orders_type'] = this.ordersType;
    data['orders_pricedelivery'] = this.ordersPriceDelivery;
    data['orders_price'] = this.ordersPrice;
    data['orders_totalprice'] = this.ordersTotalPrice;
    data['orders_coupon'] = this.ordersCoupon;
    data['orders_datetime'] = this.ordersDatetime;
    data['orders_paymentmethod'] = this.ordersPaymentMethod;
    data['orders_status'] = this.ordersStatus;
    return data;
  }
}
