
-- ══════════════════════════════════════════════════════════════
-- SUNRISE HVAC COMPANY — Complete Sample Data v4
-- Tenant: a23de957-da7b-44c0-ba43-88e14d7b23e5
-- Includes: all tables including bank_accounts, journal_entries,
--           journal_lines, bank_transactions, tenant_settings
-- ══════════════════════════════════════════════════════════════

DO $$
DECLARE
  v_tid        uuid := 'a23de957-da7b-44c0-ba43-88e14d7b23e5';
  v_terms_net30 uuid; v_terms_net15 uuid; v_terms_cod uuid;
  v_tax_fl uuid; v_tax_exempt uuid;
  v_pm_check uuid; v_pm_cc uuid; v_pm_ach uuid;
  v_st_maint uuid; v_st_repair uuid; v_st_install uuid; v_st_emerg uuid;
  v_et_ac uuid; v_et_hp uuid; v_et_rtu uuid;
  v_c1 uuid; v_c2 uuid; v_c3 uuid; v_c4 uuid; v_c5 uuid;
  v_l1 uuid; v_l2 uuid; v_l3 uuid; v_l4 uuid; v_l5 uuid;
  v_e1 uuid; v_e2 uuid; v_e3 uuid; v_e4 uuid;
  v_i1 uuid; v_i2 uuid; v_i3 uuid;
  v_wo1 uuid; v_wo2 uuid; v_wo3 uuid; v_wo4 uuid; v_wo5 uuid;
  v_p_cap uuid; v_p_cont uuid; v_p_filter uuid; v_p_ref uuid;
  v_p_labor_std uuid; v_p_labor_emerg uuid; v_p_travel uuid;
  v_p_diag uuid; v_p_pm uuid; v_p_startup uuid;
  v_p_lineset uuid; v_p_msz uuid;
  v_gl_cash uuid; v_gl_ar uuid; v_gl_ap uuid;
  v_gl_rev uuid; v_gl_parts_rev uuid; v_gl_labor_cost uuid;
  v_gl_parts_cost uuid; v_gl_vehicle uuid; v_gl_tools uuid;
  v_ba1 uuid; v_ba2 uuid;
  v_je1 uuid; v_je2 uuid; v_je3 uuid;

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
  (v_tid, 'invoice_prefix',            'SRV'),
  (v_tid, 'labor_rate_default',         '95.00'),
  (v_tid, 'auto_invoice_on_sign',       'false'),
  (v_tid, 'invoice_email_on_complete',  'false'),
  (v_tid, 'company_name',              'Sunrise HVAC Company'),
  (v_tid, 'company_phone',             '954-555-1000'),
  (v_tid, 'company_email',             'service@sunrisehvac.com'),
  (v_tid, 'company_website',           'www.sunrisehvac.com'),
  (v_tid, 'license_number',            'CAC1234567'),
  (v_tid, 'invoice_footer',            'Thank you for choosing Sunrise HVAC!'),
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

-- ── Equipment Types ───────────────────────────────────────
INSERT INTO public.equipment_types (tenant_id,code,description,industry_type,is_active)
VALUES (v_tid,'AC_UNIT','Split System AC','hvac',true) RETURNING id INTO v_et_ac;
INSERT INTO public.equipment_types (tenant_id,code,description,industry_type,is_active)
VALUES (v_tid,'HEAT_PUMP','Heat Pump','hvac',true) RETURNING id INTO v_et_hp;
INSERT INTO public.equipment_types (tenant_id,code,description,industry_type,is_active)
VALUES (v_tid,'RTU','Rooftop Unit','hvac',true) RETURNING id INTO v_et_rtu;

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
VALUES (v_tid,'5000','Cost of Labor','COGS',true) RETURNING id INTO v_gl_labor_cost;
INSERT INTO public.gl_accounts (tenant_id,account_number,account_name,account_type,is_active)
VALUES (v_tid,'5100','Cost of Parts','COGS',true) RETURNING id INTO v_gl_parts_cost;
INSERT INTO public.gl_accounts (tenant_id,account_number,account_name,account_type,is_active)
VALUES (v_tid,'6000','Vehicle Expense','EXPENSE',true) RETURNING id INTO v_gl_vehicle;
INSERT INTO public.gl_accounts (tenant_id,account_number,account_name,account_type,is_active)
VALUES (v_tid,'6100','Tools & Equipment','EXPENSE',true) RETURNING id INTO v_gl_tools;

-- ── Products / Catalog ────────────────────────────────────
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'CAP-45-5','Capacitor 45/5 MFD','parts','each',18,145,false,true,true) RETURNING id INTO v_p_cap;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'CONT-40A','Contactor 40A','parts','each',14,120,false,true,true) RETURNING id INTO v_p_cont;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'FILTER-16x25','Air Filter 16x25x1','parts','each',8,28,false,true,true) RETURNING id INTO v_p_filter;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'REF-R410A','Refrigerant R-410A','parts','lb',25,85,false,true,true) RETURNING id INTO v_p_ref;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'LINESET-KIT','Lineset & Electrical Kit','parts','each',95,200,false,false,true) RETURNING id INTO v_p_lineset;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'MSZ-GL24NA','Mitsubishi MSZ-GL24NA','equipment','each',1200,2200,false,false,true) RETURNING id INTO v_p_msz;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'LABOR-STD','Standard Labor','labor','hr',45,95,true,false,true) RETURNING id INTO v_p_labor_std;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'LABOR-EMERG','Emergency Labor','labor','hr',65,150,true,false,true) RETURNING id INTO v_p_labor_emerg;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'TRAVEL','Travel & Trip Charge','labor','each',0,65,true,false,true) RETURNING id INTO v_p_travel;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'DIAG-FEE','Diagnostic Fee','service','each',0,95,true,false,true) RETURNING id INTO v_p_diag;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'PM-SERVICE','PM Service','service','each',35,149,true,false,true) RETURNING id INTO v_p_pm;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'STARTUP','System Startup','service','each',0,125,true,false,true) RETURNING id INTO v_p_startup;
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'AC-3TON','3-Ton Split System AC','equipment','each',1350,2900,false,false,true);
INSERT INTO public.products (tenant_id,product_code,name,category,unit,cost_price,sell_price,is_labor,track_inventory,is_active)
VALUES (v_tid,'RTU-10TON','10-Ton Rooftop Unit','equipment','each',5500,11000,false,false,true);

-- ── Inventory Stock ───────────────────────────────────────
INSERT INTO public.inventory_stock (tenant_id,product_id,quantity_on_hand,quantity_reserved,reorder_point)
VALUES (v_tid,v_p_cap,15,2,5);
INSERT INTO public.inventory_stock (tenant_id,product_id,quantity_on_hand,quantity_reserved,reorder_point)
VALUES (v_tid,v_p_cont,12,1,4);
INSERT INTO public.inventory_stock (tenant_id,product_id,quantity_on_hand,quantity_reserved,reorder_point)
VALUES (v_tid,v_p_filter,48,6,20);
INSERT INTO public.inventory_stock (tenant_id,product_id,quantity_on_hand,quantity_reserved,reorder_point)
VALUES (v_tid,v_p_ref,30,4,10);

-- ── Customers ─────────────────────────────────────────────
INSERT INTO public.customers (tenant_id,terms_id,tax_rate_id,customer_code,company_name,customer_type,contact_name,email,phone,address_line1,city,state,zip,country,credit_limit,is_taxable,is_active)
VALUES (v_tid,v_terms_net30,v_tax_fl,'CUST-0001','Sunrise Plaza Shopping Center','commercial','Bob Martinez','bmart@sunriseplaza.com','954-555-0101','1234 Commercial Blvd','Sunrise','FL','33323','US',10000,true,true) RETURNING id INTO v_c1;
INSERT INTO public.customers (tenant_id,terms_id,tax_rate_id,customer_code,company_name,customer_type,contact_name,email,phone,address_line1,city,state,zip,country,credit_limit,is_taxable,is_active)
VALUES (v_tid,v_terms_net15,v_tax_fl,'CUST-0002','Broward Medical Center','commercial','Susan Chen','schen@browardmed.com','954-555-0202','5678 Healthcare Dr','Fort Lauderdale','FL','33311','US',25000,true,true) RETURNING id INTO v_c2;
INSERT INTO public.customers (tenant_id,terms_id,tax_rate_id,customer_code,company_name,customer_type,contact_name,email,phone,address_line1,city,state,zip,country,credit_limit,is_taxable,is_active)
VALUES (v_tid,v_terms_net30,v_tax_fl,'CUST-0003','Palm Beach Resorts LLC','commercial','Mike Thompson','mthompson@pbresorts.com','561-555-0303','9012 Resort Way','Boca Raton','FL','33432','US',50000,true,true) RETURNING id INTO v_c3;
INSERT INTO public.customers (tenant_id,terms_id,tax_rate_id,customer_code,company_name,customer_type,contact_name,email,phone,address_line1,city,state,zip,country,credit_limit,is_taxable,is_active)
VALUES (v_tid,v_terms_cod,v_tax_fl,'CUST-0004','Johnson Residence','residential','Tom Johnson','tjohnson@gmail.com','954-555-0404','3456 Palm Ave','Pembroke Pines','FL','33024','US',2500,true,true) RETURNING id INTO v_c4;
INSERT INTO public.customers (tenant_id,terms_id,tax_rate_id,customer_code,company_name,customer_type,contact_name,email,phone,address_line1,city,state,zip,country,credit_limit,is_taxable,is_active)
VALUES (v_tid,v_terms_net30,v_tax_exempt,'CUST-0005','Sunrise School District','government','Linda Parks','lparks@sunriseschools.gov','954-555-0505','7890 Education Ln','Sunrise','FL','33351','US',75000,false,true) RETURNING id INTO v_c5;

-- ── Service Locations ─────────────────────────────────────
INSERT INTO public.service_locations (tenant_id,customer_id,location_name,address_line1,city,state,zip,contact_name,contact_phone,access_notes,is_active)
VALUES (v_tid,v_c1,'Main Building','1234 Commercial Blvd','Sunrise','FL','33323','Bob Martinez','954-555-0101','Security desk at main entrance. Call ahead.',true) RETURNING id INTO v_l1;
INSERT INTO public.service_locations (tenant_id,customer_id,location_name,address_line1,city,state,zip,contact_name,contact_phone,access_notes,is_active)
VALUES (v_tid,v_c2,'North Wing','5678 Healthcare Dr','Fort Lauderdale','FL','33311','Facilities Dept','954-555-0202','Badge required. Check in with security.',true) RETURNING id INTO v_l2;
INSERT INTO public.service_locations (tenant_id,customer_id,location_name,address_line1,city,state,zip,contact_name,contact_phone,access_notes,is_active)
VALUES (v_tid,v_c3,'Main Resort Building','9012 Resort Way','Boca Raton','FL','33432','Mike Thompson','561-555-0303','Rooftop access via service elevator B.',true) RETURNING id INTO v_l3;
INSERT INTO public.service_locations (tenant_id,customer_id,location_name,address_line1,city,state,zip,contact_name,contact_phone,access_notes,is_active)
VALUES (v_tid,v_c4,'Residence','3456 Palm Ave','Pembroke Pines','FL','33024','Tom Johnson','954-555-0404','Gate code: 4521',true) RETURNING id INTO v_l4;
INSERT INTO public.service_locations (tenant_id,customer_id,location_name,address_line1,city,state,zip,contact_name,contact_phone,access_notes,is_active)
VALUES (v_tid,v_c5,'Central High School','7890 Education Ln','Sunrise','FL','33351','Linda Parks','954-555-0505','Maintenance entrance on south side.',true) RETURNING id INTO v_l5;

-- ── Equipment ─────────────────────────────────────────────
INSERT INTO public.equipment (tenant_id,customer_id,location_id,equipment_name,equipment_type,brand,model_number,serial_number,install_date,warranty_expiry,tonnage,seer_rating,refrigerant_type,next_service_date,is_active)
VALUES (v_tid,v_c1,v_l1,'RTU-1 Main Roof','RTU','Carrier','RTU-48XC','SN-2021-0011','2021-03-15','2024-03-15',10,16,'R-410A','2026-09-15',true) RETURNING id INTO v_e1;
INSERT INTO public.equipment (tenant_id,customer_id,location_id,equipment_name,equipment_type,brand,model_number,serial_number,install_date,warranty_expiry,tonnage,seer_rating,refrigerant_type,next_service_date,is_active)
VALUES (v_tid,v_c2,v_l2,'AHU-3 North Wing','AC_UNIT','Trane','AHU-36VP','SN-2020-0022','2020-06-10','2023-06-10',5,18,'R-410A','2026-12-10',true) RETURNING id INTO v_e2;
INSERT INTO public.equipment (tenant_id,customer_id,location_id,equipment_name,equipment_type,brand,model_number,serial_number,install_date,warranty_expiry,tonnage,seer_rating,refrigerant_type,next_service_date,is_active)
VALUES (v_tid,v_c3,v_l3,'Pool Area Mini-Split','AC_UNIT','Mitsubishi','MSZ-GL24NA','SN-2022-0033','2022-01-20','2025-01-20',2,21,'R-410A','2026-07-20',true) RETURNING id INTO v_e3;
INSERT INTO public.equipment (tenant_id,customer_id,location_id,equipment_name,equipment_type,brand,model_number,serial_number,install_date,warranty_expiry,tonnage,seer_rating,refrigerant_type,next_service_date,is_active)
VALUES (v_tid,v_c4,v_l4,'Home AC Unit','HEAT_PUMP','Lennox','XP21-036','SN-2019-0044','2019-08-05','2022-08-05',3,21,'R-410A','2026-08-05',true) RETURNING id INTO v_e4;

-- ── Invoices ──────────────────────────────────────────────
INSERT INTO public.invoices (tenant_id,customer_id,terms_id,invoice_number,invoice_date,due_date,status,subtotal,tax_amount,total,amount_paid,balance_due,notes)
VALUES (v_tid,v_c1,v_terms_net30,'SRV-2026-0001','2026-01-15','2026-02-14','paid',850,59.50,909.50,909.50,0,'Quarterly maintenance') RETURNING id INTO v_i1;
INSERT INTO public.invoices (tenant_id,customer_id,terms_id,invoice_number,invoice_date,due_date,status,subtotal,tax_amount,total,amount_paid,balance_due,notes)
VALUES (v_tid,v_c2,v_terms_net15,'SRV-2026-0002','2026-02-01','2026-02-16','sent',1250,87.50,1337.50,0,1337.50,'Emergency repair AHU-3') RETURNING id INTO v_i2;
INSERT INTO public.invoices (tenant_id,customer_id,terms_id,invoice_number,invoice_date,due_date,status,subtotal,tax_amount,total,amount_paid,balance_due,notes)
VALUES (v_tid,v_c3,v_terms_net30,'SRV-2026-0003','2026-02-10','2026-03-12','partial',3200,224,3424,1000,2424,'Mini-split installation') RETURNING id INTO v_i3;

-- ── Invoice Lines ─────────────────────────────────────────
INSERT INTO public.invoice_lines (tenant_id,invoice_id,line_number,line_type,description,quantity,unit,unit_price,discount_pct,is_taxable,tax_amount,line_total) VALUES
  (v_tid,v_i1,1,'service','PM Service',1,'each',149,0,true,10.43,159.43),
  (v_tid,v_i1,2,'labor','Standard Labor',2,'hr',95,0,true,13.30,203.30),
  (v_tid,v_i1,3,'parts','Air Filter 16x25x1',4,'each',28,0,true,7.84,119.84),
  (v_tid,v_i1,4,'parts','Refrigerant R-410A',2,'lb',85,0,true,11.90,181.90),
  (v_tid,v_i1,5,'labor','Travel & Trip Charge',1,'each',65,0,true,4.55,69.55);
INSERT INTO public.invoice_lines (tenant_id,invoice_id,line_number,line_type,description,quantity,unit,unit_price,discount_pct,is_taxable,tax_amount,line_total) VALUES
  (v_tid,v_i2,1,'service','Diagnostic Fee',1,'each',95,0,true,6.65,101.65),
  (v_tid,v_i2,2,'labor','Emergency Labor',4,'hr',150,0,true,42,642),
  (v_tid,v_i2,3,'parts','Capacitor 45/5 MFD',1,'each',145,0,true,10.15,155.15),
  (v_tid,v_i2,4,'parts','Contactor 40A',1,'each',120,0,true,8.40,128.40),
  (v_tid,v_i2,5,'parts','Refrigerant R-410A',3,'lb',85,0,true,17.85,272.85);
INSERT INTO public.invoice_lines (tenant_id,invoice_id,line_number,line_type,description,quantity,unit,unit_price,discount_pct,is_taxable,tax_amount,line_total) VALUES
  (v_tid,v_i3,1,'equipment','Mitsubishi MSZ-GL24NA',1,'each',2200,0,true,154,2354),
  (v_tid,v_i3,2,'labor','Installation Labor',5,'hr',95,0,true,33.25,508.25),
  (v_tid,v_i3,3,'parts','Lineset & Electrical Kit',1,'each',200,0,true,14,214),
  (v_tid,v_i3,4,'service','System Startup',1,'each',125,0,true,8.75,133.75);

-- ── Payments ──────────────────────────────────────────────
INSERT INTO public.payments (tenant_id,customer_id,payment_number,payment_date,amount,payment_method,reference_num,memo,status)
VALUES (v_tid,v_c1,'PAY-2026-0001','2026-02-10',909.50,'CHECK','CHK-4521','Payment for SRV-2026-0001','posted');
INSERT INTO public.payments (tenant_id,customer_id,payment_number,payment_date,amount,payment_method,reference_num,memo,status)
VALUES (v_tid,v_c3,'PAY-2026-0002','2026-02-20',1000,'CC','CC-7731','Partial payment SRV-2026-0003','posted');

-- ── Work Orders ───────────────────────────────────────────
INSERT INTO public.work_orders (tenant_id,customer_id,location_id,equipment_id,wo_number,service_type,priority,description,status,scheduled_date,is_billable)
VALUES (v_tid,v_c1,v_l1,v_e1,'WO-2026-0001','MAINT','NORMAL','Quarterly PM — RTU-1','completed','2026-01-15',true) RETURNING id INTO v_wo1;
INSERT INTO public.work_orders (tenant_id,customer_id,location_id,equipment_id,wo_number,service_type,priority,description,status,scheduled_date,is_billable)
VALUES (v_tid,v_c2,v_l2,v_e2,'WO-2026-0002','REPAIR','HIGH','AHU-3 not cooling — capacitor failure','completed','2026-02-01',true) RETURNING id INTO v_wo2;
INSERT INTO public.work_orders (tenant_id,customer_id,location_id,equipment_id,wo_number,service_type,priority,description,status,scheduled_date,is_billable)
VALUES (v_tid,v_c3,v_l3,v_e3,'WO-2026-0003','INSTALL','NORMAL','New mini-split installation pool area','completed','2026-02-10',true) RETURNING id INTO v_wo3;
INSERT INTO public.work_orders (tenant_id,customer_id,location_id,equipment_id,wo_number,service_type,priority,description,status,scheduled_date,is_billable)
VALUES (v_tid,v_c4,v_l4,v_e4,'WO-2026-0004','REPAIR','NORMAL','Unit not cooling — possible refrigerant leak','scheduled','2026-04-28',true) RETURNING id INTO v_wo4;
INSERT INTO public.work_orders (tenant_id,customer_id,location_id,equipment_id,wo_number,service_type,priority,description,status,scheduled_date,is_billable)
VALUES (v_tid,v_c5,v_l5,NULL,'WO-2026-0005','MAINT','NORMAL','Annual PM — 12 classroom units','scheduled','2026-04-29',true) RETURNING id INTO v_wo5;

-- ── Work Order Lines ──────────────────────────────────────
INSERT INTO public.work_order_lines (tenant_id,work_order_id,line_number,line_type,description,quantity,unit,unit_cost,unit_price,is_taxable,line_total,product_id) VALUES
  (v_tid,v_wo1,1,'service','PM Service',1,'each',35,149,false,149,v_p_pm),
  (v_tid,v_wo1,2,'labor','Standard Labor',2,'hr',45,95,false,190,v_p_labor_std),
  (v_tid,v_wo1,3,'parts','Air Filter 16x25x1',4,'each',8,28,false,112,v_p_filter),
  (v_tid,v_wo1,4,'labor','Travel & Trip Charge',1,'each',0,65,false,65,v_p_travel);
INSERT INTO public.work_order_lines (tenant_id,work_order_id,line_number,line_type,description,quantity,unit,unit_cost,unit_price,is_taxable,line_total,product_id) VALUES
  (v_tid,v_wo2,1,'service','Diagnostic Fee',1,'each',0,95,false,95,v_p_diag),
  (v_tid,v_wo2,2,'labor','Emergency Labor',4,'hr',65,150,false,600,v_p_labor_emerg),
  (v_tid,v_wo2,3,'parts','Capacitor 45/5 MFD',1,'each',18,145,false,145,v_p_cap),
  (v_tid,v_wo2,4,'parts','Contactor 40A',1,'each',14,120,false,120,v_p_cont),
  (v_tid,v_wo2,5,'parts','Refrigerant R-410A',3,'lb',25,85,false,255,v_p_ref);
INSERT INTO public.work_order_lines (tenant_id,work_order_id,line_number,line_type,description,quantity,unit,unit_cost,unit_price,is_taxable,line_total,product_id) VALUES
  (v_tid,v_wo3,1,'equipment','Mitsubishi MSZ-GL24NA',1,'each',1200,2200,false,2200,v_p_msz),
  (v_tid,v_wo3,2,'labor','Installation Labor',5,'hr',45,95,false,475,v_p_labor_std),
  (v_tid,v_wo3,3,'parts','Lineset & Electrical Kit',1,'each',95,200,false,200,v_p_lineset),
  (v_tid,v_wo3,4,'service','System Startup',1,'each',0,125,false,125,v_p_startup);

-- ── Bank Accounts ─────────────────────────────────────────
INSERT INTO public.bank_accounts (tenant_id,account_name,account_type,bank_name,account_number,current_balance,is_active)
VALUES (v_tid,'Business Checking','checking','Chase Bank','4521',24850.75,true) RETURNING id INTO v_ba1;
INSERT INTO public.bank_accounts (tenant_id,account_name,account_type,bank_name,account_number,current_balance,is_active)
VALUES (v_tid,'Business Savings','savings','Chase Bank','7833',15000.00,true) RETURNING id INTO v_ba2;

-- ── Bank Transactions ─────────────────────────────────────
INSERT INTO public.bank_transactions (tenant_id,bank_account_id,transaction_date,description,amount,transaction_type,is_reconciled,reference) VALUES
  (v_tid,v_ba1,'2026-01-15','Parts purchase - capacitors & contactors',-285.00,'debit',true,'CHK-1001'),
  (v_tid,v_ba1,'2026-01-20','Vehicle fuel expense',-125.50,'debit',true,'CHK-1002'),
  (v_tid,v_ba1,'2026-02-10','Customer payment - SRV-2026-0001',909.50,'credit',true,'DEP-001'),
  (v_tid,v_ba1,'2026-02-15','Refrigerant restock',-750.00,'debit',true,'CHK-1003'),
  (v_tid,v_ba1,'2026-02-20','Customer payment - SRV-2026-0003 partial',1000.00,'credit',true,'DEP-002'),
  (v_tid,v_ba1,'2026-03-01','Tool purchase - manifold gauge set',-380.00,'debit',false,'CHK-1004'),
  (v_tid,v_ba1,'2026-03-10','Insurance premium',-425.00,'debit',false,'CHK-1005'),
  (v_tid,v_ba1,'2026-04-01','Vehicle payment',-650.00,'debit',false,'CHK-1006'),
  (v_tid,v_ba1,'2026-04-15','Office supplies',-89.50,'debit',false,'CHK-1007');

-- ── Journal Entries ───────────────────────────────────────
INSERT INTO public.journal_entries (tenant_id,entry_number,entry_date,description,reference,source,is_posted)
VALUES (v_tid,'JE-0001','2026-01-15','Record invoice SRV-2026-0001','SRV-2026-0001','invoice',true) RETURNING id INTO v_je1;
INSERT INTO public.journal_entries (tenant_id,entry_number,entry_date,description,reference,source,is_posted)
VALUES (v_tid,'JE-0002','2026-02-10','Record payment received - Sunrise Plaza','PAY-2026-0001','payment',true) RETURNING id INTO v_je2;
INSERT INTO public.journal_entries (tenant_id,entry_number,entry_date,description,reference,source,is_posted)
VALUES (v_tid,'JE-0003','2026-03-01','Monthly depreciation - equipment','MAR-2026','manual',false) RETURNING id INTO v_je3;

-- ── Journal Lines ─────────────────────────────────────────
INSERT INTO public.journal_lines (tenant_id,journal_entry_id,line_number,gl_account_id,debit_amount,credit_amount) VALUES
  (v_tid,v_je1,1,v_gl_ar,909.50,0),
  (v_tid,v_je1,2,v_gl_rev,0,909.50);
INSERT INTO public.journal_lines (tenant_id,journal_entry_id,line_number,gl_account_id,debit_amount,credit_amount) VALUES
  (v_tid,v_je2,1,v_gl_cash,909.50,0),
  (v_tid,v_je2,2,v_gl_ar,0,909.50);
INSERT INTO public.journal_lines (tenant_id,journal_entry_id,line_number,gl_account_id,debit_amount,credit_amount) VALUES
  (v_tid,v_je3,1,v_gl_tools,250.00,0),
  (v_tid,v_je3,2,v_gl_cash,0,250.00);

RAISE NOTICE 'Sunrise HVAC v4 complete!';
RAISE NOTICE 'Includes: settings, products, inventory, customers, locations,';
RAISE NOTICE 'equipment, invoices, payments, work orders, bank accounts,';
RAISE NOTICE 'bank transactions, journal entries, journal lines';

END;
$$;
