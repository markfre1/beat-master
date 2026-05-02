-- ============================================================
-- ServiceFlow Fresh Seed Data v1
-- Two companies: Sunrise HVAC Company & Acme HVAC
-- All users have tenant_id in app_metadata for RLS
-- Run in Supabase SQL Editor
-- ============================================================

DO $$
DECLARE
  -- Tenant IDs
  sunrise_id  uuid := gen_random_uuid();
  acme_id     uuid := gen_random_uuid();

  -- User IDs (app)
  sunrise_owner_id   uuid := gen_random_uuid();
  sunrise_tech1_id   uuid := gen_random_uuid();
  sunrise_tech2_id   uuid := gen_random_uuid();
  sunrise_office_id  uuid := gen_random_uuid();

  acme_owner_id      uuid := gen_random_uuid();
  acme_tech1_id      uuid := gen_random_uuid();
  acme_office_id     uuid := gen_random_uuid();

  -- Auth user IDs (will be set after insert)
  sunrise_owner_auth   uuid;
  sunrise_tech1_auth   uuid;
  sunrise_tech2_auth   uuid;
  sunrise_office_auth  uuid;
  acme_owner_auth      uuid;
  acme_tech1_auth      uuid;
  acme_office_auth     uuid;

  -- Security group IDs
  sunrise_admin_grp  uuid;
  sunrise_ro_grp     uuid;
  acme_admin_grp     uuid;
  acme_ro_grp        uuid;

  -- Lookup IDs - Sunrise
  s_terms_net30   uuid;
  s_terms_net15   uuid;
  s_tax_fl        uuid;
  s_pm_cc         uuid;
  s_pm_check      uuid;
  s_pm_ach        uuid;

  -- Lookup IDs - Acme
  a_terms_net30   uuid;
  a_terms_due     uuid;
  a_tax_fl        uuid;
  a_pm_cc         uuid;
  a_pm_check      uuid;

  -- Customer IDs - Sunrise
  s_cust1_id uuid; s_cust2_id uuid; s_cust3_id uuid;
  s_cust4_id uuid; s_cust5_id uuid;

  -- Customer IDs - Acme
  a_cust1_id uuid; a_cust2_id uuid; a_cust3_id uuid;

  -- Service location IDs
  s_loc1_id uuid; s_loc2_id uuid; s_loc3_id uuid;
  a_loc1_id uuid; a_loc2_id uuid;

  -- Product IDs - Sunrise
  s_prod1_id uuid; s_prod2_id uuid; s_prod3_id uuid;
  s_prod4_id uuid; s_prod5_id uuid;

  -- Product IDs - Acme
  a_prod1_id uuid; a_prod2_id uuid; a_prod3_id uuid;

  -- Work order IDs
  s_wo1_id uuid; s_wo2_id uuid; s_wo3_id uuid;
  a_wo1_id uuid; a_wo2_id uuid;

  -- Invoice IDs
  s_inv1_id uuid; s_inv2_id uuid;
  a_inv1_id uuid;

  -- Resources (shared)
  res_ids uuid[];

BEGIN

  RAISE NOTICE 'Creating tenants...';

  -- ══════════════════════════════════════════════════════
  -- TENANTS
  -- ══════════════════════════════════════════════════════
  INSERT INTO tenants (id, name, slug, industry_type, plan, is_active, base_currency, fiscal_year_start, phone, city, state, zip)
  VALUES
    (sunrise_id, 'Sunrise HVAC Company', 'sunrise-hvac', 'hvac', 'pro', true, 'USD', 1, '954-555-0100', 'Fort Lauderdale', 'FL', '33301'),
    (acme_id,    'Acme HVAC',            'acme-hvac',    'hvac', 'starter', true, 'USD', 1, '305-555-0200', 'Miami', 'FL', '33101');

  -- ══════════════════════════════════════════════════════
  -- TENANT SETTINGS (key-value store)
  -- ══════════════════════════════════════════════════════
  INSERT INTO tenant_settings (tenant_id, setting_key, setting_value) VALUES
    (sunrise_id, 'company_name',        'Sunrise HVAC Company'),
    (sunrise_id, 'address_line1',       '1234 Sunrise Blvd'),
    (sunrise_id, 'city',                'Fort Lauderdale'),
    (sunrise_id, 'state',               'FL'),
    (sunrise_id, 'zip',                 '33301'),
    (sunrise_id, 'phone',               '954-555-0100'),
    (sunrise_id, 'email',               'info@sunrisehvac.com'),
    (sunrise_id, 'website',             'www.sunrisehvac.com'),
    (sunrise_id, 'invoice_prefix',      'INV'),
    (sunrise_id, 'wo_prefix',           'WO'),
    (sunrise_id, 'next_invoice_number', '1001'),
    (sunrise_id, 'next_wo_number',      '2001'),
    (acme_id,    'company_name',        'Acme HVAC'),
    (acme_id,    'address_line1',       '5678 Brickell Ave'),
    (acme_id,    'city',                'Miami'),
    (acme_id,    'state',               'FL'),
    (acme_id,    'zip',                 '33101'),
    (acme_id,    'phone',               '305-555-0200'),
    (acme_id,    'email',               'info@acmehvac.com'),
    (acme_id,    'website',             'www.acmehvac.com'),
    (acme_id,    'invoice_prefix',      'INV'),
    (acme_id,    'wo_prefix',           'WO'),
    (acme_id,    'next_invoice_number', '1001'),
    (acme_id,    'next_wo_number',      '2001');

  -- ══════════════════════════════════════════════════════
  -- SECURITY GROUPS
  -- ══════════════════════════════════════════════════════
  sunrise_admin_grp := gen_random_uuid();
  sunrise_ro_grp    := gen_random_uuid();
  acme_admin_grp    := gen_random_uuid();
  acme_ro_grp       := gen_random_uuid();

  INSERT INTO security_groups (id, tenant_id, name, description, is_default, is_system)
  VALUES
    (sunrise_admin_grp, sunrise_id, 'Administrator', 'Full access to all modules', true,  true),
    (sunrise_ro_grp,    sunrise_id, 'Read Only',     'View-only access',           false, true),
    (acme_admin_grp,    acme_id,    'Administrator', 'Full access to all modules', true,  true),
    (acme_ro_grp,       acme_id,    'Read Only',     'View-only access',           false, true);

  -- ══════════════════════════════════════════════════════
  -- SEED PERMISSIONS (copy from resources table)
  -- ══════════════════════════════════════════════════════
  SELECT ARRAY(SELECT id FROM resources) INTO res_ids;

  IF array_length(res_ids, 1) > 0 THEN
    INSERT INTO group_permissions (tenant_id, group_id, resource_id, can_query, can_create, can_modify, can_delete, can_export, can_approve, can_admin)
    SELECT sunrise_id, sunrise_admin_grp, r.id, true, true, true, true, true, true, true FROM resources r
    ON CONFLICT DO NOTHING;

    INSERT INTO group_permissions (tenant_id, group_id, resource_id, can_query, can_create, can_modify, can_delete, can_export, can_approve, can_admin)
    SELECT sunrise_id, sunrise_ro_grp, r.id, true, false, false, false, false, false, false FROM resources r
    ON CONFLICT DO NOTHING;

    INSERT INTO group_permissions (tenant_id, group_id, resource_id, can_query, can_create, can_modify, can_delete, can_export, can_approve, can_admin)
    SELECT acme_id, acme_admin_grp, r.id, true, true, true, true, true, true, true FROM resources r
    ON CONFLICT DO NOTHING;

    INSERT INTO group_permissions (tenant_id, group_id, resource_id, can_query, can_create, can_modify, can_delete, can_export, can_approve, can_admin)
    SELECT acme_id, acme_ro_grp, r.id, true, false, false, false, false, false, false FROM resources r
    ON CONFLICT DO NOTHING;
  END IF;

  -- ══════════════════════════════════════════════════════
  -- AUTH USERS (with tenant_id in app_metadata)
  -- ══════════════════════════════════════════════════════
  RAISE NOTICE 'Creating auth users...';

  -- Sunrise users
  INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, aud, role)
  VALUES
    (gen_random_uuid(), 'owner@sunrisehvac.com',  crypt('Password123!', gen_salt('bf')), now(),
     jsonb_build_object('provider','email','providers',array['email']::text[],'tenant_id',sunrise_id),
     jsonb_build_object('full_name','Dan Sunrise'),   now(), now(), 'authenticated', 'authenticated'),
    (gen_random_uuid(), 'tech1@sunrisehvac.com',  crypt('Password123!', gen_salt('bf')), now(),
     jsonb_build_object('provider','email','providers',array['email']::text[],'tenant_id',sunrise_id),
     jsonb_build_object('full_name','Mike Torres'),   now(), now(), 'authenticated', 'authenticated'),
    (gen_random_uuid(), 'tech2@sunrisehvac.com',  crypt('Password123!', gen_salt('bf')), now(),
     jsonb_build_object('provider','email','providers',array['email']::text[],'tenant_id',sunrise_id),
     jsonb_build_object('full_name','Sarah Johnson'), now(), now(), 'authenticated', 'authenticated'),
    (gen_random_uuid(), 'office@sunrisehvac.com', crypt('Password123!', gen_salt('bf')), now(),
     jsonb_build_object('provider','email','providers',array['email']::text[],'tenant_id',sunrise_id),
     jsonb_build_object('full_name','Lisa Park'),     now(), now(), 'authenticated', 'authenticated');

  -- Acme users
  INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, aud, role)
  VALUES
    (gen_random_uuid(), 'owner@acmehvac.com',  crypt('Password123!', gen_salt('bf')), now(),
     jsonb_build_object('provider','email','providers',array['email']::text[],'tenant_id',acme_id),
     jsonb_build_object('full_name','John Acme'),   now(), now(), 'authenticated', 'authenticated'),
    (gen_random_uuid(), 'tech1@acmehvac.com',  crypt('Password123!', gen_salt('bf')), now(),
     jsonb_build_object('provider','email','providers',array['email']::text[],'tenant_id',acme_id),
     jsonb_build_object('full_name','Carlos Rivera'), now(), now(), 'authenticated', 'authenticated'),
    (gen_random_uuid(), 'office@acmehvac.com', crypt('Password123!', gen_salt('bf')), now(),
     jsonb_build_object('provider','email','providers',array['email']::text[],'tenant_id',acme_id),
     jsonb_build_object('full_name','Maria Gomez'),  now(), now(), 'authenticated', 'authenticated');

  -- Get auth user IDs
  SELECT id INTO sunrise_owner_auth  FROM auth.users WHERE email = 'owner@sunrisehvac.com';
  SELECT id INTO sunrise_tech1_auth  FROM auth.users WHERE email = 'tech1@sunrisehvac.com';
  SELECT id INTO sunrise_tech2_auth  FROM auth.users WHERE email = 'tech2@sunrisehvac.com';
  SELECT id INTO sunrise_office_auth FROM auth.users WHERE email = 'office@sunrisehvac.com';
  SELECT id INTO acme_owner_auth     FROM auth.users WHERE email = 'owner@acmehvac.com';
  SELECT id INTO acme_tech1_auth     FROM auth.users WHERE email = 'tech1@acmehvac.com';
  SELECT id INTO acme_office_auth    FROM auth.users WHERE email = 'office@acmehvac.com';

  -- ══════════════════════════════════════════════════════
  -- PUBLIC USERS
  -- ══════════════════════════════════════════════════════
  INSERT INTO users (id, tenant_id, email, full_name, is_owner, is_active, job_title, employment_type)
  VALUES
    (sunrise_owner_auth,  sunrise_id, 'owner@sunrisehvac.com',  'Dan Sunrise',   true,  true, 'Owner',       'full_time'),
    (sunrise_tech1_auth,  sunrise_id, 'tech1@sunrisehvac.com',  'Mike Torres',   false, true, 'Technician',  'full_time'),
    (sunrise_tech2_auth,  sunrise_id, 'tech2@sunrisehvac.com',  'Sarah Johnson', false, true, 'Technician',  'full_time'),
    (sunrise_office_auth, sunrise_id, 'office@sunrisehvac.com', 'Lisa Park',     false, true, 'Office Staff','full_time'),
    (acme_owner_auth,     acme_id,    'owner@acmehvac.com',     'John Acme',     true,  true, 'Owner',       'full_time'),
    (acme_tech1_auth,     acme_id,    'tech1@acmehvac.com',     'Carlos Rivera', false, true, 'Technician',  'full_time'),
    (acme_office_auth,    acme_id,    'office@acmehvac.com',    'Maria Gomez',   false, true, 'Office Staff','full_time');

  -- ══════════════════════════════════════════════════════
  -- USER GROUP MEMBERS
  -- ══════════════════════════════════════════════════════
  INSERT INTO user_group_members (tenant_id, user_id, group_id)
  VALUES
    (sunrise_id, sunrise_owner_auth,  sunrise_admin_grp),
    (sunrise_id, sunrise_tech1_auth,  sunrise_admin_grp),
    (sunrise_id, sunrise_tech2_auth,  sunrise_admin_grp),
    (sunrise_id, sunrise_office_auth, sunrise_admin_grp),
    (acme_id,    acme_owner_auth,     acme_admin_grp),
    (acme_id,    acme_tech1_auth,     acme_admin_grp),
    (acme_id,    acme_office_auth,    acme_admin_grp);

  -- ══════════════════════════════════════════════════════
  -- PAYMENT TERMS
  -- ══════════════════════════════════════════════════════
  s_terms_net30 := gen_random_uuid();
  s_terms_net15 := gen_random_uuid();
  a_terms_net30 := gen_random_uuid();
  a_terms_due   := gen_random_uuid();

  INSERT INTO terms (id, tenant_id, code, description, days_due, discount_pct, discount_days, is_active)
  VALUES
    (s_terms_net30, sunrise_id, 'NET30', 'Net 30 Days',       30, 0, 0, true),
    (s_terms_net15, sunrise_id, 'NET15', 'Net 15 Days',       15, 0, 0, true),
    (gen_random_uuid(), sunrise_id, 'DUE',   'Due on Receipt', 0,  0, 0, true),
    (a_terms_net30, acme_id,    'NET30', 'Net 30 Days',       30, 0, 0, true),
    (a_terms_due,   acme_id,    'DUE',   'Due on Receipt',    0,  0, 0, true);

  -- ══════════════════════════════════════════════════════
  -- TAX RATES
  -- ══════════════════════════════════════════════════════
  s_tax_fl := gen_random_uuid();
  a_tax_fl := gen_random_uuid();

  INSERT INTO tax_rates (id, tenant_id, code, description, rate, applies_to, is_default, is_active)
  VALUES
    (s_tax_fl, sunrise_id, 'FL-TAX', 'Florida Sales Tax', 7.000, 'parts', true,  true),
    (gen_random_uuid(), sunrise_id, 'EXEMPT', 'Tax Exempt',       0.000, 'all',   false, true),
    (a_tax_fl, acme_id,    'FL-TAX', 'Florida Sales Tax', 7.000, 'parts', true,  true),
    (gen_random_uuid(), acme_id,    'EXEMPT', 'Tax Exempt',       0.000, 'all',   false, true);

  -- ══════════════════════════════════════════════════════
  -- PAYMENT METHODS
  -- ══════════════════════════════════════════════════════
  INSERT INTO payment_methods (tenant_id, code, description, requires_ref, is_active)
  VALUES
    (sunrise_id, 'CC',    'Credit Card',   false, true),
    (sunrise_id, 'CHECK', 'Check',         true,  true),
    (sunrise_id, 'ACH',   'ACH Transfer',  true,  true),
    (sunrise_id, 'CASH',  'Cash',          false, true),
    (acme_id,    'CC',    'Credit Card',   false, true),
    (acme_id,    'CHECK', 'Check',         true,  true),
    (acme_id,    'CASH',  'Cash',          false, true);

  -- ══════════════════════════════════════════════════════
  -- PRODUCTS / CATALOG
  -- ══════════════════════════════════════════════════════
  s_prod1_id := gen_random_uuid(); s_prod2_id := gen_random_uuid();
  s_prod3_id := gen_random_uuid(); s_prod4_id := gen_random_uuid();
  s_prod5_id := gen_random_uuid();
  a_prod1_id := gen_random_uuid(); a_prod2_id := gen_random_uuid();
  a_prod3_id := gen_random_uuid();

  INSERT INTO products (id, tenant_id, product_code, name, description, category, unit, cost_price, sell_price, is_labor, track_inventory, is_active)
  VALUES
    (s_prod1_id, sunrise_id, 'LAB-REG', 'Regular Labor',         'Standard hourly labor rate',    'labor',   'hour',  65.00,  125.00, true,  false, true),
    (s_prod2_id, sunrise_id, 'LAB-OT',  'Overtime Labor',        'Overtime hourly labor rate',    'labor',   'hour',  97.50,  187.50, true,  false, true),
    (s_prod3_id, sunrise_id, 'FILT-16', '16x20 Air Filter',      'MERV 11 replacement filter',    'parts',   'each',  8.50,   22.00,  false, true,  true),
    (s_prod4_id, sunrise_id, 'REF-410', 'R-410A Refrigerant',    'Per pound refrigerant',         'parts',   'lb',    18.00,  55.00,  false, true,  true),
    (s_prod5_id, sunrise_id, 'MAINT-A', 'Annual Maintenance',    'Full system tune-up',           'service', 'each',  85.00,  189.00, false, false, true),
    (a_prod1_id, acme_id,    'LAB-REG', 'Regular Labor',         'Standard hourly labor rate',    'labor',   'hour',  60.00,  115.00, true,  false, true),
    (a_prod2_id, acme_id,    'LAB-OT',  'Overtime Labor',        'Overtime hourly labor rate',    'labor',   'hour',  90.00,  172.50, true,  false, true),
    (a_prod3_id, acme_id,    'FILT-20', '20x25 Air Filter',      'MERV 8 replacement filter',     'parts',   'each',  6.50,   18.00,  false, true,  true);

  -- Inventory stock for tracked products
  INSERT INTO inventory_stock (tenant_id, product_id, quantity_on_hand)
  VALUES
    (sunrise_id, s_prod3_id, 24),
    (sunrise_id, s_prod4_id, 50),
    (acme_id,    a_prod3_id, 36);

  -- ══════════════════════════════════════════════════════
  -- CUSTOMERS - SUNRISE
  -- ══════════════════════════════════════════════════════
  s_cust1_id := gen_random_uuid(); s_cust2_id := gen_random_uuid();
  s_cust3_id := gen_random_uuid(); s_cust4_id := gen_random_uuid();
  s_cust5_id := gen_random_uuid();

  INSERT INTO customers (id, tenant_id, customer_code, company_name, customer_type, contact_name, phone, email, address_line1, city, state, zip, country, terms_id, tax_rate_id, credit_limit, is_active)
  VALUES
    (s_cust1_id, sunrise_id, 'SUN-001', 'Broward Office Plaza',   'commercial',   'Tom Bradley',   '954-555-1001', 'tbradley@browardplaza.com',  '100 E Las Olas Blvd',   'Fort Lauderdale', 'FL', '33301', 'US', s_terms_net30, s_tax_fl, 10000, true),
    (s_cust2_id, sunrise_id, 'SUN-002', 'Palm Beach Resort',      'commercial',   'Susan White',   '561-555-1002', 'swhite@pbresort.com',         '200 Ocean Dr',          'Palm Beach',      'FL', '33480', 'US', s_terms_net30, s_tax_fl, 25000, true),
    (s_cust3_id, sunrise_id, 'SUN-003', 'Henderson Residence',    'residential',  'Bob Henderson', '954-555-1003', 'bob@henderson.net',           '45 Coral Way',          'Coral Springs',   'FL', '33065', 'US', s_terms_net15, s_tax_fl, 2500,  true),
    (s_cust4_id, sunrise_id, 'SUN-004', 'Sunrise Medical Center', 'commercial',   'Dr. Kim Park',  '954-555-1004', 'kpark@sunrisemedical.com',    '789 Medical Pkwy',      'Fort Lauderdale', 'FL', '33312', 'US', s_terms_net30, s_tax_fl, 50000, true),
    (s_cust5_id, sunrise_id, 'SUN-005', 'Coastal Retail Group',   'commercial',   'Amy Chen',      '954-555-1005', 'achen@coastalretail.com',     '321 Federal Hwy',       'Deerfield Beach', 'FL', '33441', 'US', s_terms_net30, s_tax_fl, 15000, true);

  -- ══════════════════════════════════════════════════════
  -- CUSTOMERS - ACME
  -- ══════════════════════════════════════════════════════
  a_cust1_id := gen_random_uuid(); a_cust2_id := gen_random_uuid();
  a_cust3_id := gen_random_uuid();

  INSERT INTO customers (id, tenant_id, customer_code, company_name, customer_type, contact_name, phone, email, address_line1, city, state, zip, country, terms_id, tax_rate_id, credit_limit, is_active)
  VALUES
    (a_cust1_id, acme_id, 'ACM-001', 'Miami Tower Corp',     'commercial',  'Robert Cruz',  '305-555-2001', 'rcruz@miamitower.com',    '1 Brickell Ave',    'Miami', 'FL', '33131', 'US', a_terms_net30, a_tax_fl, 20000, true),
    (a_cust2_id, acme_id, 'ACM-002', 'Doral Warehouse Inc',  'industrial',  'Pete Morales', '305-555-2002', 'pmorales@doralwh.com',    '8900 NW 33rd St',   'Doral', 'FL', '33122', 'US', a_terms_net30, a_tax_fl, 30000, true),
    (a_cust3_id, acme_id, 'ACM-003', 'Lopez Residence',      'residential', 'Ana Lopez',    '786-555-2003', 'ana@lopezfamily.net',     '456 SW 8th St',     'Miami', 'FL', '33130', 'US', a_terms_due,   a_tax_fl, 3000,  true);

  -- ══════════════════════════════════════════════════════
  -- SERVICE LOCATIONS
  -- ══════════════════════════════════════════════════════
  s_loc1_id := gen_random_uuid(); s_loc2_id := gen_random_uuid();
  s_loc3_id := gen_random_uuid();
  a_loc1_id := gen_random_uuid(); a_loc2_id := gen_random_uuid();

  INSERT INTO service_locations (id, tenant_id, customer_id, location_name, address_line1, city, state, zip, is_active)
  VALUES
    (s_loc1_id, sunrise_id, s_cust1_id, 'Main Building',       '100 E Las Olas Blvd',  'Fort Lauderdale', 'FL', '33301', true),
    (s_loc2_id, sunrise_id, s_cust2_id, 'Resort Main',         '200 Ocean Dr',          'Palm Beach',      'FL', '33480', true),
    (s_loc3_id, sunrise_id, s_cust4_id, 'Medical Center',      '789 Medical Pkwy',      'Fort Lauderdale', 'FL', '33312', true),
    (a_loc1_id, acme_id,    a_cust1_id, 'Tower Main Office',   '1 Brickell Ave',        'Miami',           'FL', '33131', true),
    (a_loc2_id, acme_id,    a_cust2_id, 'Doral Warehouse',     '8900 NW 33rd St',       'Doral',           'FL', '33122', true);

  -- ══════════════════════════════════════════════════════
  -- WORK ORDERS
  -- ══════════════════════════════════════════════════════
  s_wo1_id := gen_random_uuid(); s_wo2_id := gen_random_uuid();
  s_wo3_id := gen_random_uuid();
  a_wo1_id := gen_random_uuid(); a_wo2_id := gen_random_uuid();

  INSERT INTO work_orders (id, tenant_id, wo_number, customer_id, location_id, assigned_to, service_type, priority, status, scheduled_date, description, diagnosis, resolution)
  VALUES
    (s_wo1_id, sunrise_id, 'WO-2001', s_cust1_id, s_loc1_id, sunrise_tech1_auth, 'MAINT',  'NORMAL', 'completed',   '2026-04-10',
     'Annual AC maintenance - 3 rooftop units',
     'All units operational. Filters dirty, coils need cleaning.',
     'Replaced filters, cleaned evaporator coils, checked refrigerant levels. All units operating within spec.'),
    (s_wo2_id, sunrise_id, 'WO-2002', s_cust4_id, s_loc3_id, sunrise_tech2_auth, 'REPAIR', 'HIGH',   'in_progress', '2026-04-28',
     'Unit 2 not cooling - patient area affected',
     'Compressor running but low refrigerant pressure. Possible leak.',
     NULL),
    (s_wo3_id, sunrise_id, 'WO-2003', s_cust3_id, s_loc1_id,  sunrise_tech1_auth, 'INSPECT','NORMAL', 'scheduled',   '2026-05-05',
     'Pre-summer system inspection',
     NULL, NULL),
    (a_wo1_id, acme_id,    'WO-2001', a_cust1_id, a_loc1_id, acme_tech1_auth,    'MAINT',  'NORMAL', 'completed',   '2026-04-15',
     'Quarterly maintenance - floors 10-20',
     'Multiple AHUs inspected. Two filters needed replacement.',
     'Replaced 4 filters, lubricated fan bearings, tested thermostats. All systems normal.'),
    (a_wo2_id, acme_id,    'WO-2002', a_cust2_id, a_loc2_id, acme_tech1_auth,    'REPAIR', 'HIGH',   'scheduled',   '2026-05-02',
     'Warehouse cooling unit making loud noise',
     NULL, NULL);

  -- Work order lines
  INSERT INTO work_order_lines (tenant_id, work_order_id, line_number, line_type, description, quantity, unit, unit_price, unit_cost, is_taxable, line_total)
  VALUES
    -- WO-2001 Sunrise (completed)
    (sunrise_id, s_wo1_id, 1, 'labor', 'AC Maintenance - Labor',    3.0, 'hour', 125.00, 65.00, false, 375.00),
    (sunrise_id, s_wo1_id, 2, 'part',  '16x20 Air Filter',          6.0, 'each',  22.00,  8.50, true,  132.00),
    -- WO-2001 Acme (completed)
    (acme_id, a_wo1_id, 1, 'labor', 'Quarterly Maintenance Labor',  4.0, 'hour', 115.00, 60.00, false, 460.00),
    (acme_id, a_wo1_id, 2, 'part',  '20x25 Air Filter',             4.0, 'each',  18.00,  6.50, true,   72.00);

  -- ══════════════════════════════════════════════════════
  -- INVOICES
  -- ══════════════════════════════════════════════════════
  s_inv1_id := gen_random_uuid(); s_inv2_id := gen_random_uuid();
  a_inv1_id := gen_random_uuid();

  INSERT INTO invoices (id, tenant_id, customer_id, work_order_id, terms_id, invoice_number, invoice_date, due_date, status, subtotal, tax_amount, total, amount_paid, balance_due, notes)
  VALUES
    (s_inv1_id, sunrise_id, s_cust1_id, s_wo1_id, s_terms_net30, 'INV-1001', '2026-04-10', '2026-05-10', 'sent',
     507.00, 9.24, 516.24, 0.00, 516.24, 'Annual maintenance - 3 rooftop units'),
    (s_inv2_id, sunrise_id, s_cust2_id, NULL,      s_terms_net30, 'INV-1002', '2026-03-15', '2026-04-14', 'paid',
     375.00, 0.00, 375.00, 375.00, 0.00, 'Emergency repair - chiller unit'),
    (a_inv1_id, acme_id,    a_cust1_id, a_wo1_id,  a_terms_net30, 'INV-1001', '2026-04-15', '2026-05-15', 'sent',
     532.00, 5.04, 537.04, 0.00, 537.04, 'Quarterly maintenance floors 10-20');

  -- Invoice lines
  INSERT INTO invoice_lines (tenant_id, invoice_id, line_number, line_type, description, quantity, unit, unit_price, unit_cost, discount_pct, is_taxable, tax_amount, line_total)
  VALUES
    -- INV-1001 Sunrise
    (sunrise_id, s_inv1_id, 1, 'labor', 'AC Maintenance Labor',  3.0, 'hour', 125.00, 65.00, 0, false, 0.00,  375.00),
    (sunrise_id, s_inv1_id, 2, 'part',  '16x20 Air Filter',      6.0, 'each',  22.00,  8.50, 0, true,  9.24,  132.00),
    -- INV-1002 Sunrise (paid)
    (sunrise_id, s_inv2_id, 1, 'labor', 'Emergency Repair Labor', 3.0, 'hour', 125.00, 65.00, 0, false, 0.00, 375.00),
    -- INV-1001 Acme
    (acme_id, a_inv1_id, 1, 'labor', 'Quarterly Maintenance Labor', 4.0, 'hour', 115.00, 60.00, 0, false, 0.00, 460.00),
    (acme_id, a_inv1_id, 2, 'part',  '20x25 Air Filter',            4.0, 'each',  18.00,  6.50, 0, true,  5.04,  72.00);

  RAISE NOTICE '✅ Seed complete!';
  RAISE NOTICE 'Sunrise tenant: %', sunrise_id;
  RAISE NOTICE 'Acme tenant: %', acme_id;
  RAISE NOTICE '';
  RAISE NOTICE 'Login credentials (all use Password123!):';
  RAISE NOTICE 'Sunrise: owner@sunrisehvac.com, tech1@sunrisehvac.com, tech2@sunrisehvac.com, office@sunrisehvac.com';
  RAISE NOTICE 'Acme:    owner@acmehvac.com, tech1@acmehvac.com, office@acmehvac.com';

END $$;
