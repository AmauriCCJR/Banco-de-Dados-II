create database BancodaEscocia
go
use BancodaEscocia
go

alter database BancodaEscocia
set recovery simple
go

--Realizando o backup database --
backup database BancodaEscocia
to disk = 'C:\Backup\BKP-DATABASE-BANCODAESCOCIA.bak' -- Endereço do backup
with init, --Especifica que um novo arquivo de backup sera criado
description = 'Backup do banco da escocia', -- Descrição do banco de dados
stats = 5 -- Barra de progressão
go


-- Criando uma tabela e inserindo dados dentro do banco de dados --

create table valores(
codigo int primary key identity(1,2),
valor1 bigint default 1000000,
valor2 bigint default 2000000,
valor3 as (valor1+valor2)
)
go

--Inserindo uma massa de dados --

insert into valores default values
go 100000

-- Consultando 2000 registros logicos de forma aleatroria --

select top 2000 codigo, valor1, valor2, valor3 
from valores
order by newid() -- Cria um ID interno aleatorio em tempo de execução
go

-- Consultando o tamanho atual dos arquivos que formam o banco de dados --

select filename, (size*8) as Kbs, (size/1024)*8 as Mbs from sys.sysfiles
go

--Consultando o tamanho da tabela valores --
exec sp_spaceused 'valores'
go

--Realizando o backup database --
backup database BancodaEscocia
to disk = 'C:\Backup\BKP-DATABASE-BANCODAESCOCIA-COM-ARQUIVOS.bak' -- Endereço do backup
with init, --Especifica que um novo arquivo de backup sera criado, caso ja exista um com o mesmo nome
description = 'Backup do banco da escocia com uma massa de dados inserida', -- Descrição do banco de dados
stats = 2, -- Barra de progressão
checksum --verifica a integridade do arquivo de backup antes da conclusão
go