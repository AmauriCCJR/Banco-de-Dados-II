use CTEVinhos
go

--criando função scalar --

create function F_CalcularAreaTriangulo(@base smallint,@altura smallint)
returns int
as 
begin

declare @area int
set @area = (@base * @altura)/2

return @area
end
go

--executando --
select dbo.F_CalcularAreaTriangulo(10,20) as 'Area do triangulo'
go

--otimizando a função para ser mais eficiente --
alter function F_CalcularAreaTriangulo(@base smallint,@altura smallint)
returns int
as 
begin
return (@base *@altura)/2
end
go

select dbo.F_CalcularAreaTriangulo(10,20) as 'Area do triangulo'
go

--Drop function --

--visualizando o codigo

exec sp_helptext 'F_CalcularAreaTriangulo'
go

/*
Patindex é uma função que sempre vai buscar o termo no texto escolhido
*/

create function F_TrocarNumerosPorLetras(@frase varchar(500))
returns varchar(500)
as
	begin
		declare @inicio int 
		set @inicio = patindex('%[0-9]%', @frase)
	
		while @inicio > 0
		begin
			set @inicio = PATINDEX('%[0-9]%',@frase)
			if @inicio > 0
			/* substring 
				(o que deve ser vasculhado, posição, tamanho do elemento)
			*/
			set @frase = REPLACE(@frase, substring(@frase, @inicio, 1), 'X')
			else
			break
		end
		return @frase
	end
go


select dbo.F_TrocarNumerosPorLetras('Este é um teste para trocar qualquer numero(1,2,3,4) por letras')
go

--Converter inteiro para binário --

create function F_ConverterInteiroParaBinario(@valor int)
returns varchar(255)
as
begin
	declare @valorResultado varchar(255), @contador int

	set @contador = 255
	set @valorResultado = ''

	while @contador > 0
	begin
		set @valorResultado = CONVERT(char(1), @valor%2)+@valorResultado
		set @valor = convert(tinyint, (@valor/2))

		set @contador = @contador-1
end
return (select right(@valorResultado,8) as 'Binário')
end
go

select dbo.F_ConverterInteiroParaBinario(192) as 'Primeiro Octeto do IP',
	   dbo.F_ConverterInteiroParaBinario(168) as 'Segundo Octeto do IP',
       dbo.F_ConverterInteiroParaBinario(100) as 'Terceiro Octeto do IP',
       dbo.F_ConverterInteiroParaBinario(1) as 'Quarto Octeto do IP'
go