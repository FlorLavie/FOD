{Una cadena de restaurantes posee un archivo de productos que tiene a la venta.
De cada producto se registra:
Código de producto, nombre, descripción, código de barras, categoría de producto, stock actual y stock mínimo.

Diariamente el depósito debe efectuar envíos a cada uno de los tres restaurantes que se encuentran en la ciudad de Laprida.
Para esto, cada restaurante envía un archivo por mail con los pedidos de productos.

Cada pedido contiene:
Código de producto, cantidad pedida y una breve descripción del producto.

Se pide realizar el proceso de actualización del archivo maestro con los tres archivos de detalle, obteniendo un informe de aquellos productos que quedaron por debajo del stock mínimo y, sobre estos productos, informar la categoría a la que pertenecen.

Además, informar aquellos pedidos que no pudieron satisfacerse totalmente por falta de stock, indicando la diferencia que no pudo ser enviada a cada restaurante.

Si el stock no es suficiente para satisfacer un pedido en su totalidad, entonces el mismo debe satisfacerse con la cantidad que se disponga.

Nota: Todos los archivos están ordenados por código de producto.}

const
  valor_alto = 9999;
  cantDetalles = 3;

type
  str30 = string[30];
  str50 = string[50];
  str15 = string[15];
  str20 = string[20];

  detalle = record
    codProducto: integer;
    cantPedida: integer;
    descripcion: str50;    { viene en el detalle, por si querés mostrarla }
  end;

  maestro = record
    codProducto: integer;
    nombre: str30;
    descripcion: str50;
    codBarras: str15;
    categoria: str20;
    stockActual: integer;
    stockMinimo: integer;
  end;

  archivo_detalle = file of detalle;
  archivo_maestro = file of maestro;

  vector_detalles = array[1..cantDetalles] of archivo_detalle;
  vector_registros = array[1..cantDetalles] of detalle;

{--- lee un registro del detalle o pone valor_alto ---}
procedure leer(var arch: archivo_detalle; var reg: detalle);
begin
  if not eof(arch) then
    read(arch, reg)
  else
    reg.codProducto := valor_alto;
end;

{--- mínimo que también devuelve de qué restaurante (índice) salió ---}
procedure minimo(var v_det: vector_detalles; var v_reg: vector_registros;
                 var min: detalle; var idxRest: integer);
var
  i, posMin: integer;
begin
  posMin := 1;
  for i := 2 to cantDetalles do
    if v_reg[i].codProducto < v_reg[posMin].codProducto then
      posMin := i;

  min := v_reg[posMin];
  idxRest := posMin;                 { <- este es el restaurante (1..3) }
  leer(v_det[posMin], v_reg[posMin]);{ avanzar el detalle del mínimo }
end;

{--- actualización del maestro e informes por pantalla ---}
procedure actualizarMaestro(var a_maestro: archivo_maestro; var v_det: vector_detalles);
var
  v_reg: vector_registros;
  regM: maestro;
  min: detalle;
  i, falta, entregado, idxRest: integer;
begin
  reset(a_maestro);

  { abrir los 3 detalles y leer el primero de cada uno }
  for i := 1 to cantDetalles do
  begin
    reset(v_det[i]);
    leer(v_det[i], v_reg[i]);
  end;

  { primer mínimo }
  minimo(v_det, v_reg, min, idxRest);

  while (min.codProducto <> valor_alto) do
  begin
    { avanzar maestro hasta el producto correspondiente }
    read(a_maestro, regM);
    while (regM.codProducto <> min.codProducto) do
      read(a_maestro, regM);

    { procesar todos los pedidos de ESTE producto,
      pudiendo venir de distintos restaurantes }
    while (min.codProducto = regM.codProducto) do
    begin
      if regM.stockActual >= min.cantPedida then
      begin
        { alcanza el stock → se entrega todo }
        regM.stockActual := regM.stockActual - min.cantPedida;
      end
      else
      begin
        { no alcanza → entregar lo que haya y reportar la diferencia }
        entregado := regM.stockActual;
        falta := min.cantPedida - regM.stockActual;
        regM.stockActual := 0;

        writeln('Pedido INCOMPLETO | Prod: ', regM.nombre,
                ' (cod ', regM.codProducto, ') | Restaurante ', idxRest,
                ' | Pedido: ', min.cantPedida,
                ' | Entregado: ', entregado,
                ' | Faltó: ', falta);
      end;

      { siguiente mínimo }
      minimo(v_det, v_reg, min, idxRest);
    end;

    { al terminar de atender todos los pedidos de este producto,
      actualizar el maestro y, si corresponde, informar bajo stock }
    seek(a_maestro, filepos(a_maestro) - 1);
    write(a_maestro, regM);

    if regM.stockActual < regM.stockMinimo then
      writeln('⚠️ Bajo stock mínimo | Prod: ', regM.nombre,
              ' (cod ', regM.codProducto, ') | Categoría: ', regM.categoria,
              ' | Stock actual: ', regM.stockActual,
              ' | Stock mínimo: ', regM.stockMinimo);
  end;

  { cerrar todo }
  close(a_maestro);
  for i := 1 to cantDetalles do close(v_det[i]);
end;

