create database Umbrella
go
use Umbrella
go

create schema MeuEsquema
go


create table MeuEsquema.GuardaChuvas (
ID_GuardaChuva int identity (1,1),
tipo varchar (25) not null,
dataCadastro date not null,
estoque int not null
)
go

create table MeuEsquema.Alugueis (
ID_Aluguel int identity(1,1),
valor_aluguel float not null,
ID_Cliente int not null,
ID_GuardaChuva int not null,
DataInicioContrato date not null,
DataFimContrato date not null
)
go


create table MeuEsquema.Reservas (
ID_Reserva int identity(1,1) not null,
ID_Cliente int not null,
ID_GuardaChuva int not null,
DataInicioReserva date not null,
DataFimReserva date not null,
MetodoReserva varchar(20) not null,
statusReserva varchar(20) not null,
valor float not null
)
go
create table MeuEsquema.Manutencao (
ID_Manutencao int identity (1,1) not null,
dataInicio date null,
dataFim date null,
valor float null,
statusManutencao varchar(20) not null
)
go

create table MeuEsquema.Fidelidades (
ID_Fidelidade int identity(1,1),
RankElo varchar (15) not null
)
go

create table MeuEsquema.Clientes (
ID_Cliente int identity(1,1),
nomeCliente varchar (30) not null,
cpf varchar (9) not null,
dataCadastro date not null,
CNH bigint not null,
email varchar (35) null,
telefone int not null,
endereco varchar(50) not null,
pontuacao bigint not null,
ID_Fidelidade int not null
)
go


alter table MeuEsquema.GuardaChuvas
	add constraint PK_GuardaChuva primary key (ID_GuardaChuva)
go

alter table MeuEsquema.Clientes 
	add constraint PK_Cliente primary key (ID_Cliente)
go

alter table MeuEsquema.Alugueis 
	add constraint PK_Aluguel primary key (ID_Aluguel)
go
alter table MeuEsquema.Reservas 
	add constraint PK_Reserva primary key (ID_Reserva)
go

alter table MeuEsquema.Manutencao 
	add constraint PK_Manutencao primary key (ID_Manutencao)
go

alter table MeuEsquema.Fidelidades
	add constraint PK_Fidelidade primary key (ID_Fidelidade)
go

alter table MeuEsquema.Alugueis
	add constraint FK_Cliente_Aluguel foreign key (ID_Cliente) references MeuEsquema.Clientes (ID_Cliente)
go

alter table MeuEsquema.Alugueis
	add constraint FK_GuardaChuva_Aluguel foreign key (ID_GuardaChuva) references MeuEsquema.GuardaChuvas (ID_GuardaChuva)
go

alter table MeuEsquema.Reservas
	add constraint FK_Cliente_Reserva foreign key (ID_Cliente) references MeuEsquema.Clientes (ID_Cliente)
go

alter table MeuEsquema.Reservas
	add constraint FK_GuardaChuva_Reserva foreign key (ID_GuardaChuva) references MeuEsquema.Clientes (ID_Cliente)
go

alter table MeuEsquema.Clientes
	add constraint FK_Fidelidades_Clientes foreign key (ID_Fidelidade) references MeuEsquema.Fidelidades (ID_Fidelidade)
go



declare @contador int 
set @contador = 1

insert into MeuEsquema.Fidelidades (RankElo) values ('bronze'),('prata'),('ouro'),('platina'),('diamante')
while (@contador <= 100)
	begin
		

		insert into MeuEsquema.Clientes (nomeCliente, cpf,dataCadastro,CNH,email,telefone, endereco,pontuacao, ID_Fidelidade) 
	values
		('CLIENTE '+ @contador,48792349+@contador,GETDATE()*@contador, 123456+@contador, 'Lugar '+@contador, 1+@contador, (rand() *5) +1 )
		 set @contador =  @contador + 1

	insert into MeuEsquema.Alugueis (
	end
