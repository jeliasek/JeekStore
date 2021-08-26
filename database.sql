DROP DATABASE IF EXISTS launchstore;
CREATE DATABASE launchstore;

-- TABLES 
CREATE TABLE "products" (
  "id" SERIAL PRIMARY KEY,
  "category_id" INT NOT NULL,
  "user_id" INT,
  "name" TEXT NOT NULL,
  "description" TEXT NOT NULL,
  "old_price" INT,
  "price" INT NOT NULL,
  "quantity" INT DEFAULT 0,
  "status" INT DEFAULT 1,
  "created_at" TIMESTAMP DEFAULT 'now()',
  "updated_at" TIMESTAMP DEFAULT 'now()'
);

CREATE TABLE "categories" (
  "id" SERIAL PRIMARY KEY,
  "name" TEXT NOT NULL
);

CREATE TABLE "files" (
  "id" SERIAL PRIMARY KEY,
  "name" TEXT,
  "path" TEXT NOT NULL,
  "product_id" INT
);

CREATE TABLE "users" (
  "id" SERIAL PRIMARY KEY,
  "name" TEXT NOT NULL,
  "email" TEXT UNIQUE NOT NULL,
  "password" TEXT NOT NULL,
  "cpf_cnpj" TEXT UNIQUE NOT NULL,
  "cep" TEXT,
  "address" TEXT,
  "created_at" TIMESTAMP DEFAULT 'now()',
  "updated_at" TIMESTAMP DEFAULT 'now()'
);

CREATE TABLE "orders" (
  "id" SERIAL PRIMARY KEY,
  "seller_id" INT NOT NULL,
  "buyer_id" INT NOT NULL,
  "product_id" INT NOT NULL,
  "price" INT NOT NULL,
  "quantity" INT DEFAULT 0,
  "total" INT NOT NULL,
  "status" TEXT NOT NULL,
  "created_at" TIMESTAMP DEFAULT 'now()',
  "updated_at" TIMESTAMP DEFAULT 'now()'
);

-- FOREING KEYS
ALTER TABLE "products" ADD FOREIGN KEY ("category_id") REFERENCES "categories" ("id");

ALTER TABLE "files" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id");

ALTER TABLE "products" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "orders" ADD FOREIGN KEY ("seller_id") REFERENCES "users" ("id");
ALTER TABLE "orders" ADD FOREIGN KEY ("buyer_id") REFERENCES "users" ("id");
ALTER TABLE "orders" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id");

-- PROCEDURES
CREATE FUNCTION trigger_set_TIMESTAMP()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGERS
-- AUTO UPDATED_AT PRODUCTS
CREATE TRIGGER set_TIMESTAMP_products
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_TIMESTAMP();

-- AUTO UPDATED_AT USERS
CREATE TRIGGER set_TIMESTAMP_users
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_TIMESTAMP();

-- AUTO UPDATED_AT ORDERS
CREATE TRIGGER set_TIMESTAMP_orders
BEFORE UPDATE ON orders
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_TIMESTAMP();

-- INSERT CATEGORIES
INSERT INTO categories(name) VALUES ('comida');
INSERT INTO categories(name) VALUES ('eletrônicos');
INSERT INTO categories(name) VALUES ('automóveis');

-- SESSIONS
CREATE TABLE "session" (
  "sid" VARCHAR NOT NULL COLLATE "default",
  "sess" JSON NOT NULL,
  "expire" TIMESTAMP(6) NOT NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "session" ADD CONSTRAINT "session_pkey" PRIMARY KEY ("sid") NOT DEFERRABLE INITIALLY IMMEDIATE;

-- TOKEN PASSWORD RECOVERY
ALTER TABLE "users" ADD COLUMN reset_token text;
ALTER TABLE "users" ADD COLUMN reset_token_expires text;

-- DELETE ON CASCADE
ALTER TABLE "products"
DROP CONSTRAINT products_user_id_fkey,
ADD CONSTRAINT products_user_id_fkey
FOREIGN KEY ("user_id")
REFERENCES "users" ("id")
ON DELETE CASCADE;

ALTER TABLE "files"
DROP CONSTRAINT files_product_id_fkey,
ADD CONSTRAINT files_product_id_fkey
FOREIGN KEY ("product_id")
REFERENCES "products" ("id")
ON DELETE CASCADE;


-- SOFT DELETE
ALTER TABLE products ADD COLUMN "deleted_at" timestamp;

CREATE OR REPLACE RULE delete_product AS
ON DELETE TO products DO INSTEAD
UPDATE products
SET deleted_at = now()
WHERE products.id = OLD.id;

CREATE OR REPLACE VIEW products_without_deleted AS
SELECT * FROM products WHERE deleted_at IS null;

ALTER TABLE products RENAME TO products_with_deleted;
ALTER VIEW products_without_deleted RENAME TO products;

/*
--TO RUN SEEDS
DELETE FROM products;
DELETE FROM users;
DELETE FROM files;

--ALTER SEQUENCE AUTO_INCREMENT FROM TABLES IDS
ALTER SEQUENCE products_id_seq RESTART WITH 1;
ALTER SEQUENCE users_id_seq RESTART WITH 1;
ALTER SEQUENCE files_id_seq RESTART WITH 1;
*/
