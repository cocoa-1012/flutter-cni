class AssetInventory {
  int? id;
  String? assetCode;
  String? supplierName;
  String? assetDesc;
  dynamic category;
  String? partNumber;
  String? variant;
  String? brand;
  dynamic status;
  String? uom;
  dynamic restockQty;
  dynamic stockQty;
  String? photo;

  AssetInventory(
      {this.id,
      this.assetCode,
      this.supplierName,
      this.assetDesc,
      this.category,
      this.partNumber,
      this.variant,
      this.brand,
      this.status,
      this.uom,
      this.restockQty,
      this.stockQty,
      this.photo});

  AssetInventory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    assetCode = json['asset_code'];
    supplierName = json['supplier_name'];
    assetDesc = json['asset_desc'];
    category = json['category'];
    partNumber = json['part_number'];
    variant = json['variant'];
    brand = json['brand'];
    status = json['status'];
    uom = json['uom'];
    restockQty = json['restock_qty'];
    stockQty = json['stock_qty'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['asset_code'] = this.assetCode;
    data['supplier_name'] = this.supplierName;
    data['asset_desc'] = this.assetDesc;
    data['category'] = this.category;
    data['part_number'] = this.partNumber;
    data['variant'] = this.variant;
    data['brand'] = this.brand;
    data['status'] = this.status;
    data['uom'] = this.uom;
    data['restock_qty'] = this.restockQty;
    data['stock_qty'] = this.stockQty;
    data['photo'] = this.photo;
    return data;
  }
}
