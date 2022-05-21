 ------------- BASE DE DADOS HOTEL ---------------------------------------------
 
 --FAZER O ER
 
 CREATE TABLE cliente  (
  rg    NUMBER NOT NULL,
  nome  VARCHAR2(40) NOT NULL,
  sexo  CHAR(1) NOT NULL,
  telefone VARCHAR2(15),
  PRIMARY KEY (rg)
  );
   
 CREATE TABLE tipo_quarto  (
  id_tipo   NUMBER NOT NULL,
  descricao VARCHAR2(40) NOT NULL,
  valor     NUMBER(9,2) NOT NULL,
  PRIMARY KEY (id_tipo)
 );
   
 CREATE TABLE quarto  (
  num_quarto NUMBER NOT NULL,
  andar      VARCHAR2(10),
  id_tipo    NUMBER NOT NULL,
  status     CHAR(1) DEFAULT 'D' NOT NULL,
  PRIMARY KEY (num_quarto),
  CONSTRAINT fk_tipoQ FOREIGN KEY(id_tipo) REFERENCES tipo_quarto(id_tipo)
 );
   
   
 CREATE TABLE servico  (
  id_servico  NUMBER NOT NULL,
  descricao   VARCHAR2(60) NOT NULL,
  valor       NUMBER(9,2) NOT NULL,
  PRIMARY KEY (id_servico)
 );
   
 CREATE TABLE reserva  (
  id_reserva NUMBER NOT NULL,
  rg         NUMBER NOT NULL,
  num_quarto NUMBER NOT NULL,
  dt_reserva DATE NOT NULL,
  qtd_dias   INTEGER NOT NULL,
  data_entrada DATE NOT NULL,
  status CHAR(1) DEFAULT 'A',
   PRIMARY KEY (id_reserva),
   FOREIGN KEY (rg) REFERENCES cliente (rg),
   FOREIGN KEY (num_quarto) REFERENCES quarto(num_quarto)
  );
   
  CREATE TABLE hospedagem  (
   id_hospedagem NUMBER NOT NULL,
   rg            NUMERIC NOT NULL,
   num_quarto    NUMBER NOT NULL,
   data_entrada  DATE NOT NULL,
   data_saida    DATE,
   status CHAR(1) NOT NULL,
    PRIMARY KEY (id_hospedagem),
    FOREIGN KEY (rg) REFERENCES cliente (rg),
    FOREIGN KEY (num_quarto) REFERENCES quarto (num_quarto)
  );
   
  CREATE TABLE atendimento  (
   id_atendimento NUMBER NOT NULL,
   id_servico     INTEGER NOT NULL,
   id_hospedagem  INTEGER NOT NULL,
    PRIMARY KEY (id_atendimento),
    FOREIGN KEY (id_servico) REFERENCES servico (id_servico),
    FOREIGN KEY (id_hospedagem) REFERENCES hospedagem (id_hospedagem)
  );
  
  INSERT INTO Cliente VALUES(8899,'Almir','M', '54 3311-9878');
  
  INSERT INTO Tipo_quarto VALUES(1,'Standard',300);
  INSERT INTO Tipo_quarto VALUES(2,'Standard',450);
  
  INSERT INTO quarto VALUES(404,'4',2,'O');
  INSERT INTO quarto VALUES(405,'4',1,'D');
  INSERT INTO quarto values(301,'3',1,'D');
  
  INSERT INTO Hospedagem VALUES(1,8899,404,'20/03/2022','31/03/2022','O');
  
  INSERT INTO servico VALUES(1,'Limpeza',300);
  INSERT INTO servico VALUES(2,'Comida',400);
  
  INSERT INTO atendimento VALUES(10,1,1);
  INSERT INTO atendimento VALUES(11,2,1);
  
  INSERT INTO Reserva VALUES(601,8899,404,'10/04/2020',8,'19/04/2022','A');
  INSERT INTO Reserva VALUES(602,9090,405,'05/04/2020',3,'21/04/2022','A');
  INSERT INTO Reserva VALUES(603,9091,404,'10/01/2020',2,'29/04/2022','A');
  
  UPDATE quarto
  SET status = 'O'
  WHERE num_quarto = 404
  
  DELETE FROM reserva
  WHERE id_reserva = 13
  
-------------------------Base de dados escola-----------------------------------
  
  -- drop table professor cascade constraint;
CREATE TABLE Professor(
codigo int PRIMARY KEY,
nome varchar2(50),
titulacao varchar(80)
);

-- drop table disciplina cascade constraint;
CREATE TABLE Disciplina (
id int PRIMARY KEY,
nome varchar2(50),
nhoras numeric(6,2)
);

-- drop table turma cascade constraint;
CREATE TABLE Turma (
codigo int PRIMARY KEY,
nivel varchar2(3),
id int,
FOREIGN KEY(id) REFERENCES Disciplina (id)
);

-- drop table aluno cascade constraint;
CREATE TABLE Aluno (
matricula int PRIMARY KEY,
nome varchar2(50),
sexo varchar2(1),
codigo int,
FOREIGN KEY(codigo) REFERENCES Turma (codigo)
);

-- drop table ministra cascade constraint;
CREATE TABLE ministra (
numero int,
codigo int,
id int,
semestre varchar(8),
PRIMARY KEY(numero)
);

ALTER TABLE ministra ADD CONSTRAINT fk_professor
FOREIGN KEY(codigo) REFERENCES Professor(codigo); 

ALTER TABLE ministra ADD CONSTRAINT fk_disciplina
FOREIGN KEY(id) REFERENCES Disciplina(id);

insert into professor(codigo, nome, titulacao)values(50,'Doroteia','Especialista');
insert into professor(codigo, nome, titulacao)values(51,'Maysa','Mestre');
insert into professor(codigo, nome, titulacao)values(52,'Procopio','Doutor');
insert into professor(codigo, nome, titulacao)values(53,'Wilma','Mestre');

insert into disciplina(id, nome, nhoras)values(1, 'Laboratorio de Banco de Dados', 80);
insert into disciplina(id, nome, nhoras)values(2, 'Programacao OO', 120);
insert into disciplina(id, nome, nhoras)values(3, 'Projeto de Banco de Dados', 80);
insert into disciplina(id, nome, nhoras)values(4, 'Projeto de Dados', 40);

insert into turma(codigo, nivel,id)values(20, 'I',2);
insert into turma(codigo, nivel,id)values(21, 'II',1);
insert into turma(codigo, nivel,id)values(22, 'III',1);
insert into turma(codigo, nivel,id)values(23, 'IV',3);
insert into turma(codigo, nivel,id)values(24, 'I',1);

insert into aluno(matricula, nome, sexo,codigo)values(10, 'Bety', 'F', 20);
insert into aluno(matricula, nome, sexo,codigo)values(11, 'Getulio', 'M',22);
insert into aluno(matricula, nome, sexo,codigo)values(12, 'Analis', 'F',22);
insert into aluno(matricula, nome, sexo,codigo)values(13, 'Terezinha', 'F',21);
insert into aluno(matricula, nome, sexo,codigo)values(14, 'Teodoro', 'M',23);

insert into ministra(numero, codigo, id, semestre)values(1000, 53, 3, '2021/2');
insert into ministra(numero, codigo, id, semestre)values(1001, 51, 1, '2021/2');
insert into ministra(numero, codigo, id, semestre)values(1002, 52, 1, '2020/1');
insert into ministra(numero, codigo, id, semestre)values(1003, 53, 2, '2020/1');
insert into ministra(numero, codigo, id, semestre)values(1004, 51, 3, '2021/1');
insert into ministra(numero, codigo, id, semestre)values(1005, 52, 2, '2021/1');
insert into ministra(numero, codigo, id, semestre)values(1006, 51, 4, '2022/1');


-------------------------------base de dados vendas-----------------------------

--drop table produtos cascade constraints;    
create table produtos (
    codigo number not null,
    descricao varchar2(20),
    estoque number(7,2),
    precounitario number(7,2),
    primary key (codigo)
);

insert into produtos values(1,'Computador',5,3700);
insert into produtos values(2,'SmartPhone',2,1299);
insert into produtos values(3,'MacBook',2,12000);
insert into produtos values(4,'Impressora',10,499.89);

--drop table vendas cascade constraints;  
CREATE TABLE vendas(
    numero NUMBER PRIMARY KEY,
    valorProduto NUMBER NOT NULL,
    quantidade NUMBER,
    data DATE,
    parcelas NUMBER,   
    codigoProduto NUMBER,
    FOREIGN KEY (codigoProduto) REFERENCES produtos(codigo)
);

insert into vendas values(100, 12000, 1, '12/04/2022', 24, 3);

--drop table parcelas cascade constraints; 
CREATE TABLE parcelas(
    numero NUMBER,
    valorParcela NUMBER NOT NULL,
    dataVenc date NOT NULL,
    dataPagto date,
    nvenda NUMBER,
    FOREIGN KEY (nvenda) REFERENCES vendas(numero),
    PRIMARY KEY (numero,nvenda)
);

insert into parcelas(numero, valorParcela, dataVenc, nvenda) values(1, 500.00, '12/05/2022', 100);






