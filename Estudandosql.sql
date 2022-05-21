-- Exemplo: Fa?a um procedimento que recebe como par?metro
-- o codigo e a percentual de aumento de salario de um Colaborador
create or replace procedure p_procedure01(varCod number, varSal number) is
begin
    update colaborador
    set salario = salario + (salario * varSal/100)
    where codigo = varCod;
end p_procedure01;

exec p_procedure01(50, 10)

select * from colaborador

--1- Faça um Procedimento PL/SQL que recebe o codigo da disciplina e o novo 
--valor da carga hor?ria (nhoras).Baseado nesse novo valor, atualize o n?mero 
--de horas da disciplina.
create or replace procedure p_procedure02(varCod number, varNhoras number) is
begin
    update disciplina
    set nhoras = varNhoras
    where id = varCod;
end p_procedure02;

exec p_procedure02(1, 100)

select * from disciplina

--Fa?a uma fun??o que baseada no c?digo e nhoras
--de uma disciplina retorne o nome da disciplina
create or replace function f_function01(varCod number, varNhoras number)
return varchar is
    varNome varchar2(40);
begin
    select nome into varNome
    from disciplina
    where id = varCod and nhoras = varNhoras;
    DBMS_OUTPUT.PUT_LINE(varNome);
    return(varNome);
end f_function01;

select f_function01(1, 100) from dual

SET SERVEROUTPUT ON;


--1- Faca uma Funcao em PL/SQL que recebe o numero de 
--matricula retorna o nome do aluno.

create or replace function f_function02(varMat number)
return varchar is
    varNome varchar2(40);
begin
    select nome into varNome
    from aluno
    where matricula = varMat;
    DBMS_OUTPUT.PUT_LINE(varNome);
    return(varNome);
end f_function02;

select * from aluno

select f_function02(10) from dual

--2- Fa?a uma Fun??o PL/SQL que passado o semestre (exemplo:2021/2) retorna o 
--n?mero de alunos matriculados (quantos)
create or replace function f_function03(varSemestre varchar)
return number is
    varNmatriculas number;
begin
    select count(aluno.matricula) into varNmatriculas
    from ministra inner join disciplina on
         ministra.id = disciplina.id inner join turma on
         disciplina.id = turma.id inner join aluno on
         turma.codigo = aluno.codigo
    where ministra.semestre = varSemestre;
    DBMS_OUTPUT.PUT_LINE(varNmatriculas);
    return(varNmatriculas);
end f_function03;

select f_function03('2021/01') from dual


--1- Fa?a em PL/SQL uma FUNCTION que liste o nome do cliente que est? 
--hospedado em determinado quarto. 
create or replace function f_function04(varQuarto number)
return varchar is
    varCliente varchar2(40);
begin
    select cliente.nome into varCliente
    from quarto inner join hospedagem on
         quarto.num_quarto = hospedagem.num_quarto inner join cliente on
         hospedagem.rg = cliente.rg
    where quarto.num_quarto = varQuarto;
    DBMS_OUTPUT.PUT_LINE(varCliente);
    return(varCliente);
end f_function04;

select f_function04(404) from dual

--2-Faça em PL/SQL uma FUNCTION que o somatório de todos os serviços (mais de um)
--prestados para determinado cliente.
create or replace function f_function05(varCliente number)
return number is
    varSomaServico number;
begin 
    select sum(servico.valor) into varSomaServico
    from servico inner join atendimento on
         servico.id_servico = atendimento.id_servico inner join hospedagem on
         atendimento.id_hospedagem = hospedagem.id_hospedagem
    where hospedagem.rg = varCliente;
    DBMS_OUTPUT.PUT_LINE(varSomaServico);
    return(varSomaServico);
end f_function05;

select f_function05(8899) from dual

--3-Faça em PL/SQL um PROCEDURE que efetue uma reserva. Verifique se o quarto
--está disponivel (Status D - disponivel, R - reservado, O - ocupado
create or replace procedure p_procedure01(varID number, varRG number, varNum_quarto number, varDt_reserva date, 
                                          varQtd_dias number, varDt_entrada date, varStatus varchar) IS
    varStatusQuarto varchar2(1);
begin
    select status into varStatusQuarto
    from quarto
    where num_quarto = varNum_quarto;
    if(varStatusQuarto = 'D') then
        insert into reserva values(varID, varRG, varNum_quarto, varDt_reserva, varQtd_dias, varDt_entrada, varStatus);
        update quarto
        set status = 'R'
        where num_quarto = varNum_quarto;
    else
        DBMS_OUTPUT.PUT_LINE('Quarto nao esta disponivel');
    end if;
end p_procedure01;
exec p_procedure01(603,8899,301,'10/01/2020',10,'29/04/2022','O')
exec p_procedure01(602,8899,405,'10/01/2020',10,'29/04/2022','O')
select * from reserva

--1- Faça um PROCEDURE em PL/SQL para listar e apresentar quantos anos bissextos
--existem entre um intervalo de 2 anos (ano1 e ano2). Teste se ano1 é menor que 
--ano2 para fazer a verificação. Um ano é bissexto quando for possível dividi?lo 
--por 4 ou por 400 (com resto 0) 
--Exemplo: MOD(ano,4) = 0 neste caso é bissexto
create or replace procedure p_procedure06(varAno1 number, varAno2 number) is
begin
    if(varAno1 <= varAno2) then
        for i in varAno1..varAno2 loop
            if(MOD(i,4)=0 or MOD(i,400)=0) then
                DBMS_OUTPUT.PUT_LINE(i);
            end if;
        end loop;
    end if;
end p_procedure06;
EXEC p_procedure06(2000, 2022); 


--Fazer um procedimento que utilize cursor para passar os dados de uma tabela 
--Disciplina, para uma tabela DisciplinaCursor
create or replace procedure c_cursor is
    cursor c1 is
        select * from disciplina;
    varCursor c1%rowtype;
begin
    open c1;
    loop
        fetch c1 into varCursor;
        exit when c1%notfound;
        insert into disciplinaCursor 
        values(varCursor.id, varCursor.nome, varCursor.nhoras, SYSDATE);
    end loop;
    close c1;
end c_cursor;
exec c_cursor;

select * from disciplina
select * from disciplinaCursor
drop table disciplinaCursor


--Faça um TRIGGER para gerar as parcelas relacionadas a uma venda
create or replace trigger t_trigger


--1- Faça um procedimento para armazenar em um cursor todas as reservas. Depois
--percorra esse cursor para listar data da entrada da reserva, cliente e o quarto.
--Somente das reservas com data de entrada atual e nos próximos 5 dias.



--2- Faça um Trigger que dispara quando for realizada uma reserva no Hotel. Setar
--para O (ocupado) o status do quarto após a reserva. Verificar se o quarto está
--disponível para reserva. Caso não esteja lança uma exceção programada impedindo
--a reserva.


--faca o comando SQL para listar o gasto na hospedagem de todos os cliente
--(custo do quarto + servicos). Liste ordenado pela data de hospedagem, apenas dos
--meses de marco e abril de 2022.
create or replace function f_functionGasto(varCliente number)
return number is
    varSomaQuarto number;
    varSomaServico number;
begin
    select sum(valor) into varSomaQuarto
    from tipo_quarto inner join quarto on
         tipo_quarto.id_tipo = quarto.id_tipo inner join hospedagem on
         quarto.num_quarto = hospedagem.num_quarto inner join 
    where hospedagem.rg = varCliente;
    
    
    select sum(valor) into varSomaServico
    from servico
    where hospedagem.rg = varCliente;
    
end f_functionGasto;

select * from atendimento
select * from hospedagem
select * from tipo_quarto
select * from quarto


--Faca uma function que liste passando o mes como parametro, apresente o numero
--de hospedes no quarto 401.
create or replace function f_functionNhospedes(varMes date)
return number is
    varResultado number;
begin
    select count(id_hospedagem) into varResultado
    from hospedagem
    where num_quarto = 404 and data_entrada = varMes;
    return(varResultado);
end f_functionNhospedes;

select f_functionNhospedes('21/03/22') from dual


--Faca um procedimento para armazenar em um cursor todos os serviços(descricao e
--valor) realizados na hospedagem dos clientes. Depois apresente apenas das 
--hospedagens do mes de abril de 2022.
create or replace procedure p_cursorServicos is
    cursor c1 is
        select servico.descricao, servico.valor, hospedagem.rg, hospedagem.data_entrada
        from servico inner join atendimento on
             servico.id_servico = atendimento.id_servico inner join hospedagem on
             atendimento.id_hospedagem = hospedagem.id_hospedagem
        order by hospedagem.rg;
begin 
    for regCursor in c1 loop
            DBMS_OUTPUT.PUT_LINE(regCursor.descricao || '-' || regCursor.valor || '-' || regCursor.rg);
    end loop;
end p_cursorServicos;

exec p_cursorServicos;

SET SERVEROUTPUT ON;


--Faca uma trigger que dispara quando for realizado o checkout da hospedagem,
--atualize o status do quarto para 'D'. Caso nao esteja disponivel lanca uma excecao
--programada impedindo a reserva.
create or replace trigger t_triggerCheck
after update on hospedagem
for each row
when (old.data_saida = new.sysdate) 
begin
    update quarto
    set status = 'D'
    where 
end t_triggerCheck;









