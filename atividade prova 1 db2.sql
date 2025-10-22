create database olympicdata
go
use olympicdata
go


--Criação de esquemas
create schema olympic
go

--Criação de Tabelas
create table olympic.Paises (
CodPais int identity(1,1),
NomePais varchar(20) not null,
Sigla char(2) not null,
Continente varchar(12) not null
)
go

create table olympic.Modalidades(
CodModalidade int identity(1,1),
NomeModalidade varchar(25) not null,
Tipo varchar(20) not null,
Categoria varchar (20) not null
)
go

create table olympic.Atletas (
CodAtleta int identity(1,1),
NomeAtleta varchar (25) not null,
Sexo char(1) default('M') not null,
Idade int not null,
CodPais int not null 
)
go
-- Tipo de competicao: Verão, inverno
create table olympic.Competicoes(
CodCompeticao int identity(1,1),
Ano int not null,
CidadeSede varchar (20) not null,
TipoCompeticao varchar(30) not null
)
go

create table olympic.Resultados(
CodResultado int identity(1,1),
CodAtleta int not null,
CodModalidade int not null,
CodCompeticao int not null,
Medalha varchar (6) not null,
TempoEmMinutos int not null,
Pontuacao int not null
)
go

--Add PKs, FKs e Clustered Keys
alter table olympic.Paises
	add constraint PK_Paises primary key clustered (CodPais)
go

alter table olympic.Modalidades
	add constraint PK_Modalidades primary key clustered (CodModalidade)
go

alter table olympic.Atletas
	add constraint PK_Atletas primary key clustered (CodAtleta)
go

alter table olympic.Competicoes
	add constraint PK_Competicoes primary key clustered (CodCompeticao)
go

alter table olympic.Resultados
	add constraint PK_Resultados primary key clustered (CodResultado)
go

alter table olympic.Atletas
	add constraint FK_Atletas_Pais foreign key(CodPais) references olympic.Paises(CodPais)
go

alter table olympic.Resultados
	add constraint Fk_Resultado_Atleta foreign key(CodAtleta) references olympic.Atletas(CodAtleta)
go

alter table olympic.Resultados
	add constraint Fk_Resultado_Modalidades foreign key(CodModalidade) references olympic.Modalidades(CodModalidade)
go

alter table olympic.Resultados
	add constraint Fk_Resultado_Competicao foreign key(CodCompeticao) references olympic.Competicoes(CodCompeticao)
go

create unique nonClustered index PK_Paises_Sigla_NonClustered on olympic.Paises (Sigla)
go

create unique nonClustered index CK_Modalidade_Nome_NonClustered on olympic.Modalidades (NomeModalidade)
go

create unique nonClustered index CK_Paises_NomePais on olympic.Paises (NomePais)
go

create nonClustered index CK_Atleta_NomeAtleta on olympic.Atletas (NomeAtleta)
go

create nonClustered index CK_CidadeSede on olympic.Competicoes(CidadeSede)
go

--Add Inserts

insert into olympic.Paises(NomePais, Sigla, Continente) values 
('Russia', 'RU', 'Europa'), 
('Coreia do Norte','NK','Asia'),
('Vietna','VT','Europa'),
('Venezuela','VN','America'),
('Israel','IS','Europa')
GO

insert into olympic.Modalidades (NomeModalidade, Tipo, Categoria) values 
('Maratona','Individual','Corrida'),
('Tiro ao alvo','Coletivo','Pontaria'),
('Natação','Individual','Corrida'),
('Volei','Coletivo','Quadra'),
('Escalada','Coletivo','Corrida')
GO

insert into olympic.Atletas (NomeAtleta, Sexo, Idade, CodPais) values
('Jesus','O',2025, 5),
('Vladimir Manso','M', 62, 1),
('Sung Jin Woo','M', 19, 2),
('Nego Ney','M',34, 4),
('Oruam','F',24,2)
go

insert into olympic.Competicoes (Ano,CidadeSede,TipoCompeticao) values
(0000,'Jerusalem','Verão Abençoado'),
(2014 ,'Moskow','Inverno'),
(2018 ,'Summoners Rift','Verão'),
(2022 ,'Madur Uro','Inverno'),
(2026 ,'Ala hu akbar','Verão')
go

insert into olympic.Resultados (CodAtleta, CodModalidade, CodCompeticao, Medalha, TempoEmMinutos, Pontuacao) values
( 1,2 ,1 , 'Ouro', 32 ,666 ),
(3 ,5 ,2 , 'Prata', 9,  200),
(4 , 1, 4, 'Prata',12 , 069 ),
(2,4 ,3 , 'Ouro', 46, 576 ),
(5, 5, 2, 'Bronze', 34, 333)
go




-- Questão 1 --
Select A.NomeAtleta, A.Sexo, A.Idade, P.NomePais
from olympic.Atletas A inner join olympic.Paises P on A.CodPais = P.CodPais
order by A.NomeAtleta asc
go

-- Questão 2 --

select a.NomeAtleta, m.NomeModalidade, r.Medalha, r.Pontuacao
from olympic.Resultados r inner join olympic.Atletas a on r.CodAtleta = a.CodAtleta 
inner join olympic.Modalidades m on r.CodModalidade = m.CodModalidade
go


-- Questão 3 --

select c.Ano, c.CidadeSede, a.NomeAtleta, r.TempoEmMinutos
from olympic.Competicoes c inner join olympic.Resultados r on c.CodCompeticao = r.CodCompeticao
inner join olympic.Atletas a on r.CodAtleta = a.CodAtleta
go

-- Questão 4 --
select p.NomePais,count(r.Medalha) as 'Quantidade de medalhas' 
from olympic.Atletas a inner join olympic.Resultados r on a.CodPais = r.CodAtleta
inner join olympic.Paises p on p.CodPais = a.CodPais
group by p.NomePais
go

-- Questão 5 --
select m.CodModalidade, m.NomeModalidade, c.TipoCompeticao, c.Ano
from olympic.Resultados r inner join olympic.Competicoes c on r.CodCompeticao = c.CodCompeticao
inner join olympic.Modalidades m on r.CodModalidade = m.CodModalidade
order by m.CodModalidade asc
go

-- Questão 6 --

select p.NomePais, m.NomeModalidade
from olympic.Atletas a inner join olympic.Paises p on p.CodPais = a.CodPais
inner join olympic.Resultados r on r.CodAtleta = a.CodAtleta
inner join olympic.Modalidades m on r.CodModalidade = m.CodModalidade
where a.CodAtleta > 0
go


-- Pivot 1 --

select pvt.NomePais,pvt.Bronze, pvt.Prata, pvt.Ouro
from (select r.Medalha, p.NomePais from olympic.Atletas a inner join olympic.Resultados r on a.CodPais = r.CodAtleta
inner join olympic.Paises p on p.CodPais = a.CodPais) as P
pivot (count(P.Medalha) for Medalha in ([Bronze], [Prata], [Ouro])) as pvt
go

-- Pivot 2 --
select pvt.NomeModalidade, pvt.Bronze, pvt.Prata, pvt.Ouro from
(select m.NomeModalidade, r.Medalha from olympic.Resultados r inner join olympic.Modalidades m
on r.CodModalidade = m.CodModalidade) as P
pivot (count(P.Medalha) for Medalha in ([Bronze], [Prata], [Ouro])) as pvt
go

-- Pivot 3 --
select pvt.Ano, pvt.Bronze, pvt.Prata, pvt.Ouro from
(Select c.Ano, r.Medalha from olympic.Resultados r inner join olympic.Competicoes c
on c.CodCompeticao = r.CodCompeticao) as P
pivot (count(P.Medalha) for Medalha in ([Bronze], [Prata], [Ouro])) as pvt
go


-- UnPivot --
/*select * from
(select a.NomeAtleta, r.Medalha from olympic.Atletas a inner join olympic.Resultados r 
on a.CodAtleta = r.CodAtleta ) as P
unpivot (Count(Case when Medalha = 'Ouro' then 1 end) as 'Ouro',
		Count(Case when Medalha = 'Prata' then 1 end) as 'Prata',
		Count(Case when Medalha = 'Bronze' then 1 end) as 'Bronze',)*/


-- BackUp 1 -- 
alter database olympicdata
set recovery simple
go

-- BackUp2 --
backup database olympicdata
to disk ='C:\Backup\Amauri-e-Matheus\Backup-OLYMPICDATA-Simple-1.bak'
with init,
description = 'Motomotiva bibi',
stats = 2,
checksum,
medianame = 'HD de backup'
go

--BackUp 3 --
alter table olympic.Resultados
drop constraint Fk_Resultado_Atleta
go

drop table olympic.Atletas
go

--BackUp 4 --
backup database olympicdata
to disk ='C:\Backup\Amauri-e-Matheus\Backup-OLYMPICDATA-Simple-2.bak'
with init,
description = 'Motomotiva bibi',
stats = 25,
checksum,
medianame = 'HD de backup'
go

--BackUp 5 --
alter database olympicdata
set recovery full
go

-- BackUp6 --
backup database olympicdata
to disk ='C:\Backup\Amauri-e-Matheus\Backup-OLYMPICDATA-full-1.bak'
with init,
description = 'Motomotiva fogosa',
stats = 25,
checksum,
medianame = 'HD de backup'
go

-- BckUp 7 --
