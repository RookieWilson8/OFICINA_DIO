

-- Questões
-- 01. Quando foi o total do faturamento
SELECT CONCAT('R$ ', FORMAT(SUM(valor_total_pgto_nota), 2, 'en_US')) as 'Total_Faturamento_Oficina' FROM pagtos_nota;

-- 02. Quando foi o total para cada forma de pagamento 
SELECT pagamento_tipo, 
       CONCAT('R$ ', FORMAT(SUM(valor_total_pgto_nota), 2, 'en_US')) as Total_por_Forma_Pagamento 
FROM pagtos_nota GROUP BY pagamento_tipo
ORDER BY SUM(valor_total_pgto_nota);

-- 03. Quando foi a média para cada forma de pagamento 
SELECT pagamento_tipo, 
       CONCAT('R$ ', FORMAT(AVG(valor_total_pgto_nota), 2, 'en_US')) as Media_Forma_Pagamento 
FROM pagtos_nota GROUP BY pagamento_tipo
ORDER BY AVG(valor_total_pgto_nota);

-- 04. A quantidade de ocorrências de cada forma de pagamento 
SELECT pagamento_tipo, COUNT(valor_total_pgto_nota) as 'Qtd_Pagamentos'
FROM pagtos_nota
GROUP BY pagamento_tipo 
ORDER BY COUNT(valor_total_pgto_nota);

-- 05. Quantidade de Pagamentos acima do Ticket Medio
SELECT pagamento_tipo, COUNT(valor_total_pgto_nota) as 'Qtd_acima_media'
FROM pagtos_nota
WHERE valor_total_pgto_nota > (SELECT AVG(valor_total_pgto_nota) FROM pagtos_nota)
GROUP BY pagamento_tipo
ORDER BY COUNT(valor_total_pgto_nota);

-- 06. Faturamento por mês
SELECT MONTH(data_nota) as mes, YEAR(data_nota) as ano, 
       CONCAT('R$ ', FORMAT(SUM(valor_total_pgto_nota), 2, 'en_US')) 
FROM pagtos_nota
GROUP BY mes, ano
ORDER BY ano, mes;

-- 09. Lista de Motos que estão na oficina
SELECT marca, modelo, tipo_moto
FROM veiculos INNER JOIN motos on id_veiculo = id_veiculo_moto;

-- 10. Quantidade de Veículos na Oficina
SELECT COUNT(*) as 'Veiculos_na_oficina' FROM veiculos;

-- 11. Quantidade de clientes no Cadastro
SELECT COUNT(*) as 'Clientes_da_oficina' FROM clientes;

-- 12. Quantos Clientes estão sendo atendidos no momento.
SELECT COUNT(*) as 'Clientes_em_atendimento'
FROM clientes INNER JOIN veiculos ON clientes.id_cliente = veiculos.id_cliente;

-- 13. Clientes que têm mais de um veículo na Oficina
SELECT nome_cliente, COUNT(id_veiculo) as 'qtd_veiculo_do_cliente'
FROM clientes NATURAL JOIN veiculos
GROUP BY id_cliente
HAVING COUNT(id_veiculo) > 1;


-- 14. Quantidade de Cada tipo de veículo na Oficina
SELECT tipo_veiculo, COUNT(*) as 'Qtd_por_Tipo_Veiculo'
FROM clientes NATURAL JOIN veiculos
GROUP BY tipo_veiculo;

-- 15. Quantidade de Atendimentos em cada Veículo
SELECT nome_cliente, tipo_veiculo, marca, modelo, count(id_veiculo_servico) as 'qtd'
FROM clientes NATURAL JOIN veiculos INNER JOIN servicos ON id_veiculo_servico = id_veiculo
GROUP BY id_veiculo_servico
ORDER BY count(id_veiculo_servico), nome_cliente;

-- 16. Quais carros têm mais Atendimentos?
SELECT nome_cliente, tipo_veiculo, marca, modelo, count(id_veiculo_servico) as 'qtd'
FROM clientes NATURAL JOIN veiculos INNER JOIN servicos ON id_veiculo_servico = id_veiculo
GROUP BY id_veiculo_servico
HAVING count(id_veiculo_servico) > 7
ORDER BY count(id_veiculo_servico);


-- 17. Quais os status possíveis de um problema?
SELECT DISTINCT status_servico FROM servicos;

-- 18. Quais carros têm mais problemas aguardando Peças e/ou uma Autorização
SELECT nome_cliente, tipo_veiculo, marca, modelo, status_servico, count(id_veiculo_servico) as 'qtd'
FROM clientes NATURAL JOIN veiculos INNER JOIN servicos ON id_veiculo_servico = id_veiculo
GROUP BY id_veiculo_servico
HAVING status_servico IN ("Aguardando Autorização Adicional", "Aguardando Peças", "Aguardando Retirada", "Aguardando Aprovação")
ORDER BY count(id_veiculo_servico);

-- 19. Lista de Todos os serviços Pendentes na Oficina.
SELECT 
    nome_cliente, tipo_veiculo, modelo, descricao_servico,
    status_servico, abertura_data_servico, fechamento_data_servico
FROM clientes NATURAL JOIN veiculos 
INNER JOIN servicos ON id_veiculo_servico = id_veiculo
INNER JOIN def_servicos ON def_servicos.id_servico = servicos.id_servico
WHERE id_cliente IN (SELECT id_cliente 
                     FROM clientes NATURAL JOIN veiculos INNER JOIN servicos ON id_veiculo_servico = id_veiculo
                     GROUP BY id_cliente HAVING fechamento_data_servico IS NULL)
ORDER BY nome_cliente, tipo_veiculo, modelo;


-- 20. Quais as peças mais usadas?
SELECT nome_peca, COUNT(id_peca_servico) as 'Qtd_Total_das_Pecas_Usadas'
FROM servicos INNER JOIN pecas ON id_peca_servico = id_peca
GROUP BY id_peca_servico
HAVING count(id_peca_servico) > 4
ORDER BY count(id_peca_servico);

-- 21. Qual o custo com as peças mais usadas?
SELECT nome_peca, COUNT(id_peca_servico) as 'Qtd_Total_das_Pecas_Usadas', preco_peca, 
       CONCAT('R$ ', FORMAT((count(id_peca_servico) * preco_peca), 2, 'de_DE')) as 'Custo_Total_com_as_Peças'
FROM servicos INNER JOIN pecas ON id_peca_servico = id_peca
GROUP BY id_peca_servico
HAVING count(id_peca_servico) > 4
ORDER BY count(id_peca_servico);

-- 22. Quem atualiza o sistema a parte de Serviços.
SELECT id_funcionario, id_func, nome_func, cargo_func, COUNT(id_servico) 
FROM servicos INNER JOIN funcionarios ON id_func = id_funcionario
GROUP BY id_funcionario;

SELECT DISTINCT id_funcionario FROM servicos;
