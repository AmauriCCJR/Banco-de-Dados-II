--Alterar o modelo de recuperação full --

alter database BancodaEscocia
set recovery full
go

-- Realizando o backup full --
backup database BancodaEscocia
to disk = 'C:\Databases\Backup\Meu-arquivo-de-backup-BancodaEscocia4.bak'
with init,
description = 'Meu backup full',
stats = 2,
checksum,
medianame = 'HD de backup' -- Nome da media de backup --
go

-- Realizando o backup de log --

Backup log BancodaEscocia
to disk = 'C:\Databases\LOG\Arquivo-de-log-bancodaescocia.bak'
with init,
format, -- Criando uma nova midia de backup, gerando um, novo cabeçalho para o arquivo --
checksum, -- Verifica a integridade do arquivo de backup --
description = 'Backup full arquivo de log',
stats = 10
go

use BancodaEscocia
go

create table eleitores (
codigoEleitor int primary key,
nomeEleitor varchar(20),
dataEleitor date
)
go

--Simulando escrita em log --

declare @contador int
set @contador = 1

while @contador <= 9999999
	begin
		insert into eleitores values (@contador, 'Eleitor', getdate()+@contador)

		set @contador = @contador+1
	end
go



use master
go

--Validando a estrutura fisica e logica dos arquivos armazenados no arquivo de backup --
--1) Apresentar a lista de arquivos contidos no arquivo de backup --
restore filelistonly from disk = 'C:\Databases\Backup\Meu-arquivo-de-backup-BancodaEscocia4.bak'
go

--2) Verificando a integridade do arquivo de backup --
restore verifyonly from disk = 'C:\Databases\Backup\Meu-arquivo-de-backup-BancodaEscocia4.bak'
go

--3) Verificando a consistência do cabeçalho do arquivo de backup --
restore headeronly from disk = 'C:\Databases\Backup\Meu-arquivo-de-backup-BancodaEscocia4.bak'
go

--4) Obter as informações sobre a ferramenta de backup foi utilizado --
restore labelonly from disk = 'C:\Databases\Backup\Meu-arquivo-de-backup-BancodaEscocia4.bak'
go

