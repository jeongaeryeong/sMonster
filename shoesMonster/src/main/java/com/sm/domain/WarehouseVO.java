package com.sm.domain;

import lombok.Data;

@Data
public class WarehouseVO {
	private String wh_code;
	private String wh_name;
	private String wh_dv;
	private int wh_use;
	private String wh_addr;
	private String wh_tel;
	private String wh_note;
	private String prod_code;
	private String raw_code;
	private String emp_id;
	
	private ProductVO product;
	private RawMaterialVO raw_mat;
	private StockVO stock;
	
	public WarehouseVO() {
		product = new ProductVO();
		raw_mat = new RawMaterialVO();
	}
	
} //Warehouse
