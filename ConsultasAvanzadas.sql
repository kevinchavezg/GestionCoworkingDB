-- Consulta 81
select u.nombre, u.apellido, sum(f.total) as totalAcumulado
from Usuarios u
inner join Facturas f on u.idUsuario = f.usuario_id
group by u.idUsuario
order by totalAcumulado desc
limit 1;
