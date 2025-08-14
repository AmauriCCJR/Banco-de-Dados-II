create database AtvRecordar
go
use AtvRecordar
go


create table numeros (
id int identity(1,1) not null,
numero int not null
)
go
alter table numeros
add constraint PK_IDNumeros primary key(id)
go

--Desativando a contagem de linhas processadas --
set nocount on
go

--Removendo possiveis numeros armazenados --
truncate table numeros
go

--Declarando as variaveis de controle --

declare @ContadordeNumeros int, @NumeroSorteado int, @QuantidadedeNumeros int

-- Atribuindo valores iniciais --

set @ContadordeNumeros = 0
set @NumeroSorteado = 0
set @QuantidadedeNumeros = rand()*10000

-- Realizando o sorteio--
-- Apresentando os numeros sorteados no formato texto --

while @ContadordeNumeros <= @QuantidadedeNumeros
	begin
		set @NumeroSorteado = rand() * @QuantidadedeNumeros
		if not exists (select numero from numeros where numero = @NumeroSorteado)
			begin
				insert into numeros values (@NumeroSorteado)
				print @NumeroSorteado
			end
		set @ContadordeNumeros = @ContadordeNumeros + 1
	end

print 'A quantidade de Numeros Sorteados é de ' + convert(varchar(5), @QuantidadedeNumeros)
go

-- Mostrando os valores que foram inseridos no select -- 
select numero from numeros
order by numero asc
go




