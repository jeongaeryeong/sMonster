package com.sm.domain;


import lombok.Data;

@Data
public class StockVO {

	private String stock_num;
	private String raw_code;
	private String wh_code;
	private String stock_text;
	private String prod_code;
	private String in_num;
	private int stock_count;
	
	private ProductVO product;
	private RawMaterialVO raw_mat;
	private RequirementsVO requirement;
	private WarehouseVO warehouse;
	private WorkOrderVO workOrder;
	private PerformanceVO performance;
	
	public StockVO() {
		warehouse = new WarehouseVO();
		product = new ProductVO();
		raw_mat = new RawMaterialVO();
	}
	
}
