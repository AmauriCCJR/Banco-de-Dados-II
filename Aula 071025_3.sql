--Criando o Banco de Dados - MinhasVisoes --
Create Database MinhasVisoes
Go
 
-- Acessando o Banco de Dados - MinhasVisoes --
Use MinhasVisoes
Go
 
-- Criando a Tabela Cargos --
Create Table Cargos
(CodigoCargo Char(2) Primary Key Not Null,
  DescricaoCargo Varchar(50) Not Null,
  VlrSalario Numeric(6,2) Not Null)
Go
 
-- Criando a Tabela Departamentos --
Create Table Departamentos
(CodigoDepartamento Char(2) Primary Key Not Null,
DescricaoDepartamento Varchar(30) Not Null,
RamalTel SmallInt Not Null)
Go
 
-- Criando a Tabela Funcionarios --
Create Table Funcionarios 
(NumeroRegistro Int Primary Key Not Null,
NomeFuncionario Varchar(80) Not Null,
DtAdmissao Date Default GetDate(),
Sexo Char(1) Not Null Default 'M',
CodigoCargo Char(2) Not Null,
CodigoDepartamento Char(2) Not Null)
Go
 
-- Criando os relacionamentos --
Alter Table Funcionarios
Add Constraint [FK_Funcionarios_Cargos] Foreign Key (CodigoCargo)
   References Cargos(CodigoCargo)
Go
 
Alter Table Funcionarios
Add Constraint [FK_Funcionarios_Departamentos] Foreign Key (CodigoDepartamento)
  References Departamentos(CodigoDepartamento)
Go
 
-- Inserindo os Dados --
Insert Into Cargos (CodigoCargo, DescricaoCargo, VlrSalario)
Values ('C1', 'Aux.Vendas', 350.00), 
	   ('C2', 'Vigia', 400.00),
	   ('C3', 'Vendedor', 800.00),
	   ('C4', 'Aux.Cobran a', 250.00), 
	   ('C5', 'Gerente', 1000.00), 
       ('C6', 'Diretor', 2500.00),
	   ('C7', 'Presidente', 5600.00)
Go
 
Insert Into Departamentos (CodigoDepartamento,DescricaoDepartamento,RamalTel)
Values ('D1', 'Assist.T cnica', 2246),
       ('D2', 'Estoque', 2589),
	   ('D3', 'Administra  o', 2772),
	   ('D4', 'Seguran a', 1810),
	   ('D5', 'Vendas', 2599),
	   ('D6', 'Cobran a', 2688)
Go
 
Insert Into Funcionarios (NumeroRegistro, NomeFuncionario, DtAdmissao, Sexo, CodigoCargo, CodigoDepartamento)
Values (101, 'Luis Sampaio', '2003-08-10', 'M', 'C3', 'D5'),
       (104, 'Carlos Pereira', '2004-03-02', 'M', 'C4', 'D6'),
	   (134, 'Jose Alves', '2002-05-03', 'M', 'C5', 'D1'),
	   (121, 'Luis Paulo Souza', '2001-12-10', 'M', 'C3', 'D5'),
	   (195, 'Marta Silveira', '2002-01-05', 'F', 'C1', 'D5'),
	   (139, 'Ana Luiza', '2003-01-12', 'F', 'C4', 'D6'),
	   (123, 'Pedro Sergio', '2003-06-29', 'M', 'C7', 'D3'),
	   (148, 'Larissa Silva', '2002-06-01', 'F', 'C4', 'D6'),
	   (115, 'Roberto Fernandes', '2003-10-15', 'M', 'C3', 'D5'),
	   (22, 'Sergio Nogueira', '2000-02-10', 'M', 'C2', 'D4')
Go



-- Simular o select que vai trazer os dados
select NomeFuncionario, convert(varchar(10), DtAdmissao, 103) AS 'Data de Admissão', 
	DATEDIFF(year, DtAdmissao, getdate()) as 'Total de Anos',
	DATEDIFF(MONTH, DtAdmissao, getdate()) as 'Total de Meses',
	DATEDIFF(DAY, DtAdmissao, getdate()) as 'Total de Dias'
	from Funcionarios
go


--Evoluir o select para uma visão

create view V_TempoDeTrabalho
as
select NomeFuncionario, convert(varchar(10), DtAdmissao, 103) AS 'Data de Admissão', 
	DATEDIFF(year, DtAdmissao, getdate()) as 'Total de Anos',
	DATEDIFF(MONTH, DtAdmissao, getdate()) as 'Total de Meses',
	DATEDIFF(DAY, DtAdmissao, getdate()) as 'Total de Dias'
	from Funcionarios
go


select NomeFuncionario, 
	[Data de Admissão], 
	[Total de Anos], 
	[Total de Meses], 
	[Total de Dias] 
	from V_TempoDeTrabalho
	order by [Data de Admissão] desc
go

-- simulando o select de bonifação de salarios --

select DescricaoCargo,VlrSalario,
	case 
	when vlrSalario between 100 and 599 then (vlrSalario*0.35)
	when VlrSalario between 600 and 799 then (VlrSalario *0.2)
	when VlrSalario between 800 and 999 then (VlrSalario * 0.08)
	when VlrSalario >= 1000 then(VlrSalario * 0.05)
	end as Bonus
from Cargos
go

-- Evoluindo o select para uma nova view --

create view V_CalcBonificacaoAnual
as
select DescricaoCargo,VlrSalario,
	case 
	when vlrSalario between 100 and 599 then (vlrSalario*0.35)
	when VlrSalario between 600 and 799 then (VlrSalario *0.2)
	when VlrSalario between 800 and 999 then (VlrSalario * 0.08)
	when VlrSalario >= 1000 then(VlrSalario * 0.05)
	end as Bonus
from Cargos
go


--Executando --
select DescricaoCargo, VlrSalario, Bonus, (VlrSalario+Bonus) as 'Salario Bonificado'  from V_CalcBonificacaoAnual
go


--Alterando a estrutura da view adicionando a coluna codigoCargo --

alter view V_CalcBonificacaoAnual
as
select CodigoCargo, DescricaoCargo,VlrSalario,
	case 
	when vlrSalario between 100 and 599 then (vlrSalario*0.35)
	when VlrSalario between 600 and 799 then (VlrSalario *0.2)
	when VlrSalario between 800 and 999 then (VlrSalario * 0.08)
	when VlrSalario >= 1000 then(VlrSalario * 0.05)
	end as Bonus
from Cargos
go

--Estabelecendo a junção entre a tabela Funcionarios e a view --

select F.NomeFuncionario, F.CodigoCargo, f.CodigoDepartamento, 
v.DescricaoCargo, v.VlrSalario, v.Bonus, (v.VlrSalario+bonus) as 'Salário Bonificado'
from Funcionarios F inner join V_CalcBonificacaoAnual V on F.CodigoCargo = V.CodigoCargo
where v.VlrSalario >= 500
order by [Salário Bonificado]desc
go



