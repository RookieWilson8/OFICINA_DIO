

use oficina;

-- Questões
-- 01. Quando foi o total do faturamento
SELECT CONCAT('R$ ', FORMAT(SUM(valor_total_pgto_nota),2,'de_DE')) as 'Total_Faturamento_Oficina' FROM pagtos_nota; /*
+---------------------------+
| Total_Faturamento_Oficina |
+---------------------------+
| R$ 1.020.566,00           |
+---------------------------+ */

-- 02. Quando foi o total para cada forma de pagamento 
SELECT pagamento_tipo, 
	   CONCAT('R$ ', FORMAT(SUM(valor_total_pgto_nota),2,'de_DE')) as Total_por_Forma_Pagamento 
FROM pagtos_nota GROUP BY pagamento_tipo
ORDER BY SUM(valor_total_pgto_nota); /*
+----------------+---------------------------+
| pagamento_tipo | Total_por_Forma_Pagamento |
+----------------+---------------------------+
| Débito         | R$ 136.694,00             |
| Crédito        | R$ 197.192,00             |
| Pix            | R$ 254.945,00             |
| dinheiro       | R$ 431.735,00             |
+----------------+---------------------------+*/

-- 03. Quando foi a média  para cada forma de pagamento 
SELECT pagamento_tipo, 
CONCAT('R$ ', FORMAT(AVG(valor_total_pgto_nota),2,'de_DE')) as Media_Forma_Pagamento 
FROM pagtos_nota GROUP BY pagamento_tipo
ORDER BY AVG(valor_total_pgto_nota); /*
+----------------+-----------------------+
| pagamento_tipo | Media_Forma_Pagamento |
+----------------+-----------------------+
| Crédito        | R$ 4.809,56           |
| Pix            | R$ 4.998,92           |
| Débito         | R$ 5.257,46           |
| dinheiro       | R$ 5.265,06           |
+----------------+-----------------------+ */

-- 04. A quantidade de ocorrências de cada forma de pagamento 
SELECT pagamento_tipo, COUNT(valor_total_pgto_nota) as 'Qtd_Pagamentos'
FROM pagtos_nota
GROUP BY pagamento_tipo 
ORDER BY COUNT(valor_total_pgto_nota); /*
+----------------+----------------+
| pagamento_tipo | Qtd_Pagamentos |
+----------------+----------------+
| Débito         |             26 |
| Crédito        |             41 |
| Pix            |             51 |
| dinheiro       |             82 |
+----------------+----------------+*/

-- 05. Quantidade de Pagamentos acima do Ticket Medio
SELECT pagamento_tipo, COUNT(valor_total_pgto_nota) as 'Qtd_acima_media'
FROM pagtos_nota
WHERE valor_total_pgto_nota > (SELECT AVG(valor_total_pgto_nota) FROM pagtos_nota)
GROUP BY pagamento_tipo
ORDER BY  COUNT(valor_total_pgto_nota); /*
+----------------+-----------------+
| pagamento_tipo | Qtd_acima_media |
+----------------+-----------------+
| Débito         |              15 |
| Crédito        |              22 |
| Pix            |              28 |
| dinheiro       |              46 |
+----------------+-----------------+ */

-- 06. Quando foi o faturamento por mês
SELECT MONTH(data_nota) as mes, YEAR(data_nota) as ano, 
CONCAT('R$ ', FORMAT(AVG(valor_total_pgto_nota),2,'de_DE')) 
FROM pagtos_nota
GROUP BY mes
ORDER BY mes; /*
+-----+------+-------------------------------------------------------------+
| mes | ano  | CONCAT('R$ ', FORMAT(AVG(valor_total_pgto_nota),2,'de_DE')) |
+-----+------+-------------------------------------------------------------+
|   1 | 2023 | R$ 4.643,71                                                 |
|   2 | 2022 | R$ 3.817,13                                                 |
|   3 | 2022 | R$ 6.140,81                                                 |
|   4 | 2022 | R$ 3.563,44                                                 |
|   5 | 2022 | R$ 3.778,43                                                 |
|   6 | 2023 | R$ 4.842,15                                                 |
|   7 | 2022 | R$ 5.045,13                                                 |
|   8 | 2022 | R$ 5.992,07                                                 |
|   9 | 2022 | R$ 3.798,38                                                 |
|  10 | 2022 | R$ 4.717,63                                                 |
|  11 | 2022 | R$ 4.310,56                                                 |
|  12 | 2022 | R$ 638,00                                                   |
+-----+------+-------------------------------------------------------------+*/

-- 07. O Faturamento mensal para cada Forma de Pagamento
SELECT  
    MONTH(data_nota) as mes, 
    YEAR(data_nota) as ano,
    (SELECT  CONCAT('R$ ', FORMAT(SUM(valor_total_pgto_nota),2,'de_DE')) FROM pagtos_nota WHERE pagamento_tipo = 'pix' and MONTH(data_nota) = mes) as Total_pix ,
    (SELECT CONCAT('R$ ', FORMAT(SUM(valor_total_pgto_nota),2,'de_DE'))  FROM pagtos_nota WHERE pagamento_tipo = 'dinheiro' and MONTH(data_nota) = mes) as Total_dinheiro,
	(SELECT CONCAT('R$ ', FORMAT(SUM(valor_total_pgto_nota),2,'de_DE'))  FROM pagtos_nota WHERE pagamento_tipo = 'Crédito' and MONTH(data_nota) = mes) as Total_Crédito,
    (SELECT CONCAT('R$ ', FORMAT(SUM(valor_total_pgto_nota),2,'de_DE'))  FROM pagtos_nota WHERE pagamento_tipo = 'Débito' and MONTH(data_nota) = mes) as Total_Debito,
    CONCAT('R$ ', FORMAT(SUM(valor_total_pgto_nota),2,'de_DE'))  as Total
FROM pagtos_nota
GROUP BY mes
ORDER BY mes;  /*
+-----+------+---------------+----------------+---------------+--------------+---------------+
| mes | ano  | Total_pix     | Total_dinheiro | Total_Crédito | Total_Debito | Total         |
+-----+------+---------------+----------------+---------------+--------------+---------------+
|   1 | 2023 | R$ 8.010,00   | R$ 17.419,00   | R$ 7.077,00   | null         | R$ 32.506,00  |
|   2 | 2022 | R$ 8.020,00   | R$ 5.908,00    | R$ 16.609,00  | null         | R$ 30.537,00  |
|   3 | 2022 | R$ 107.098,00 | R$ 174.303,00  | R$ 85.337,00  | R$ 56.978,00 | R$ 423.716,00 |
|   4 | 2022 | R$ 6.321,00   | R$ 10.605,00   | R$ 7.047,00   | R$ 8.098,00  | R$ 32.071,00  |
|   5 | 2022 | R$ 7.591,00   | R$ 16.447,00   | null          | R$ 2.411,00  | R$ 26.449,00  |
|   6 | 2023 | R$ 11.131,00  | R$ 28.844,00   | R$ 16.067,00  | R$ 6.906,00  | R$ 62.948,00  |
|   7 | 2022 | R$ 30.196,00  | R$ 21.313,00   | R$ 3.122,00   | R$ 26.091,00 | R$ 80.722,00  |
|   8 | 2022 | R$ 25.162,00  | R$ 37.009,00   | R$ 14.244,00  | R$ 13.466,00 | R$ 89.881,00  |
|   9 | 2022 | R$ 5.168,00   | R$ 32.560,00   | R$ 10.517,00  | R$ 12.529,00 | R$ 60.774,00  |
|  10 | 2022 | R$ 36.366,00  | R$ 68.918,00   | R$ 31.185,00  | R$ 5.060,00  | R$ 141.529,00 |
|  11 | 2022 | R$ 9.882,00   | R$ 18.409,00   | R$ 5.349,00   | R$ 5.155,00  | R$ 38.795,00  |
|  12 | 2022 | null          | null           | R$ 638,00     | null         | R$ 638,00     |
+-----+------+---------------+----------------+---------------+--------------+---------------+ */


-- 08. Lista de Carros que estão na oficina
SELECT marca, modelo, carroceria, cor
FROM veiculos INNER JOIN carros on id_veiculo = id_veiculo_carro; /*
+-------------+------------+------------+--------+
| marca       | modelo     | carroceria | cor    |
+-------------+------------+------------+--------+
| Peugeot     | 208        | Hatch      | prata  |
| Volkswagen  | Voyage     | Hatch      | verde  |
| Fiat        |  Cronos    | Hatch      | preto  |
| Renault     | Kwid       | Hatch      | preto  |
| Fiat        | Argo       | Hatch      | branco |
| Volkswagen  | Gol        | Hatch      | preto  |
| Fiat        | Mobi       | Hatch      | branco |
| Chevrolet   | Onix Plus  | Hatch      | branco |
| Chevrolet   | Onix       | Hatch      | prata  |
| Hyundai     | HB20       | Hatch      | branco |
| Volkswagen  | Polo       | Hatch      | branco |
| Volkswagen  | Savero     | Hatch      | cinza  |
| Ford        | Fiesta     | Hatch      | preto  |
| Ford        | Ka         | Hatch      | cinza  |
| Ford        | Focus      | Hatch      | branco |
| Volkswagen  | Fusca      | Hatch      | cinza  |
| Fial        | Uno        | Hatch      | marron |
| Fial        | Gol        | Hatch      | preto  |
| Renault     | Kwid       | Hatch      | preto  |
| Fiat        | Argo       | Hatch      | preto  |
| Fial        | Gol        | Sedan      | prata  |
| Honda       | Civic      | Sedan      | prata  |
+-------------+------------+------------+--------+ */

-- 09. Lista de Motos que estão na oficina
SELECT marca, modelo, tipo_moto
FROM veiculos INNER JOIN motos on id_veiculo = id_veiculo_moto; /*
+----------+--------------+-----------+
| marca    | modelo       | tipo_moto |
+----------+--------------+-----------+
| Honda    | Biz 110//123 | esportiva |
| Suzuki   | SV650        | esportiva |
| Yamaha   | Fazer FZ25   | esportiva |
| Honda    | NXR 160 Bros | esportiva |
| Honda    | POP 110      | esportiva |
| Kawasaki | Ninja 300    | esportiva |
| Yamaha   | YZF-R3       | esportiva |
+----------+--------------+-----------+ */

-- 10. Quantidade de Veiculos na Oficina
SELECT COUNT(*) as 'Veiculos_na_oficina' from veiculos; /*
+---------------------+
| Veiculos_na_oficina |
+---------------------+
|                  30 |
+---------------------+ */

-- 11. Quanridades de clientes no Cadastro
SELECT COUNT(*) as 'Clientes_da_oficina' from clientes; /*
+---------------------+
| Clientes_da_oficina |
+---------------------+
|                  30 |
+---------------------+ */

-- 12. Quantos Clientes estão sendo atendidos no momento.
SELECT count(*)
FROM clientes NATURAL JOIN veiculos; /*
+----------+
| count(*) |
+----------+
|       30 |
+----------+ */

-- 13. Clientes que tem mais de um veículo na Oficina
SELECT nome_cliente, COUNT(id_veiculo) as 'qtd_veiculo_do_cliente'
FROM clientes NATURAL JOIN veiculos
GROUP BY id_cliente
HAVING COUNT(id_veiculo) > 1; /*
+----------------------------+------------------------+
| nome_cliente               | qtd_veiculo_do_cliente |
+----------------------------+------------------------+
| Maria  da Silva            |                      2 |
| Júlia Rodrigues            |                      2 |
| Beatriz Alves              |                      3 |
| Maria da Costa             |                      2 |
| Alice Carvalho             |                      2 |
| Júnior Barbosa             |                      2 |
| Ana Clara Rodrigues Costa  |                      2 |
| Lucas Gabriel Pereira Lima |                      2 |
+----------------------------+------------------------+ */

-- 14. Quantidade de Cada tipo de veiculo na Oficina
SELECT tipo_veiculo, COUNT(*) as 'Qtd_por_Tipo_Veiculo'
FROM clientes NATURAL JOIN veiculos
GROUP BY tipo_veiculo; /*
+--------------+----------------------+
| tipo_veiculo | Qtd_por_Tipo_Veiculo |
+--------------+----------------------+
| Carro        |                   23 |
| Moto         |                    7 |
+--------------+----------------------+ */

-- 13. Quantidade de Atendimentos em cada Veículo
SELECT nome_cliente, tipo_veiculo, marca, modelo, count(id_veiculo_servico) as 'qtd'
FROM clientes NATURAL JOIN veiculos INNER JOIN servicos ON id_veiculo_servico = id_veiculo
GROUP BY id_veiculo_servico
ORDER BY count(id_veiculo_servico), nome_cliente; /*
+-------------------------------+--------------+-------------+--------------+-----+
| nome_cliente                  | tipo_veiculo | marca       | modelo       | qtd |
+-------------------------------+--------------+-------------+--------------+-----+
| Ana Clara Rodrigues Costa     | Carro        | Fial        | Gol          |   1 |
| Ana Clara Rodrigues Costa     | Carro        | Honda       | Civic        |   2 |
| Antônio Cardoso Matos         | Carro        | Peugeot     | 208          |   2 |
| Maria  da Silva               | Carro        | Volkswagen  | Polo         |   2 |
| Maria Luiza da Silva Santos   | Carro        | Ford        | Ka           |   2 |
| Alice Carvalho                | Carro        | Fiat        | Argo         |   4 |
| Beatriz Alves                 | Carro        | Fiat        | Mobi         |   4 |
| João Pedro Oliveira Almeida   | Carro        | Hyundai     | HB20         |   4 |
| Júlia Rodrigues               | Carro        | Fial        | Gol          |   4 |
| Manuela  Pereira              | Carro        | Fiat        | Cronos       |   4 |
| Maria da Costa                | Carro        | Fiat        | Argo         |   4 |
| Clara Eloá Fernandes          | Carro        | Ford        | Focus        |   5 |
| Júlia Rodrigues               | Carro        | Ford        | Fiesta       |   5 |
| Sophia de Oliveira            | Carro        | Volkswagen  | Voyage       |   5 |
| José de Castro                | Carro        | Renault     | Kwid         |   6 |
| Maria  da Silva               | Carro        | Volkswagen  | Fusca        |   6 |
| Maria de Nunes da Silva       | Carro        | Fial        | Uno          |   6 |
| Otavio Coelho                 | Carro        | Renault     | Kwid         |   6 |
| Beatriz Alves                 | Carro        | Chevrolet   | Onix Plus    |   7 |
| Gabriela de Souza             | Carro        | Chevrolet   | Onix         |   7 |
| Lucas Gabriel Pereira Lima    | Moto         | Honda       | POP 110      |   7 |
| Isabela Lima                  | Carro        | Volkswagen  | Gol          |   8 |
| Júnior Barbosa                | Carro        | Volkswagen  | Savero       |   8 |
| Júnior Barbosa                | Moto         | Yamaha      | Fazer FZ25   |   8 |
| Lucas Gabriel Pereira Lima    | Moto         | Honda       | NXR 160 Bros |   9 |
| Maria da Costa                | Carro        | Volkswagen  | Fusca        |   9 |
| Alice Carvalho                | Moto         | Suzuki      | SV650        |  13 |
| Beatriz Alves                 | Moto         | Kawasaki    | Ninja 300    |  14 |
| Miguel Antônio Gomes Ribeiro  | Moto         | Honda       | Biz 110//123 |  17 |
| Pedro Henrique Alves Ferreira | Moto         | Yamaha      | YZF-R3       |  20 |
+-------------------------------+--------------+-------------+--------------+-----+ */

-- 16. Quais carros tem mais Atendimentos?
SELECT nome_cliente, tipo_veiculo, marca, modelo, count(id_veiculo_servico) as 'qtd'
FROM clientes NATURAL JOIN veiculos INNER JOIN servicos ON id_veiculo_servico = id_veiculo
GROUP BY id_veiculo_servico
HAVING count(id_veiculo_servico) > 7
ORDER BY count(id_veiculo_servico); /*
+-------------------------------+--------------+-------------+--------------+-----+
| nome_cliente                  | tipo_veiculo | marca       | modelo       | qtd |
+-------------------------------+--------------+-------------+--------------+-----+
| Isabela Lima                  | Carro        | Volkswagen  | Gol          |   8 |
| Júnior Barbosa                | Carro        | Volkswagen  | Savero       |   8 |
| Júnior Barbosa                | Moto         | Yamaha      | Fazer FZ25   |   8 |
| Maria da Costa                | Carro        | Volkswagen  | Fusca        |   9 |
| Lucas Gabriel Pereira Lima    | Moto         | Honda       | NXR 160 Bros |   9 |
| Alice Carvalho                | Moto         | Suzuki      | SV650        |  13 |
| Beatriz Alves                 | Moto         | Kawasaki    | Ninja 300    |  14 |
| Miguel Antônio Gomes Ribeiro  | Moto         | Honda       | Biz 110//123 |  17 |
| Pedro Henrique Alves Ferreira | Moto         | Yamaha      | YZF-R3       |  20 |
+-------------------------------+--------------+-------------+--------------+-----+*/

-- 17. Quais os status possiveis de um problema?
SELECT DISTINCT status_servico FROM servicos; /*
+----------------------------------+
| status_servico                   |
+----------------------------------+
| Aguardando Peças                 |
| Em Andamento                     |
| Concluido                        |
| Aguardando Autorização Adicional |
| Aguardando Retirada              |
| Aguardando Aprovação             |
+----------------------------------+ */

-- 18. Quais carros tem mais problemas aguardando Peças e/ou uma Autorização
SELECT nome_cliente, tipo_veiculo, marca, modelo, status_servico, count(id_veiculo_servico) as 'qtd'
FROM clientes NATURAL JOIN veiculos INNER JOIN servicos ON id_veiculo_servico = id_veiculo
GROUP BY id_veiculo_servico
HAVING  status_servico in ( "Aguardando Autorização Adicional", "Aguardando Peças", "Aguardando Retirada", "Aguardando Aprovação")
ORDER BY count(id_veiculo_servico); /*
+------------------------------+--------------+-------------+--------------+----------------------------------+-----+
| nome_cliente                 | tipo_veiculo | marca       | modelo       | status_servico                   | qtd |
+------------------------------+--------------+-------------+--------------+----------------------------------+-----+
| Ana Clara Rodrigues Costa    | Carro        | Fial        | Gol          | Aguardando Peças                 |   1 |
| Antônio Cardoso Matos        | Carro        | Peugeot     | 208          | Aguardando Peças                 |   2 |
| Beatriz Alves                | Carro        | Fiat        | Mobi         | Aguardando Peças                 |   4 |
| Júlia Rodrigues              | Carro        | Fial        | Gol          | Aguardando Aprovação             |   4 |
| Sophia de Oliveira           | Carro        | Volkswagen  | Voyage       | Aguardando Autorização Adicional |   5 |
| Clara Eloá Fernandes         | Carro        | Ford        | Focus        | Aguardando Retirada              |   5 |
| Otavio Coelho                | Carro        | Renault     | Kwid         | Aguardando Autorização Adicional |   6 |
| Isabela Lima                 | Carro        | Volkswagen  | Gol          | Aguardando Peças                 |   8 |
| Miguel Antônio Gomes Ribeiro | Moto         | Honda       | Biz 110//123 | Aguardando Autorização Adicional |  17 |
+------------------------------+--------------+-------------+--------------+----------------------------------+-----+
 */

-- 19. Lista de Todos os serviços Pendentes na Oficina.
SELECT 
	nome_cliente, tipo_veiculo, modelo, descricao_servico,
	status_servico, abertura_data_servico,fechamento_data_servico
FROM clientes NATURAL JOIN veiculos 
INNER JOIN servicos ON id_veiculo_servico = id_veiculo
INNER JOIN def_servicos ON def_servicos.id_servico = servicos.id_servico
WHERE id_cliente in (SELECT id_cliente 
                     FROM clientes NATURAL JOIN veiculos INNER JOIN servicos ON id_veiculo_servico = id_veiculo
                     GROUP BY id_cliente HAVING  fechamento_data_servico is null)
ORDER BY nome_cliente, tipo_veiculo, modelo; /*
+-------------------------------+--------------+--------------+----------------------------------------------------+----------------------------------+-----------------------+-------------------------+
| nome_cliente                  | tipo_veiculo | modelo       | descricao_servico                                  | status_servico                   | abertura_data_servico | fechamento_data_servico |
+-------------------------------+--------------+--------------+----------------------------------------------------+----------------------------------+-----------------------+-------------------------+
| Alice Carvalho                | Carro        | Argo         | Trocas de filtros                                  | Aguardando Autorização Adicional | 2022-06-08            | null                    |
| Alice Carvalho                | Carro        | Argo         | Diagnóstico e conserto da suspensão                | Aguardando Peças                 | 2022-12-27            | null                    |
| Alice Carvalho                | Carro        | Argo         | Trocas de velas                                    | Aguardando Autorização Adicional | 2022-06-08            | null                    |
| Alice Carvalho                | Moto         | SV650        | Troca de Bateria                                   | Aguardando Autorização Adicional | 2022-09-11            | null                    |
| Alice Carvalho                | Moto         | SV650        | Troca de Rolamentos Roda                           | Aguardando Autorização Adicional | 2022-04-14            | null                    |
| Alice Carvalho                | Moto         | SV650        | Troca de Bateria                                   | Aguardando Peças                 | 2023-06-21            | null                    |
| Alice Carvalho                | Moto         | SV650        | Troca de Disco de Freio                            | Em Andamento                     | 2023-01-10            | null                    |
| Alice Carvalho                | Moto         | SV650        | Troca de Amortecedor                               | Aguardando Autorização Adicional | 2022-12-27            | null                    |
| Alice Carvalho                | Moto         | SV650        | Troca de Lona de Freio                             | Aguardando Aprovação             | 2022-07-16            | null                    |
| Alice Carvalho                | Moto         | SV650        | Troca de Bateria                                   | Aguardando Peças                 | 2022-11-21            | null                    |
| Ana Clara Rodrigues Costa     | Carro        | Civic        | Trocas de óleo                                     | Aguardando Aprovação             | 2023-01-03            | null                    |
| Ana Clara Rodrigues Costa     | Carro        | Gol          | Lavagem do veiculo                                 | Aguardando Peças                 | 2023-02-10            | null                    |
| Antônio Cardoso Matos         | Carro        | 208          | Diagnóstico e conserto de problemas mecânicos      | Aguardando Peças                 | 2023-02-10            | null                    |
| Antônio Cardoso Matos         | Carro        | 208          | Reparo de componentes da suspensão                 | Aguardando Peças                 | 2022-06-08            | null                    |
| Beatriz Alves                 | Carro        | Mobi         | Diagnóstico e reparo do alternador                 | Aguardando Peças                 | 2023-04-21            | null                    |
| Beatriz Alves                 | Carro        | Mobi         | Diagnóstico e conserto de falhas no motor          | Aguardando Peças                 | 2022-04-03            | null                    |
| Beatriz Alves                 | Carro        | Mobi         | Lavagem  a seco e limpeza interna                  | Aguardando Aprovação             | 2022-12-05            | null                    |
| Beatriz Alves                 | Carro        | Onix Plus    | Lavagem  a seco e limpeza interna                  | Aguardando Aprovação             | 2022-07-12            | null                    |
| Beatriz Alves                 | Carro        | Onix Plus    | Diagnóstico e conserto de problemas mecânicos      | Aguardando Autorização Adicional | 2022-04-01            | null                    |
| Beatriz Alves                 | Carro        | Onix Plus    | Troca e reparo de pastilhas                        | Aguardando Autorização Adicional | 2022-06-10            | null                    |
| Beatriz Alves                 | Moto         | Ninja 300    | Troca de Bateria                                   | Aguardando Aprovação             | 2023-02-10            | null                    |
| Beatriz Alves                 | Moto         | Ninja 300    | Troca de Bateria                                   | Aguardando Autorização Adicional | 2022-09-19            | null                    |
| Beatriz Alves                 | Moto         | Ninja 300    | Instalação de Baú/Bauletos E Malas                 | Aguardando Aprovação             | 2023-05-06            | null                    |
| Beatriz Alves                 | Moto         | Ninja 300    | Troca de Rolamentos Roda                           | Em Andamento                     | 2022-08-23            | null                    |
| Clara Eloá Fernandes          | Carro        | Focus        | Troca de pneus                                     | Aguardando Peças                 | 2022-12-30            | null                    |
| Clara Eloá Fernandes          | Carro        | Focus        | Lavagem do veiculo                                 | Aguardando Aprovação             | 2022-07-16            | null                    |
| Gabriela de Souza             | Carro        | Onix         | Diagnóstico e conserto de problemas mecânicos      | Aguardando Aprovação             | 2023-01-10            | null                    |
| Gabriela de Souza             | Carro        | Onix         | Inspeção da suspensão                              | Aguardando Peças                 | 2023-04-21            | null                    |
| Isabela Lima                  | Carro        | Gol          | Trocas de óleo                                     | Aguardando Peças                 | 2023-02-25            | null                    |
| Isabela Lima                  | Carro        | Gol          | Diagnóstico e reparo de problemas com bateria      | Em Andamento                     | 2022-03-26            | null                    |
| Isabela Lima                  | Carro        | Gol          | Troca de discos de freio                           | Em Andamento                     | 2022-06-08            | null                    |
| José de Castro                | Carro        | Kwid         | outros componentes do sistema de freios            | Aguardando Aprovação             | 2022-04-22            | null                    |
| José de Castro                | Carro        | Kwid         | Troca e reparo de pastilhas                        | Aguardando Autorização Adicional | 2023-04-21            | null                    |
| José de Castro                | Carro        | Kwid         | Reparo de componentes da suspensão                 | Aguardando Autorização Adicional | 2022-04-01            | null                    |
| Júlia Rodrigues               | Carro        | Fiesta       | Trocas de filtros                                  | Em Andamento                     | 2023-03-16            | null                    |
| Júlia Rodrigues               | Carro        | Fiesta       | Manutenção e recarga do sistema de ar condicionado | Aguardando Peças                 | 2023-04-21            | null                    |
| Júlia Rodrigues               | Carro        | Gol          | Diagnóstico e reparo de sistemas elétricos         | Em Andamento                     | 2022-02-14            | null                    |
| Júlia Rodrigues               | Carro        | Gol          | Lavagem do veiculo                                 | Aguardando Aprovação             | 2022-03-26            | null                    |
| Júlia Rodrigues               | Carro        | Gol          | conserto de furos e desgastes.                     | Aguardando Aprovação             | 2022-02-26            | null                    |
| Júnior Barbosa                | Carro        | Savero       | Polimento                                          | Aguardando Autorização Adicional | 2022-11-21            | null                    |
| Júnior Barbosa                | Carro        | Savero       | Troca de discos de freio                           | Aguardando Aprovação             | 2022-09-29            | null                    |
| Júnior Barbosa                | Carro        | Savero       | Reparos e trocas de fluido na transmissão          | Aguardando Aprovação             | 2022-10-14            | null                    |
| Júnior Barbosa                | Carro        | Savero       | Diagnóstico e reparo do sistema de ignição         | Em Andamento                     | 2022-12-05            | null                    |
| Júnior Barbosa                | Moto         | Fazer FZ25   | Troca de Bateria                                   | Aguardando Autorização Adicional | 2022-05-25            | null                    |
| Júnior Barbosa                | Moto         | Fazer FZ25   | Troca de Bateria                                   | Em Andamento                     | 2023-01-10            | null                    |
| Júnior Barbosa                | Moto         | Fazer FZ25   | Troca de Pastilha                                  | Em Andamento                     | 2022-09-29            | null                    |
| Júnior Barbosa                | Moto         | Fazer FZ25   | Troca de Câmara de Ar                              | Aguardando Autorização Adicional | 2022-07-16            | null                    |
| Júnior Barbosa                | Moto         | Fazer FZ25   | Troca de Relação/Transmissão                       | Aguardando Peças                 | 2022-04-14            | null                    |
| Júnior Barbosa                | Moto         | Fazer FZ25   | Troca de Bateria                                   | Aguardando Peças                 | 2022-07-16            | null                    |
| Júnior Barbosa                | Moto         | Fazer FZ25   | Balanceamento Por Roda                             | Aguardando Aprovação             | 2022-10-21            | null                    |
| Júnior Barbosa                | Moto         | Fazer FZ25   | Troca de Bateria                                   | Aguardando Autorização Adicional | 2022-09-11            | null                    |
| Lucas Gabriel Pereira Lima    | Moto         | NXR 160 Bros | Instalação de Baú/Bauletos E Malas                 | Aguardando Peças                 | 2022-09-19            | null                    |
| Lucas Gabriel Pereira Lima    | Moto         | NXR 160 Bros | Troca de Lona de Freio                             | Aguardando Autorização Adicional | 2022-10-21            | null                    |
| Lucas Gabriel Pereira Lima    | Moto         | NXR 160 Bros | Troca de Amortecedor                               | Aguardando Aprovação             | 2023-06-21            | null                    |
| Lucas Gabriel Pereira Lima    | Moto         | NXR 160 Bros | Troca de Bateria                                   | Aguardando Peças                 | 2022-09-11            | null                    |
| Lucas Gabriel Pereira Lima    | Moto         | NXR 160 Bros | Troca de Bateria                                   | Aguardando Peças                 | 2022-04-14            | null                    |
| Lucas Gabriel Pereira Lima    | Moto         | NXR 160 Bros | Troca de Bateria                                   | Aguardando Autorização Adicional | 2022-04-01            | null                    |
| Lucas Gabriel Pereira Lima    | Moto         | NXR 160 Bros | Troca de Bateria                                   | Aguardando Aprovação             | 2023-05-06            | null                    |
| Lucas Gabriel Pereira Lima    | Moto         | POP 110      | Troca de Bateria                                   | Aguardando Aprovação             | 2022-08-23            | null                    |
| Lucas Gabriel Pereira Lima    | Moto         | POP 110      | Troca de Óleo de Motor                             | Aguardando Peças                 | 2023-03-26            | null                    |
| Lucas Gabriel Pereira Lima    | Moto         | POP 110      | Troca de Pastilha                                  | Em Andamento                     | 2022-07-16            | null                    |
| Manuela  Pereira              | Carro        | Cronos       | Diagnóstico e conserto de problemas mecânicos      | Em Andamento                     | 2022-05-25            | null                    |
| Manuela  Pereira              | Carro        | Cronos       | Diagnóstico e conserto de sistema de transmissão   | Aguardando Peças                 | 2022-04-03            | null                    |
| Maria  da Silva               | Carro        | Fusca        | Troca de pneus                                     | Aguardando Aprovação             | 2022-03-26            | null                    |
| Maria  da Silva               | Carro        | Fusca        | Reparos e trocas de fluido na transmissão          | Aguardando Autorização Adicional | 2023-01-03            | null                    |
| Maria  da Silva               | Carro        | Fusca        | conserto de furos e desgastes.                     | Aguardando Peças                 | 2022-12-30            | null                    |
| Maria  da Silva               | Carro        | Fusca        | Manutenção e recarga do sistema de ar condicionado | Aguardando Peças                 | 2022-12-30            | null                    |
| Maria  da Silva               | Carro        | Fusca        | Trocas de correias                                 | Aguardando Autorização Adicional | 2022-05-25            | null                    |
| Maria da Costa                | Carro        | Argo         | Reparos e trocas de fluido na transmissão          | Aguardando Autorização Adicional | 2022-09-19            | null                    |
| Maria da Costa                | Carro        | Argo         | Lavagem do veiculo                                 | Em Andamento                     | 2022-07-12            | null                    |
| Maria da Costa                | Carro        | Fusca        | Diminuir riscos ou danos na pintura                | Em Andamento                     | 2023-01-10            | null                    |
| Maria da Costa                | Carro        | Fusca        | Trocas de outros componentes                       | Aguardando Peças                 | 2023-01-03            | null                    |
| Maria da Costa                | Carro        | Fusca        | Trocas de filtros                                  | Em Andamento                     | 2023-01-10            | null                    |
| Maria da Costa                | Carro        | Fusca        | Trocas de velas                                    | Em Andamento                     | 2022-04-22            | null                    |
| Maria de Nunes da Silva       | Carro        | Uno          | Trocas de velas                                    | Aguardando Autorização Adicional | 2022-12-05            | null                    |
| Maria de Nunes da Silva       | Carro        | Uno          | Diagnóstico e reparo de sistemas elétricos         | Aguardando Peças                 | 2022-04-03            | null                    |
| Miguel Antônio Gomes Ribeiro  | Moto         | Biz 110//123 | Troca de Escapamento                               | Aguardando Peças                 | 2022-02-14            | null                    |
| Miguel Antônio Gomes Ribeiro  | Moto         | Biz 110//123 | Troca de Rolamentos Roda                           | Aguardando Peças                 | 2022-04-01            | null                    |
| Miguel Antônio Gomes Ribeiro  | Moto         | Biz 110//123 | Troca de Bateria                                   | Aguardando Autorização Adicional | 2023-01-10            | null                    |
| Miguel Antônio Gomes Ribeiro  | Moto         | Biz 110//123 | Troca de Pastilha                                  | Aguardando Aprovação             | 2023-05-06            | null                    |
| Miguel Antônio Gomes Ribeiro  | Moto         | Biz 110//123 | Troca de Bateria                                   | Em Andamento                     | 2022-04-14            | null                    |
| Miguel Antônio Gomes Ribeiro  | Moto         | Biz 110//123 | Retifica de Cubo de Freio                          | Aguardando Aprovação             | 2022-06-03            | null                    |
| Miguel Antônio Gomes Ribeiro  | Moto         | Biz 110//123 | Troca de Bateria                                   | Aguardando Peças                 | 2023-04-21            | null                    |
| Miguel Antônio Gomes Ribeiro  | Moto         | Biz 110//123 | Troca de Bateria                                   | Aguardando Aprovação             | 2023-06-21            | null                    |
| Miguel Antônio Gomes Ribeiro  | Moto         | Biz 110//123 | Troca de Bateria                                   | Aguardando Autorização Adicional | 2022-09-19            | null                    |
| Miguel Antônio Gomes Ribeiro  | Moto         | Biz 110//123 | Troca de Bateria                                   | Aguardando Aprovação             | 2022-12-27            | null                    |
| Miguel Antônio Gomes Ribeiro  | Moto         | Biz 110//123 | Troca de Lona de Freio                             | Em Andamento                     | 2023-04-21            | null                    |
| Miguel Antônio Gomes Ribeiro  | Moto         | Biz 110//123 | Troca de Amortecedor                               | Aguardando Autorização Adicional | 2022-06-03            | null                    |
| Miguel Antônio Gomes Ribeiro  | Moto         | Biz 110//123 | Troca de Disco de Freio                            | Aguardando Aprovação             | 2023-01-03            | null                    |
| Otavio Coelho                 | Carro        | Kwid         | Trocas de outros componentes                       | Aguardando Autorização Adicional | 2022-04-22            | null                    |
| Otavio Coelho                 | Carro        | Kwid         | Reparo de componentes da suspensão                 | Aguardando Autorização Adicional | 2022-04-22            | null                    |
| Otavio Coelho                 | Carro        | Kwid         | Diagnóstico e conserto de falhas no motor          | Aguardando Autorização Adicional | 2023-05-06            | null                    |
| Pedro Henrique Alves Ferreira | Moto         | YZF-R3       | Balanceamento Por Roda                             | Aguardando Autorização Adicional | 2022-09-29            | null                    |
| Pedro Henrique Alves Ferreira | Moto         | YZF-R3       | Troca de Bateria                                   | Em Andamento                     | 2023-05-06            | null                    |
| Pedro Henrique Alves Ferreira | Moto         | YZF-R3       | Instalação de Bagageiro/Suporte                    | Aguardando Autorização Adicional | 2022-08-06            | null                    |
| Pedro Henrique Alves Ferreira | Moto         | YZF-R3       | Troca de Bateria                                   | Aguardando Aprovação             | 2022-02-14            | null                    |
| Pedro Henrique Alves Ferreira | Moto         | YZF-R3       | Troca de Amortecedor                               | Aguardando Aprovação             | 2022-02-14            | null                    |
| Pedro Henrique Alves Ferreira | Moto         | YZF-R3       | Troca de Relação/Transmissão                       | Aguardando Peças                 | 2022-09-29            | null                    |
| Pedro Henrique Alves Ferreira | Moto         | YZF-R3       | Troca de Câmara de Ar                              | Aguardando Peças                 | 2023-02-10            | null                    |
| Pedro Henrique Alves Ferreira | Moto         | YZF-R3       | Troca de Cabos Motos                               | Aguardando Peças                 | 2023-03-16            | null                    |
| Pedro Henrique Alves Ferreira | Moto         | YZF-R3       | Troca de Amortecedor                               | Aguardando Peças                 | 2022-10-14            | null                    |
| Pedro Henrique Alves Ferreira | Moto         | YZF-R3       | Troca de Bateria                                   | Aguardando Peças                 | 2022-12-05            | null                    |
| Pedro Henrique Alves Ferreira | Moto         | YZF-R3       | Troca de Bateria                                   | Em Andamento                     | 2022-03-26            | null                    |
| Pedro Henrique Alves Ferreira | Moto         | YZF-R3       | Troca de Bateria                                   | Em Andamento                     | 2022-10-14            | null                    |
| Pedro Henrique Alves Ferreira | Moto         | YZF-R3       | Balanceamento Por Roda                             | Em Andamento                     | 2022-08-23            | null                    |
| Pedro Henrique Alves Ferreira | Moto         | YZF-R3       | Troca de Bateria                                   | Aguardando Autorização Adicional | 2022-02-26            | null                    |
| Sophia de Oliveira            | Carro        | Voyage       | Trocas de velas                                    | Aguardando Aprovação             | 2022-04-01            | null                    |
| Sophia de Oliveira            | Carro        | Voyage       | Diagnóstico e reparo do sistema de ignição         | Aguardando Autorização Adicional | 2022-02-26            | null                    |
| Sophia de Oliveira            | Carro        | Voyage       | outros componentes do sistema de freios            | Aguardando Peças                 | 2023-05-06            | null                    |
| Sophia de Oliveira            | Carro        | Voyage       | Diagnóstico e conserto do sistema de freios        | Em Andamento                     | 2022-04-22            | null                    |
+-------------------------------+--------------+--------------+----------------------------------------------------+----------------------------------+-----------------------+-------------------------+
*/

-- 20. Quais as peças mais usadas?
select nome_peca, count(id_peca_servico) as 'Qtd_Total_das_Pecas_Usadas'
from servicos INNER join pecas on id_peca_servico = id_peca
GROUP BY id_peca_servico
HAVING count(id_peca_servico) > 4
ORDER BY count(id_peca_servico); /*
+----------------------------------------------+----------------------------+
| nome_peca                                    | Qtd_Total_das_Pecas_Usadas |
+----------------------------------------------+----------------------------+
| Bomba de combustível                         |                          7 |
| Suspensão dianteira                          |                          7 |
| Virabrequim                                  |                          7 |
| Câmbio manual/automático                     |                          6 |
| Mangueiras e tubulações do ar-condicionado   |                          6 |
| Radiador de arrefecimento do ar-condicionado |                          6 |
| Servo freio                                  |                          6 |
| Transmissão                                  |                          6 |
| Barra de direção                             |                          5 |
| Diferencial                                  |                          5 |
| Embreagem                                    |                          5 |
| Tanque de combustível                        |                          5 |
+----------------------------------------------+----------------------------+ */

-- 21. Quail o custo com as peças mais usadas?
select nome_peca, count(id_peca_servico) as 'Qtd_Total_das_Pecas_Usadas', preco_peca, 
CONCAT('R$ ', FORMAT((count(id_peca_servico)*preco_peca),2,'de_DE')) as 'Custo Total com as Peças'
from servicos INNER join pecas on id_peca_servico = id_peca
GROUP BY id_peca_servico
HAVING count(id_peca_servico) > 4
ORDER BY count(id_peca_servico); /*
+----------------------------------------------+----------------------------+------------+--------------------------+
| nome_peca                                    | Qtd_Total_das_Pecas_Usadas | preco_peca | Custo Total com as Peças |
+----------------------------------------------+----------------------------+------------+--------------------------+
| Bomba de combustível                         |                          7 |    1377.00 | R$ 9.639,00              |
| Suspensão dianteira                          |                          7 |    1311.00 | R$ 9.177,00              |
| Virabrequim                                  |                          7 |    1627.00 | R$ 11.389,00             |
| Câmbio manual/automático                     |                          6 |    1746.00 | R$ 10.476,00             |
| Mangueiras e tubulações do ar-condicionado   |                          6 |    1513.00 | R$ 9.078,00              |
| Radiador de arrefecimento do ar-condicionado |                          6 |    1370.00 | R$ 8.220,00              |
| Servo freio                                  |                          6 |    1583.00 | R$ 9.498,00              |
| Transmissão                                  |                          6 |    1692.00 | R$ 10.152,00             |
| Barra de direção                             |                          5 |    1606.00 | R$ 8.030,00              |
| Diferencial                                  |                          5 |    1323.00 | R$ 6.615,00              |
| Embreagem                                    |                          5 |    1744.00 | R$ 8.720,00              |
| Tanque de combustível                        |                          5 |    1384.00 | R$ 6.920,00              |
+----------------------------------------------+----------------------------+------------+--------------------------+ */

-- 22. Quem atualiza o sistema a parte de Serviços.
SELECT id_funcionario, id_func, nome_func, cargo_func, COUNT(id_servico) 
from servicos INNER JOIN funcionarios ON id_func = id_funcionario
GROUP BY id_funcionario; /*
+----------------+---------+-------------------------------+-------------------+-------------------+
| id_funcionario | id_func | nome_func                     | cargo_func        | COUNT(id_servico) |
+----------------+---------+-------------------------------+-------------------+-------------------+
|              3 |       3 | Manuela Oliveira Lima Santos  | auxiliar mecânico |                96 |
|              5 |       5 | Isabela Cristina Santos Souza | auxiliar adm      |               103 |
+----------------+---------+-------------------------------+-------------------+-------------------+ */


SELECT DISTINCT id_funcionario from servicos; /*
+----------------+
| id_funcionario |
+----------------+
|              3 |
|              5 |
+----------------+ */
