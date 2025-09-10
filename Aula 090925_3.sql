-- Acessar o master --
use master
go

-- remover o banco da bolivia --
drop database BancoDaBolivia
go

-- realizando a restauração do bkp do banco da bolivia --

restore database BancoDaBolivia
from disk = 'C:\Databases\Backup\BancoDaBolivia.bkp'
with recovery, -- Para recuperar o conteudo --
replace, -- caso exista este banco, substitua o conteudo pelo backup --
stats = 10
go

use BancoDaBolivia
go

select codigo, valor1,valor2,valor3 from Valores
go

