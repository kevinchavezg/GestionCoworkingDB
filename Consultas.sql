-- Usuarios y Membresias

-- Consulta 1. Listar todos los usuarios con su información básica.
select * from usuarios;

-- Consulta 2. Listar los usuarios con membresía activa.
select u.nombre, u.apellido
from usuarios u
inner join asignacionMembresias am on u.idUsuario = am.usuario_id
where am.estado = 'Activa';

-- Consulta 3. Listar los usuarios cuya membresía está vencida.
select u.nombre, u.apellido
from usuarios u
inner join asignacionMembresias am on u.idUsuario = am.usuario_id
where am.estado = 'Vencida';

-- Consulta 4. Listar los usuarios con membresía suspendida.
select u.nombre, u.apellido
from usuarios u
inner join asignacionMembresias am on u.idUsuario = am.usuario_id
where am.estado = 'Suspendida';

-- Consulta 5. Contar cuántos usuarios tienen cada tipo de membresía.
select m.tipo, count(am.usuario_id) as NoUsuarios
from membresias m
inner join asignacionMembresias am on m.idMembresia = am.membresia_id
group by m.tipo;

-- Consulta 6. Mostrar el top 10 de usuarios con más antigüedad en el coworking.
select u.nombre, u.apellido, min(am.fechaInicial) as Antiguedad
from usuarios u
inner join asignacionMembresias am on u.idUsuario = am.usuario_id
group by u.idUsuario
order by Antiguedad asc
limit 10;

-- Consulta 7. Listar usuarios que pertenecen a una empresa específica.
select u.nombre, u.apellido, u.empresa
from usuarios u
where empresa = 'Innovatech';

-- Consulta 8. Contar cuántos usuarios están asociados a cada empresa.
select u.empresa, count(u.idUsuario)
from usuarios u
group by u.empresa;

-- Consulta 9. Mostrar usuarios que nunca han hecho una reserva.
select * from usuarios u
where u.idUsuario not in (select usuario_id from reservas);

-- Consulta 10. Mostrar usuarios con más de 5 reservas activas en el mes.
select u.nombre, u.apellido
from usuarios u
inner join reservas r on u.idUsuario = r.usuario_id
where r.estado = 'Confirmada' and month(r.fecha) = month(current_date())
group by u.idUsuario
having count(r.usuario_id) > 5;

-- Consulta 11. Calcular el promedio de edad de los usuarios.
select avg(timestampdiff(year, fechaNacimiento, curdate())) as promedio_edad
from usuarios;

-- Consulta 12. Listar usuarios que han cambiado de membresía más de 2 veces.
select u.nombre, u.apellido
from usuarios u
inner join asignacionMembresias am on u.idUsuario = am.usuario_id
group by u.idUsuario
having count(am.idAsignacion) > 2;

-- Consulta 13. Listar usuarios que han gastado más de $500 en reservas.
select u.nombre, u.apellido
from usuarios u
join facturas f on u.idUsuario = f.usuario_id
where f.estado = 'Pagada'
having sum(f.total) > 500;

-- Consulta 14. Mostrar usuarios que tienen tanto membresía como servicios adicionales.
select distinct u.nombre, u.apellido
from usuarios u
inner join asignacionMembresias am on u.idUsuario = am.usuario_id
inner join reservas r on u.idUsuario = r.usuario_id
where am.estado = 'Activa' and r.servicioAdicional_id is not null;

-- Consulta 15. Listar usuarios con membresía Premium y reservas activas.
select distinct u.nombre, u.apellido
from usuarios u
inner join asignacionMembresias am on u.idUsuario = am.usuario_id
inner join reservas r on u.idUsuario = r.usuario_id
where am.membresia_id = 4 and r.estado = 'Confirmada';

-- Consulta 16. Mostrar usuarios con membresía Corporativa y su empresa.
select u.nombre, u.apellido, u.empresa
from usuarios u
inner join asignacionmembresias am on u.idUsuario = am.usuario_id
inner join membresias m on am.membresia_id = m.idMembresia
where m.tipo = 'Corporativa';

-- Consulta 17. Identificar usuarios con membresía diaria que la han renovado más de 10 veces.
select u.nombre, u.apellido
from usuarios u
inner join asignacionMembresias am on u.idUsuario = am.usuario_id
inner join membresias m on am.membresia_id = m.idMembresia
where m.tipo = 'Diaria'
group by u.idUsuario
having count(am.idAsignacion) > 10;

-- Consulta 18. Mostrar usuarios cuya membresía vence en los próximos 7 días.
select u.nombre, u.apellido
from usuarios u
inner join asignacionMembresias am on u.idUsuario = am.usuario_id
where am.fechaVencimiento between curdate() and curdate()+7;

-- Consulta 19. Listar usuarios que se registraron en el último mes.
select u.nombre, u.apellido
from usuarios u
inner join asignacionMembresias am on u.idUsuario = am.usuario_id
where am.fechaInicial >= curdate()-30;

-- Consulta 20. Mostrar usuarios que nunca han asistido al coworking (0 accesos).
select u.nombre, u.apellido
from usuarios u
where u.idusuario not in (select usuario_id from Reservas);


-- Espacios y Reservas

-- Consulta 21. Listar todos los espacios disponibles con su capacidad.
select e.idespacio, t.capacidad
from espacios e
inner join TiposEspacios t on e.tipoEspacio_id = t.idTipoEspacio;

-- Consulta 22. Listar reservas activas en el día actual.
select *
from reservas r
where r.fecha = curdate() and r.estado = 'Confirmada';

-- Consulta 23. Mostrar reservas canceladas en el último mes.
select *
from reservas r
where r.fecha >= curdate()-30 and r.estado = 'Cancelada';

-- Consulta 24. Listar reservas de salas de reuniones en horario pico (9 am – 11 am).
select r.*
from reservas r
inner join espacios e on r.espacio_id = e.idEspacio
inner join tiposEspacios t on e.tipoespacio_id = t.idtipoEspacio
where t.nombre = 'Salas de reuniones' and r.hora_entrada >= '09:00:00' and r.hora_salida <= '11:00:00';

-- Consulta 25. Contar cuántas reservas se hacen por cada tipo de espacio.
select t.nombre, count(r.idReserva)
from reservas r
inner join espacios e on r.espacio_id = e.idEspacio
inner join tiposEspacios t on e.tipoEspacio_id = t.idTipoEspacio
group by t.nombre;

-- 26. Mostrar el espacio más reservado del último mes.
select e.idEspacio
from reservas r
inner join espacios e on r.espacio_id = e.idEspacio
where r.fecha >= curdate()-30
order by r.fecha desc
limit 1;

-- Consulta 27. Listar usuarios que más han reservado salas privadas
select u.nombre, u.apellido
from usuarios u
inner join reservas r on u.idUsuario = r.usuario_id
inner join espacios e on r.espacio_id = e.idEspacio
inner join tiposEspacios t on e.tipoEspacio_id = t.idTipoEspacio
where t.nombre = 'Oficina privada';

-- Consulta 28. Mostrar reservas que exceden la capacidad máxima del espacio.
select r.*, e.capacidad
from reservas r
inner join espacios e on r.espacio_id = e.idEspacio
inner join asistencias a on r.asistencia_id = a.idAsistencia
inner join tiposEspacios t on e.tipoEspacio_id = t.idTipoEspacio
where r.asistencia_id > t.capacidad;

-- Consulta 29. Listar espacios que no se han reservado en la última semana.
select e.idEspacio
from espacios e
where idEspacio not in (select r.espacio_id from reservas r where fecha >= curdate()-7);

-- Consulta 30. Calcular la tasa de ocupación promedio de cada espacio.
select e.idEspacio, avg(t.capacidad)
from espacios e
inner join TiposEspacios t on e.tipoEspacio_id = t.idTipoEspacio
group by e.idEspacio;

-- Consulta 31. Mostrar reservas de más de 8 horas.
select *
from reservas r
where timestampdiff(hour, hora_entrada, hora_salida) > 8;

-- Consulta 32. Identificar usuarios con más de 20 reservas en total.
select u.nombre, u.apellido, count(r.idReserva) as totalReservas
from usuarios u
inner join reservas r on u.idUsuario = r.usuario_id
group by idUsuario
having count(r.idReserva) > 20;

-- Consulta 33. Mostrar reservas realizadas por empresas con más de 10 empleados.
select r.idReserva, u.empresa
from reservas r
inner join usuarios u on r.usuario_id = u.idUsuario
where u.empresa in (select empresa from usuarios group by empresa having count(idUsuario) > 10);

-- Consulta 34. Listar reservas que se solapan en horario.

-- Consulta 35. Listar reservas de fin de semana.
select *
from reservas r
where dayofweek(fecha) in (1, 7);

-- Consulta 36. Mostrar el porcentaje de ocupación por cada tipo de espacio.
select t.nombre, count(r.idReserva)*100 / count(r.idreserva)
from tiposEspacios t
inner join espacios e on t.idTipoEspacio = e.tipoEspacio_id
inner join reservas r on e.idEspacio = r.espacio_id
group by t.nombre;

-- Consulta 37. Mostrar la duración promedio de reservas por tipo de espacio.
select t.nombre, avg(timestampdiff(minute, r.hora_entrada, r.hora_salida)) as promedioReserva
from tiposEspacios t
inner join espacios e on t.idTipoEspacio = e.tipoEspacio_id
inner join reservas r on e.idEspacio = r.espacio_id
group by t.nombre;


-- Consulta 38. Mostrar reservas con servicios adicionales incluidos.
select r.*, s.nombre
from reservas r
inner join serviciosAdicionales s on r.servicioAdicional_id = s.idServicioAdicional;

-- Consulta 39. Listar usuarios que reservaron sala de eventos en los últimos 6 meses.
select u.nombre, u.apellido
from usuarios u
inner join reservas r on u.idUsuario = r.usuario_id
inner join espacios e on r.espacio_id = e.idespacio
inner join tiposEspacios t on e.tipoEspacio_id = t.idTipoEspacio
where r.fecha < curdate()-(7*30) and t.nombre = 'Salas de eventos';

-- Consulta 40. Identificar reservas realizadas y nunca asistidas.
select *
from reservas r
where r.estado = ('Cancelada');



-- Pagos y Facturación

-- Consulta 41. Listar todos los pagos realizados con método tarjeta.
select p.* 
from pagos p 
inner join facturas f on p.factura_id = f.idfactura 
inner join metodospago mp on f.metodopago_id = mp.idmetodopago 
where mp.nombre like 'Tarjeta';

-- Consulta 42. Listar pagos pendientes de usuarios.
select u.*, f.idfactura, f.total 
from usuarios u 
inner join facturas f on u.idusuario = f.usuario_id 
where f.estado = 'Pendiente';

-- Consulta 43. Mostrar pagos cancelados en los últimos 3 meses.
select p.* 
from pagos p 
join facturas f on p.factura_id = f.idfactura 
where f.estado = 'cancelado' and p.fecha >= curdate()-90;

-- Consulta 44. Listar facturas generadas por membresías.
select f.* 
from facturas f 
inner join asignacionmembresias am on f.usuario_id = am.usuario_id 
where f.fecha = am.fechainicial;

-- Consulta 45. Listar facturas generadas por reservas.
select f.* 
from facturas f 
inner join reservas r on f.reserva_id = r.idreserva;

-- Consulta 46. Mostrar el total de ingresos por membresías en el último mes.
select sum(f.total)
from facturas f 
inner join asignacionmembresias am on f.usuario_id = am.usuario_id 
where f.fecha = am.fechainicial and f.estado = 'Pagado' and f.fecha >= curdate()-30;

-- Consulta 47. Mostrar el total de ingresos por reservas en el último mes.
select sum(f.total) as totalIngresos 
from facturas f 
inner join reservas r on f.reserva_id = r.idreserva 
where f.estado = 'Pagado' and f.fecha >= curdate()-30;

-- Consulta 48. Mostrar el total de ingresos por servicios adicionales.
select sum(sa.precio) as totalServicios 
from serviciosadicionales sa 
inner join reservas r on sa.idservicioadicional = r.servicioadicional_id 
inner join facturas f on r.idreserva = f.reserva_id where f.estado = 'Pagado';

-- Consulta 49. Identificar usuarios que nunca han pagado con PayPal.
select * 
from usuarios u
where u.idusuario not in (select f.usuario_id from facturas f join metodospago mp on f.metodopago_id = mp.idmetodopago where mp.nombre like 'Paypal');

-- Consulta 50. Calcular el promedio de gasto por usuario.
select u.nombre, u.apellido, avg(f.total)
from usuarios u
inner join facturas f on u.idusuario = f.usuario_id
where f.estado = 'Pagado'
group by u.idusuario;


-- Consulta 51. Mostrar el top 5 de usuarios que más han pagado en total.
select u.idusuario, u.nombre, u.apellido, sum(f.total) as totalPagado
from usuarios u 
inner join facturas f on u.idusuario = f.usuario_id 
where f.estado = 'pagado' 
group by u.idusuario, u.nombre, u.apellido 
order by totalPagado desc 
limit 5;

-- Consulta 52. Mostrar facturas con monto mayor a $1000.
select * from facturas where total > 1000;

-- Consulta 53. Listar pagos realizados después de la fecha de vencimiento.
select p.* 
from pagos p 
inner join facturas f on p.factura_id = f.idfactura 
inner join asignacionmembresias am on f.usuario_id = am.usuario_id 
where p.fecha > am.fechavencimiento;

-- Consulta 54. Calcular el total recaudado en el año actual.
select sum(monto) as total from pagos where year(fecha) = year(curdate());

-- Consulta 55. Mostrar facturas anuladas y su motivo.
select * from facturas where estado in ('Cancelado');

-- Consulta 56. Mostrar usuarios con facturas pendientes mayores a $200.
select u.nombre, u.apellido 
from usuarios u
inner join facturas f on u.idUsuario = f.usuario_id
where f.estado = 'Pendiente' and f.total > 200;

-- Consulta 57. Mostrar usuarios que han pagado más de una vez el mismo servicio.
select u.nombre, u.apellido
from usuarios u 
inner join reservas r on u.idusuario = r.usuario_id 
inner join facturas f on r.idreserva = f.reserva_id 
where f.estado = 'Pagado' and r.servicioadicional_id is not null 
group by u.idusuario, r.servicioadicional_id 
having count(r.idreserva) > 1;

-- Consulta 58. Listar ingresos por cada método de pago.
select mp.nombre, sum(f.total)
from metodospago mp 
inner join facturas f on mp.idmetodopago = f.metodopago_id 
where f.estado = 'Pagado' group by mp.nombre;

-- Consulta 59. Mostrar facturación acumulada por empresa.
select u.empresa, sum(f.total) 
from usuarios u 
inner join facturas f on u.idusuario = f.usuario_id 
where f.estado = 'Pagado' 
group by u.empresa;

-- Consulta 60. Mostrar ingresos netos por mes del último año.


-- Accesos y Asistencias

-- Consulta 61. Listar todos los accesos registrados hoy.
select a.* 
from asistencias a 
inner join reservas r on a.reserva_id = r.idreserva 
where r.fecha = curdate();

-- Consulta 62. Mostrar usuarios con más de 20 asistencias en el mes.
select u.nombre, u.apellido, count(a.idasistencia) as Asistencias 
from usuarios u 
inner join asistencias a on u.idusuario = a.usuario_id 
inner join reservas r on a.reserva_id = r.idreserva 
where month(r.fecha) = month(curdate()) 
group by u.idusuario 
having count(a.idasistencia) > 20;

-- Consulta 63. Mostrar usuarios que no asistieron en la última semana.
select * 
from usuarios u 
where idusuario not in (select a.usuario_id from asistencias a join reservas r on a.reserva_id = r.idreserva where r.fecha >= curdate()-7);

-- Consulta 64. Calcular la asistencia promedio por día de la semana.
select dayname(r.fecha) as dia, count(a.idasistencia) as Asistencias 
from asistencias a 
inner join reservas r on a.reserva_id = r.idreserva 
group by dayname(r.fecha);

-- Consulta 65. Mostrar los 10 usuarios más constantes (más asistencias).
select u.nombre, u.apellido, count(a.idasistencia) as totalAsistencias 
from usuarios u 
inner join asistencias a on u.idusuario = a.usuario_id 
group by u.idusuario 
order by totalAsistencias desc 
limit 10;

-- Consulta 66. Mostrar accesos fuera del horario permitido.
select a.* 
from asistencias a 
inner join reservas r on a.reserva_id = r.idreserva 
inner join espacios e on r.espacio_id = e.idespacio 
where r.hora_entrada < e.horarioentrada or r.hora_salida > e.horariosalida;

-- Consulta 67. Mostrar usuarios que accedieron sin membresía activa (rechazados).
select distinct u.nombre, u.apellido
from usuarios u 
inner join asistencias a on u.idusuario = a.usuario_id 
inner join reservas r on a.reserva_id = r.idreserva 
inner join asignacionmembresias am on u.idusuario = am.usuario_id 
where r.fecha between am.fechainicial and am.fechavencimiento and am.estado != 'Activa';

-- Consulta 68. Listar usuarios que solo acceden los fines de semana.
select u.* 
from usuarios u 
join asistencias a on u.idusuario = a.usuario_id 
inner join reservas r on a.reserva_id = r.idreserva 
group by u.idusuario 
having sum(case when dayofweek(r.fecha) in (1, 7) then 1 else 0 end) = count(a.idasistencia);


-- Consulta 69. Mostrar usuarios que accedieron más de 2 veces en el mismo día.
select u.nombre, u.apellido, r.fecha, count(a.idasistencia) as acceso 
from usuarios u 
inner join asistencias a on u.idusuario = a.usuario_id 
inner join reservas r on a.reserva_id = r.idreserva 
group by u.idusuario, r.fecha 
having count(a.idasistencia) > 2;

-- Consulta 70. Mostrar el total de accesos diarios en el último mes.
select r.fecha, count(a.idasistencia) as total_accesos 
from asistencias a 
inner join reservas r on a.reserva_id = r.idreserva 
where r.fecha >= curdate()-30 
group by r.fecha 
order by r.fecha;

-- Consulta 71. Mostrar usuarios que han accedido pero no tienen reservas.
select u.* 
from usuarios u 
inner join asistencias a on u.idusuario = a.usuario_id;

-- Consulta 72. Mostrar los días con más concurrencia en el coworking.
select r.fecha, count(a.idasistencia) as total_asistencias 
from asistencias a 
inner join reservas r on a.reserva_id = r.idreserva 
group by r.fecha 
order by total_asistencias desc limit 5;

-- Consulta 73. Mostrar usuarios que entraron pero no registraron salida.
select r.* 
from reservas r 
inner join asistencias a on r.idreserva = a.reserva_id 
where r.hora_salida is null;

-- Consulta 74. Mostrar accesos de usuarios con membresía vencida.
select a.* 
from asistencias a 
inner join reservas r on a.reserva_id = r.idreserva 
join asignacionmembresias am on a.usuario_id = am.usuario_id 
where r.fecha > am.fechavencimiento or am.estado = 'Vencida';

-- Consulta 75. Mostrar accesos de usuarios corporativos por empresa.
select u.empresa, count(a.idasistencia) as total 
from asistencias a 
inner join usuarios u on a.usuario_id = u.idusuario 
inner join asignacionmembresias am on u.idusuario = am.usuario_id 
inner join membresias m on am.membresia_id = m.idmembresia 
where m.tipo = 'Corporativa' 
group by u.empresa;


-- Consulta 76. Mostrar clientes que nunca han usado el coworking a pesar de pagar membresía.
select distinct u.nombre, u.apellido 
from usuarios u 
inner join asignacionmembresias am on u.idusuario = am.usuario_id 
where u.idusuario not in (select usuario_id from asistencias);

-- Consulta 77. Mostrar accesos rechazados por intentos con QR inválido.


-- Consulta 78. Mostrar accesos promedio por usuario.

-- Consulta 79. Identificar usuarios que asisten más en la mañana.

-- Consulta 80. Identificar usuarios que asisten más en la noche.

