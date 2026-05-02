-- ================================================================
-- ServiceFlow Sunrise Tenant Seed Data
-- Run in Supabase SQL Editor
-- ================================================================

-- Step 1: Clean up
DELETE FROM journal_lines         WHERE tenant_id = 'a23de957-da7b-44c0-ba43-88e14d7b23e5';
DELETE FROM journal_entries       WHERE tenant_id = 'a23de957-da7b-44c0-ba43-88e14d7b23e5';
DELETE FROM bank_transactions     WHERE tenant_id = 'a23de957-da7b-44c0-ba43-88e14d7b23e5';
DELETE FROM bank_accounts         WHERE tenant_id = 'a23de957-da7b-44c0-ba43-88e14d7b23e5';
DELETE FROM vendor_bills          WHERE tenant_id = 'a23de957-da7b-44c0-ba43-88e14d7b23e5';
DELETE FROM payments              WHERE tenant_id = 'a23de957-da7b-44c0-ba43-88e14d7b23e5';
DELETE FROM invoice_lines         WHERE tenant_id = 'a23de957-da7b-44c0-ba43-88e14d7b23e5';
DELETE FROM invoices              WHERE tenant_id = 'a23de957-da7b-44c0-ba43-88e14d7b23e5';
DELETE FROM work_order_signatures WHERE tenant_id = 'a23de957-da7b-44c0-ba43-88e14d7b23e5';
DELETE FROM work_order_photos     WHERE tenant_id = 'a23de957-da7b-44c0-ba43-88e14d7b23e5';
DELETE FROM work_order_notes      WHERE tenant_id = 'a23de957-da7b-44c0-ba43-88e14d7b23e5';
DELETE FROM work_order_lines      WHERE tenant_id = 'a23de957-da7b-44c0-ba43-88e14d7b23e5';
DELETE FROM work_orders           WHERE tenant_id = 'a23de957-da7b-44c0-ba43-88e14d7b23e5';
DELETE FROM inventory_stock       WHERE tenant_id = 'a23de957-da7b-44c0-ba43-88e14d7b23e5';
DELETE FROM products              WHERE tenant_id = 'a23de957-da7b-44c0-ba43-88e14d7b23e5';
DELETE FROM equipment             WHERE tenant_id = 'a23de957-da7b-44c0-ba43-88e14d7b23e5';
DELETE FROM service_locations     WHERE tenant_id = 'a23de957-da7b-44c0-ba43-88e14d7b23e5';
DELETE FROM customers             WHERE tenant_id = 'a23de957-da7b-44c0-ba43-88e14d7b23e5';
DELETE FROM vendors               WHERE tenant_id = 'a23de957-da7b-44c0-ba43-88e14d7b23e5';

-- Step 2: Customers
INSERT INTO customers (id, tenant_id, customer_code, company_name, customer_type, contact_name, phone, email, address_line1, city, state, zip, credit_limit, is_active, country) VALUES
('c1000001-0000-4000-a000-000000000001', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'CUST-001', 'Broward Office Park LLC',  'commercial',  'Tom Harrison',   '954-555-0101', 'tom@browardofficepark.com', '1200 W Broward Blvd',  'Fort Lauderdale', 'FL', '33312', 25000, true, 'US'),
('c1000001-0000-4000-a000-000000000002', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'CUST-002', 'Sunrise Plaza Hotel',       'commercial',  'Maria Gonzalez', '954-555-0202', 'mgmt@sunriseplaza.com',     '3400 N University Dr', 'Sunrise',         'FL', '33351', 50000, true, 'US'),
('c1000001-0000-4000-a000-000000000003', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'CUST-003', 'Delray Beach Condos',       'residential', 'Frank Deluca',   '561-555-0303', 'frank@delraycondo.com',     '900 SE 5th Ave',       'Delray Beach',    'FL', '33483', 10000, true, 'US'),
('c1000001-0000-4000-a000-000000000004', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'CUST-004', 'Palm Beach Retail Group',   'commercial',  'Sandra Wu',      '561-555-0404', 'sandra@pbretail.com',       '501 Clematis St',      'West Palm Beach', 'FL', '33401', 30000, true, 'US');

-- Step 3: Service Locations
INSERT INTO service_locations (id, tenant_id, customer_id, location_name, address_line1, city, state, zip, contact_name, contact_phone, is_active) VALUES
('a0000001-0000-4000-a000-000000000011', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'c1000001-0000-4000-a000-000000000001', 'Broward Office Park Main Building',  '1200 W Broward Blvd Suite 100', 'Fort Lauderdale', 'FL', '33312', 'Tom Harrison',   '954-555-0101', true),
('a0000001-0000-4000-a000-000000000012', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'c1000001-0000-4000-a000-000000000002', 'Sunrise Plaza Lobby HVAC Unit',      '3400 N University Dr',          'Sunrise',         'FL', '33351', 'Maria Gonzalez', '954-555-0202', true),
('a0000001-0000-4000-a000-000000000013', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'c1000001-0000-4000-a000-000000000002', 'Sunrise Plaza Pool Mechanical Room', '3400 N University Dr Bldg B',   'Sunrise',         'FL', '33351', 'Maria Gonzalez', '954-555-0202', true),
('a0000001-0000-4000-a000-000000000014', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'c1000001-0000-4000-a000-000000000003', 'Delray Beach Condos Unit 4B',        '900 SE 5th Ave Apt 4B',         'Delray Beach',    'FL', '33483', 'Frank Deluca',   '561-555-0303', true);

-- Step 4: Vendors
INSERT INTO vendors (id, tenant_id, vendor_code, company_name, vendor_type, contact_name, phone, email, address_line1, city, state, zip, is_1099, is_active) VALUES
('b0000001-0000-4000-a000-000000000021', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'VEND-001', 'Carrier HVAC Supply',      'supplier',      'Bob Marsh',     '800-555-1111', 'orders@carriersupply.com', '100 Industrial Way', 'Doral',   'FL', '33166', false, true),
('b0000001-0000-4000-a000-000000000022', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'VEND-002', 'South Florida Sheet Metal', 'subcontractor', 'Rick Castillo', '954-555-2222', 'rick@sfsheetmetal.com',    '250 NW 27th Ave',    'Miami',   'FL', '33125', true,  true),
('b0000001-0000-4000-a000-000000000023', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'VEND-003', 'Dade Electrical Services',  'subcontractor', 'Anna Torres',   '305-555-3333', 'anna@dadeelectric.com',    '400 SW 8th St',      'Hialeah', 'FL', '33010', true,  true);

-- Step 5: Products
INSERT INTO products (id, tenant_id, product_code, name, description, category, unit, cost_price, sell_price, is_labor, track_inventory, is_active) VALUES
('d0000001-0000-4000-a000-000000000031', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'LAB-001',  'Standard Labor',           'HVAC technician labor rate',         'Labor',      'hr', 0,    125,  true,  false, true),
('d0000001-0000-4000-a000-000000000032', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'LAB-002',  'Emergency Labor',          'After-hours emergency labor rate',   'Labor',      'hr', 0,    175,  true,  false, true),
('d0000001-0000-4000-a000-000000000033', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'PART-001', 'Carrier Condenser 3-ton',  '3-ton condenser unit',               'Equipment',  'ea', 1850, 2750, false, true,  true),
('d0000001-0000-4000-a000-000000000034', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'PART-002', 'Air Handler 2-ton Carrier','AHU for residential use',            'Equipment',  'ea', 950,  1450, false, true,  true),
('d0000001-0000-4000-a000-000000000035', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'PART-003', 'MERV-13 Filter 20x25x4',  'High-efficiency pleated air filter', 'Filters',    'ea', 18,   42,   false, true,  true),
('d0000001-0000-4000-a000-000000000036', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'PART-004', 'Refrigerant R-410A 25lb', '25 lb jug EPA 608 required',         'Refrigerant','ea', 95,   185,  false, true,  true);

-- Step 6: Inventory Stock
INSERT INTO inventory_stock (tenant_id, product_id, quantity_on_hand, quantity_reserved, reorder_point) VALUES
('a23de957-da7b-44c0-ba43-88e14d7b23e5', 'd0000001-0000-4000-a000-000000000033', 4,  1, 2),
('a23de957-da7b-44c0-ba43-88e14d7b23e5', 'd0000001-0000-4000-a000-000000000034', 6,  0, 3),
('a23de957-da7b-44c0-ba43-88e14d7b23e5', 'd0000001-0000-4000-a000-000000000035', 50, 5, 20),
('a23de957-da7b-44c0-ba43-88e14d7b23e5', 'd0000001-0000-4000-a000-000000000036', 12, 2, 5);

-- Step 7: Work Orders
INSERT INTO work_orders (id, tenant_id, wo_number, status, priority, customer_id, location_id, service_type, scheduled_date, description) VALUES
('e0000001-0000-4000-a000-000000000041', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'WO-0001', 'completed',   'normal', 'c1000001-0000-4000-a000-000000000001', 'a0000001-0000-4000-a000-000000000011', 'maintenance',  '2025-04-05', 'Annual PM rooftop unit RTU-2. Clean coils, check refrigerant, replace filters.'),
('e0000001-0000-4000-a000-000000000042', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'WO-0002', 'in_progress', 'high',   'c1000001-0000-4000-a000-000000000002', 'a0000001-0000-4000-a000-000000000012', 'repair',       '2025-04-20', 'Lobby AC not cooling. Compressor cycling off on high pressure.'),
('e0000001-0000-4000-a000-000000000043', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'WO-0003', 'scheduled',   'normal', 'c1000001-0000-4000-a000-000000000003', 'a0000001-0000-4000-a000-000000000014', 'installation', '2025-05-02', 'Install new 2-ton split system to replace failed unit in Unit 4B.'),
('e0000001-0000-4000-a000-000000000044', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'WO-0004', 'completed',   'urgent', 'c1000001-0000-4000-a000-000000000002', 'a0000001-0000-4000-a000-000000000013', 'repair',       '2025-04-10', 'Pool mechanical room chiller fault alarm. Emergency call-out.');

-- Step 8: Invoices (uses first terms record for Sunrise tenant)
INSERT INTO invoices (id, tenant_id, invoice_number, status, customer_id, work_order_id, terms_id, invoice_date, due_date, subtotal, tax_amount, total, amount_paid, balance_due, discount_amount, notes)
SELECT
  'f0000001-0000-4000-a000-000000000051', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'INV-0001', 'paid',
  'c1000001-0000-4000-a000-000000000001', 'e0000001-0000-4000-a000-000000000041', t.id,
  '2025-04-06', '2025-05-06', 875.00, 61.25, 936.25, 936.25, 0.00, 0,
  'Annual PM completed. Replaced 4 filters, cleaned coils.'
FROM terms t WHERE t.tenant_id = 'a23de957-da7b-44c0-ba43-88e14d7b23e5' LIMIT 1;

INSERT INTO invoices (id, tenant_id, invoice_number, status, customer_id, work_order_id, terms_id, invoice_date, due_date, subtotal, tax_amount, total, amount_paid, balance_due, discount_amount, notes)
SELECT
  'f0000001-0000-4000-a000-000000000052', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'INV-0002', 'sent',
  'c1000001-0000-4000-a000-000000000002', 'e0000001-0000-4000-a000-000000000044', t.id,
  '2025-04-11', '2025-05-11', 1640.00, 114.80, 1754.80, 0.00, 1754.80, 0,
  'Emergency chiller repair. Parts and labor. Net 30.'
FROM terms t WHERE t.tenant_id = 'a23de957-da7b-44c0-ba43-88e14d7b23e5' LIMIT 1;

INSERT INTO invoices (id, tenant_id, invoice_number, status, customer_id, work_order_id, terms_id, invoice_date, due_date, subtotal, tax_amount, total, amount_paid, balance_due, discount_amount, notes)
SELECT
  'f0000001-0000-4000-a000-000000000053', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'INV-0003', 'draft',
  'c1000001-0000-4000-a000-000000000003', 'e0000001-0000-4000-a000-000000000043', t.id,
  '2025-04-25', '2025-05-25', 2895.00, 202.65, 3097.65, 0.00, 3097.65, 0,
  'New 2-ton split system installation pending completion.'
FROM terms t WHERE t.tenant_id = 'a23de957-da7b-44c0-ba43-88e14d7b23e5' LIMIT 1;

-- Step 9: Bank Accounts
INSERT INTO bank_accounts (id, tenant_id, account_name, account_type, bank_name, account_number, current_balance, is_active) VALUES
('a1000001-0000-4000-a000-000000000061', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'Sunrise HVAC Operating', 'checking', 'Wells Fargo', 'xxxx4421', 42850.00, true),
('a1000001-0000-4000-a000-000000000062', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'Sunrise HVAC Savings',   'savings',  'Wells Fargo', 'xxxx8893', 18500.00, true);

-- Step 10: Journal Entries
INSERT INTO journal_entries (id, tenant_id, entry_number, entry_date, description, source, is_posted) VALUES
('a2000001-0000-4000-a000-000000000071', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'JE-0001', '2025-04-06', 'Payment received INV-0001 Broward Office Park', 'manual', true),
('a2000001-0000-4000-a000-000000000072', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'JE-0002', '2025-04-15', 'Carrier HVAC Supply parts purchase VB-0001',    'manual', true);

-- Step 11: Vendor Bills
INSERT INTO vendor_bills (id, tenant_id, bill_number, status, vendor_id, bill_date, due_date, total, balance_due, notes) VALUES
('a3000001-0000-4000-a000-000000000081', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'VB-0001', 'paid',   'b0000001-0000-4000-a000-000000000021', '2025-04-03', '2025-05-03', 1240.00, 0.00,   'Condenser unit and filters for WO-0001'),
('a3000001-0000-4000-a000-000000000082', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'VB-0002', 'unpaid', 'b0000001-0000-4000-a000-000000000022', '2025-04-12', '2025-05-12', 680.00,  680.00, 'Sheet metal ductwork Sunrise Plaza chiller room'),
('a3000001-0000-4000-a000-000000000083', 'a23de957-da7b-44c0-ba43-88e14d7b23e5', 'VB-0003', 'unpaid', 'b0000001-0000-4000-a000-000000000023', '2025-04-22', '2025-05-22', 454.75,  454.75, 'Electrical disconnect work for WO-0003 install');
