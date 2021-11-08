class MaterialInventory {
  int? id;
  String? materialCode;
  String? productDesc;
  String? supplierName;
  dynamic category;
  String? partNumber;
  String? variant;
  String? brand;
  dynamic location;
  String? uom;
  dynamic restockQty;
  dynamic stockQty;
  String? photo;

  MaterialInventory(
      {this.id,
      this.materialCode,
      this.productDesc,
      this.supplierName,
      this.category,
      this.partNumber,
      this.variant,
      this.brand,
      this.location,
      this.uom,
      this.restockQty,
      this.stockQty,
      this.photo});

  MaterialInventory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    materialCode = json['material_code'];
    productDesc = json['product_desc'];
    supplierName = json['supplier_name'];
    category = json['category'];
    partNumber = json['part_number'];
    variant = json['variant'];
    brand = json['brand'];
    location = json['location'];
    uom = json['uom'];
    restockQty = json['restock_qty'];
    stockQty = json['stock_qty'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['material_code'] = this.materialCode;
    data['product_desc'] = this.productDesc;
    data['supplier_name'] = this.supplierName;
    data['category'] = this.category;
    data['part_number'] = this.partNumber;
    data['variant'] = this.variant;
    data['brand'] = this.brand;
    data['location'] = this.location;
    data['uom'] = this.uom;
    data['restock_qty'] = this.restockQty;
    data['stock_qty'] = this.stockQty;
    data['photo'] = this.photo;
    return data;
  }
}
