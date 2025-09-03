create database FatecDoisArquivos
on primary
--Criando arquivos de banco de dados --
(
name = 'FatecDoisArquivos-data',
filename = 'C:\Databases\DATA\FatecDoisArquivos-data.mdf',
size = 40 MB, 
MaxSize = 4GB, 
FileGrowth = 100 MB
) 
,
(
name = 'FatecDoisArquivos-data-1',
filename = 'C:\Databases\DATA\FatecDoisArquivos-data-1.ndf',
size = 80 MB, 
MaxSize = 8192MB, 
FileGrowth = 1GB
) 
-- Criando arquivo de log para o banco de dados -- 
log on
(
name = 'FatecDoisArquivos-Log-1',
filename = 'C:\Databases\LOG\FatecDoisArquivos-log-1.ldf',
size = 1024 MB,
MaxSize = unlimited, 
Filegrowth = 25%
) 
go


