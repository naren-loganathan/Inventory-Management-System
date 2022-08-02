-- Trigger for automatically setting the depth when a new category is inserted into the category table.
CREATE OR REPLACE FUNCTION depth_fix()
RETURNS trigger
AS $$
DECLARE par_depth INT;
BEGIN
    IF (NEW.parent_id IS NULL) THEN
        par_depth = -1;
    ELSE
        SELECT depth INTO par_depth FROM category WHERE category.category_id = NEW.parent_id;
    END IF;

    UPDATE category SET depth = par_depth + 1 WHERE category.category_id = NEW.category_id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER depth_trigger
AFTER INSERT ON category
FOR EACH ROW EXECUTE PROCEDURE depth_fix();

-- Trigger for automatically moving reserved stock back to the available stock upon cancellation.
CREATE OR REPLACE FUNCTION move_stock()
RETURNS trigger
AS $$
DECLARE pdt_id INT;
DECLARE qty INT;
BEGIN
    SELECT quantity INTO qty FROM customer_order WHERE order_id = OLD.order_id; 
    SELECT product_id INTO pdt_id FROM orders WHERE order_id = OLD.order_id; 
    UPDATE product SET stock = stock + qty WHERE product_id = pdt_id;
    UPDATE product SET reserved_stock = reserved_stock - qty WHERE product_id = pdt_id;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER replace_stock
AFTER UPDATE ON customer_order
FOR EACH ROW
WHEN (OLD.status IS DISTINCT FROM 'CANCELLED' AND NEW.status = 'CANCELLED')
EXECUTE PROCEDURE move_stock();