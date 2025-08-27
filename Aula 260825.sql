create database Agosto2025
go

use Agosto2025
go

--Obtendo informações sobre banco de dados --

select name, database_id,
compatibility_level as 'Nivel', 
recovery_model as 'Modelo',
recovery_model_desc as 'Descrição do Modelo', -- Modelo de Backup (simples, completo, bulk_logged) --
state -- Estado do banco -> 0 = online --
from sys.databases
where name = 'Agosto2025'
go

--Utilizando a função DatabasePropertyEx --

-- Essa função pede duas propriedades, o nome do banco e o atributo que tu quer
select  DATABASEPROPERTYEX('Agosto2025','Collation') as 'Linguagem do banco de dados',
		DATABASEPROPERTYEX('Agosto2025','Recovery') as 'Modelo de Backup',
		DATABASEPROPERTYEX('Agosto2025','Status') as 'Status do Banco',
		DATABASEPROPERTYEX('Agosto2025','Version') as 'Versão'
go

--Obtendo a versão do SqL Server --
--Se usar o Ctrl+T antes de executar mostra o resultado como Texto --
select @@VERSION
go

--Utilizar a stored Procedure --
--Para mostrar o resultado como tabela utilizar CTRL+D--
exec sp_server_info
go
-- Mostrando os dados da maquina --
exec XP_MSver
go

--Alterando o status do banco de dados --
user master 
go

--Deixar ele offline (impede qualquer entrada nele) --
alter database Agosto2025
set offline
go

-- Deixar ele Online --
alter database Agosto2025
set online
go

--Deixa-lo em emergencia (quem tiver online nele continua, mas impede novas entradas) --
alter database Agosto2025
set emergency
go

--alterando o modelo de recuperação --
-- Full - Realiza backup completo de arquivos e log
alter database Agosto2025
set recovery full
go

-- Simples - Realiza backup completo de arquivos e uma pequena parte do arquivo de log
alter database Agosto2025
set recovery simple
go

-- Bulk_Logged - Realiza backup completo de arquivos e salva só os updates, inserts, deletes dos logs
alter database Agosto2025
set recovery bulk_logged
go

-- Utilizar a Stored SP_HelpDB principais propriedades e espaço fisico alocado --
exec Sp_helpDB 'Agosto2025'
go

sp_spaceused -- Mostra o espaço utilizado do banco de dados --
go
