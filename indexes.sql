-- Hash Index on product name.
CREATE INDEX IF NOT EXISTS name_index ON product USING HASH(product_name);

-- BTree Indexes over dates (invoices & orders & their payments).
CREATE INDEX IF NOT EXISTS invoice_date_index ON invoice USING BTREE(invoice_date);
CREATE INDEX IF NOT EXISTS order_date_index ON customer_order USING BTREE(order_date);

CREATE INDEX IF NOT EXISTS invoice_payment_date_index ON invoice_payment USING BTREE(payment_date);
CREATE INDEX IF NOT EXISTS order_payment_date_index ON customer_payment USING BTREE(payment_date);

-- BTree Index over selling prices of products.
CREATE INDEX IF NOT EXISTS price_index ON product USING BTREE(selling_price);