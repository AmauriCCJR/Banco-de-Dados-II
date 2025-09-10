-- Criando banco de dados BancodaBolivia --

create database BancoDaBolivia
go

use BancoDaBolivia
go

-- Realizando o acesso a dados armazenados em outros banco de dados --
select * from BancodaEscocia.dbo.valores
go

-- Inserindo os dados da tabela valores no banco da bolivia
select * into Valores from BancodaEscocia.dbo.valores
go


--Consultando--
select codigo, valor1,valor2,valor3 from Valores


--Realizando o backup do banco da bolivia --

backup database BancoDaBolivia
to disk = 'C:\Databases\Backup\BancoDaBolivia.bkp'
with init,format, stats = 5, checksum
go

