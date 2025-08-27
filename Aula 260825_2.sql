--crtl + n = nova query

-- Criando um novo banco com configurações personalizadas --
create database fatec20252
on primary 
(name = 'FatecSR20252-Data', -- Nome interno do arquivo de dados
filename = 'C:\Databases\DATA\FatecSR20252-Data.mdf', -- Diretorio
size = 50 MB, -- Tamanho inicial
MaxSize = 500 MB, -- Tamanho maximo de crescimento
FileGrowth = 10 MB) -- Fator de crescimento

log on
(name = 'FatecSR20252-Log', -- Nome interno do arquivo de dados
filename = 'C:\Databases\LOG\FatecSR20252-Data.ldf', -- Diretorio
size = 100 MB, -- Tamanho inicial
MaxSize = unlimited, -- Tamanho maximo de crescimento
Filegrowth = 100 MB) -- Fator de crescimento
go

--Acessando o banco de dados --
use fatec20252
go

--Alterando o modelo de recuperação para full

alter database fatec20252
set recovery full
go

--Simulando a escrita e crescimento dos arquivos --

create table jogadores (
jogadorID int primary key identity(1,1),
jogadorNome varchar(30) not null,
jogadorData  datetime not null
)
go

-- Criando o loop para inserção de dados --

declare @contador int -- Declarando variavel

set @contador = 1

while @contador <= 999999
	begin
		insert into jogadores 
		values ('Amauri Carlos', GETDATE()+@contador)
		set @contador = @contador+1
	end
go

create table municipios(
codigoMunicio smallint identity(1,1) primary key,
nomeMunicio varchar(100) not null default 'São Roque',
dataFundacao date not null default getdate(),
estadoMunicio char(2) not null default 'SP'
)
go

-- identificando a quantidade de linhas existentes no arquivo de log --
Select count(*) from fn_dblog(null, null)
go

-- inserindo dados na tabela municipios --
insert into municipios default values
go 100


-- Consultando as intruções inserts armazenadas no log --
select Operation, [Transaction Name], [Page ID], [Slot ID], [Transaction ID], [Current LSN],
	[Begin Time], [End Time]
from fn_dblog(null, null)
where Operation in ('LOP_INSERT_ROWS')
and AllocUnitName like '%Municipios%'
go