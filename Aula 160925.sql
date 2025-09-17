create database  indices
go
use indices
go

--Criando tabela Heap Table (Sem chave primária)
create table HeapTableAlunos
(
codigoAluno int,
NomeAluno varchar(20),
dataAluno date
)
go


insert into HeapTableAlunos (codigoAluno, NomeAluno, dataAluno) values
(1,'Aluno 1', GETDATE()),(2,'Aluno 2', GETDATE()+1), 
(3, 'Aluno 3', GETDATE()+2), (4,'Aluno 4', GETDATE()+3), (5, 'Aluno 5', GETDATE()+4)
go

set nocount on
go

-- Ativar o plano de execução antes de realizar o select - teclando ctrl+M --

select codigoAluno, NomeAluno, dataAluno from HeapTableAlunos
go

--Sempre que apresentar o table scan é pq não há chave primária

alter table HeapTableAlunos
	alter column codigoAluno int not null
go

alter table HeapTableAlunos
	add constraint PK_HTA_Chave_Primaria primary key clustered (codigoAluno)
go

--Testando uso de chave primaria (seek)

Select NomeAluno,dataAluno from HeapTableAlunos
	where codigoAluno = 4
go

-- Realizando a ordenação de valores

Select NomeAluno, dataAluno from HeapTableAlunos
order by dataAluno desc
go

-- Criando um novo indice nonClustered na tabela

Create nonclustered index IND_NonClustered_dataAluno
	on HeapTableAlunos (dataAluno)
go

-- Simulando o uso do indice NonClustered

-- Exemplo 1
Select NomeAluno, dataAluno	from HeapTableAlunos
where dataAluno between '2025-09-16' and '2025-09-30'
go

--Exemplo 2
Select dataAluno from HeapTableAlunos where codigoAluno = 1
go

-- Exemplo 3
select dataAluno from HeapTableAlunos
go

--Exemplo 4
Select dataAluno from HeapTableAlunos
where dataAluno =  '2025-09-17'
go

--Exemplo 5 - Forçando o uso do indice NonClustered

select codigoAluno, NomeAluno, dataAluno from HeapTableAlunos with (index = IND_NonClustered_DataAluno)
where dataAluno = '2025-09-17'
go

--Exemplo 6 - Utilizando o index NonClustered --
select codigoAluno,dataAluno from HeapTableAlunos
where dataAluno >= '2025-09-17'
order by dataAluno desc
go