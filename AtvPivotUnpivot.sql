create database Atv_Pivot_Unpivot
go
use Atv_Pivot_Unpivot
go


CREATE TABLE Pilotos (
    CodigoPiloto int identity(1,1) primary key,
    Nome varchar (100) not null,
    Nacionalidade varchar(50),
    Equipe varchar(50)
)
go

CREATE TABLE Corridas (
    CodigoCorrida INT IDENTITY(1,1) PRIMARY KEY,
    NomeGP varchar(100) NOT NULL,
    Pais varchar(50),
    DataCorrida date
)
go

CREATE TABLE Resultados (
    CodigoResultado INT IDENTITY(1,1) PRIMARY KEY,
    CodigoPiloto INT NOT NULL,
    CodigoCorrida INT NOT NULL,
    PosicaoFinal INT,
    TempoTotal TIME(3),
    Pontos INT,
    FOREIGN KEY (CodigoPiloto) REFERENCES Pilotos(CodigoPiloto),
    FOREIGN KEY (CodigoCorrida) REFERENCES Corridas(CodigoCorrida)
)
go
CREATE TABLE PontuacoesGP (
    CodigoPiloto INT PRIMARY KEY,
    Nome varchar(100),
    GP_Australia INT,
    GP_Monaco INT,
    GP_Inglaterra INT,
    FOREIGN KEY (CodigoPiloto) REFERENCES Pilotos(CodigoPiloto)
)
go

CREATE TABLE TemposGP (
    CodigoPiloto INT PRIMARY KEY,
    Nome varchar(100),
    Tempo_Australia TIME(3),
    Tempo_Monaco TIME(3),
    Tempo_Inglaterra TIME(3),
    FOREIGN KEY (CodigoPiloto) REFERENCES Pilotos(CodigoPiloto)
)
go

INSERT INTO Pilotos (Nome, Nacionalidade, Equipe)
VALUES 
('Lewis Hamilton', 'Britânico', 'Mercedes'),
('Max Verstappen', 'Holandês', 'Red Bull'),
('Charles Leclerc', 'Monegasco', 'Ferrari'),
('Lando Norris', 'Britânico', 'McLaren');
go

INSERT INTO Corridas (NomeGP, Pais, DataCorrida)
VALUES 
('GP da Austrália', 'Austrália', '2025-03-16'),
('GP de Mônaco', 'Mônaco', '2025-05-25'),
('GP da Inglaterra', 'Reino Unido', '2025-07-06');
go

INSERT INTO Resultados (CodigoPiloto, CodigoCorrida, PosicaoFinal, TempoTotal, Pontos)
VALUES
(2, 1, 1, '01:25:13', 25),   
(1, 1, 2, '01:25:45', 18),   
(3, 1, 3, '01:26:12', 15);   
go

INSERT INTO Resultados (CodigoPiloto, CodigoCorrida, PosicaoFinal, TempoTotal, Pontos)
VALUES
(3, 2, 1, '01:33:18', 25),   
(1, 2, 2, '01:33:30', 18),   
(4, 2, 3, '01:34:02', 15);   
go

INSERT INTO Resultados (CodigoPiloto, CodigoCorrida, PosicaoFinal, TempoTotal, Pontos)
VALUES
(1, 3, 1, '01:27:45', 25),  
(2, 3, 2, '01:27:51', 18),   
(4, 3, 3, '01:28:10', 15);   
go


-- Atv 1 Pivot --
select pvt.Nome as Piloto, pvt.[GP de Mônaco], pvt.[GP da Austrália], pvt.[GP da Inglaterra]
from (select p.Nome, c.NomeGP, r.Pontos
    from Resultados r inner join Pilotos p on r.CodigoPiloto = p.CodigoPiloto
					  inner join Corridas c on r.CodigoCorrida = c.CodigoCorrida) as GP
pivot (sum(Pontos) for NomeGP in ([GP da Austrália],[GP de Mônaco],[GP da Inglaterra])) as pvt
go

-- Atv 2 Pivot --

select pvt.Nome as Piloto, pvt.[GP de Mônaco], pvt.[GP da Austrália], pvt.[GP da Inglaterra]
from (select p.Nome, c.NomeGP, r.PosicaoFinal
    from Resultados r inner join Pilotos p on r.CodigoPiloto = p.CodigoPiloto
					  inner join Corridas c on r.CodigoCorrida = c.CodigoCorrida) as GP
pivot (max(PosicaoFinal) for NomeGP in ([GP da Austrália],[GP de Mônaco],[GP da Inglaterra])) as pvt
go

--Atv 3 pivot --

select pvt.Nome as Piloto, pvt.[GP de Mônaco], pvt.[GP da Austrália], pvt.[GP da Inglaterra]
from (select p.Nome, c.NomeGP, r.TempoTotal
    from Resultados r inner join Pilotos p on r.CodigoPiloto = p.CodigoPiloto
					  inner join Corridas c on r.CodigoCorrida = c.CodigoCorrida) as GP
pivot (max(TempoTotal) for NomeGP in ([GP da Austrália],[GP de Mônaco],[GP da Inglaterra])) as pvt
go












