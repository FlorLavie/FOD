{Una empresa que comercializa fármacos recibe de cada una de sus 30 sucursales un resumen mensual de las ventas y desea analizar la información para la toma de futuras decisiones.

El formato de los archivos que recibe la empresa es:
cod_farmaco, nombre, fecha, cantidad_vendida, forma_pago (campo String indicando contado o tarjeta).

Los archivos de ventas están ordenados por cod_farmaco y fecha.

Cada sucursal puede vender cero, uno o más veces determinado fármaco el mismo día, y la forma de pago podría variar en cada venta.

Realizar los siguientes procedimientos:

a) Recibe los 30 archivos de ventas e informa por pantalla el fármaco con mayor cantidad vendida.

c) Recibe los 30 archivos de ventas y guarda en un archivo de texto un resumen de ventas por fecha y fármaco, con el siguiente formato:
cod_farmaco, nombre, fecha, cantidad_total_vendida.

(El archivo de texto deberá estar organizado de manera tal que al tener que utilizarlo pueda recorrerse realizando la menor cantidad de lecturas posibles.)

Nota: En el archivo de texto, por cada fármaco aparecerá a lo sumo una vez.

Además, describir las estructuras de datos utilizadas.}


program farmacos;                                   { Nombre del programa }

const
  valor_alto    = 9999;                             { Centinela para cortar el merge }
  cantDetalles  = 30;                               { Cantidad de sucursales/archivos }

type
  str10  = string[10];                              { Tipos string acotados }
  str30  = string[30];
  str50  = string[50];

  detalle = record                                  { Registro de CADA venta en una sucursal }
    codFarmaco      : integer;                      { Clave 1 (orden de entrada) }
    nombre          : str30;                        { Nombre del fármaco (repetido en todas las ventas) }
    fecha           : str10;                        { Clave 2 (YYYYMMDD) }
    cantVendida     : integer;                      { Cantidad de esta venta puntual }
    formaPago       : str10;                        { 'contado' o 'tarjeta' (no lo usamos acá) }
  end;

  archivo_detalle  = file of detalle;               { Archivo binario de ventas }
  vector_detalles  = array[1..cantDetalles] of archivo_detalle; { 30 archivos abiertos a la vez }
  vector_registros = array[1..cantDetalles] of detalle;         { Registro “vigente” de cada archivo }

{-------------------------------------------}
procedure leer(var arch: archivo_detalle; var reg: detalle);
begin
  if not eof(arch) then                             { ¿Queda algo por leer? }
    read(arch, reg)                                 { Sí: leo el siguiente registro }
  else
    reg.codFarmaco := valor_alto;                   { No: coloco centinela para ese archivo }
end;

{-------------------------------------------}
procedure minimo(                                      { Devuelve el menor por (cod,fecha) }
  var v_det: vector_detalles;                          { Vector de archivos detalle }
  var v_reg: vector_registros;                         { Vector de registros vigentes }
  var min   : detalle;                                 { Salida: el mínimo encontrado }
  var idx   : integer                                   { Salida: de qué archivo salió }
);
var
  i, pos: integer;
begin
  pos := 1;                                            { Arranco suponiendo que el 1 es el mínimo }
  for i := 2 to cantDetalles do                        { Recorro del 2 al 30 }
    if (v_reg[i].codFarmaco < v_reg[pos].codFarmaco)   { Compara primero por código… }
    or ((v_reg[i].codFarmaco = v_reg[pos].codFarmaco)
    and (v_reg[i].fecha < v_reg[pos].fecha)) then      { …y si empatan, por fecha }
      pos := i;                                        { Actualizo posición del mínimo }
  min := v_reg[pos];                                   { Copio el registro mínimo }
  idx := pos;                                          { Guardo de qué archivo vino }
  leer(v_det[pos], v_reg[pos]);                        { Avanzo ese archivo (leo su siguiente) }
end;

{-------------------------------------------}
procedure farmacoMasVendido(var v_det: vector_detalles);  { Inciso a) }
var
  v_reg               : vector_registros;               { Registros vigentes de cada sucursal }
  min                 : detalle;                        { Siguiente (cod,fecha) a procesar }
  idx, i              : integer;                        { idx = sucursal del mínimo }
  codActual, totalCod : longint;                        { Acumulación por código }
  nombreActual        : str30;                          { Nombre del fármaco actual }
  maxCod, maxTotal    : longint;                        { Mejor (máximo) hallado }
  maxNombre           : str30;
begin
  for i := 1 to cantDetalles do begin                  { Abro y “cebo” (leo 1° registro) }
    reset(v_det[i]);
    leer(v_det[i], v_reg[i]);
  end;

  maxTotal  := -1; maxCod := -1; maxNombre := '';      { Inicializo máximo global }

  minimo(v_det, v_reg, min, idx);                      { Pido el primer mínimo }
  while (min.codFarmaco <> valor_alto) do begin        { Mientras haya datos en algún archivo… }
    codActual    := min.codFarmaco;                    { Tomo el código actual }
    nombreActual := min.nombre;                        { Nombre asociado (vale cualquiera del mismo cod) }
    totalCod     := 0;                                 { Reseteo acumulador por código }

    while (min.codFarmaco <> valor_alto)               { Agrupo TODAS las ventas de este código }
      and (min.codFarmaco = codActual) do begin
      totalCod := totalCod + min.cantVendida;          { Sumo cantidades, sin importar la fecha }
      minimo(v_det, v_reg, min, idx);                  { Siguiente mínimo (puede ser misma u otra sucursal) }
    end;

    if totalCod > maxTotal then begin                  { ¿Mejor que el máximo global? }
      maxTotal  := totalCod;
      maxCod    := codActual;
      maxNombre := nombreActual;
    end;
  end;

  writeln('📦 Fármaco con mayor cantidad vendida: ',     { Muestro resultado final }
          maxNombre, ' (cód ', maxCod, ') - Total: ', maxTotal);

  for i := 1 to cantDetalles do close(v_det[i]);       { Cierro todos los archivos }
end;

{-------------------------------------------}
procedure generarResumen(var v_det: vector_detalles);  { Inciso c) }
var
  v_reg               : vector_registros;              { Estados vigentes de cada sucursal }
  min, regOut         : detalle;                       { min: actual del merge; regOut: para imprimir }
  idx, i              : integer;
  codActual           : integer;
  fechaActual         : str10;
  totalPar            : longint;                       { Total por par (cod,fecha) }
  txt                 : Text;                          { Archivo de salida de texto }
begin
  for i := 1 to cantDetalles do begin                  { Abro y cebo }
    reset(v_det[i]);
    leer(v_det[i], v_reg[i]);
  end;

  assign(txt, 'resumen_ventas.txt');                   { Creo el archivo de salida }
  rewrite(txt);
  writeln(txt, 'cod_farmaco;nombre;fecha;cantidad_total_vendida'); { Encabezado útil }

  minimo(v_det, v_reg, min, idx);                      { Primer mínimo }
  while (min.codFarmaco <> valor_alto) do begin        { Mientras quede algo… }
    codActual   := min.codFarmaco;                     { Fijo la clave (cod,fecha)… }
    fechaActual := min.fecha;
    regOut      := min;                                { Me guardo el nombre para ese par }
    totalPar    := 0;                                  { Reseteo acumulador del par }

    while (min.codFarmaco <> valor_alto)               { Agrupo todas las líneas del MISMO (cod,fecha) }
      and (min.codFarmaco = codActual)
      and (min.fecha = fechaActual) do begin
      totalPar := totalPar + min.cantVendida;          { Sumo cantidades }
      minimo(v_det, v_reg, min, idx);                  { Avanzo el merge }
    end;

    writeln(txt, regOut.codFarmaco, ';',               { Escribo UNA sola línea por par (cod,fecha) }
                 regOut.nombre, ';',
                 fechaActual, ';', totalPar);
  end;

  close(txt);                                          { Cierro salida… }
  for i := 1 to cantDetalles do close(v_det[i]);       { …y todos los detalles }
end;

{-------------------------------------------}
var
  v_det: vector_detalles;                              { Vector de 30 archivos detalle }
  i    : integer;
begin
  { IMPORTANTE: Acá deberías asignar nombres REALES a cada archivo }
  { Ejemplo (ilustrativo): 'ventas_01.dat', 'ventas_02.dat', … 'ventas_30.dat' }
  for i := 1 to cantDetalles do
    assign(v_det[i], 'ventas_' + chr(48 + (i div 10)) + chr(48 + (i mod 10)) + '.dat');
    { Nota: esta línea arma nombres 'ventas_00.dat'.. 'ventas_30.dat' de ejemplo.
      En práctica, reemplazá por tus nombres reales o un vector de strings. }

  writeln('--- PROCESO DE ANALISIS DE VENTAS ---');    { Cartelito }
  writeln;

  farmacoMasVendido(v_det);                            { Inciso (a): máximo global por código }

  writeln;
  writeln('Generando archivo resumen...');

  generarResumen(v_det);                               { Inciso (c): resumen (cod,fecha) }

  writeln('✅ Archivo "resumen_ventas.txt" generado correctamente.');
end.

