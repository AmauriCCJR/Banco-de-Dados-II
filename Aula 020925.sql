use Agosto2025

create table clientes (
codCliente int primary key identity (1,1),
nomeCliente varchar(20) default 'Cliente',
dataNasc datetime default getdate()+rand()*1000
)
go

insert into clientes default values
go 1000

-- Ctrl + M, ou clicar no 'L' deitado no menu em cima, para acompanhar o plano de execução dos selects --
select codCliente, nomeCliente, dataNasc 
from clientes
go

--Evoluindo--
select codCliente, nomeCliente, dataNasc 
from clientes
where codCliente between 125 and 679
go

--Evoluindo mais--
select codCliente, nomeCliente, dataNasc 
from clientes
where codCliente between 125 and 679
order by dataNasc desc
go

--Evoluindo mais ainda --
select codCliente, nomeCliente, dataNasc,
codCliente+rand()*2000 as 'Código qualquer'
from clientes
where codCliente between 125 and 679
order by dataNasc desc
go

--Evoluindo mais ainda ao extremo --
select convert(varchar(10), dataNasc,103) as 'Data', count(dataNasc) as Contador
from clientes
group by dataNasc
order by dataNasc desc
go

