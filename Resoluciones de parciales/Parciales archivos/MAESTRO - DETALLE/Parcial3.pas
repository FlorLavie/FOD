{Archivos – Actualización Maestro-Detalle – Inventario de Insumos de una Farmacia

Una famosa farmacia mantiene información en un archivo maestro sobre sus insumos médicos.
El archivo maestro contiene los siguientes campos:
Código de insumo, Nombre del insumo, Descripción, Stock actual, Stock mínimo y si requiere receta de archivo (es un adicional que se le hace a las recetas para medicamentos que requieren receta médica).

Además, la farmacia registra diariamente los insumos vendidos durante el día.
El archivo detalle contiene:
Código de insumo, Cantidad vendida, Nombre del cliente y Domicilio.

Ambos archivos están ordenados por código de insumo.

Requerimientos del programa

Declarar los tipos de datos necesarios para la gestión de ambos tipos de archivos (registro maestro y detalle).

Implementar un procedimiento que realice la actualización del archivo maestro a partir de los archivos detalle del mes (3 archivos detalle), siguiendo estas reglas:

Por cada código de insumo que aparezca en el archivo detalle, se debe descontar del stock actual del maestro la cantidad vendida.

Si al actualizar un insumo su stock actual queda por debajo del stock mínimo, se debe mostrar un mensaje por pantalla indicando que es necesario reponer ese insumo (incluyendo su nombre, descripción, stock actual y mínimo).

Además, se debe cargar en un archivo de texto (declarado en el procedimiento) los medicamentos y clientes que necesitan receta de archivo.
En este archivo se carga: código de insumo, cantidad vendida, nombre del cliente y domicilio.

}

program parcial3;

type
    valor_alto := 9999;

    detalle = record 
        codInsumo: integer;
        cantVendida: integer;
        NomCliente: string;
        domicilio: string;
    end;

    maestro = record
        codInsumo: integer;
        nomInsumo: string;
        descripción: string;
        stockActual: integer;
        stockMinumo: integer;
        receta: boolean;
    end;

    archivo_detalle: file of detalle;
    archivo_maestro: file of maestro;

    vector_detalles = array[1..cantDetalles] of archivo_detalle;
    vector_registros = array[1..cantDetalles] of detalle;


    procedure leerDetalle(var arch: archivo_detalle; var reg: detalle);
    begin
        if not eof(arch) then
           read(arch, reg)
        else
           reg.codInsumo := valor_alto;
        end;

    procedure minimo(var v_det: vector_detalles; var v_reg: vector_registros; var min: detalle);
    var
       i, posMin: integer;
    begin
        posMin := 1;
        for i := 2 to cantDetalles do
           if v_reg[i].codInsumo < v_reg[posMin].codInsumo then
            posMin := i;

        min := v_reg[posMin];
        leerDetalle(v_det[posMin], v_reg[posMin]);
    end;

   procedure actualizarMaestro(var a_maestro: archivo_maestro; var v_det: vector_detalles);
   var
      v_reg: vector_registros;
      min: detalle;
      regM: maestro;
      i, totalVendida: integer;
      texto: Text;
    begin
       reset(a_maestro);

      { Abrir los 30 detalles y leer el primero de cada uno }
      for i := 1 to cantDetalles do
      begin
        reset(v_det[i]);
        leerDetalle(v_det[i], v_reg[i]);
      end;

      assign(texto, 'recetas.txt');
      rewrite(texto);

      minimo(v_det, v_reg, min);  { Busco el primer mínimo }

      while min.codInsumo <> valor_alto do
      begin
       { Avanzo en el maestro hasta encontrar el insumo correspondiente }
         read(a_maestro, regM);
         while regM.codInsumo <> min.codInsumo do
         read(a_maestro, regM);

         totalVendida := 0;

        { Acumulo todas las ventas del mismo insumo }
        while (min.codInsumo = regM.codInsumo) do
        begin
            totalVendida := totalVendida + min.cantVendida;

            { Si requiere receta, lo guardo en el archivo de texto }
            if regM.receta then
            begin
              writeln(texto, regM.codInsumo, ' ', min.cantVendida, ' ', min.nomCliente);
              writeln(texto, min.domicilio);
            end;

            minimo(v_det, v_reg, min);
         end;

       { Actualizo stock en el maestro }
        regM.stockActual := regM.stockActual - totalVendida;
        seek(a_maestro, filepos(a_maestro) - 1);
        write(a_maestro, regM);

       { Si bajó del mínimo, aviso }
        if regM.stockActual < regM.stockMinimo then
         writeln('⚠️ Reponer: ', regM.nomInsumo, ' - ', regM.descripcion,
              ' | Stock actual: ', regM.stockActual,
              ' | Stock mínimo: ', regM.stockMinimo);
     end;

     { Cierro todos los archivos }
     close(a_maestro);
     close(texto);
     for i := 1 to cantDetalles do
       close(v_det[i]);
  end;


  
    var 
        a_maestro: archivo_maestro;
        a_detalle: archivo_detalle;

begin
    
end.