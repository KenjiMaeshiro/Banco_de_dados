CREATE DATABASE loja; 

use loja;

-- Criação de tabelas
CREATE TABLE cliente(
id_cliente int PRIMARY KEY NOT NULL,
nome varchar(75),
dt_nasc date,
numero int,
complemento varchar(50),
id_genero int,
id_cep char(9),
CONSTRAINT C_genero FOREIGN KEY (id_genero) references genero(id_genero),
CONSTRAINT C_cep FOREIGN KEY (id_cep) references cep(id_cep));

CREATE TABLE genero(
id_genero int PRIMARY KEY NOT NULL,
desc_genero varchar(10));

CREATE TABLE cep(
id_cep char(9) PRIMARY KEY NOT NULL,
logradouro varchar(100),
id_bairro int,
CONSTRAINT C_bairro FOREIGN KEY (id_bairro) references bairro(id_bairro));

CREATE TABLE bairro(
id_bairro int PRIMARY KEY NOT NULL,
nome_bairro varchar(50),
cidade varchar(50),
uf varchar(2),
CONSTRAINT C_uf FOREIGN KEY (uf) references uf(UF));

CREATE TABLE uf(
UF varchar(2) PRIMARY KEY NOT NULL,
estado varchar(50));

CREATE TABLE loja(
id_loja int PRIMARY KEY NOT NULL,
nome_loja varchar(50),
id_cep char(9),
CONSTRAINT C2_cep FOREIGN KEY (id_cep) references cep(id_cep));

CREATE TABLE vendedor(
id_vendedor int PRIMARY KEY NOT NULL,
nome_vendedor varchar(50),
perc_comiss double,
id_loja int,
CONSTRAINT C_loja FOREIGN KEY (id_loja) references loja(id_loja));

CREATE TABLE nota_fiscal(
num_nf int PRIMARY KEY NOT NULL,
data_nf date,
vl_frete double,
vl_comissao double,
id_cliente int,
id_oper_fiscal int,
id_vendedor int,
CONSTRAINT C_cliente FOREIGN KEY (id_cliente) references cliente(id_cliente),
CONSTRAINT C_vendedor FOREIGN KEY (id_vendedor) references vendedor (id_vendedor),
CONSTRAINT C_oper_fiscal FOREIGN KEY (id_oper_fiscal) references oper_fiscal (id_oper_fiscal));

CREATE TABLE oper_fiscal(
id_oper_fiscal int PRIMARY KEY NOT NULL,
nome_operacao varchar(50),
icms double,
ipi double,
pis double,
cofins double,
iss double,
ir double);

CREATE TABLE item_nf(
num_nf int NOT NULL,
id_produto int,
qtde int,
vl_unitario double,
vl_total double,
tt_impostos double,
CONSTRAINT C_produto FOREIGN KEY (id_produto) references produto (id_produto),
PRIMARY KEY (num_nf, id_produto));

CREATE TABLE produto(
id_produto int PRIMARY KEY NOT NULL,
nome varchar(50),
peso double,
preco double,
id_un_med int,
id_categ int,
CONSTRAINT C_un_med FOREIGN KEY (id_un_med) references un_medida (id_un_med),
CONSTRAINT C_categ FOREIGN KEY (id_categ) references categoria (id_categ));

CREATE TABLE un_medida(
id_un_med int PRIMARY KEY NOT NULL,
desc_unidade_medida varchar(50));

CREATE TABLE categoria(
id_categ int PRIMARY KEY NOT NULL,
nome_categoria varchar(50));

-- Inclusão de registros
-- Cliente
INSERT INTO bairro (id_bairro, nome_bairro) VALUES (1, 'Santo Ângelo');
INSERT INTO cep (id_cep, logradouro, id_bairro) VALUES ('11111-222', 'Rua Jaboticabal', 1);
INSERT INTO genero (id_genero, desc_genero) VALUES (1, 'Masculino');
INSERT INTO cliente (id_cliente, nome, dt_nasc, numero, complemento, id_genero, id_cep) VALUES
(1, 'Franciso Souza Cruz', '2003-05-01', 345, 'Jd', 1, '11111-222');

-- Produto
INSERT INTO categoria (id_categ, nome_categoria) VALUES (1, 'MATINAIS');
INSERT INTO un_medida (id_un_med, desc_unidade_medida) VALUES (1, 'Gramas');
INSERT INTO produto (id_produto, nome, peso, preco, id_un_med, id_categ) VALUES
(1, 'Caixa de Cereal', 250, 8.78, 1, 1);

-- Nova venda
INSERT INTO loja (id_loja, nome_loja) VALUES (1, 'Atacadão'); 
INSERT INTO vendedor (id_vendedor, nome_vendedor, perc_comiss, id_loja) VALUES (1, 'Lucas', 5, 1);
INSERT INTO oper_fiscal (id_oper_fiscal, nome_operacao, icms, ipi, pis, cofins, iss, ir) VALUES
(1, 'Venda', 0, 0, 0, 0, 0, 0);
INSERT INTO categoria (id_categ, nome_categoria) VALUES (2, 'PADARIA'), (3, 'Bebidas');
INSERT INTO produto (id_produto, nome, id_categ) VALUES (2, 'pão', 2), (3, 'refrigerante', 3);
INSERT INTO nota_fiscal (num_nf, data_nf, vl_frete, vl_comissao, id_cliente, id_oper_fiscal, id_vendedor) VALUES
(1, '2026-09-20', 0, 0, 1, 1, 1);
INSERT INTO item_nf (num_nf, id_produto, qtde) VALUES (1, 1, 1), (1, 2, 2), (1, 3, 3);


-- Elaboração de consultas
-- 1)
SET SQL_SAFE_UPDATES = 0;
INSERT INTO produto (id_produto, nome, peso, preco, id_un_med, id_categ) VALUES
(4, 'suco de laranja', 0.1, 4.00, NULL, 3);
INSERT INTO nota_fiscal (num_nf, data_nf, vl_frete, vl_comissao, id_cliente, id_oper_fiscal, id_vendedor) VALUES
(2, '2026-02-05', 10.00, 5.00, NULL, NULL, NULL),
(3, '2026-02-15', 12.00, 6.00, NULL, NULL, NULL),
(4, '2026-02-25', 8.00, 4.00, NULL, NULL, NULL);
select * from item_nf;
INSERT INTO item_nf (num_nf, id_produto, qtde, vl_unitario, vl_total, tt_impostos) VALUES
(2, 2, 2, 1.50, 3.00, 0.50),
(3, 3, 1, 3.00, 3.00, 1.00),
(4, 4, 3, 4.00, 12.00, 2.00);
SELECT p.nome AS produto,
       i.qtde,
       i.vl_total
FROM item_nf i
INNER JOIN nota_fiscal nf ON i.num_nf = nf.num_nf
INNER JOIN produto p ON i.id_produto = p.id_produto
WHERE nf.data_nf >= '2026-02-01' AND nf.data_nf <= '2026-02-28';

-- 2)
INSERT INTO vendedor (id_vendedor, nome_vendedor, perc_comiss, id_loja) VALUES
(2, 'Pedro Henrique', 0.05, 1);
UPDATE nota_fiscal SET id_vendedor = 1 WHERE num_nf = 2; 
UPDATE nota_fiscal SET id_vendedor = 1 WHERE num_nf = 3; 
UPDATE nota_fiscal SET id_vendedor = 2 WHERE num_nf = 4; 
select *from nota_fiscal;
SELECT v.nome_vendedor AS vendedor,
       i.vl_total,
       nf.vl_comissao
FROM nota_fiscal nf
INNER JOIN vendedor v ON nf.id_vendedor = v.id_vendedor
INNER JOIN item_nf i ON i.num_nf = nf.num_nf;

-- 3) 
INSERT INTO genero (id_genero, desc_genero) VALUES (2, 'Feminino');
INSERT INTO cliente (id_cliente, nome, dt_nasc, numero, complemento, id_genero, id_cep) VALUES
(2, 'Yasmin Ferreia', '1990-05-10', NULL, NULL, 2, NULL),
(3, 'João Paulo', '1985-08-20', NULL, NULL, 1, NULL),
(4, 'Ana Luiza', '1998-03-15', NULL, NULL, 2, NULL);
UPDATE nota_fiscal SET data_nf = '2026-01-05' WHERE num_nf = 2; 
UPDATE nota_fiscal SET data_nf = '2026-01-015' WHERE num_nf = 3; 
UPDATE nota_fiscal SET data_nf = '2026-01-025' WHERE num_nf = 4; 
SELECT c.nome,
       g.desc_genero AS genero,
       (YEAR(CURDATE()) - YEAR(c.dt_nasc)) AS idade
FROM cliente c
INNER JOIN genero g ON c.id_genero = g.id_genero
INNER JOIN nota_fiscal nf_jan ON nf_jan.id_cliente = c.id_cliente
                              AND nf_jan.data_nf >= '2026-01-01' AND nf_jan.data_nf <= '2026-01-31'
LEFT JOIN nota_fiscal nf_fev ON nf_fev.id_cliente = c.id_cliente
                              AND nf_fev.data_nf >= '2026-02-01' AND nf_fev.data_nf <= '2026-02-28'
WHERE nf_fev.num_nf IS NULL;

-- 4) 
SELECT cat.nome_categoria AS categoria,
       p.nome AS produto
FROM produto p
INNER JOIN categoria cat ON p.id_categ = cat.id_categ
ORDER BY cat.nome_categoria;


-- 5)
UPDATE cliente SET dt_nasc = '1990-02-10' WHERE id_cliente = 2;
UPDATE cliente SET dt_nasc = '1998-02-15' WHERE id_cliente = 4;

INSERT INTO bairro (id_bairro, nome_bairro) VALUES (2, 'Gonzaga'), (3, 'Embaré');
INSERT INTO cep (id_cep, logradouro, id_bairro) VALUES ('11055-000', 'Av. Ana Costa', 2), ('11045-000', 'Av. Bartolomeu de Gusmão', 3);
UPDATE cliente SET id_cep = '11055-000' WHERE id_cliente = 2;
UPDATE cliente SET id_cep = '11045-000' WHERE id_cliente = 4;

SELECT c.nome,
       (YEAR(CURDATE()) - YEAR(c.dt_nasc)) AS idade,
       b.nome_bairro AS bairro
FROM cliente c
INNER JOIN cep ce ON c.id_cep = ce.id_cep
INNER JOIN bairro b ON ce.id_bairro = b.id_bairro
WHERE c.id_genero = 2
  AND MONTH(c.dt_nasc) = 2;
