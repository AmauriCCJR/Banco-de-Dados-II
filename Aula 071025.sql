-- Exemplo 1 - Criando um Pivot Básico -- Contando Valores Numéricos --
create database pivotteste
go
use pivotteste
go
Create Table Usuarios 

(Codigo TinyInt, 

Nome Varchar(10))

Go
 
-- Inserindo --

Insert Into Usuarios  Values (1,'jose')

Insert Into Usuarios  Values (2,'mario')

Insert Into Usuarios  Values (1,'jose')

Insert Into Usuarios  Values (2,'mario')

Insert Into Usuarios  Values (3,'celso')

Insert Into Usuarios  Values (4,'andre')

Go
 
-- Consultando os Dados --

Select * From Usuarios

Go
 
-- Montando o Pivot Table -- Transformando os Nomes dos Usuários em Colunas Distintas com Totais --

Select * From Usuarios

Pivot (Count(Codigo) For Nome In ([Jose], [Mario], [Celso],[Andre])) As Pvt

Go
 
 
Select [jose],[mario],[celso],[andre] From Usuarios

Pivot (Count(Codigo) For Nome In ([jose],[mario],[celso],[andre])) As Pvt -- Definindo as 

Go
 
-- Apresentando colunas específicas do Pivot --

Select Pvt.Andre As 'André Chato', Pvt.Mario From Usuarios

Pivot (Count(Codigo) For Nome In ([Jose],[Mario],[Celso],[Andre])) As Pvt

Go
 
-- Exemplo 2 -- Criando um Pivot Básico -- Contando valores caracteres --

-- Removendo a Tabela Usuarios --

Drop Table Usuarios

Go
 
-- Recriando a Tabela Usuarios --

Create Table Usuarios 

(Codigo TinyInt Identity(1,1),

Nome Varchar(10),

IdUsuario TinyInt)

Go
 
-- Inserindo --

Insert Into Usuarios  Values ('jose',12)

Insert Into Usuarios  Values ('mario',10)

Insert Into Usuarios  Values ('jose',12)

Insert Into Usuarios  Values ('mario',10)

Insert Into Usuarios  Values ('celso',8)

Insert Into Usuarios  Values ('andre',6)

Go
 
-- Consultando --

Select * From Usuarios

Go
 
-- Montando o Pivot Table -- Transformando os valores do IdUsuario em Colunas distintas --

Select Pvt.[6], Pvt.[8], Pvt.[10], Pvt.[12] From Usuarios

Pivot (Count(Nome) For IdUsuario In ([6],[8],[10],[12])) As Pvt

Go
 
-- Removendo a repetição de Linhas na apresentação do Pivot Table --

Select Pvt.[6] As 'José', Pvt.[8] As 'Mario' From -- Select de apresentação --

(Select Nome, IdUsuario From Usuarios) As U -- Select Base para o Pivot usar as colunas na transformação --

Pivot (Count(Nome) For IdUsuario In ([6],[8],[10],[12])) As Pvt

Go
 
-- Exemplo 3 -- Trabalhando com Funções de Agregação no Pivot Table --

Create Table Vendas 

(CodigoVenda Int Identity(1,1) Primary Key Clustered, 

AnoVenda SmallInt, 

ValorVenda Money)

Go
 
-- Inserindo --

Insert Into Vendas 

Values (2015, 12000), (2016, 18000), (2017, 25000), (2015, 15000), (2016, 6000), (2016, 20000), (2017, 24000),

            (2018, 120), (2018, 1000), (2019, 200), (2019, 150), (2020, 600), (2020, 200), (2021, 4000), (2022, 8000)

Go
 
-- Consultando --

Select * From Vendas

Go


-- Montando o pivot table -- Transformando as linhas de anos e vendas em colunas, estabelecendo a soma por ano

select NomeQualquer.[2015], NomeQualquer.[2016], NomeQualquer.[2017], NomeQualquer.[2018] from --Select de apresentação
(select AnoVenda,ValorVenda from Vendas) as V -- select base para o pivot utilizar a criar colunas
pivot (sum(ValorVenda) for AnoVenda in ([2015],[2016],[2017],[2018])) as NomeQualquer -- operador pivot e a função de agregação --
go


-- Montando um pivot table sumarizado --

select  Convert(Numeric(8,2), ([2016]+[2018]+[2020]+[2022])) as SomaAnosPares,
		Convert(Numeric(8,2), ([2015]+[2017]+[2019]+[2021])) as SomaAnosImpares,
		Convert(Numeric(8,2), ([2015]+[2016]+[2017]+[2018]+[2019]+[2020]+[2021]+[2022])) as SomaGeral
from 
(select AnoVenda, ValorVenda from Vendas) as Ve
pivot (sum(ValorVenda) for AnoVenda in ([2015],[2016],[2017], [2018], [2019], [2020], [2021], [2022])) as Pvt
go

-- Exemplo 4 --

create table Fornos 
( id int primary key,
Defeito varchar(20) not null,
Forno varchar(20) not null,
Equipe Varchar(20) not null
)
go

insert into Fornos values 
(1, 'Defeito A', 'Forno 3', 'Azul'), (2, 'Defeito A', 'Forno 2', 'Verde'), (3,'Defeito B','Forno 1','Azul'),(4,'Defeito A','Forno 1','Preto'),
(5,'Defeito B','Forno 2','Verde'),(6,'Defeito B','Forno 2','Azul'),(7,'Defeito A','Forno 1','Preto'),(8,'Defeito A','Forno 2','Azul')
go



-- Dois Pivot juntos para dois calculos diferentes --
Select Pvt.[Defeitos Agrupados por Equipes], Pvt.Fornos, Pvt.Azul, Pvt.Preto, Pvt. Verde from
(select CONCAT(Defeito, '-', Equipe) as DefeitosPorEquipe, -- Coluna para ser utilizada para contar o pivot
		CONCAT(Defeito, '-', Equipe) as 'Defeitos agrupados por Equipes', 
		Equipe, 
		forno as 'Fornos' 
		from Fornos) as F -- Coluna para mostrar os dados
pivot (count(DefeitosPorEquipe) for Equipe in ([Azul],[Preto], [Verde])) as Pvt
	union all
	Select 'Totais...', '---->', 
	sum(Azul) as SomaAzul, 
	sum(Preto) as SomaPreto, 
	sum(Verde) as SomaVerde 
	from
	(select concat(Defeito,' - ', Equipe) as DefeitosPorEquipe, Equipe from Fornos) as F
	pivot (Count(DefeitosPorEquipe) for Equipe in ([Azul], [Preto], [Verde])) as Pvt
go

-- UNPIVOT --

-- Exemplo 1 -- Vendas Por Funcioanario --

-- Criando a Tabela VendasPorFuncionario --

Create Table VendasPorFuncionario 

(CodigoFuncionario TinyInt, 

Empresa1 TinyInt, 

Empresa2 TinyInt,  

Empresa3 TinyInt, 

Empresa4 TinyInt, 

Empresa5 TinyInt);  

Go
 
-- Inserindo --

Insert Into VendasPorFuncionario Values (1,4,3,5,4,4);  

Insert Into VendasPorFuncionario Values (2,4,1,5,5,5);  

Insert Into VendasPorFuncionario Values (3,4,3,5,4,4);  

Insert Into VendasPorFuncionario Values (4,4,2,5,5,4);  

Insert Into VendasPorFuncionario Values (5,5,1,5,5,5);  

Go
 
-- Consultando --

Select * From VendasPorFuncionario

Go
 
 --Montando o unPivot -- Transformando as colunas de empresas em linhas --


 select UnPvt.CodigoFuncionario as Funcionario, 
 UnPvt.NomeDaEmpresa as 'Nome da Empresa',
 UnPvt.TotalDeVendasPorEmpresa as 'Total de Vendas por Empresa'
 from 
(Select codigoFuncionario, 
Empresa1, 
Empresa2, 
Empresa3, 
Empresa4, 
Empresa5 from VendasPorFuncionario) as V
 unpivot (TotalDeVendasPorEmpresa for NomeDaEmpresa in (Empresa1, Empresa2, Empresa3, Empresa4, Empresa5)) as UnPvt
 order by NomeDaEmpresa
 go


 -- Exemplo 2 -- Relação de Estudantes --
Create Table Estudantes 
(Codigo Int,
Nota1 Float,
Nota2 Float,
Nota3 Float)
Go
 
-- Inserindo cinco Estudantes e suas respectivas Notas --
Insert Into Estudantes 
Values (1, 5.6, 7.3, 4.2), 
            (2, 4.8, 7.9, 6.5), 
			(3, 6.8, 6.6, 8.9), 
			(4, 8.2, 9.3, 9.1), 
			(5, 6.2, 5.4, 4.4)
Go
 
-- Consultando --
Select * From Estudantes
Go

select Codigo as Estudante, DescricaoNota as 'Descrição da Nota', Notas from
(select Codigo, Nota1, Nota2, Nota3 from Estudantes) as E
unpivot (Notas for DescricaoNota in (Nota1, Nota2, Nota3)) as unpvt
go
