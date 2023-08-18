
create database oficina;
use oficina;


create table clientes (
	id_cliente int auto_increment primary key,
    	nome_cliente varchar(100),
    	cpf_cliente char(11) not null,
    	endereco_cliente varchar(255),
    	bairro_cliente varchar(50),
    	estado_cliente char(2),
    	email_cliente varchar(100),
    	contato_cliente char(11),
    
    	constraint unique_cpf_cliente unique (CPF_cliente)
);


create table veiculos (
	id_veiculo int auto_increment,
    	id_cliente int not null,
    	tipo_veiculo varchar(20) null,
	Marca varchar(50),
	modelo varchar(25),
	placa varchar(10),
	ano char(4),
	cor varchar(20),
	quilometragem varchar(7),
    	combustivel varchar(10),
    	capacidade_tanque int null,
    
    	constraint primary key (id_veiculo, id_cliente),
    	constraint fk_cliente_veiculo foreign key (id_cliente) references clientes(id_cliente)    
);


create table motos (
  	id_moto int auto_increment,
	id_veiculo_moto int,
	tipo_moto varchar(20),
	cilindrada varchar(10),
	transmissao varchar(15),
	freios_sistema varchar(10),
	marchas int null,
 
	constraint primary key(id_moto, id_veiculo_moto),
  	constraint unique_veiculo_moto unique (id_veiculo_moto),
	constraint fk_veiculo_moto foreign key (id_veiculo_moto) references veiculos(id_veiculo)   
);

create table carros(
    	id_carro int auto_increment,
    	id_veiculo_carro int not null,
    	refrigeracao boolean default false,
    	volume varchar(50) null,
    	vidro_eletrico boolean default True,
    	carroceria varchar(20),
    
    	constraint primary key(id_carro, id_veiculo_carro),
    	constraint unique_veiculo_carro unique (id_veiculo_carro),
    	constraint fk_carro_moto foreign key (id_veiculo_carro) references veiculos(id_veiculo)
);

create table funcionarios (
	id_func int auto_increment primary key,
    	nome_func varchar(100),
    	cargo_func varchar(20),
    	data_contratacao date not null,
    	salario numeric(10,2) not null,
    	cpf_func char(11) not null,
    	endereco_func varchar(255),
    	bairro_func varchar(50),
    	estado_func char(2),
    	email_func varchar(100),
    	contato_func char(11),
    
    	constraint unique_cpf_func unique (CPF_func)
);

create table fornecedores (
	id_fornecedor int auto_increment primary key,
	razao_social_fornecedor varchar(255) not null,
	CNPJ_fornecedor char(15) not null,
	telefone_fornecedor char(11) not null,
	nome_contato_fornecedor varchar(100) not null,
    	endereco_fornecedor varchar(100)not null,
    	bairro_fornecedor varchar(50),
    	estado_fornecedor char(2),
    	cpf_contato_fornecedor char(11) not null,
	telefone_contato_fornecedor char(11) not null,
    
	constraint unique_cpf_contato_fornecedor unique (cpf_contato_fornecedor),
	constraint unique_cnpj_fornecedor unique (CNPJ_fornecedor)
);

create table pecas (
	id_peca int auto_increment primary key, 
	nome_peca varchar(100) not null,
	tipo_peca enum('carro','moto') not null,
	serie_peca varchar(20) not null,
	fabricante varchar(50),
	preco_peca numeric(10,2) not null,
	qtd_peca int not null
);

create table compras (
	id_compra int auto_increment primary key,
    	id_peca_comprada int,
	id_fornecedor int not null,
	data_compra date not null,
	quantidade_peca_comprada int not null,
	valor_unit_peca numeric(10,2),
	total_compra_peca numeric(10,2),
    
    	constraint fk_peca_comprada foreign key (id_peca_comprada) references pecas(id_peca),
    	constraint fk_fornecedor_peca_comprada foreign key (id_fornecedor) references fornecedores(id_fornecedor)
);

create table def_servicos (
	id_servico int auto_increment primary key,
	id_funcionario int not null,
	descricao_servico varchar(255),
	valor_servico numeric(10,2),
    
    	constraint fk_funcionario_servico foreign key (id_funcionario) references funcionarios(id_func)  
);

create table servicos (
	id_pk_serico int auto_increment primary key,
	id_servico int,
    	id_peca_servico int null,
	id_veiculo_servico int null,
    	id_funcionario int not null,
    	status_servico varchar(255),
    	abertura_data_servico date not null, 
    	fechamento_data_servico date  null,
    
    	constraint fk_peca_servico foreign key (id_peca_servico) references pecas(id_peca),
    	constraint fk_servico_def_servico foreign key (id_servico) references def_servicos(id_servico),
	constraint fk_veiculo_servico foreign key (id_veiculo_servico) references veiculos(id_veiculo) 
);

create table pagtos_nota (
	id_nota_fiscal int not null,
	id_servico_pgto_nota int not null,
	id_cliente_pgto_nota int not null,
	data_nota date not null, 
	pagamento_tipo enum('Boleto','Crédito', 'Débito', 'Pix', 'Crediário', 'Cartão da Loja', 'Tranférência', 'dinheiro'),
	valor_total_pgto_nota numeric(10,2),
	data_pgto_nota date not null,
    
    	constraint primary key (id_nota_fiscal, id_servico_pgto_nota, id_cliente_pgto_nota),
    	constraint fk_cliente_pgto_nota foreign key (id_cliente_pgto_nota) references clientes(id_cliente),
    	constraint fk_servico_pgto_nota foreign key (id_servico_pgto_nota) references servicos(id_pk_serico)
);
