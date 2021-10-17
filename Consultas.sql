-- Consultas
Use Proyecto2;
-- Primera consulta R = 6
select Nombre_eleccion, Año_eleccion, NombrePais, (SubSub.MaxPais/Totales)*100 as Porcentaje from (
	select Nombre_eleccion, Año_eleccion,  Nombre_pais as NombrePais, sum(TotalPais) as Totales from(
		select Nombre_pais,Año_eleccion,Nombre_eleccion, Nombre_partido,sum(Cant_analfabeto + Cant_alfabeto) as TotalPais from Eleccion
		inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
		inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
		inner join Region on Region.ID_region = Departamento.FK_ID_region
		inner join Pais on Pais.ID_pais = Region.FK_ID_pais
		inner join Partido_politico on Partido_politico.ID_partidoPolitico = Eleccion.FK_ID_partidoPolitico
		inner join Nombre_eleccion on Nombre_eleccion.ID_nombreEleccion = Eleccion.FK_ID_nombreEleccion
		group by Nombre_pais, Nombre_partido,Año_eleccion,Nombre_eleccion) 
	as NewC
	group by Nombre_eleccion, Año_eleccion,  Nombre_pais
) as PSub
inner join (
	select SubMax.Nombre_pais, SubTotal.Nombre_partido, MaxPais from(
		select Nombre_pais, max(TotalPais) as MaxPais from(
			select Nombre_pais, Nombre_partido,sum(Cant_analfabeto + Cant_alfabeto) as TotalPais from Eleccion
			inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
			inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
			inner join Region on Region.ID_region = Departamento.FK_ID_region
			inner join Pais on Pais.ID_pais = Region.FK_ID_pais
			inner join Partido_politico on Partido_politico.ID_partidoPolitico = Eleccion.FK_ID_partidoPolitico
			group by Nombre_pais, Nombre_partido
		) as NewC
	group by Nombre_pais) SubMax
	inner join (
		select Nombre_pais, Nombre_partido,sum(Cant_analfabeto + Cant_alfabeto) as TotalPais from Eleccion
		inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
		inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
		inner join Region on Region.ID_region = Departamento.FK_ID_region
		inner join Pais on Pais.ID_pais = Region.FK_ID_pais
		inner join Partido_politico on Partido_politico.ID_partidoPolitico = Eleccion.FK_ID_partidoPolitico
		group by Nombre_pais, Nombre_partido) 
	as SubTotal on SubTotal.TotalPais = SubMax.MaxPais
) as SubSub on SubSub.Nombre_pais = PSub.NombrePais;


    -- Segunda consulta  R=81
select NombrePais, Nombre_departamento, TotalDepartamento, (TotalDepartamento/TotalPais)*100 as Porcentaje from (
	select Nombre_pais as NombrePais, Nombre_departamento, sum(Cant_analfabeto + Cant_alfabeto) as TotalDepartamento from Eleccion
	inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
	inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
	inner join Region on Region.ID_region = Departamento.FK_ID_region
	inner join Pais on Pais.ID_pais = Region.FK_ID_pais
	inner join Sexo on Sexo.ID_sexo = Eleccion.FK_ID_sexo
	where Sexo.Tipo_sexo = "mujeres"
	group by Nombre_pais, Nombre_departamento)
as Sub
inner join (
	select Nombre_pais, sum(Cant_analfabeto + Cant_alfabeto) as TotalPais from Eleccion
	inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
	inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
	inner join Region on Region.ID_region = Departamento.FK_ID_region
	inner join Pais on Pais.ID_pais = Region.FK_ID_pais
	inner join Sexo on Sexo.ID_sexo = Eleccion.FK_ID_sexo
	where Sexo.Tipo_sexo = "mujeres"
	group by Nombre_pais)
as SubSub on SubSub.Nombre_pais = Sub.NombrePais;
    
    
-- Tercera consulta 
select Sub.Nombre_pais, SubSub.Nombre_partido, CantidadMaxima from (
	select Sub.Nombre_pais, Max(Alcaldias) as CantidadMaxima from(
		Select Nombre_pais, Nombre_partido, count(Nombre_partido) as Alcaldias from (
			Select Sub.Nombre_pais, Nombre_partido, MaxMunicipio from(
				select Nombre_pais, Nombre_municipio,Max(TotalPais) as MaxMunicipio from (
					select Nombre_pais,Nombre_municipio, Nombre_partido,sum(Cant_analfabeto + Cant_alfabeto) as TotalPais from Eleccion
					inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
					inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
					inner join Region on Region.ID_region = Departamento.FK_ID_region
					inner join Pais on Pais.ID_pais = Region.FK_ID_pais
					inner join Partido_politico on Partido_politico.ID_partidoPolitico = Eleccion.FK_ID_partidoPolitico
					group by Nombre_pais,Nombre_municipio, Nombre_partido
				) as sub
				group by Nombre_pais,Nombre_municipio
			) as Sub
			inner join (
				select Nombre_pais,Nombre_municipio, Nombre_partido,sum(Cant_analfabeto + Cant_alfabeto) as TotalPais from Eleccion
				inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
				inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
				inner join Region on Region.ID_region = Departamento.FK_ID_region
				inner join Pais on Pais.ID_pais = Region.FK_ID_pais
				inner join Partido_politico on Partido_politico.ID_partidoPolitico = Eleccion.FK_ID_partidoPolitico
				group by Nombre_pais,Nombre_municipio, Nombre_partido
			) as SubSub on SubSub.Nombre_pais = Sub.Nombre_pais and SubSub.TotalPais = Sub.MaxMunicipio 
		) as Sub
		group by Nombre_pais, Nombre_partido
	) Sub
	group by Nombre_pais
) as Sub
inner join (
Select Nombre_pais, Nombre_partido, count(Nombre_partido) as Alcaldias from (
		Select Sub.Nombre_pais, Nombre_partido, MaxMunicipio from(
			select Nombre_pais, Nombre_municipio,Max(TotalPais) as MaxMunicipio from (
				select Nombre_pais,Nombre_municipio, Nombre_partido,sum(Cant_analfabeto + Cant_alfabeto) as TotalPais from Eleccion
				inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
				inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
				inner join Region on Region.ID_region = Departamento.FK_ID_region
				inner join Pais on Pais.ID_pais = Region.FK_ID_pais
				inner join Partido_politico on Partido_politico.ID_partidoPolitico = Eleccion.FK_ID_partidoPolitico
				group by Nombre_pais,Nombre_municipio, Nombre_partido
			) as sub
			group by Nombre_pais,Nombre_municipio
		) as Sub
		inner join (
			select Nombre_pais,Nombre_municipio, Nombre_partido,sum(Cant_analfabeto + Cant_alfabeto) as TotalPais from Eleccion
			inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
			inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
			inner join Region on Region.ID_region = Departamento.FK_ID_region
			inner join Pais on Pais.ID_pais = Region.FK_ID_pais
			inner join Partido_politico on Partido_politico.ID_partidoPolitico = Eleccion.FK_ID_partidoPolitico
			group by Nombre_pais,Nombre_municipio, Nombre_partido
		) as SubSub on SubSub.Nombre_pais = Sub.Nombre_pais and SubSub.TotalPais = Sub.MaxMunicipio 
	) as Sub
	group by Nombre_pais, Nombre_partido
) as SubSub on SubSub.Alcaldias = Sub.CantidadMaxima
group by Nombre_pais,SubSub.Nombre_partido;



    -- Cuarta consulta R = 7
Select Sub.Nombre_pais,Sub.Nombre_region,SubSub.Nombre_raza, MaxVotos from (
	Select Nombre_pais, Nombre_region, max(SumVotos) as MaxVotos from (
		select Nombre_pais,Nombre_raza,Nombre_region , sum(Cant_analfabeto+Cant_alfabeto) as SumVotos from Eleccion
		inner join Raza on Raza.ID_raza = Eleccion.FK_ID_raza
		inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
		inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
		inner join Region on Region.ID_region = Departamento.FK_ID_region
		inner join Pais on Pais.ID_pais = Region.FK_ID_pais
		-- where Nombre_raza like '%INDIGENAS%'
		group by Nombre_pais,Nombre_region,Nombre_raza
	) as Sub 
	group by Nombre_pais, Nombre_region
) as Sub
inner join(
	select Nombre_pais,Nombre_raza,Nombre_region , sum(Cant_analfabeto+Cant_alfabeto) as SumVotos from Eleccion
	inner join Raza on Raza.ID_raza = Eleccion.FK_ID_raza
	inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
	inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
	inner join Region on Region.ID_region = Departamento.FK_ID_region
	inner join Pais on Pais.ID_pais = Region.FK_ID_pais
	where Nombre_raza like '%INDIGENAS%'
	group by Nombre_pais,Nombre_region,Nombre_raza
) as SubSub on SubSub.SumVotos = Sub.MaxVotos and SubSub.Nombre_region = Sub.Nombre_region;


-- Quinta consulta 


-- Sexta consulta R = 80
select Nombre_departamento, max(Porcentaje) from(
	select  Nombre_departamento, Tipo_sexo, (Suma/SumaTotal)*100 as Porcentaje from(
		select Sub.Nombre_pais, Sub.Nombre_departamento, Sub.Tipo_sexo, Suma, SumaTotal from (
			select Nombre_pais, Nombre_departamento,Sexo.Tipo_sexo, sum(Cant_Universitarios) as Suma from Eleccion
			inner join Raza on Raza.ID_raza = Eleccion.FK_ID_raza
			inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
			inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
			inner join Region on Region.ID_region = Departamento.FK_ID_region
			inner join Pais on Pais.ID_pais = Region.FK_ID_pais
			inner join Sexo on Sexo.ID_sexo = Eleccion.FK_ID_sexo
			where Sexo.Tipo_sexo like "%hombres%"
			group by Nombre_pais,Nombre_departamento,Tipo_sexo
			union all
			select Nombre_pais, Nombre_departamento,Sexo.Tipo_sexo, sum(Cant_Universitarios) as Suma from Eleccion
			inner join Raza on Raza.ID_raza = Eleccion.FK_ID_raza
			inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
			inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
			inner join Region on Region.ID_region = Departamento.FK_ID_region
			inner join Pais on Pais.ID_pais = Region.FK_ID_pais
			inner join Sexo on Sexo.ID_sexo = Eleccion.FK_ID_sexo
			where Sexo.Tipo_sexo like "%mujeres%"
			group by Nombre_pais,Nombre_departamento,Tipo_sexo
			order by Nombre_pais,Nombre_departamento
		) as Sub
		inner join (
			select Nombre_pais, Nombre_departamento, sum(Cant_Universitarios) as SumaTotal from Eleccion
			inner join Raza on Raza.ID_raza = Eleccion.FK_ID_raza
			inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
			inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
			inner join Region on Region.ID_region = Departamento.FK_ID_region
			inner join Pais on Pais.ID_pais = Region.FK_ID_pais
			group by Nombre_pais,Nombre_departamento
		)as SubSub on Sub.Nombre_pais = SubSub.Nombre_pais and Sub.Nombre_departamento = SubSub.Nombre_departamento
	) as Sub
)as Sub
group by Nombre_departamento;




-- Septima consulta R = 22
select Sub.Nombre_pais,Sub.Nombre_region, (SumVotosTotales/Cantidad) as Promedio from(
	select Nombre_pais,Nombre_region, sum(SumVotos) as SumVotosTotales from (
		select Nombre_pais,Nombre_region ,Nombre_departamento, sum(Cant_analfabeto+Cant_alfabeto) as SumVotos from Eleccion
		inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
		inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
		inner join Region on Region.ID_region = Departamento.FK_ID_region
		inner join Pais on Pais.ID_pais = Region.FK_ID_pais
		group by Nombre_pais, Nombre_region,Nombre_departamento
	) as Sub
	group by Nombre_pais,Nombre_region
) as Sub
inner join(
	select Nombre_pais, Nombre_region, count(Nombre_region)as cantidad from(
		select Nombre_pais,Nombre_region ,Nombre_departamento from Eleccion
		inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
		inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
		inner join Region on Region.ID_region = Departamento.FK_ID_region
		inner join Pais on Pais.ID_pais = Region.FK_ID_pais
		group by Nombre_pais, Nombre_region,Nombre_departamento
	)as Sub
	group by Nombre_pais,Nombre_region
)as SubSub on SubSub.Nombre_pais = Sub.Nombre_pais and SubSub.Nombre_region = Sub.Nombre_region;





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



-- Decima consulta R= 1 El salvador
select Sub.Nombre_pais, Diferenciaminima from(
	select Sub.Nombre_pais, (MaxVotos - MinVotos) as diferencia from(
	select Nombre_pais, max(SumVotos) as MaxVotos from(
		Select Nombre_pais,Nombre_partido, sum(Cant_analfabeto+Cant_alfabeto) as SumVotos from Eleccion
		inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
		inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
		inner join Region on Region.ID_region = Departamento.FK_ID_region
		inner join Pais on Pais.ID_pais = Region.FK_ID_pais
		inner join Partido_politico on Partido_politico.ID_partidoPolitico = Eleccion.FK_ID_partidoPolitico
		group by Nombre_pais,Nombre_partido
	)as sub
	group by Nombre_pais
	) as Sub
	inner join(
		select Nombre_pais, Min(SumVotos) as MinVotos from(
			Select Nombre_pais,Nombre_partido, sum(Cant_analfabeto+Cant_alfabeto) as SumVotos from Eleccion
			inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
			inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
			inner join Region on Region.ID_region = Departamento.FK_ID_region
			inner join Pais on Pais.ID_pais = Region.FK_ID_pais
			inner join Partido_politico on Partido_politico.ID_partidoPolitico = Eleccion.FK_ID_partidoPolitico
			group by Nombre_pais,Nombre_partido
		)as sub
		group by Nombre_pais
	)as SubSub on SubSub.Nombre_pais = Sub.Nombre_pais
)as Sub
	inner join(
	select min(diferencia) as Diferenciaminima from(
		select Sub.Nombre_pais, (MaxVotos - MinVotos) as diferencia from(
		select Nombre_pais, max(SumVotos) as MaxVotos from(
			Select Nombre_pais,Nombre_partido, sum(Cant_analfabeto+Cant_alfabeto) as SumVotos from Eleccion
			inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
			inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
			inner join Region on Region.ID_region = Departamento.FK_ID_region
			inner join Pais on Pais.ID_pais = Region.FK_ID_pais
			inner join Partido_politico on Partido_politico.ID_partidoPolitico = Eleccion.FK_ID_partidoPolitico
			group by Nombre_pais,Nombre_partido
		)as sub
		group by Nombre_pais
		) as Sub
		inner join(
			select Nombre_pais, Min(SumVotos) as MinVotos from(
				Select Nombre_pais,Nombre_partido, sum(Cant_analfabeto+Cant_alfabeto) as SumVotos from Eleccion
				inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
				inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
				inner join Region on Region.ID_region = Departamento.FK_ID_region
				inner join Pais on Pais.ID_pais = Region.FK_ID_pais
				inner join Partido_politico on Partido_politico.ID_partidoPolitico = Eleccion.FK_ID_partidoPolitico
				group by Nombre_pais,Nombre_partido
			)as sub
			group by Nombre_pais
		)as SubSub on SubSub.Nombre_pais = Sub.Nombre_pais
	)as Sub
) as SubSub on SubSub.Diferenciaminima = Sub.diferencia;



-- Onceaba consulta
select Sub.Nombre_pais, SumVotosMujeres, (SumVotosMujeres/SumVotos)*100 as Porcentaje from (
	Select Nombre_pais, sum(Cant_analfabeto+Cant_alfabeto) as SumVotos from Eleccion
	inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
	inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
	inner join Region on Region.ID_region = Departamento.FK_ID_region
	inner join Pais on Pais.ID_pais = Region.FK_ID_pais
	inner join Partido_politico on Partido_politico.ID_partidoPolitico = Eleccion.FK_ID_partidoPolitico
	group by Nombre_pais
) as Sub
inner join(
	Select Nombre_pais,Tipo_sexo, sum(Cant_alfabeto) as SumVotosMujeres from Eleccion -- Duda no se si son alfabetas o analfabetas 
	inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios 
	inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
	inner join Region on Region.ID_region = Departamento.FK_ID_region
	inner join Pais on Pais.ID_pais = Region.FK_ID_pais
	inner join Sexo on Sexo.ID_sexo = Eleccion.FK_ID_sexo
    inner join Raza on Raza.ID_raza = Eleccion.FK_ID_raza
	inner join Partido_politico on Partido_politico.ID_partidoPolitico = Eleccion.FK_ID_partidoPolitico
	where Sexo.Tipo_sexo like "%mujeres%" and Raza.Nombre_raza like "%Indigenas%"
	group by Nombre_pais,Tipo_sexo
) as SubSub on SubSub.Nombre_pais = Sub.Nombre_pais;




-- Consulta 12 R = Guatemala
Select Sub.Nombre_pais, (SumAnalfabetas/SumVotos)*100 as Porcentaje from(
select Nombre_pais, sum(Cant_analfabeto+Cant_alfabeto) as SumVotos from Eleccion
inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
inner join Region on Region.ID_region = Departamento.FK_ID_region
inner join Pais on Pais.ID_pais = Region.FK_ID_pais
group by Nombre_pais
)as Sub
inner join(
	select Nombre_pais, sum(Cant_analfabeto) as SumAnalfabetas from Eleccion
	inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
	inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
	inner join Region on Region.ID_region = Departamento.FK_ID_region
	inner join Pais on Pais.ID_pais = Region.FK_ID_pais
	group by Nombre_pais
)as Subsub on Subsub.Nombre_pais = Sub.Nombre_pais
order by Porcentaje desc limit 1;



-- Consulta 13
select Nombre_pais, Nombre_departamento, sum(Cant_analfabeto+Cant_alfabeto) as SumaVotos from Eleccion
inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
inner join Region on Region.ID_region = Departamento.FK_ID_region
inner join Pais on Pais.ID_pais = Region.FK_ID_pais
where Nombre_pais like "%Guatemala%" 
group by Nombre_pais, Nombre_departamento
having sum(Cant_analfabeto+Cant_alfabeto) > (
	select sum(Cant_analfabeto+Cant_alfabeto) as SumaVotosGuatemala from Eleccion
	inner join Municipio on Municipio.ID_municipio = Eleccion.FK_ID_municipios
	inner join Departamento on Departamento.ID_departamento = Municipio.FK_ID_departamento
	inner join Region on Region.ID_region = Departamento.FK_ID_region
	inner join Pais on Pais.ID_pais = Region.FK_ID_pais
	where Nombre_pais like "%Guatemala%" and Nombre_departamento like "%Guatemala%"
	group by Nombre_departamento
);





