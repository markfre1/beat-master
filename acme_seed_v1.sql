
-- ══════════════════════════════════════════════════════════════
-- ACME HVAC COMPANY — Complete Sample Data v1
-- Tenant: 6bcf6d95-458f-4c04-9f43-2c379e146f2e
-- Different customer profile: Residential & Light Commercial
-- ══════════════════════════════════════════════════════════════

DO $$
DECLARE
  v_tid        uuid := '6bcf6d95-458f-4c04-9f43-2c379e146f2e';
  v_terms_net30 uuid; v_terms_net15 uuid; v_terms_cod uuid;
  v_tax_fl uuid; v_tax_exempt uuid;
  v_pm_check uuid; v_pm_cc uuid; v_pm_ach uuid;
  v_st_maint uuid; v_st_repair uuid; v_st_install uuid; v_st_emerg uuid; v_st_inspect uuid;
  v_et_ac uuid; v_et_hp uuid; v_et_furnace uuid; v_et_mini uuid;
  v_c1 uuid; v_c2 uuid; v_c3 uuid; v_c4 uuid; v_c5 uuid;
  v_l1 uuid; v_l2 uuid; v_l3 uuid; v_l4 uuid; v_l5 uuid;
  v_e1 uuid; v_e2 uuid; v_e3 uuid; v_e4 uuid; v_e5 uuid;
  v_i1 uuid; v_i2 uuid; v_i3 uuid; v_i4 uuid;
  v_wo1 uuid; v_wo2 uuid; v_wo3 uuid; v_wo4 uuid; v_wo5 uuid; v_wo6 uuid;
  v_p_cap uuid; v_p_cont uuid; v_p_filter uuid; v_p_ref uuid; v_p_belt uuid;
  v_p_labor_std uuid; v_p_labor_emerg uuid; v_p_travel uuid;
  v_p_diag uuid; v_p_pm uuid; v_p_inspect uuid;
  v_p_ac3ton uuid; v_p_hp3ton uuid;
  v_gl_cash uuid; v_gl_ar uuid; v_gl_ap uuid;
  v_gl_rev uuid; v_gl_parts_rev uuid; v_gl_labor uuid; v_gl_parts_cost uuid;
  v_ba1 uuid;
  v_je1 uuid;
  v_vend1 uuid; v_vend2 uuid; v_vend3 uuid;

BEGIN

-- ── Clean existing data ───────────────────────────────────
DELETE FROM public.bank_transactions    WHERE tenant_id = v_tid;
DELETE FROM public.journal_lines        WHERE tenant_id = v_tid;
DELETE FROM public.journal_entries      WHERE tenant_id = v_tid;
DELETE FROM public.bank_accounts        WHERE tenant_id = v_tid;
DELETE FROM public.work_order_lines     WHERE tenant_id = v_tid;
DELETE FROM public.work_order_notes     WHERE tenant_id = v_tid;
DELETE FROM public.work_order_photos    WHERE tenant_id = v_tid;
DELETE FROM public.work_order_signatures WHERE tenant_id = v_tid;
DELETE FROM public.work_orders          WHERE tenant_id = v_tid;
DELETE FROM public.invoice_lines        WHERE tenant_id = v_tid;
DELETE FROM public.payments             WHERE tenant_id = v_tid;
DELETE FROM public.invoices             WHERE tenant_id = v_tid;
DELETE FROM public.vendor_bills         WHERE tenant_id = v_tid;
DELETE FROM public.vendors              WHERE tenant_id = v_tid;
DELETE FROM public.equipment            WHERE tenant_id = v_tid;
DELETE FROM public.service_locations    WHERE tenant_id = v_tid;
DELETE FROM public.customers            WHERE tenant_id = v_tid;
DELETE FROM public.inventory_stock      WHERE tenant_id = v_tid;
DELETE FROM public.products             WHERE tenant_id = v_tid;
DELETE FROM public.gl_accounts          WHERE tenant_id = v_tid;
DELETE FROM public.equipment_types      WHERE tenant_id = v_tid;
DELETE FROM public.service_types        WHERE tenant_id = v_tid;
DELETE FROM public.payment_methods      WHERE tenant_id = v_tid;
DELETE FROM public.tax_rates            WHERE tenant_id = v_tid;
DELETE FROM public.terms                WHERE tenant_id = v_tid;
DELETE FROM public.tenant_settings      WHERE tenant_id = v_tid;

-- ── Tenant Settings ───────────────────────────────────────
INSERT INTO public.tenant_settings (tenant_id, setting_key, setting_value) VALUES
  (v_tid, 'invoice_prefix',            'ACM'),
  (v_tid, 'labor_rate_default',         '89.00'),
  (v_tid, 'auto_invoice_on_sign',       'false'),
  (v_tid, 'invoice_email_on_complete',  'false'),
  (v_tid, 'company_name',              'Acme HVAC Company'),
  (v_tid, 'company_phone',             '561-555-2000'),
  (v_tid, 'company_email',             'service@acmehvac.com'),
  (v_tid, 'company_website',           'www.acmehvac.com'),
  (v_tid, 'company_address1',          '1200 Boca Industrial Pkwy'),
  (v_tid, 'company_city',              'Boca Raton'),
  (v_tid, 'company_state',             'FL'),
  (v_tid, 'company_zip',               '33487'),
  (v_tid, 'company_fax',               '561-555-2001'),
  (v_tid, 'company_ein',               '65-9876543'),
  (v_tid, 'license_number',            'CAC1818181'),
  (v_tid, 'invoice_footer',            'Thank you for choosing Acme HVAC! Net 30 unless otherwise stated.'),
  (v_tid, 'module_field_service',      'true'),
  (v_tid, 'module_invoicing',          'true'),
  (v_tid, 'module_full_accounting',    'true'),
  (v_tid, 'module_field_app',          'true'),
  (v_tid, 'module_reports',            'true');

-- ── Payment Terms ─────────────────────────────────────────
INSERT INTO public.terms (tenant_id,code,description,days_due,discount_pct,discount_days,is_active)
VALUES (v_tid,'NET30','Net 30 Days',30,0,0,true) RETURNING id INTO v_terms_net30;
INSERT INTO public.terms (tenant_id,code,description,days_due,discount_pct,discount_days,is_active)
VALUES (v_tid,'NET15','Net 15 Days',15,0,0,true) RETURNING id INTO v_terms_net15;
INSERT INTO public.terms (tenant_id,code,description,days_due,discount_pct,discount_days,is_active)
VALUES (v_tid,'COD','Cash on Delivery',0,0,0,true) RETURNING id INTO v_terms_cod;

-- ── Tax Rates ─────────────────────────────────────────────
INSERT INTO public.tax_rates (tenant_id,code,description,rate,is_default,applies_to,is_active)
VALUES (v_tid,'FL_TAX','Florida Sales Tax',7.0,true,'all',true) RETURNING id INTO v_tax_fl;
INSERT INTO public.tax_rates (tenant_id,code,description,rate,is_default,applies_to,is_active)
VALUES (v_tid,'EXEMPT','Tax Exempt',0,false,'all',true) RETURNING id INTO v_tax_exempt;

-- ── Payment Methods ───────────────────────────────────────
INSERT INTO public.payment_methods (tenant_id,code,description,requires_ref,is_active)
VALUES (v_tid,'CHECK','Check',true,true) RETURNING id INTO v_pm_check;
INSERT INTO public.payment_methods (tenant_id,code,description,requires_ref,is_active)
VALUES (v_tid,'CC','Credit Card',true,true) RETURNING id INTO v_pm_cc;
INSERT INTO public.payment_methods (tenant_id,code,description,requires_ref,is_active)
VALUES (v_tid,'ACH','ACH Transfer',true,true) RETURNING id INTO v_pm_ach;

-- ── Service Types ─────────────────────────────────────────
INSERT INTO public.service_types (tenant_id,code,description,industry_type,estimated_hours,is_active)
VALUES (v_tid,'MAINT','Preventive Maintenance','hvac',2,true) RETURNING id INTO v_st_maint;
INSERT INTO public.service_types (tenant_id,code,description,industry_type,estimated_hours,is_active)
VALUES (v_tid,'REPAIR','Repair Service','hvac',3,true) RETURNING id INTO v_st_repair;
INSERT INTO public.service_types (tenant_id,code,description,industry_type,estimated_hours,is_active)
VALUES (v_tid,'INSTALL','New Installation','hvac',8,true) RETURNING id INTO v_st_install;
INSERT INTO public.service_types (tenant_id,code,description,industry_type,estimated_hours,is_active)
VALUES (v_tid,'EMERGENCY','Emergency Service','hvac',2,true) RETURNING id INTO v_st_emerg;
INSERT INTO public.service_types (tenant_id,code,description,industry_type,estimated_hours,is_active)
VALUES (v_tid,'INSPECT','Home Inspection','hvac',1,true) RETURNING id INTO v_st_inspect;

-- ── Equipment Types ───────────────────────────────────────
INSERT INTO public.equipment_types (tenant_id,code,description,industry_type,is_active)
VALUES (v_tid,'AC_UNIT','Split System AC','hvac',true) RETURNING id INTO v_et_ac;
INSERT INTO public.equipment_types (tenant_id,code,description,industry_type,is_active)
VALUES (v_tid,'HEAT_PUMP','Heat Pump','hvac',true) RETURNING id INTO v_et_hp;
INSERT INTO public.equipment_types (tenant_id,code,description,industry_type,is_active)
VALUES (v_tid,'FURNACE','Gas Furnace','hvac',true) RETURNING id INTO v_et_furnace;
INSERT INTO public.equipment_types (tenant_id,code,description,industry_type,is_active)
VALUES (v_tid,'MINI_SPLIT','Mini Split','hvac',true) RETURNING id INTO v_et_mini;

-- ── GL Accounts ───────────────────────────────────────────
INSERT INTO public.gl_accounts (tenant_id,account_number,account_name,account_type,is_active)
VALUES (v_tid,'1000','Cash - Operating','ASSET',true) RETURNING id INTO v_gl_cash;
INSERT INTO public.gl_accounts (tenant_id,account_number,account_name,account_type,is_active)
VALUES (v_tid,'1200','Accounts Receivable','ASSET',true) RETURNING id INTO v_gl_ar;
INSERT INTO public.gl_accounts (tenant_id,account_number,account_name,account_type,is_active)
VALUES (v_tid,'2000','Accounts Payable','LIABILITY',true) RETURNING id INTO v_gl_ap;
INSERT INTO public.gl_accounts (tenant_id,account_number,account_name,account_type,is_active)
VALUES (v_tid,'4000','Service Revenue','REVENUE',true) RETURNING id INTO v_gl_rev;
INSERT INTO public.gl_accounts (tenant_id,account_number,account_name,account_type,is_active)
VALUES (v_tid,'4100','Parts & Materials Revenue','REVENUE',true) RETURNING id INTO v_gl_parts_rev;
INSERT INTO public.gl_accounts (tenant_id,account_number,account_name,account_type,is_active)
VALUES (v_tid,'5000','Cost of Labor','COGS',true) RETURNING id INTO v_gl_labor;
INSERT INTO public.gl_accounts (tenant_id,account_number,account_name,account_type,is_active)
VALUES (v_tid,'5100','Cost of Parts','COGS',true) RETURNING id INTO v_gl_parts_cost;

-- ── Products / Catalog ────────────────────────────────────
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'CAP-40-5','Capacitor 40/5 MFD','parts','each',16,135,false,true,true) RETURNING id INTO v_p_cap;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'CONT-30A','Contactor 30A','parts','each',12,110,false,true,true) RETURNING id INTO v_p_cont;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'FILTER-20x25','Air Filter 20x25x1','parts','each',9,32,false,true,true) RETURNING id INTO v_p_filter;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'REF-R410A','Refrigerant R-410A','parts','lb',25,85,false,true,true) RETURNING id INTO v_p_ref;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'BELT-AHU','AHU Drive Belt','parts','each',18,65,false,true,true) RETURNING id INTO v_p_belt;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'LABOR-STD','Standard Labor','labor','hr',42,89,true,false,true) RETURNING id INTO v_p_labor_std;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'LABOR-EMERG','Emergency Labor','labor','hr',60,145,true,false,true) RETURNING id INTO v_p_labor_emerg;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'TRAVEL','Travel & Trip Charge','labor','each',0,59,true,false,true) RETURNING id INTO v_p_travel;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'DIAG-FEE','Diagnostic Fee','service','each',0,89,true,false,true) RETURNING id INTO v_p_diag;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'PM-RESI','Residential PM Service','service','each',30,129,true,false,true) RETURNING id INTO v_p_pm;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'INSPECT-HVAC','HVAC Inspection','service','each',0,149,true,false,true) RETURNING id INTO v_p_inspect;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'AC-3TON-TRANE','Trane 3-Ton AC System','equipment','each',1450,3200,false,false,true) RETURNING id INTO v_p_ac3ton;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'HP-3TON-CARRIER','Carrier 3-Ton Heat Pump','equipment','each',1600,3500,false,false,true) RETURNING id INTO v_p_hp3ton;

-- ── Inventory Stock ───────────────────────────────────────
INSERT INTO public.inventory_stock (tenant_id,product_id,quantity_on_hand,quantity_reserved,reorder_point)
VALUES (v_tid,v_p_cap,20,3,6);
INSERT INTO public.inventory_stock (tenant_id,product_id,quantity_on_hand,quantity_reserved,reorder_point)
VALUES (v_tid,v_p_cont,18,2,5);
INSERT INTO public.inventory_stock (tenant_id,product_id,quantity_on_hand,quantity_reserved,reorder_point)
VALUES (v_tid,v_p_filter,60,8,25);
INSERT INTO public.inventory_stock (tenant_id,product_id,quantity_on_hand,quantity_reserved,reorder_point)
VALUES (v_tid,v_p_ref,25,3,10);
INSERT INTO public.inventory_stock (tenant_id,product_id,quantity_on_hand,quantity_reserved,reorder_point)
VALUES (v_tid,v_p_belt,8,1,4);

-- ── Customers ─────────────────────────────────────────────
INSERT INTO public.customers (tenant_id,terms_id,tax_rate_id,customer_code,company_name,customer_type,contact_name,email,phone,address_line1,city,state,zip,country,credit_limit,is_taxable,is_active)
VALUES (v_tid,v_terms_net30,v_tax_fl,'CUST-0001','Boca Raton Office Park','commercial','Steve Allen','sallen@bocaratonop.com','561-555-3001','500 Glades Rd','Boca Raton','FL','33431','US',15000,true,true) RETURNING id INTO v_c1;
INSERT INTO public.customers (tenant_id,terms_id,tax_rate_id,customer_code,company_name,customer_type,contact_name,email,phone,address_line1,city,state,zip,country,credit_limit,is_taxable,is_active)
VALUES (v_tid,v_terms_net15,v_tax_fl,'CUST-0002','Delray Beach Hotel & Spa','commercial','Angela Cruz','acruz@delrayhotel.com','561-555-3002','750 Atlantic Ave','Delray Beach','FL','33483','US',30000,true,true) RETURNING id INTO v_c2;
INSERT INTO public.customers (tenant_id,terms_id,tax_rate_id,customer_code,company_name,customer_type,contact_name,email,phone,address_line1,city,state,zip,country,credit_limit,is_taxable,is_active)
VALUES (v_tid,v_terms_cod,v_tax_fl,'CUST-0003','Rodriguez Residence','residential','Carlos Rodriguez','crodriguez@gmail.com','561-555-3003','1122 Palm Beach Lakes Blvd','West Palm Beach','FL','33401','US',3000,true,true) RETURNING id INTO v_c3;
INSERT INTO public.customers (tenant_id,terms_id,tax_rate_id,customer_code,company_name,customer_type,contact_name,email,phone,address_line1,city,state,zip,country,credit_limit,is_taxable,is_active)
VALUES (v_tid,v_terms_net30,v_tax_fl,'CUST-0004','Wellington Commons HOA','commercial','Patricia Nguyen','pnguyen@wellingtonhoa.com','561-555-3004','2200 Wellington Trace','Wellington','FL','33414','US',20000,true,true) RETURNING id INTO v_c4;
INSERT INTO public.customers (tenant_id,terms_id,tax_rate_id,customer_code,company_name,customer_type,contact_name,email,phone,address_line1,city,state,zip,country,credit_limit,is_taxable,is_active)
VALUES (v_tid,v_terms_cod,v_tax_fl,'CUST-0005','Smith Residence','residential','John Smith','jsmith@gmail.com','561-555-3005','45 Ocean Blvd','Palm Beach','FL','33480','US',2500,true,true) RETURNING id INTO v_c5;

-- ── Service Locations ─────────────────────────────────────
INSERT INTO public.service_locations (tenant_id,customer_id,location_name,address_line1,city,state,zip,contact_name,contact_phone,access_notes,is_active)
VALUES (v_tid,v_c1,'Building A','500 Glades Rd','Boca Raton','FL','33431','Steve Allen','561-555-3001','Mechanical room on roof level 3.',true) RETURNING id INTO v_l1;
INSERT INTO public.service_locations (tenant_id,customer_id,location_name,address_line1,city,state,zip,contact_name,contact_phone,access_notes,is_active)
VALUES (v_tid,v_c2,'Main Building','750 Atlantic Ave','Delray Beach','FL','33483','Maintenance Dept','561-555-3002','Check in with front desk. Badge required after 5pm.',true) RETURNING id INTO v_l2;
INSERT INTO public.service_locations (tenant_id,customer_id,location_name,address_line1,city,state,zip,contact_name,contact_phone,access_notes,is_active)
VALUES (v_tid,v_c3,'Residence','1122 Palm Beach Lakes Blvd','West Palm Beach','FL','33401','Carlos Rodriguez','561-555-3003','Dog in backyard. Call 30 min ahead.',true) RETURNING id INTO v_l3;
INSERT INTO public.service_locations (tenant_id,customer_id,location_name,address_line1,city,state,zip,contact_name,contact_phone,access_notes,is_active)
VALUES (v_tid,v_c4,'Clubhouse','2200 Wellington Trace','Wellington','FL','33414','Patricia Nguyen','561-555-3004','Key in lockbox, code 7788.',true) RETURNING id INTO v_l4;
INSERT INTO public.service_locations (tenant_id,customer_id,location_name,address_line1,city,state,zip,contact_name,contact_phone,access_notes,is_active)
VALUES (v_tid,v_c5,'Residence','45 Ocean Blvd','Palm Beach','FL','33480','John Smith','561-555-3005','Gate code #4433.',true) RETURNING id INTO v_l5;

-- ── Equipment ─────────────────────────────────────────────
INSERT INTO public.equipment (tenant_id,customer_id,location_id,equipment_name,equipment_type,brand,model_number,serial_number,install_date,warranty_expiry,tonnage,seer_rating,refrigerant_type,next_service_date,is_active)
VALUES (v_tid,v_c1,v_l1,'AHU-1 Rooftop','AC_UNIT','Trane','XR15-036','SN-ACM-001','2020-05-10','2023-05-10',3,15,'R-410A','2026-11-10',true) RETURNING id INTO v_e1;
INSERT INTO public.equipment (tenant_id,customer_id,location_id,equipment_name,equipment_type,brand,model_number,serial_number,install_date,warranty_expiry,tonnage,seer_rating,refrigerant_type,next_service_date,is_active)
VALUES (v_tid,v_c2,v_l2,'Pool Area HP','HEAT_PUMP','Carrier','25HBC636A','SN-ACM-002','2021-09-15','2024-09-15',3,16,'R-410A','2026-09-15',true) RETURNING id INTO v_e2;
INSERT INTO public.equipment (tenant_id,customer_id,location_id,equipment_name,equipment_type,brand,model_number,serial_number,install_date,warranty_expiry,tonnage,seer_rating,refrigerant_type,next_service_date,is_active)
VALUES (v_tid,v_c3,v_l3,'Home AC System','AC_UNIT','Lennox','XC21-036','SN-ACM-003','2018-07-20','2021-07-20',3,21,'R-410A','2026-07-20',true) RETURNING id INTO v_e3;
INSERT INTO public.equipment (tenant_id,customer_id,location_id,equipment_name,equipment_type,brand,model_number,serial_number,install_date,warranty_expiry,tonnage,seer_rating,refrigerant_type,next_service_date,is_active)
VALUES (v_tid,v_c4,v_l4,'Clubhouse RTU','AC_UNIT','Rheem','RLNL-B060','SN-ACM-004','2022-03-01','2025-03-01',5,16,'R-410A','2026-09-01',true) RETURNING id INTO v_e4;
INSERT INTO public.equipment (tenant_id,customer_id,location_id,equipment_name,equipment_type,brand,model_number,serial_number,install_date,warranty_expiry,tonnage,seer_rating,refrigerant_type,next_service_date,is_active)
VALUES (v_tid,v_c5,v_l5,'Home Heat Pump','HEAT_PUMP','Trane','XP21-036','SN-ACM-005','2019-11-05','2022-11-05',3,21,'R-410A','2026-11-05',true) RETURNING id INTO v_e5;

-- ── Vendors ───────────────────────────────────────────────
INSERT INTO public.vendors (tenant_id,vendor_code,company_name,contact_name,email,phone,address_line1,city,state,zip,is_active)
VALUES (v_tid,'VEND-0001','Palm Beach HVAC Supply','Dan Carter','dcarter@pbhvacsupply.com','561-555-8001','800 Commerce Rd','Lake Worth','FL','33461',true) RETURNING id INTO v_vend1;
INSERT INTO public.vendors (tenant_id,vendor_code,company_name,contact_name,email,phone,address_line1,city,state,zip,is_active)
VALUES (v_tid,'VEND-0002','Trane South Florida','Sales Desk','sales@tranesfl.com','800-555-8002','900 Trane Way','Doral','FL','33166',true) RETURNING id INTO v_vend2;
INSERT INTO public.vendors (tenant_id,vendor_code,company_name,contact_name,email,phone,address_line1,city,state,zip,is_active)
VALUES (v_tid,'VEND-0003','Ferguson HVAC','Mike Wilson','mwilson@ferguson.com','561-555-8003','500 Ferguson Dr','Boca Raton','FL','33487',true) RETURNING id INTO v_vend3;

-- ── Invoices ──────────────────────────────────────────────
INSERT INTO public.invoices (tenant_id,customer_id,terms_id,invoice_number,invoice_date,due_date,status,subtotal,tax_amount,total,amount_paid,balance_due,notes)
VALUES (v_tid,v_c1,v_terms_net30,'ACM-2026-0001','2026-01-20','2026-02-19','paid',756,52.92,808.92,808.92,0,'Semi-annual PM — AHU-1') RETURNING id INTO v_i1;
INSERT INTO public.invoices (tenant_id,customer_id,terms_id,invoice_number,invoice_date,due_date,status,subtotal,tax_amount,total,amount_paid,balance_due,notes)
VALUES (v_tid,v_c2,v_terms_net15,'ACM-2026-0002','2026-02-05','2026-02-20','sent',1890,132.30,2022.30,0,2022.30,'Emergency repair — compressor & capacitor') RETURNING id INTO v_i2;
INSERT INTO public.invoices (tenant_id,customer_id,terms_id,invoice_number,invoice_date,due_date,status,subtotal,tax_amount,total,amount_paid,balance_due,notes)
VALUES (v_tid,v_c3,v_terms_cod,'ACM-2026-0003','2026-03-01','2026-03-01','partial',3200,224,3424,500,2924,'New Trane 3-ton installation') RETURNING id INTO v_i3;
INSERT INTO public.invoices (tenant_id,customer_id,terms_id,invoice_number,invoice_date,due_date,status,subtotal,tax_amount,total,amount_paid,balance_due,notes)
VALUES (v_tid,v_c4,v_terms_net30,'ACM-2026-0004','2026-03-15','2026-04-14','sent',580,40.60,620.60,0,620.60,'Quarterly maintenance — clubhouse units') RETURNING id INTO v_i4;

-- ── Invoice Lines ─────────────────────────────────────────
INSERT INTO public.invoice_lines (tenant_id,invoice_id,line_number,line_type,description,quantity,unit,unit_price,discount_pct,is_taxable,tax_amount,line_total) VALUES
  (v_tid,v_i1,1,'service','Residential PM Service',1,'each',129,0,true,9.03,138.03),
  (v_tid,v_i1,2,'labor','Standard Labor',3,'hr',89,0,true,18.69,285.69),
  (v_tid,v_i1,3,'parts','Air Filter 20x25x1',2,'each',32,0,true,4.48,68.48),
  (v_tid,v_i1,4,'parts','AHU Drive Belt',1,'each',65,0,true,4.55,69.55),
  (v_tid,v_i1,5,'labor','Travel & Trip Charge',1,'each',59,0,true,4.13,63.13);
INSERT INTO public.invoice_lines (tenant_id,invoice_id,line_number,line_type,description,quantity,unit,unit_price,discount_pct,is_taxable,tax_amount,line_total) VALUES
  (v_tid,v_i2,1,'service','Diagnostic Fee',1,'each',89,0,true,6.23,95.23),
  (v_tid,v_i2,2,'labor','Emergency Labor',5,'hr',145,0,true,50.75,775.75),
  (v_tid,v_i2,3,'parts','Capacitor 40/5 MFD',1,'each',135,0,true,9.45,144.45),
  (v_tid,v_i2,4,'parts','Refrigerant R-410A',4,'lb',85,0,true,23.80,363.80),
  (v_tid,v_i2,5,'labor','Travel & Trip Charge',1,'each',59,0,true,4.13,63.13);
INSERT INTO public.invoice_lines (tenant_id,invoice_id,line_number,line_type,description,quantity,unit,unit_price,discount_pct,is_taxable,tax_amount,line_total) VALUES
  (v_tid,v_i3,1,'equipment','Trane 3-Ton AC System',1,'each',3200,0,true,224,3424);
INSERT INTO public.invoice_lines (tenant_id,invoice_id,line_number,line_type,description,quantity,unit,unit_price,discount_pct,is_taxable,tax_amount,line_total) VALUES
  (v_tid,v_i4,1,'service','Residential PM Service',2,'each',129,0,true,18.03,276.03),
  (v_tid,v_i4,2,'labor','Standard Labor',2,'hr',89,0,true,12.46,190.46),
  (v_tid,v_i4,3,'parts','Air Filter 20x25x1',4,'each',32,0,true,8.96,136.96);

-- ── Payments ──────────────────────────────────────────────
INSERT INTO public.payments (tenant_id,customer_id,payment_number,payment_date,amount,payment_method,reference_num,memo,status)
VALUES (v_tid,v_c1,'PAY-2026-0001','2026-02-15',808.92,'CHECK','CHK-2201','Payment for ACM-2026-0001','posted');
INSERT INTO public.payments (tenant_id,customer_id,payment_number,payment_date,amount,payment_method,reference_num,memo,status)
VALUES (v_tid,v_c3,'PAY-2026-0002','2026-03-05',500,'CC','CC-4412','Partial payment ACM-2026-0003','posted');

-- ── Work Orders ───────────────────────────────────────────
INSERT INTO public.work_orders (tenant_id,customer_id,location_id,equipment_id,wo_number,service_type,priority,description,status,scheduled_date,is_billable)
VALUES (v_tid,v_c1,v_l1,v_e1,'WO-ACM-0001','MAINT','NORMAL','Semi-annual PM — AHU-1 rooftop unit','completed','2026-01-20',true) RETURNING id INTO v_wo1;
INSERT INTO public.work_orders (tenant_id,customer_id,location_id,equipment_id,wo_number,service_type,priority,description,status,scheduled_date,is_billable)
VALUES (v_tid,v_c2,v_l2,v_e2,'WO-ACM-0002','REPAIR','EMERGENCY','Pool heat pump down — guests complaining','completed','2026-02-05',true) RETURNING id INTO v_wo2;
INSERT INTO public.work_orders (tenant_id,customer_id,location_id,equipment_id,wo_number,service_type,priority,description,status,scheduled_date,is_billable)
VALUES (v_tid,v_c3,v_l3,v_e3,'WO-ACM-0003','INSTALL','NORMAL','Replace old Lennox with new Trane 3-ton','completed','2026-03-01',true) RETURNING id INTO v_wo3;
INSERT INTO public.work_orders (tenant_id,customer_id,location_id,equipment_id,wo_number,service_type,priority,description,status,scheduled_date,is_billable)
VALUES (v_tid,v_c4,v_l4,v_e4,'WO-ACM-0004','MAINT','NORMAL','Quarterly PM — clubhouse units','completed','2026-03-15',true) RETURNING id INTO v_wo4;
INSERT INTO public.work_orders (tenant_id,customer_id,location_id,equipment_id,wo_number,service_type,priority,description,status,scheduled_date,is_billable)
VALUES (v_tid,v_c5,v_l5,v_e5,'WO-ACM-0005','REPAIR','HIGH','Heat pump not heating — refrigerant check','scheduled','2026-04-28',true) RETURNING id INTO v_wo5;
INSERT INTO public.work_orders (tenant_id,customer_id,location_id,equipment_id,wo_number,service_type,priority,description,status,scheduled_date,is_billable)
VALUES (v_tid,v_c1,v_l1,v_e1,'WO-ACM-0006','INSPECT','NORMAL','Annual HVAC inspection for insurance','scheduled','2026-04-30',true) RETURNING id INTO v_wo6;

-- ── Work Order Lines ──────────────────────────────────────
INSERT INTO public.work_order_lines (tenant_id,work_order_id,line_number,line_type,description,quantity,unit,unit_cost,unit_price,is_taxable,line_total,product_id) VALUES
  (v_tid,v_wo1,1,'service','Residential PM Service',1,'each',30,129,false,129,v_p_pm),
  (v_tid,v_wo1,2,'labor','Standard Labor',3,'hr',42,89,false,267,v_p_labor_std),
  (v_tid,v_wo1,3,'parts','Air Filter 20x25x1',2,'each',9,32,false,64,v_p_filter),
  (v_tid,v_wo1,4,'parts','AHU Drive Belt',1,'each',18,65,false,65,v_p_belt),
  (v_tid,v_wo1,5,'labor','Travel & Trip Charge',1,'each',0,59,false,59,v_p_travel);
INSERT INTO public.work_order_lines (tenant_id,work_order_id,line_number,line_type,description,quantity,unit,unit_cost,unit_price,is_taxable,line_total,product_id) VALUES
  (v_tid,v_wo2,1,'service','Diagnostic Fee',1,'each',0,89,false,89,v_p_diag),
  (v_tid,v_wo2,2,'labor','Emergency Labor',5,'hr',60,145,false,725,v_p_labor_emerg),
  (v_tid,v_wo2,3,'parts','Capacitor 40/5 MFD',1,'each',16,135,false,135,v_p_cap),
  (v_tid,v_wo2,4,'parts','Refrigerant R-410A',4,'lb',25,85,false,340,v_p_ref),
  (v_tid,v_wo2,5,'labor','Travel & Trip Charge',1,'each',0,59,false,59,v_p_travel);
INSERT INTO public.work_order_lines (tenant_id,work_order_id,line_number,line_type,description,quantity,unit,unit_cost,unit_price,is_taxable,line_total,product_id) VALUES
  (v_tid,v_wo3,1,'equipment','Trane 3-Ton AC System',1,'each',1450,3200,false,3200,v_p_ac3ton);

-- ── Vendor Bills ──────────────────────────────────────────
INSERT INTO public.vendor_bills (tenant_id,vendor_id,bill_number,bill_date,due_date,status,subtotal,tax_amount,total,amount_paid,balance_due,notes) VALUES
  (v_tid,v_vend1,'BILL-ACM-0001','2026-01-15','2026-02-14','paid',320,0,320,320,0,'Parts restock — capacitors, filters, belts'),
  (v_tid,v_vend2,'BILL-ACM-0002','2026-02-28','2026-03-30','sent',3200,0,3200,0,3200,'Trane 3-ton unit purchase'),
  (v_tid,v_vend3,'BILL-ACM-0003','2026-03-10','2026-04-09','partial',850,0,850,300,550,'Refrigerant and misc parts'),
  (v_tid,v_vend1,'BILL-ACM-0004','2026-04-01','2026-05-01','draft',480,0,480,0,480,'Monthly parts order');

-- ── Bank Accounts ─────────────────────────────────────────
INSERT INTO public.bank_accounts (tenant_id,account_name,account_type,bank_name,account_number,current_balance,is_active)
VALUES (v_tid,'Business Checking','checking','Wells Fargo','8821',18650.00,true) RETURNING id INTO v_ba1;

-- ── Bank Transactions ─────────────────────────────────────
INSERT INTO public.bank_transactions (tenant_id,bank_account_id,transaction_date,description,amount,transaction_type,is_reconciled,reference) VALUES
  (v_tid,v_ba1,'2026-01-15','Parts purchase - filters and belts',-320.00,'debit',true,'CHK-2001'),
  (v_tid,v_ba1,'2026-02-15','Customer payment - ACM-2026-0001',808.92,'credit',true,'DEP-001'),
  (v_tid,v_ba1,'2026-03-05','Customer payment - partial ACM-2026-0003',500.00,'credit',true,'DEP-002'),
  (v_tid,v_ba1,'2026-03-15','Vehicle insurance premium',-385.00,'debit',true,'CHK-2002'),
  (v_tid,v_ba1,'2026-04-01','Office rent',-1200.00,'debit',false,'CHK-2003'),
  (v_tid,v_ba1,'2026-04-10','Tool calibration service',-195.00,'debit',false,'CHK-2004');

-- ── Journal Entries ───────────────────────────────────────
INSERT INTO public.journal_entries (tenant_id,entry_number,entry_date,description,reference,source,is_posted)
VALUES (v_tid,'JE-0001','2026-01-20','Record invoice ACM-2026-0001','ACM-2026-0001','invoice',true) RETURNING id INTO v_je1;

INSERT INTO public.journal_lines (tenant_id,journal_entry_id,line_number,gl_account_id,debit_amount,credit_amount) VALUES
  (v_tid,v_je1,1,v_gl_ar,808.92,0),
  (v_tid,v_je1,2,v_gl_rev,0,808.92);

RAISE NOTICE 'Acme HVAC sample data v1 complete!';
RAISE NOTICE '13 products, 5 inventory, 5 customers, 5 locations, 5 equipment';
RAISE NOTICE '4 invoices, 2 payments, 6 work orders, 3 vendors, 4 vendor bills';
RAISE NOTICE '1 bank account, 6 transactions, 1 journal entry';

END;
$$;
