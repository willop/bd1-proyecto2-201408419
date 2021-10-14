-- Llenado de de tablas
use Proyecto2;

-- pais R=6
Insert into Pais(Nombre_pais)
select distinct pais from Temporal;
select * from Pais;

-- Region R=22
Insert into Region(Nombre_region, FK_ID_pais)
select distinct region,ID_pais from Temporal
inner join Pais on Pais.Nombre_pais = Temporal.Pais;
select * from Region;


-- Departamento R=81
insert into Departamento(Nombre_departamento, FK_ID_region)
select distinct depto, ID_region from Temporal
inner join Region on Region.Nombre_region = Temporal.Region
inner join Pais on Pais.Nombre_pais = Temporal.Pais 
Where Pais.ID_pais = Region.FK_ID_pais;
select * from Departamento;


-- Municipio R=1210 -1169
insert into Municipio (Nombre_municipio, FK_ID_departamento)
select distinct municipio,ID_departamento from Temporal
inner join Departamento on Departamento.Nombre_departamento = Temporal.Depto
inner join Region on Region.Nombre_region = Temporal.Region
inner join Pais on Pais.Nombre_pais = Temporal.Pais
Where Pais.ID_pais = Region.FK_ID_pais
and Region.ID_region = Departamento.FK_ID_region;
select * from Municipio;

-- Sexo R = 2
Insert into Sexo(Tipo_sexo)
select distinct Sexo from Temporal;
select * from Sexo;

-- Raza R = 3
Insert into Raza(Nombre_raza)
select distinct Raza from Temporal;

-- Nombre eleccion R = 2
insert into Nombre_eleccion(Nombre_eleccion, Año_eleccion)
select distinct Nombre_eleccion, año_eleccion from Temporal;


-- Partido_politico R=18
insert into Partido_politico(Partido, Nombre_partido)
select distinct partido,Nombre_partido from Temporal;

-- Eleccion
insert into Eleccion(FK_ID_partidoPolitico,FK_ID_nombreEleccion,FK_ID_municipios, FK_ID_sexo,FK_ID_raza, Cant_analfabeto,Cant_alfabeto,Cant_primaria,Cant_nivelMedio,Cant_Universitarios)
select distinct ID_partidoPolitico, ID_nombreEleccion, ID_municipio,ID_sexo,ID_raza, analfabetos,alfabetos,primaria,Nivel_Medio,Universitarios from Temporal
inner join Sexo on Sexo.Tipo_sexo = Temporal.sexo
inner join Nombre_eleccion on Nombre_eleccion.Nombre_eleccion = Temporal.Nombre_eleccion and Nombre_eleccion.Año_eleccion = Temporal.Año_eleccion
inner join Partido_politico on Partido_politico.Partido = Temporal.Partido
inner join Raza on Raza.Nombre_raza = Temporal.Raza
inner join Municipio on Municipio.Nombre_municipio = Temporal.Municipio
inner join Departamento on Departamento.Nombre_departamento = Temporal.Depto
inner join Region on Region.Nombre_region = Temporal.Region
inner join Pais on Pais.Nombre_pais = Temporal.Pais
Where Pais.ID_pais = Region.FK_ID_pais
and Departamento.FK_ID_region = Region.ID_region
and Municipio.FK_ID_departamento = Departamento.ID_departamento;
