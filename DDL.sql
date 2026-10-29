create DATABASE GestionCoworkingDB;

use GestionCoworkingDB;

create table Membresias(
    idMembresia int primary key auto_increment,
    tipo varchar(45) not null,
    precio decimal(10,2) not null,
    duracion int not null
);

create table AsignacionMembresias(
    idAsignacion int primary key auto_increment,
    membresia_id int not null,
    usuario_id int not null,
    estado varchar(45) not null,
    fechaInicial date not null,
    fechaVencimiento date not null,
    foreign key (membresia_id) references Membresias(idMembresia)
);

create table LogMembresias(
    idLogMembresia int primary key auto_increment,
    asignacion_id int not null,
    fecha date not null,
    estadoAnterior varchar(45) not null,
    estadoActual varchar(45) not null,
    foreign key (asignacion_id) references AsignacionMembresias(idAsignacion)
);

create table Usuarios(
    idUsuario int primary key auto_increment,
    nombre varchar(45) not null,
    apellido varchar(45) not null,
    dpi varchar(20) not null,
    fechaNacimiento date not null,
    telefono varchar(9) not null,
    correo varchar(45) not null unique,
    empresa varchar(100) not null
);


create table TiposEspacios (
    idTipoEspacio int primary key auto_increment,
    nombre varchar(45) not null,
    capacidad int not null,
    precio decimal(10,2) not null
);

create table Espacios(
    idEspacio int primary key auto_increment,
    tipoEspacio_id int not null,
    capacidad int not null,
    horarioEntrada time not null,
    horarioSalida time not null,
    precio decimal(10,2) not null,
    foreign key (tipoEspacio_id) references TiposEspacios(idTipoEspacio)
);

create table ServiciosAdicionales(
    idServicioAdicional int primary key auto_increment,
    nombre varchar(45) not null,
    precio decimal(10,2) not null
);


create table Reservas(
    idReserva int primary key auto_increment,
    usuario_id int not null,
    espacio_id int not null,
    fecha date not null,
    hora_entrada time not null,
    hora_salida time not null,
    estado varchar(45) not null,
    asistencia_id int not null,
    servicioAdicional_id int,
    foreign key (usuario_id) references Usuarios(idUsuario),
    foreign key (espacio_id) references Espacios(idEspacio),
    foreign key (servicioAdicional_id) references ServiciosAdicionales(idServicioAdicional)
);

create table Asistencias (
    idAsistencia int primary key auto_increment,
    reserva_id int not null,
    usuario_id int not null,
    foreign key (reserva_id) references Reservas(idReserva),
    foreign key (usuario_id) references Usuarios(idUsuario)
);


create table MetodosPago(
    idMetodoPago int primary key auto_increment,
    nombre varchar(45) not null
);

create table Facturas(
    idFactura int primary key auto_increment,
    fecha date not null,
    reserva_id int not null,
    usuario_id int not null,
    nit varchar(10) not null,
    metodoPago_id int not null,
    estado varchar(45) not null,
    total decimal(10,2) not null,
    foreign key (usuario_id) references Usuarios(idUsuario),
    foreign key (reserva_id) references Reservas(idReserva),
    foreign key (metodoPago_id) references MetodosPago(idMetodoPago)
);

create table DetalleFacturas(
    idDetalleFactura int primary key auto_increment,
    factura_id int not null,
    cantidad int not null,
    precioUnitario decimal(10,2) not null,
    subtotal decimal(10,2) not null,
    foreign key (factura_id) references Facturas(idFactura)
);

create table Pagos(
    idPago int primary key auto_increment,
    factura_id int not null,
    fecha date not null,
    monto decimal(10,2) not null,
    foreign key (factura_id) references Facturas(idFactura)
);