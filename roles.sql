-- Implementing roles in our database.

-- Inventory manager: Essentially a superuser.
DROP OWNED BY inventory_manager;
DROP ROLE inventory_manager;
CREATE ROLE inventory_manager WITH SUPERUSER LOGIN PASSWORD 'invmgr';

-- Product manager: Deals with products.
DROP OWNED BY product_manager;
DROP ROLE product_manager;
CREATE ROLE product_manager WITH LOGIN PASSWORD 'pdtmgr';
GRANT ALL ON brand, category, product, product_brand, product_category TO product_manager;

-- Supply manager: Deals with suppliers.
DROP OWNED BY supply_manager;
DROP ROLE supply_manager;
CREATE ROLE supply_manager WITH LOGIN PASSWORD 'supmgr';
GRANT ALL ON supplier, supplies, invoice TO supply_manager;
GRANT SELECT ON product, brand, category, product_brand, product_category TO supply_manager;

-- Cashier: Deals with payments.
DROP OWNED BY cashier;
DROP ROLE cashier;
CREATE ROLE cashier WITH LOGIN PASSWORD 'cashier';
GRANT ALL ON customer_payment, invoice_payment TO cashier;
GRANT SELECT ON supplies, orders, customer_order, invoice TO cashier;
GRANT UPDATE ON customer_order, invoice TO cashier;
GRANT SELECT, UPDATE ON product TO cashier;

-- Customer Support Staff: Deals with customers.
DROP OWNED BY customer_support_staff;
DROP ROLE customer_support_staff;
CREATE ROLE customer_support_staff WITH LOGIN PASSWORD 'staff';
GRANT SELECT ON customer, brand, category TO customer_support_staff; 
GRANT SELECT ON product_brand, product_category TO customer_support_staff;

GRANT ALL ON customer_order TO customer_support_staff;
GRANT ALL ON orders TO customer_support_staff;
GRANT SELECT, UPDATE ON product TO customer_support_staff;

-- Procedure privileges.
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO supply_manager, customer_support_staff;

REVOKE EXECUTE ON PROCEDURE place_order(INT, INT, INT) FROM public;
REVOKE EXECUTE ON PROCEDURE place_invoice(INT, INT, INT, NUMERIC) FROM public;
REVOKE EXECUTE ON PROCEDURE pay_order(INT, INT, NUMERIC, VARCHAR) FROM public;
REVOKE EXECUTE ON PROCEDURE pay_invoice(INT, INT, NUMERIC, VARCHAR) FROM public;

GRANT EXECUTE ON PROCEDURE place_order(INT, INT, INT) TO customer_support_staff;
GRANT EXECUTE ON PROCEDURE place_invoice(INT, INT, INT, NUMERIC) TO supply_manager;
GRANT EXECUTE ON PROCEDURE pay_order(INT, INT, NUMERIC, VARCHAR) TO cashier;
GRANT EXECUTE ON PROCEDURE pay_invoice(INT, INT, NUMERIC, VARCHAR) TO cashier;