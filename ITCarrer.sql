CREATE DATABASE factory;
USE factory;

CREATE TABLE products
(
	product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    size VARCHAR(20),
    price DECIMAL(10, 2) NOT NULL,
    quantity_in_stock INT NOT NULL
);

CREATE TABLE materials
(
	material_id INT AUTO_INCREMENT PRIMARY KEY,
    material_name VARCHAR(255) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    supplier VARCHAR(255),
    quantity_in_stock INT NOT NULL
);

CREATE TABLE employees
(
	employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    position VARCHAR(255),
    hire_date DATE,
    salary DECIMAL(10, 2)
);

CREATE TABLE product_materials
(
	product_id INT NOT NULL,
    material_id INT NOT NULL,
    quantity_used INT NOT NULL,
    CONSTRAINT pk_product_materials PRIMARY KEY (product_id,material_id),
    CONSTRAINT fk_product_id FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT fk_materials_id FOREIGN KEY (material_id) REFERENCES materials(material_id)
);

CREATE TABLE orders
(
	order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(255) NOT NULL,
    order_date DATE,
    delivery_date DATE,
    total_amount DECIMAL(10, 2) NOT NULL
);

CREATE TABLE order_products
(
	order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL, 
    subtotal DECIMAL(10, 2), 
    CONSTRAINT pk_order_products PRIMARY KEY (order_id,product_id),
    CONSTRAINT fk_order_id FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_product_id_1 FOREIGN KEY (product_id) REFERENCES products(product_id)
);
DROP DATABASE factory;

SELECT materials.material_name AS "name"
FROM materials
ORDER BY materials.material_name LIMIT 5;

SELECT materials.material_name AS "material_name",
materials.unit_price AS "unit_price",
materials.supplier AS "supplier",
materials.quantity_in_stock AS "quantiny_in_stock"
FROM materials
WHERE materials.quantity_in_stock < 2000
ORDER BY materials.material_id DESC LIMIT 3;

SELECT products.product_name AS "product_name"
FROM products
WHERE product_id IN
(
	SELECT product_materials.product_id
    FROM product_materials
    WHERE product_materials.material_id = (SELECT materials.material_id 
    FROM materials
    WHERE material_name = "Denim")
)
ORDER BY products.product_name DESC LIMIT 3;

SELECT products.product_name AS "product_name"
FROM products 
JOIN order_products ON order_products.product_id = products.product_id
GROUP BY products.product_name
ORDER BY COUNT(order_products.product_id) DESC LIMIT 3;

SELECT ROUND(AVG(employees.salary),2) AS "average_salary"
FROM employees
WHERE employees.position = "Supervisor";

SELECT orders.customer_name AS "customer_name"
FROM orders
JOIN order_products ON order_products.order_id = orders.order_id
JOIN products ON products.product_id = order_products.product_id
JOIN product_materials ON product_materials.product_id = products.product_id
JOIN materials ON materials.material_id = product_materials.material_id
WHERE materials.material_name = "Silk"
ORDER BY orders.customer_name;

SELECT MAX(products.price) AS "price"
FROM products