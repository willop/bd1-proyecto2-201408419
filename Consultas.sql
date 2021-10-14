-- Consultas
Use Proyecto2;
-- Primera consulta R = 6

select distinct Nombre_eleccion,Año_eleccion,SubSuma.Partido ,SubSuma.Nombre_pais,(Top/Total)*100 as Porcentaje  from(
		select Sub.idpais,Nombre_eleccion.Nombre_eleccion, subsub.Nombre_pais ,Nombre_eleccion.Año_eleccion, sum(Sub.TotalVotos) as Total, subsub.top from(
			select ID_pais as idpais, (Cant_alfabeto+Cant_analfabeto) as TotalVotos from Eleccion
			inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
			inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
			inner join Region on Region.ID_region = Departamento.FK_ID_region
			inner join Pais on Pais.ID_pais = Region.FK_ID_pais
			inner join Partido_politico on Partido_politico.ID_partidoPolitico = Eleccion.FK_ID_partidoPolitico
		)as Sub
		inner join (
			select id_pais,Nombre_eleccion,año_eleccion,FK_ID_nombreEleccion, Nombre_pais, max(TotalVotos)as top from(
				select id_pais,Nombre_eleccion,año_eleccion,FK_ID_nombreEleccion, Nombre_pais, (Cant_alfabeto+Cant_analfabeto) as TotalVotos from Eleccion
				inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
				inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
				inner join Region on Region.ID_region = Departamento.FK_ID_region
				inner join Pais on Pais.ID_pais = Region.FK_ID_pais
				inner join Nombre_eleccion on Nombre_eleccion.ID_nombreEleccion = Eleccion.FK_ID_nombreEleccion
			) as sub
			group by id_pais,Nombre_eleccion,año_eleccion, Nombre_pais,FK_ID_nombreEleccion
		) as subsub on subsub.id_pais = Sub.idpais
		inner join Nombre_eleccion on Nombre_eleccion.ID_nombreEleccion = subsub.FK_ID_nombreEleccion
		group by Sub.idpais,subsub.top,Nombre_eleccion.Nombre_eleccion,Nombre_eleccion.Año_eleccion
	)as ConsultaJunta
    inner join (
    select Partido,Nombre_pais, (Eleccion.Cant_alfabeto+Eleccion.Cant_analfabeto) as suma from Eleccion
    inner join Partido_politico on Partido_politico.ID_partidoPolitico = Eleccion.FK_ID_partidoPolitico
    inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
	inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
	inner join Region on Region.ID_region = Departamento.FK_ID_region
	inner join Pais on Pais.ID_pais = Region.FK_ID_pais 
)as SubSuma on SubSuma.suma = ConsultaJunta.Top and SubSuma.Nombre_pais = ConsultaJunta.Nombre_pais;
    
    
    
    -- Segunda consulta
	
    
    -- Cuarta consulta R = 4 pendiente
    -- Resultado Personal = 8
select * from(
select Nombre_pais,Nombre_region, Max(SuperSub.Top) as Top from(
		select Nombre_pais,Nombre_raza,Nombre_region, max(SumVotos) as Top from (
				select Nombre_pais,Nombre_region,Nombre_raza ,SumVotos from(
					select Pais.Nombre_pais, Region.Nombre_region, Nombre_raza, (Cant_analfabeto+Cant_alfabeto) as SumVotos from Eleccion
					inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
					inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
					inner join Region on Region.ID_region = Departamento.FK_ID_region
					inner join Pais on Pais.ID_pais = Region.FK_ID_pais 
					inner join Raza on Raza.ID_raza = Eleccion.FK_ID_raza
			group by Pais.Nombre_pais, Region.Nombre_region, Nombre_raza,SumVotos
		)as sub
		group by Nombre_pais,Nombre_region,Nombre_raza,SumVotos
        ) as MegaConsulta
	group by Nombre_pais,Nombre_region,Nombre_raza
) as SuperSub
group by Nombre_pais,Nombre_region
)as prisub
inner join (
select Nombre_raza, Nombre_pais , Nombre_region , (Cant_analfabeto+Cant_alfabeto) as SumVotos from Eleccion
inner join Raza on Raza.ID_raza = Eleccion.FK_ID_raza
inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
inner join Region on Region.ID_region = Departamento.FK_ID_region
inner join Pais on Pais.ID_pais = Region.FK_ID_pais
where Nombre_raza like '%INDIGENAS%')as Megasub on Megasub.SumVotos = prisub.Top and Megasub.Nombre_pais = prisub.Nombre_pais;


-- Octava consulta R = 6
Select Nombre_pais, sum(Cant_nivelMedio) as Nivel_medio, sum(Cant_primaria) as Primaria ,sum(Cant_Universitarios) as Universitario from Eleccion
inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
inner join Region on Region.ID_region = Departamento.FK_ID_region
inner join Pais on Pais.ID_pais = Region.FK_ID_pais
group by Nombre_pais;

-- Novena consulta R = 18
select Subconsulta1.Nombre_pais,Nombre_raza,(Subconsulta1.suma / Sub.SumVotos)*100 as Porcentaje from(
	select Nombre_pais,Nombre_raza, sum(SumVotos) as suma from (
		Select Nombre_pais, Nombre_raza,(Cant_analfabeto+Cant_alfabeto) as SumVotos from Eleccion
		inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
		inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
		inner join Region on Region.ID_region = Departamento.FK_ID_region
		inner join Pais on Pais.ID_pais = Region.FK_ID_pais
		inner join Raza on Raza.ID_raza = Eleccion.FK_ID_raza
	) as Consulta
	group by Nombre_pais, Nombre_raza
) as Subconsulta1
inner join(
select Nombre_pais, sum(SumVotos) as SumVotos from (
		Select Nombre_pais, Nombre_raza,(Cant_analfabeto+Cant_alfabeto) as SumVotos from Eleccion
		inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
		inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
		inner join Region on Region.ID_region = Departamento.FK_ID_region
		inner join Pais on Pais.ID_pais = Region.FK_ID_pais
		inner join Raza on Raza.ID_raza = Eleccion.FK_ID_raza
	) as Consulta
	group by Nombre_pais
) as Sub on Sub.Nombre_pais = Subconsulta1.Nombre_pais;




