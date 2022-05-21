------------------------pesquisas do banco de dados escola--------------------

SELECT  turma.nivel, count(*)                                                   
FROM    turma inner join aluno ON
        turma.codigo = aluno.codigo
WHERE   turma.nivel = 'III'
GROUP BY turma.nivel		

SELECT  aluno.nome,aluno.matricula,disciplina.nome
FROM    disciplina inner join turma ON
        disciplina.id = turma.id 
		inner join aluno ON aluno.codigo=turma.codigo
WHERE   disciplina.nome = 'Laboratorio de Banco de Dados'
order by aluno.nome

SELECT  p.nome,p.titulacao,d.nome
FROM    professor p inner join ministra m ON
        p.codigo = m.codigo inner join disciplina d ON
        d.id = m.id		  
WHERE   d.nome = 'Laboratorio de Banco de Dados'

--4- Listar os professores e suas disciplinas 
--ordenadas por semestre em ordem crescente

SELECT  p.nome, d.nome, m.semestre
FROM    professor p inner join ministra m ON 
        p.codigo = m.codigo inner join disciplina d ON
        d.id = m.id
order by 3		
  
     ou .....
  	 
SELECT p.nome, d.nome, m.semestre
FROM   professor p, ministra m, disciplina d
WHERE  p.codigo = m.codigo and  d.id = m.id
order by 3		

--5- Somar o n?mero de horas, que s?o ministradas pelo professor 
--Maysa, a cada semestre

SELECT  m.semestre,sum(d.nhoras),count(d.id)
FROM    professor p inner join ministra m ON 
        p.codigo = m.codigo inner join disciplina d ON
        d.id = m.id
WHERE   p.nome = 'Maysa'		 
group by m.semestre

insert into ministra(numero, codigo, id, semestre) values(1021, 51, 4, '2021/1');

--6- Listar o nome de alunos matriculados em cada 
--disciplina, do semestre 2021/1 (e o nome do professor)

SELECT  a.nome,d.nome,p.nome,m.semestre
FROM    aluno a inner join turma t ON
        a.codigo=t.codigo inner join disciplina d ON
        d.id=t.id inner join ministra m ON
        m.id=d.id 
        inner join professor p ON
        p.codigo = m.codigo
WHERE   m.semestre = '2021/1'		   

--7- Listar o nome dos professores que ministram disciplinas, com o nhoras 
--maior que a carga hor?ria da disciplina de Projeto de Dados

SELECT  p.nome,d.nome,d.nhoras
FROM    professor p inner join ministra m ON 
        p.codigo = m.codigo inner join disciplina d ON
        d.id = m.id
WHERE   d.nhoras >    -- all e any
                  (
                   SELECT nhoras
                   FROM   disciplina
                   WHERE  nome = 'Projeto de Dados'
                  )
                            
--8- Fa?a uma consulta para listar o nome das disciplinas que 2 ou mais 
--alunos matriculados

SELECT  d.nome, COUNT(a.nome) 
FROM    disciplina d inner join turma t on 
        t.id = d.id inner join aluno a on 
        a.codigo = t.codigo
having COUNT(a.nome)>2
Group By d.nome;
 
--9- Fa?a uma consulta para listar o c?digo das turmas que n?o possuem alunos

SELECT  t.codigo, count(a.matricula)
FROM    turma t FULL join aluno a ON
        t.codigo = a.codigo
WHERE   a.codigo is null
group by t.codigo  
       
          ou ...
          
 SELECT codigo
 FROM   turma
 WHERE  codigo NOT IN (SELECT codigo FROM Aluno)
             
--10- Fa?a uma consulta para listar o n?mero de alunos matriculados por 
--semestre, em ordem decrescente de alunos

SELECT  m.semestre, count(a.matricula)
FROM    aluno a inner join turma t ON
        a.codigo = t.codigo inner join disciplina d ON
        d.id = t.id inner join ministra m ON
        m.id = d.id
group by m.semestre       
order by count(a.matricula) desc  
   
   
------------------------------- PL/SQL -----------------------------------------
   
   
CREATE TABLE Estudante AS 
(SELECT * FROM aluno WHERE matricula >=11)   
   
SELECT * FROM Estudante                                                         

--BLOCO PL/SQL
DECLARE                                                                         -- area de declaracao
    a NUMBER;                                                                   -- a é do tipo number        
    b VARCHAR2(30);                                                             -- b é do tipo varchar2
    c VARCHAR2(1);                                      
    d NUMBER;
BEGIN                                                                           -- area de execução
    SELECT matricula,nome,sexo,codigo INTO a,b,c,d                              -- seleciona os campos e armazena nas variaveis
    FROM Estudante WHERE matricula > 13;                                        -- da tabela estudante onde matricula é maior que 13
   
    INSERT INTO Estudante VALUES(a+30,b||' da Computa??o',c,d);                 -- insere na tabela dps da matricula 13 outra matricula + 10, copia o nome do aluno anterior e concatena com da computacao
END;


-------------------------------------------------------------------------------------------------------------------------------------------------------


-- PL/SQL - Bloco Anonimo
CREATE TABLE colaborador(
codigo INT PRIMARY KEY,
nome   VARCHAR2(40) NOT NULL,
salario NUMBER(10,2)
);

CREATE SEQUENCE minhaSeq01                                                      -- cria um sequencia
increment by 1                                                                  -- incrementa de 1 em 1
start with 50                                                                   -- inicia a sequencia em 50
maxvalue 55                                                                     -- valor maximo é 50
nocycle;
   
--drop sequence minhaSeq01;
CREATE SEQUENCE minhaSeq01
increment by 1
start with 56;

INSERT INTO Colaborador (codigo,nome,salario) VALUES (minhaSeq01.nextval,'Ana',1800.89); --usando minhaSeq01.nextval como valor, cada vez vai acrescentar um numero incrementado
   
   Select * From colaborador
   
INSERT INTO Colaborador (codigo,nome,salario) VALUES (minhaSeq01.nextval,'Juca',3000);
               
-- BLOCO AN?NIMO    
DECLARE                                                                         -- area de declaracao
    varMat NUMBER;    
    varN   VARCHAR2(30);    
    varSal NUMBER(10,2);

BEGIN
    varSal := 2000;                                                             -- atribui 2000 para a variavel varSal    
SELECT matricula,nome INTO varMat,varN                                          -- seleciona matricula e armazena em varMat e nome em varN
FROM   Aluno                                                                    -- da tabela aluno
WHERE  matricula > 13;                                                          -- onde matricula > 13
IF (varMat = 13) THEN                                                           -- se varMat(matricula) = 13
    INSERT INTO Colaborador VALUES(minhaSeq01.nextval,varN,varSal);             -- se sim adiciona os seguintes valores na tabela colaborador
ELSE
    INSERT INTO Colaborador VALUES(minhaSeq01.nextval,varN,1500);   
END IF;                                                                         -- termina o bloco de execucao IF
END;
  
--- PROCEDURE  --------------                                                   ---------------------------------------------------------------------------    
CREATE or replace PROCEDURE boasVindas(varNome VARCHAR) IS                      -- cria uma procedure com varNome como parametro
-- area de declaracao de variavel
BEGIN
    DBMS_OUTPUT.PUT_LINE('Oi, Seja Bem Vindo! ' || varNome);                    -- || operador de concatenacao 
END boasVindas;
  
--drop procedure boasVindas;   
--SET SERVEROUTPUT ON;  

EXEC boasVindas('Juca');   -- ou EXECUTE boasVindas;                            -- executa a procedure passando 'Juca' como parametro
  
  
------------------------------------------------------------------------------------------------------------------------------------------------------


-- Exemplo: Fa?a um procedimento que recebe como par?metro
-- o codigo e a percentual de aumento de salario de um Colaborador

CREATE or REPLACE PROCEDURE atualizaSalario(varCod NUMBER, varPerc NUMBER)IS    -- procedure passando dois parametros
BEGIN
    UPDATE Colaborador                                                          -- da um update na tabela colaborador
    SET    salario = salario + (salario * varPerc/100)                          -- salario = salario + (salario * varPerc/100) onde varPerc sera passado por parametro
    WHERE  codigo = varCod;                                                     -- onde codigo da tabela colaborador for igual ao varCod passado por parametro
END atualizaSalario; 
           
EXEC atualizaSalario(51,10)                                                     -- executa a procedure onde 51 é o varCod e 10 é o varPerc
select * from colaborador
                                        
--**** EXERCICIOS ****                                                          -----------------------------------------------------------------------------------------------    
--1- Faça um Procedimento PL/SQL que recebe o codigo da disciplina e o novo 
--valor da carga hor?ria (nhoras).Baseado nesse novo valor, atualize o n?mero 
--de horas da disciplina.                                                           

CREATE or replace PROCEDURE p_atualiza(varCod NUMBER, varCH NUMBER)IS           -- procedure passando dois parametros
BEGIN                                                                           -- comeca o bloco de execucao
    UPDATE disciplina                                                           -- da um update na tabela disciplina
    SET    nhoras = varCH                                                       -- nhoras recebe varCH passado por parametro
    WHERE  id = varCod;                                                         -- onde id igual a varCod passado por parametro            
END p_atualiza;                                                                 -- encerra o bloco de execucao

EXEC p_atualiza(4,90);                                                          -- executa a procedure onde 4 é o varCod e 90 é o varCH        
SELECT * FROM Disciplina

--Exemplo de Functions                                                          ----------------------------------------------------------------------------------------------- 
--Fa?a uma fun??o que baseada no c?digo e nhoras
--de uma disciplina retorne o nome da disciplina

CREATE or replace FUNCTION f_exemplo(varCod NUMBER,varNHoras NUMBER)            -- funcao passando dois parametros
RETURN VARCHAR IS                                                               -- a funcao tem que retornar um varchar
    varResultado VARCHAR2(40);                                                  -- variavel que recebe um varchar2 de tamanho 40
BEGIN                                                                           -- comeca o bloco de execucao
    SELECT nome INTO varResultado                                               -- seleciona o nome e armazena em varResultado
    FROM   disciplina                                                           -- da tabela diciplina
    WHERE  id = varCod and nhoras = varNHoras;                                  -- onde id é igual a varCod passado por parametro e nhoras é igual a varNHoras passado por parametro
RETURN(varResultado);                                                           -- retorna varResultado
END f_exemplo;                                                                  -- encerra o bloco de execucao

--chamar uma funcao
SELECT f_exemplo(1,80) FROM Dual                                                -- chama a funcao onde 1 é o varCod e 80 é o varNHoras
  
--Exercicios:                                                                   ----------------------------------------------------------------------------------------------- 
--1- Faca uma Funcao em PL/SQL que recebe o numero de 
--matricula retorna o nome do aluno.

CREATE or REPLACE FUNCTION f_exerc01(varMat NUMBER)                             -- funcao passando um parametro
RETURN VARCHAR IS                                                               -- a funcao tem que retornar um varchar
    varNome VARCHAR2(30);                                                       -- variavel que recebe um varchar2 de tamanho 30
BEGIN                                                                           -- comeca o bloco de execucao
    SELECT nome INTO varNome                                                    -- seleciona o nome e armazena em varNome
    FROM   aluno                                                                -- da tabela aluno
    WHERE  matricula = varMat;                                                  -- onde matricula for igual varMat passado por parametro        
RETURN (varNome);                                                               -- retorna varNome    
END f_exerc01;                                                                  -- encerra o bloco de execucao
SELECT f_exerc01(14) FROM dual;                                                 -- chama a funcao onde 14 é o varMat

--2- Fa?a uma Fun??o PL/SQL que passado o semestre (exemplo:2021/2) retorna o   ----------------------------------------------------------------------------------------------- 
--n?mero de alunos matriculados (quantos)

CREATE or replace FUNCTION f_exerc02(varSem VARCHAR)                            -- funcao passando por parametro varSem
RETURN NUMBER IS                                                                -- a funcao tem que retornar um numero
    varR NUMBER;                                                                -- variavel que recebe um numero
BEGIN                                                                           -- comeca o bloco de execucao
    SELECT  count(a.matricula) INTO varR                                        -- seleciona a contagem de matriculas e armazena em varR        
    FROM    aluno a inner join turma t ON                                       -- da ligacao das tabelas
            a.codigo=t.codigo inner join disciplina d ON
            d.id=t.id inner join ministra m ON
            m.id=d.id 
    WHERE   m.semestre = varSem;                                                -- onde ministra.semestre for igual a varSem passado por parametro
RETURN (varR);                                                                  -- retorna varR
END f_exerc02;                                                                  -- encerra o bloco de execucao
SELECT f_exerc02('2020/1') FROM dual                                            -- chama a funcao onde '2020/1' é o varSem
          
--EXEMPLO: Procedimento que chama Funcao                                        -----------------------------------------------------------------------------------------------     
--SET SERVEROUTPUT ON; 
CREATE or replace PROCEDURE boasVindasX(varMat NUMBER) IS                       -- procedure passando por parametro varMat
    varNome VARCHAR2(40);                                                       -- variavel que recebe um varchar2 de tamanho 40
BEGIN                                                                           -- comeca o bloco de execucao
    varNome := f_exerc01(varMat);                                               -- varNome recebe o retorno da funcao f_exerc01 passando varMat como parametro
    DBMS_OUTPUT.PUT_LINE('Oi, Seja Bem Vindo(a)! ' || varNome);                 -- mensagem que mostra o nome
END boasVindasX;                                                                -- encerra o bloco de execucao

EXEC boasVindasX(14)                                                            -- executa a procedure onde 14 é o varMat
 
--Atividade para Entregar                                                       ----------------------------------------------------------------------------------------------- 
--1- Fa?a em PL/SQL uma FUNCTION que liste o nome do cliente que est? 
--hospedado em determinado quarto. 
 
SELECT * FROM cliente

CREATE OR REPLACE FUNCTION f_nomeCliente(varNumQuarto NUMBER)                   -- funcao que recebe varNumQuarto como parametro    
RETURN VARCHAR IS                                                               -- a funcao tem que retornar um varchar
    varResultado VARCHAR2(40);                                                  -- variavel que recebe um varchar2 de tamanho 40
BEGIN                                                                           -- comeca o bloco de execucao
    SELECT  nome INTO varResultado                                              -- seleciona o nome e armazena em varResultado
    FROM    cliente INNER JOIN reserva ON                                       -- da ligação das tabelas    
            cliente.rg = reserva.rg INNER JOIN quarto ON 
            reserva.num_quarto = quarto.num_quarto
    WHERE   quarto.num_quarto = varNumQuarto;                                   -- onde quarto.num_quarto e igual a varNumQuarto passado por parametro
RETURN varResultado;                                                            -- retorna varResultado
END f_nomeCliente;                                                              -- encerra o bloco de execucao
  
SELECT f_nomeCliente(404) FROM dual;                                            -- chama a funcao onde 404 é o varNumQuarto


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 


CREATE OR REPLACE FUNCTION f_exerc1(numQuarto NUMBER)                           -- funcao que recebe numQuarto como parametro
RETURN VARCHAR IS                                                               -- a funcao tem que retornar um varchar
    varNome VARCHAR2(30);                                                       -- variavel que recebe um varchar2 com tamanho 30
BEGIN                                                                           -- comeca o bloco de execucao
    SELECT  cliente.nome INTO varNome                                           -- seleciona nome do cliente e armazena em varNome
    FROM    cliente INNER JOIN hospedagem ON                                    -- da ligacao das tabelas
            cliente.rg = hospedagem.rg INNER JOIN quarto ON
            quarto.num_quarto = hospedagem.num_quarto
    WHERE   hospedagem.num_quarto = numQuarto AND hospedagem.status = 'O';      -- onde hospedagem.num_quarto é igual a numQuarto passado por parametro e hospedagem.status é igual a 'O'
RETURN varNome;                                                                 -- retorna varNome
END f_exerc1;                                                                   -- encerra o bloco de execucao

SELECT f_exerc1(404) FROM dual;                                                 -- chama a funcao onde 404 é o numQuarto


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 


--2-Faça em PL/SQL uma FUNCTION que o somatório de todos os serviços (mais de um)
--prestados para determinado cliente.

CREATE OR REPLACE FUNCTION f_somaServicos(varCliente NUMBER)                    -- funcao que tem varCliente como parametro
RETURN NUMBER IS                                                                -- a funcao tem que retornar um numero
    varSomaServico NUMBER;                                                      -- variavel que armazena um numero    
BEGIN                                                                           -- comeca o bloco de execucao
    SELECT SUM(servico.valor) INTO varSomaServico                               -- seleciona a soma de servicos.valor e armazena em varSomaServico    
    FROM   cliente INNER JOIN hospedagem ON                                     -- da ligacao das tabelas
           cliente.rg = hospedagem.rg
           INNER JOIN atendimento ON
           hospedagem.id_hospedagem = atendimento.id_hospedagem
           INNER JOIN servico ON
           servico.id_servico = atendimento.id_servico
    WHERE  cliente.rg = varCliente;                                             -- onde cliente.rg é igual a varCliente passado por parametro    
    RETURN varSomaServico;                                                      -- retorna varSomaServico
END f_somaServicos;                                                             -- encerra o bloco de execucao

SELECT f_somaServicos(8899) FROM dual;                                          -- chama a funcao onde 8899 é o varCliente

--3-Faça em PL/SQL um PROCEDURE que efetue uma reserva. Verifique se o quarto   ----------------------------------------------------------------------------------------------- 
--está disponivel (Status D - disponivel, R - reservado, O - ocupado

CREATE or replace PROCEDURE fazerReserva(varIdReserva NUMBER, varRg NUMBER,     -- procedure passando varios parametros    
                                         varNumQuarto NUMBER, varDtReserva DATE, 
                                         varqtdDias NUMBER, vardtEntrada DATE, 
                                         varStatus VARCHAR) IS
    varStatusQuarto CHAR;                                                       -- variavel que armazena um char
BEGIN                                                                           -- comeco do bloco de execucao
    SELECT  status INTO varStatusQuarto                                         -- seleciona o status e armazena em varStatusQuarto
    FROM    quarto                                                              -- da tabela quarto    
    WHERE   num_quarto = varNumQuarto;                                          -- onde num_quarto é igual a varNumQuarto passado por parametro
    IF(varStatusQuarto = 'D') THEN                                              -- se varStatusQuarto for igual a 'D'
        INSERT INTO reserva VALUES(varIdReserva, varRg, varNumQuarto, varDtReserva, -- insere na tabela reserva os seguintes valores passados por parametro
                                   varqtdDias, vardtEntrada, varStatus);
        UPDATE quarto                                                           -- apos ter inserido os valores da um update na tabela quarto
        SET status = 'R'                                                        -- seta o status para 'R'
        WHERE num_quarto = varNumQuarto;                                        -- onde num_quarto é igual a varNumQuarto passado por parametro
    END IF;                                                                     -- encerra o bloco de execucao do IF
END fazerReserva;                                                               -- encerra o bloco de execucao
  
EXEC fazerReserva(12, 8899,405,'20/02/2022',21,'28/02/2022','O');               -- executa a procedure passando os valores por parametro        
SELECT * FROM reserva

--1- Faça um PROCEDURE em PL/SQL para listar e apresentar quantos anos bissextos----------------------------------------------------------------------------------------------- 
--existem entre um intervalo de 2 anos (ano1 e ano2). Teste se ano1 é menor que 
--ano2 para fazer a verificação. Um ano é bissexto quando for possível dividi?lo 
--por 4 ou por 400 (com resto 0) 
--Exemplo: MOD(ano,4) = 0 neste caso é bissexto

CREATE or replace PROCEDURE anosBissextos(varAno1 NUMBER, varAno2 NUMBER) IS    -- procedure passando dois valores por parametro
    cont NUMBER;                                                                -- variavel que armazena um numero
BEGIN                                                                           -- comeca o bloco de execucao
    cont := 0;                                                                  -- a variavel cont recebe o valor 0
    IF(varAno1 <= varAno2) THEN                                                 -- se varAno1 <= varAno2        
        FOR v IN varAno1..varAno2                                               -- v recebe cada valor de varAno1 enquanto varAno1 for menor que varAno2
        LOOP                                                                    -- inicia o loop
            IF(MOD(v,4)=0 or MOD(v,400)=0) THEN                                 -- se resto de divisao de v por 4 for 0 ou v resto por 400 for 0
                DBMS_OUTPUT.PUT_LINE(v);                                        -- mostra o valor de v
                cont := cont+1;                                                 -- cont recebe cont + 1
            END IF;                                                             -- termina o bloco do IF
        END LOOP;                                                               -- termina o loop
        DBMS_OUTPUT.PUT_LINE('Nº de anos Bissextos: ' || cont);                 -- mostra os quantos anos bissextos
    ELSE                                                                        -- se varAno2 for maior que varAno1        
        DBMS_OUTPUT.PUT_LINE('Problema nos intervalos dos anos');               -- mostra msg de erro
    END IF;                                                                     -- termina o bloco do IF
END anosBissextos;                                                              -- termina a procedure

EXEC anosBissextos(2000, 2022);                                                 -- executa a procedure onde 2000 e varAno1 e 2022 e varAno2
SET SERVEROUTPUT ON;                                                            -- para habilitar a msg DBMS


-----------------------EXEMPLO CURSOR EXPLICITO-------------------------------------------------------------------------------------------------------------------------------- 


CREATE TABLE DisciplinaCursor(
id INT PRIMARY KEY,
nome VARCHAR2(30),
nhoras NUMBER(6,2),
dataCadastro DATE
);

SELECT * FROM Disciplina

--Fazer um procedimento que utilize cursor para passar os dados de uma tabela   
--Disciplina, para uma tabela DisciplinaCursor

CREATE or replace PROCEDURE p_cursor01 IS                                       -- cursor
    CURSOR c1 IS                                                                -- cria uma variavel cursor      
        SELECT * FROM Disciplina;                                       
    varCursor c1%ROWTYPE;                                                       -- varCursor é do tipo c1%rowtype que indica que a variavel sera um array de linhas vindas do cursor
BEGIN                                                                           -- comeca o bloco de execucao
    OPEN c1;                                                                    -- abre o cursor c1
    LOOP                                                                        -- inicia o loop
        FETCH c1 INTO varCursor;                                                -- move cada linha de c1 para varCursor
        EXIT WHEN c1%NOTFOUND;                                                  -- sai do cursor quando não houver mais dados
        INSERT INTO DisciplinaCursor(id,nome,nhoras,dataCadastro)               -- insere na tabela disciplinaCursor
        VALUES(varCursor.id, varCursor.nome, varCursor.nhoras, SYSDATE);        -- os seguintes valores
        --SELECT SYSDATE FROM DUAL; --retorna a data atual
    END LOOP;                                                                   -- encerra o loop
    CLOSE c1;                                                                   -- fecha o cursor
END p_cursor01;                                                                 -- termina o bloco de execucao

SELECT * FROM DisciplinaCursor
EXEC p_cursor01;                                                                -- executa o cursor


---------------------------Cursor Exemplo 2 mais simples----------------------------------------------------------------------------------------------------------------------- 


CREATE or replace PROCEDURE p_cursor02 IS                                       -- cursor    
    CURSOR c2 IS                                                                -- cria uma variavel cursor
        SELECT nome,nhoras FROM disciplina order by nhoras;                     -- seleciona nome e nhoras da tabela disciplina    
BEGIN                                                                           -- comeca o bloco de execucao
    FOR regCursor IN c2 LOOP                                                    -- para cada valor dentro de regCursor dentro de c2
        IF(regCursor.nhoras > 80) THEN                                          -- se regCursor.nhoras > 80
            DBMS_OUTPUT.PUT_LINE(regCursor.nome || '-' || regCursor.nhoras);    -- mostra o nome e nhoras
        END IF;                                                                 -- fecha o IF    
    END LOOP;                                                                   -- termina o loop
END p_cursor02;                                                                 -- termina a execucao do bloco

EXEC p_cursor02;                                                                -- executa o cursor


----------------------Exemplo 1 - tratamento de exceções----------------------------------------------------------------------------------------------------------------------- 
                    --EXEMPLO exceção pré-definida


CREATE TABLE empregado(
emp_id number primary key,
emp_nome varchar2(20) not null,
salario number(10,2)
);

insert into empregado values(1,'Ana', 1780.99);
insert into empregado(emp_id,emp_nome) values(2,'Joana');
insert into empregado values(3,'Juca', 2800);

--Procedimento recebe o código do empregado e retorna o salario
CREATE or replace PROCEDURE p_Excecao1 (varId NUMBER) IS                        -- procedure com um parametro
    varNome VARCHAR(3);                                                         -- varNome recebe um varchar de tamanho 3    
    varSal  NUMBER;                                                             -- varSal recebe um numero
BEGIN                                                                           
    SELECT salario INTO varSal                                                  -- seleciona o salario e joga para varSal
    FROM empregado                                                              -- da tabela empregado        
    WHERE emp_id = varId;                                                       -- onde emp_id for igual a varId passado por parametro
    
    --SELECT emp_nome INTO varNome 
    --FROM empregado 
    --WHERE emp_id = varId;
    
    DBMS_OUTPUT.PUT_LINE('Valor do Salário R$: ' || varSal);
EXCEPTION
    WHEN VALUE_ERROR THEN                                                       -- se o valor passado for maior que o que cabe na variavel
        raise_application_error(-20001,'Algo errado com os dados!');            
    WHEN NO_DATA_FOUND THEN                                                     -- quando passado um id que não existe
        raise_application_error(-20022,'Nada encontrado!');                     
END p_Excecao1;

EXEC p_Excecao1(21); --com exceção
EXEC p_Excecao1(1);  --sem exceção
SET SERVEROUTPUT ON;


----------------------exemplo 2 - Exceções do sistema com OTHERS--------------------------------------------------------------------------------------------------------------- 


CREATE or replace PROCEDURE p_Excecao2 (varId NUMBER) IS                        
    varNome VARCHAR(3);
    varSal  NUMBER;
BEGIN
    SELECT salario INTO varSal 
    FROM empregado 
    WHERE emp_id = varId;
    
    --SELECT emp_nome INTO varNome 
    --FROM empregado 
    --WHERE emp_id = varId;
    
    DBMS_OUTPUT.PUT_LINE('Valor do Salário R$: ' || varSal);
EXCEPTION
    WHEN OTHERS THEN                                                            -- quando outro tipo de excecao
        DBMS_OUTPUT.PUT_LINE(SQLCODE);                                          -- mostra a excecao
        DBMS_OUTPUT.PUT_LINE(SQLERRM);                                          -- mostra a excecao
        RAISE;
END p_Excecao2;

EXEC p_Excecao2(21); --com exceção
EXEC p_Excecao2(1);  --sem exceção
EXEC p_Excecao2(3);
SET SERVEROUTPUT ON;


----------------------exemplo 3 - Excecoes programadas------------------------------------------------------------------------------------------------------------------------- 
                    --exemplo 1

CREATE or replace PROCEDURE p_ExcecaoProgramada01(varId NUMBER) IS
    varRes NUMBER;
    erro1 EXCEPTION;                                                            -- erro1 é do tipo exception
BEGIN
    if(varId >= 1) THEN                                                         -- se tudo der certo executa o IF
        SELECT salario INTO varRes 
        FROM empregado
        WHERE emp_id = varId;
        DBMS_OUTPUT.PUT_LINE('salario ' || varRes);
    else                                                                        -- se não mostra o erro1 que vai ser programado abaixo
        RAISE erro1;
    END IF;
    
    EXCEPTION 
        WHEN erro1 THEN                                                         -- quando erro1
            raise_application_error(-20001, 'Id deve ser >= 1');                -- mostra a msg
        --WHEN erro2 THEN
            --raise_application_error(-20001, 'Id deve ser >= 1');
END p_ExcecaoProgramada01;

EXEC p_ExcecaoProgramada01(1);  --sucesso
EXEC p_ExcecaoProgramada01(-1); --error

----------------------exemplo 3 - Excecoes programadas------------------------------------------------------------------------------------------------------------------------- 
                    --exemplo 2

CREATE or replace PROCEDURE p_ExcecaoProgramada02(varId NUMBER, varTaxa NUMBER) IS
    varRes NUMBER;
BEGIN
    SELECT salario INTO varRes 
    FROM empregado
    WHERE emp_id = varId;
        if(varRes is null) THEN
            raise_application_error(20001, 'Sem Salario');
        else
            update empregado
            set salario = salario + (salario * varTaxa/100)
            where emp_id = varId;
        END IF;
    
END p_ExcecaoProgramada02;

select * from empregado

EXEC p_ExcecaoProgramada02(3,10); -- sucesso
EXEC p_ExcecaoProgramada02(2,50); -- error

------------------------ TRIGGER ---------------------------------------------------------------------------------------------------------------------------------------------- 

CREATE SEQUENCE seq_TgEmp
start with 1
increment by 1;
--criada a sequencia

CREATE TABLE logEmpregado(
id NUMBER PRIMARY KEY,
codigo NUMBER,
salarioVelho NUMBER(10,1),
salarioNovo NUMBER(10,2),
dataAlteracao DATE,
usuario VARCHAR2(30)
);

CREATE or replace TRIGGER tg_AuditaEmp                                          -- dispara uma trigger
AFTER update ON empregado                                                       -- dps de um update em empregado
FOR EACH ROW                                                                    -- para cada linha
WHEN (NEW.salario > OLD.salario)                                                -- a trigger so dispara quando o novo salario for maior que o antigo
BEGIN
    INSERT INTO logEmpregado VALUES (seq_TgEmp.nextVal, :OLD.emp_id, :OLD.salario, :NEW.salario, sysdate, user);
END tg_AuditaEmp;

SELECT * FROM empregado
SELECT * FROM logEmpregado

update Empregado
set salario = 3201
where emp_id = 3;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--Faça um TRIGGER para gerar as parcelas relacionadas a uma venda

CREATE OR REPLACE TRIGGER tg_geraParcela                                        -- dispara um trigger
    AFTER INSERT ON vendas                                                      -- dps de um insert na tabela vendas                    
    FOR EACH ROW                                                                -- para cada linha lida
    DECLARE
        varEstoque NUMBER;
        erro1 EXCEPTION;
        varValorParcela NUMBER;
        varDataAtual DATE;
    BEGIN
        --verificar a qtd em estoque
        SELECT estoque INTO varEstoque                                          -- seleciona o estoque e guarda em varEstoque    
        FROM produtos                                                           -- da tabela produtos
        WHERE codigo = :NEW.codigoProduto;                                      -- onde o codigo for igual ao novo codigo inserido na tabela vendas
        
        IF(varEstoque < :NEW.quantidade) THEN                                   -- se varEstoque for menor que a quantidade inserida na tabela vendas
            RAISE erro1;                                                        -- mostra msg de erro
        ELSE
            --Se tem produto em estoque, atualiza na tabela produto a quantidade 
            --do estoque
            UPDATE produtos                                                     -- update na tabela produtos
            SET estoque = estoque - :NEW.quatidade                              -- estoque recebe o estoque - a quantidade colocada na tabela vendas            
            WHERE codigo = :NEW.codigoProduto;                                  -- onde o codigo da tabela produtos é igual ao codigo inserido na tabela vendas
            
            --encontrar o valor da parcela
            varValorParcela := (:NEW.valorProduto * :NEW.quantidade) / :NEW.parcelas; -- varValorParcela recebe o resultado
            varDataAtual := current_date;                                       -- varDataAtual recebe a data atual do sistema
            FOR i IN 1..:NEW.parcelas                                           -- para cada i dentro do intervalo de 1 ate quantidade de parcelas inseridas na tabela vendas
            LOOP
                varDataAtual :=  varDataAtual + 30;                             -- soma + 30 para varDataAtual em cada loop
                INSERT INTO parcelas(numero, valoParcela, dataVenc, nvenda)     -- insere na tabela parcelas
                VALUES(i, varValorParcela, varDataAtual, :NEW.numero);          -- os seguintes valores
            END LOOP;
        END IF;
        
        EXCEPTION
            WHEN erro1 THEN
                RAISE.APPLICATION_ERROR(-20001, 'Sem estoque');
    END tg_geraParcela;

select * from vendas
select * from produtos
select * from parcelas

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--1- Faça um procedimento para armazenar em um cursor todas as reservas. Depois
--percorra esse cursor para listar data da entrada da reserva, cliente e o quarto.
--Somente das reservas com data de entrada atual e nos próximos 5 dias.

SET SERVEROUTPUT ON;

CREATE or replace PROCEDURE p_cursor1904 IS
Cursor c1 IS
    SELECT  q.num_quarto, c.nome,r.data_Entrada
    FROM    quarto q inner join reserva r ON
            q.num_quarto = r.num_quarto inner join cliente c ON
            c.rg = r.rg
    order by  r.data_Entrada;      
BEGIN
    FOR regCursor IN c1 LOOP
        IF  (regCursor.data_Entrada >= current_date-1) and
            (regCursor.data_Entrada <= current_date+5) THEN
            DBMS_OUTPUT.PUT_LINE(regCursor.nome||' - '||regCursor.num_quarto
                                ||' - '||regCursor.data_Entrada);
        END IF;
    END LOOP;
END p_cursor1904;
  
EXEC p_cursor1904;
    
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--2- Faça um Trigger que dispara quando for realizada uma reserva no Hotel. Setar
--para O (ocupado) o status do quarto após a reserva. Verificar se o quarto está
--disponível para reserva. Caso não esteja lança uma exceção programada impedindo
--a reserva.
  
CREATE or replace TRIGGER tg_atividade
AFTER insert ON Reserva
FOR EACH ROW
DECLARE
    varStatus VARCHAR2(2);
    erro1 EXCEPTION;

BEGIN
    SELECT status INTO varStatus 
    FROM quarto 
    WHERE num_quarto = :NEW.num_quarto;

    IF (varStatus <> 'O') THEN
        UPDATE quarto
        SET    status = 'O'
        WHERE  num_quarto = :NEW.num_quarto;
    ELSE
        raise erro1;
    END IF;

    EXCEPTION 
        WHEN erro1 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Quarto Ocupado');
END tg_atividade;





