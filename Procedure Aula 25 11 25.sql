use CTEVinhos
go
-- criando stored procedure --
create procedure P_OlaMundoAm
as
begin
set nocount on

select 'Hello world...'+SYSTEM_USER

end
go
-- executando stored procedure --
exec P_OlaMundoAm 
go

execute P_OlaMundoAm
go

--Exec e execute não tem diferença

-- Ler o código
sp_helptext 'P_OlaMundoAm'
go

select OBJECT_DEFINITION(OBJECT_ID('P_OlaMundoAm'))
go


--Alterando procedure e adicionando condição
alter procedure P_OlaMundoAm @NomeUsuario varchar(20)
as
begin
set nocount on

select 'Hello World...'+@NomeUsuario as 'Mensagem'

end
go

--executando--

exec P_OlaMundoAm 'Amauri'
go

create procedure P_calculadoraAm (@valor1 int=1, @valor2 int=1, @operador char(1))
as
begin
	set nocount on -- Desativando a contagem e apresentação de linhas
	declare @resultado int
	if (@valor1 <> 0 and @valor2 <> 0)
	begin
		if @operador = '+'
			set @resultado = @valor1 + @valor2
		if @operador = '-'
			set @resultado = @valor1 - @valor2
		if @operador = 'x'
			set @resultado = @valor1 * @valor2
		if @operador = '/'
			set @resultado = @valor1 / @valor2
		end
		select CONCAT('O resultado obtido é: ', @resultado)
end
go

/* 
deletar procedure
drop procedure P_CalculadoraAm --
go
*/

exec P_calculadoraAm 5,2,'+'
go

-- Criando tabela temporaria --
create table #Exemplo
(codigo int identity(1,1),
data datetime)
go
-- inserindo dados --
insert into #Exemplo values (getdate()), (GETDATE()+1), (GETDATE()+2)
go
select codigo, data from #Exemplo


--criando procedure mais pratica --
create procedure P_PesquisarDatas(@codigo int, @data datetime)
as
begin
	set nocount on
	set @data = (select case when @data is null then GETDATE() else @data end)
	select codigo,data from #Exemplo
	where codigo = @codigo
	and data = @data
end
go

exec P_PesquisarDatas 1, '25-11-2025'
go

--alterando o codigo fonte da stored procedure --

alter procedure P_PesquisarDatas(@codigo int, @data datetime)
as
begin
	set nocount on
	set @data = (select case when @data is null then GETDATE() else @data end)
	select codigo,data from #Exemplo
	where codigo = @codigo
	and convert(date, data) = @data
end
go

exec P_PesquisarDatas 1, '25-11-2025'
go
