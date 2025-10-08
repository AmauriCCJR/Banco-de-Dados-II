use ContandoHistorias
go

--Declarando o bloco de c�digo select.. values - select virtual --

select codigo, nome, datanascimento 
from (
	values (1,'Amauri Pai', '1966-07-30'), (2,'Amauri JR','2000-05-28')) as Tabela (codigo, nome, datanascimento)
go

--Criando a primeira view com base no select..values --

create view V_MinhaPrimeiraVisao
as -- As � obrigat�rio ter ap�s o create view
select codigo, nome, datanascimento 
from (
	values (1,'Amauri Pai', '1966-07-30'), (2,'Amauri JR','2000-05-28')) as Tabela (codigo, nome, datanascimento)
go


-- N�o da para usar o order by dentro de uma vis�o, pois ela n�o tem os dados propriamente dito



--Executando a vis�o
select codigo, nome, datanascimento from V_MinhaPrimeiraVisao
-- order by nome asc -- Pode ser usado na execu��o, mas n�o dentro da vis�o
go


alter view V_MinhaPrimeiraVisao
as
select codigo, nome, datanascimento, salario 
from (values 
	(1,'Amauri Pai', '1966-07-30', 2489), 
	(2,'Amauri JR','2000-05-28', 2378)) as Tabela (codigo, nome, datanascimento, salario)
go


select codigo, nome, datanascimento, salario from V_MinhaPrimeiraVisao
where salario >= 2380
go

-- Consultando a estrutura da view

Exec sp_help 'V_MinhaPrimeiraVisao'
go


-- Consultando o codigo fonte --

exec sp_helptext 'V_MinhaPrimeiraVisao'
go



