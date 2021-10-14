use Proyecto2;
create table Pais (
    ID_pais int auto_increment primary key,
    Nombre_pais varchar(100) not null
);

-- Region
create table Region (
    ID_region int auto_increment primary key,
    Nombre_region varchar(100) not null,
    FK_ID_pais int not null,
    Foreign key (FK_ID_pais) references Pais(ID_pais)
);

-- Departamento
create table Departamento (
    ID_departamento int auto_increment primary key,
    Nombre_departamento varchar(100) not null,
    FK_ID_region int not null,
    Foreign key (FK_ID_region) references Region(ID_region) on delete cascade
);

-- Municipio
Create table Municipio (
    ID_municipio int auto_increment primary key,
    Nombre_municipio varchar(100) not null,
    FK_ID_departamento int not null,
    Foreign key (FK_ID_departamento) references Departamento(ID_departamento) on delete cascade
);

-- Nombre_eleccion
Create table Nombre_eleccion (
    ID_nombreEleccion int auto_increment primary key,
    Nombre_eleccion varchar(100) not null,
    Año_eleccion integer not null
);

-- PartidoPolitico
create table Partido_politico (
    ID_partidoPolitico int auto_increment primary key,
    Partido varchar(100) not null,
    Nombre_partido varchar(100) not null
);

-- Sexo
create table Sexo (
    ID_sexo int auto_increment primary key,
    Tipo_sexo varchar(50) not null
);


-- Raza
create table Raza (
    ID_raza int auto_increment primary key,
    Nombre_raza varchar(100) not null
);

-- Eleccion
create table Eleccion (
    ID_Eleccion int auto_increment primary key,
    Cant_analfabeto integer not null,
    Cant_alfabeto integer not null,
    Cant_primaria integer not null,
    Cant_nivelMedio integer not null,
    Cant_Universitarios integer not null,
    FK_ID_nombreEleccion integer not null,
    FK_ID_municipios integer not null,
    FK_ID_sexo integer not null,
    FK_ID_raza integer not null,
    FK_ID_partidoPolitico integer not null,
    Foreign key (FK_ID_nombreEleccion) references Nombre_eleccion(ID_nombreEleccion) on delete cascade,
    Foreign key (FK_ID_municipios) references Municipio(ID_municipio) on delete cascade,
    Foreign key (FK_ID_sexo) references Sexo(ID_sexo) on delete cascade,
    Foreign key (FK_id_raza) references Raza(ID_raza) on delete cascade,
    Foreign Key (FK_ID_partidoPolitico) references Partido_politico(ID_partidoPolitico) on delete cascade
);



-- drop table Eleccion cascade;
-- drop table Raza cascade;
-- drop table Sexo cascade;
-- drop table Partido_politico cascade;
-- drop table Nombre_eleccion cascade;
-- drop table Municipio cascade;
-- drop table Departamento cascade;
-- drop table Region cascade;
-- drop table Pais cascade;
