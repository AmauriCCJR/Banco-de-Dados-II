-- Atividade: CTE em cenário de vendas de vinhos --
-- Criando o Banco de Dados CTEVinhos --
Create Database CTEVinhos
Go

-- Acessando --
Use CTEVinhos
Go

-- Criação das tabelas principais --
Create Table Vinhos 
(CodigoVinhos Int Primary Key Identity(1,1),
  Nome Varchar(100),
  Tipo Varchar(50),
  Safra Int)
Go

Create Table Clientes
(CodigoClientes Int Primary Key Identity(1,1),
  Nome Varchar(100),
  Cidade Varchar(100))
Go

Create Table Regioes 
(CodigoRegioes Int Primary Key Identity(1,1),
  Nome Varchar(100))
Go

Create Table Funcionarios 
(CodigoFuncionarios Int Primary Key Identity(1,1),
  Nome Varchar(100),
  SupervisorDe Int)
Go

Create Table Vendas 
(CodigoVendas Int Primary Key Identity(1,1),
 CodigoClientes Int,
 CodigoVinhos Int,
 CodigoFuncionarios Int,
 CodigoRegioes Int,
 Quantidade Int,
 ValorUnitario Decimal(10,2),
 DataVenda Date)
Go


-- Criação dos relacionamentos após as tabelas --

Alter Table Vendas 
 Add Constraint FK_Vendas_Clientes_CodigoClientes Foreign Key (CodigoClientes) 
  References Clientes(CodigoClientes)
Go

Alter Table Vendas 
 Add Constraint FK_Vendas_Vinhos_CodigoVinhos Foreign Key (CodigoVinhos) 
  References Vinhos(CodigoVinhos)
Go

Alter Table Vendas 
 Add Constraint FK_Vendas_Funcionarios_CodigoFuncionarios Foreign Key (CodigoFuncionarios) 
  References Funcionarios(CodigoFuncionarios)
Go

Alter Table Vendas 
 Add Constraint FK_Vendas_Regioes_CodigoRegioes Foreign Key (CodigoRegioes) 
  References Regioes(CodigoRegioes)
Go

-- Inserção de dados nas tabelas --
-- Vinhos --
Insert Into Vinhos (Nome, Tipo, Safra)
 Values ('Cabernet Sauvignon', 'Tinto', 2018),
             ('Merlot', 'Tinto', 2019),
             ('Chardonnay', 'Branco', 2020),
             ('Rosé da Serra', 'Rosé', 2021),
             ('Espumante São Roque', 'Espumante', 2022)
Go

-- Clientes --
Insert Into Clientes (Nome, Cidade)
Values ('Alice Borges', 'São Roque'),
            ('Marcos Tavares', 'Sorocaba'),
            ('Fernanda Lopes', 'Jundiaí'),
            ('Rafael Costa', 'São Paulo'),
            ('Juliana Prado', 'Campinas')
Go

-- Regioes --
Insert Into Regioes (Nome)
Values ('Centro'),
            ('Zona Norte'),
            ('Zona Sul'),
            ('Zona Leste'),
            ('Zona Oeste')
Go

-- Funcionarios --
Insert Into Funcionarios (Nome, SupervisorDe)
Values ('Carlos Ribeiro', NULL),
            ('Beatriz Lima', 1),
            ('Eduardo Martins', 1),
            ('Tatiane Souza', 2),
            ('João Pedro', 2)
Go

-- Vendas --
Insert Into Vendas (CodigoClientes, CodigoVinhos, CodigoFuncionarios, CodigoRegioes, Quantidade, ValorUnitario, DataVenda)
Values (1, 1, 2, 1, 10, 45.00, '2025-10-01'),
            (2, 3, 3, 2, 5, 60.00, '2025-10-02'),
            (3, 2, 4, 3, 8, 50.00, '2025-10-03'),
            (4, 5, 5, 4, 3, 80.00, '2025-10-04'),
            (5, 4, 2, 5, 6, 55.00, '2025-10-05')
Go

-- Implementando a CTEs --

-- 1 --

--CTE não se cria, se declara em memoria --

;with CTE_VendasPorRegiao (Regiao, TotalVendas) 
as 
(
	select r.Nome as Região, sum(v.Quantidade * v.ValorUnitario) as TotalVendas 
	from Vendas v inner join Regioes r on v.CodigoRegioes = r.CodigoRegioes
	group by r.Nome
) 
 select Regiao, TotalVendas from CTE_VendasPorRegiao
 go

 -- Exemplo 2 - CTE recursiva (chamando ele mesmo)

 ;with CTE_Hierarquia (CodigoFuncionario, Nome, Supervisor, Nivel)
 as
 (
 select CodigoFuncionarios, Nome, SupervisorDe, 1 as Nivel
 from Funcionarios
 where SupervisorDe is null

 union all

 select f.CodigoFuncionarios, f.Nome, f.SupervisorDe, h.Nivel+1

 from Funcionarios f inner join CTE_Hierarquia h on f.SupervisorDe = h.CodigoFuncionario
 )

 --Executando (tem que selecionar desde o go até o ; la em cima)
 select c.CodigoFuncionario, c.Nome, f.SupervisorDe, c.Nome as 'Supervisor', c.Nivel 
 from CTE_Hierarquia C inner join Funcionarios f on c.Nivel = f.CodigoFuncionarios
 go


 --Exemplo 3 --

 ;with CTE_VendasPorTipo
as (
select v.Tipo, r.Nome as Regiao, vd.Quantidade * vd.ValorUnitario as ValorTotal
from Vendas vd inner join vinhos v on vd.CodigoVinhos = v.CodigoVinhos 
inner join Regioes r on vd.CodigoRegioes = r.CodigoRegioes
)

, CTE_PIVOT(Regiao, Tinto, Branco, Rose, Espumante)
as (
select Regiao, isnull(Tinto,0) as Tinto, isNull(Branco,0) as Branco, isnull(Rosé,0) as Rosé,
ISNULL(Espumante,0) as Espumante 
from (select Regiao, Tipo, ValorTotal from CTE_VendasPorTipo) As selectBase
pivot(sum(ValorTotal) for Tipo in ([Tinto],[Branco],[Rosé],[Espumante])) as pvt
)

select Regiao, Tinto, Branco, Rose, Espumante, Total = Tinto+Branco+Rose+Espumante from CTE_PIVOT
go

--Exemplo 4 --
--Clienes que mais compram a cada mes --
;with CTE_MaioresVendas (Cliente, Mes, TotalComprado)
as (
select c.Nome as Cliente,
MONTH(v.DataVenda) as Mes,
sum(v.Quantidade*v.ValorUnitario) as TotalComprado
from Vendas v inner join Clientes c on v.CodigoClientes = v.CodigoClientes

group by C.Nome, MONTH(v.DataVenda)
)

select Cliente, Mes, TotalComprado from CTE_MaioresVendas
order by Mes, TotalComprado desc
go

-- Exemplo 5 --

;with fatorial (f, numero) 
as
(
select CAST(1 as bigint) AS f, 0 as numero -- fatorial de 0 é 1
union all
select CAST(1 as bigint) AS f, 1 as numero -- fatorial de 1 é 1
union all
select f*(numero+1), numero + 1 from fatorial
where numero < 20
and numero > 0
)

select f from fatorial
where numero = 6
go



