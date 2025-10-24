{ el gerente de una cadena de librerias requiere info de los libros vendidos en cada sucursal 
totalizados por ISBN puede haber mas de un isbn en un mismo autor

se dspone de un archivo con registros de ventas: codigo de sucursal (word)
identificador de autor (longword)
isbn del libro 
identificador interno del ejemplar

ordenado por cod sucursal, idautor, e isbn

definir los tipos de registro (tVta) y del archivo. codificar un procedimiento totalizar que reciba el archivo asignado
y el nombre de un archivo de texto y reporte en el archivo de texto:

CODIGO DE SUCURSAL:
    IDENTIFICADOR DEL AUTOR:
        ISBN --- TOTAL DE EJEMPLARES VENDIDOS DEL LIBRO ---
    total de ejemplares vendidos del mismo autor
total de ejemploares vendidos en la sucursal
TOTAL DE EJEMPLARES VENDIDOS EN LA CADENA
}

program parcial2;
const
 valorAlto := 9999,

type 
   ventas = record
    CodSuc : string;
    idAutor : string;
    isbn: string;
    idInt: string;
    end;

    archivo: file of ventas;

procedure leer ( var a:archivo, var reg: ventas);
begin
    if (not EOF (a)) then
        read (a, reg);
    else 
        reg.CodSuc := valorAlto;
end;


procedure totalizar ( var a: archivo, var nombre: string, var txt: text )
var 
  reg : ventas;
  actual: ventas;
  totalLibro: integer;
  totalAutor: integer;
  totalSucursal : integer;
  totalCadena: integer;

begin   
    // asigno archivo de texto
    assign (txt, nombre)
    // creo archivo de texto 
    rewrite (txt);
    // abro archivo
    reset (a);
    leer (a,reg)
    // inicializo total de ejemplares vendidos
    totalCadena :=0 

    // primer corte
    while (reg.CodSuc <> valorAlto) do
        begin
            actual.CodSuc := reg.CodSuc;
            // con el archivo de texto 
            writeln (txt, "CODIGO DE SUCURSAL:" , actual.CodSuc);
            totalSucursal := 0;
           // mientras sea la misma sucursal 
           while (actual.CodSuc = reg.CodSuc) do
               begin
                   actual.idAutor := reg.idAutor;
                   writeln (txt, "iidentificador del autor", act.idAutor);
                   totalAutor := 0;
                   // mientras sea la misma sucursal y autor
                   while (actual.CodSuc = reg.CodSuc) and (actual.idAutor = reg.idAutor )do
                       begin 
                           // inicializo la informacion del libro, el ISBN
                           actual.isbn := reg.isnb;
                           totalLibro := 0;
                           //mientras sea la misma sucursal, autor y libro
                           while (actual.CodSuc = reg.CodSuc) and (actual.idAutor = reg.idAutor ) and (actual.isbn = reg.isbn )do
                               begin 
                                   totalLibro:= totalLibro + 1;
                                   // leo el archivo
                                   leer (a, reg);
                                end; //cambie de libro
                            writeln (txt, "ISBN", actual.isbn, "total vendidos", actual.totalLibro);
                            totalAutor:= totalAutor + totalLibro;
                        end
                    // cambie de autor
                    writeln (txt, "total para el autor", actual.idAutor, "es de", totalAutor);
                    //sumo al total de la sucursal lo vendido por ese autor
                    totalSucursal := totalSucursal + totalAutor;
                end;
                // cambio de sucursal
                // informo lo vendido por la sucursal y sumo al total general
            writeln (txt,"total vendido por la sucursal:", totalSucursal);
            totalCadena := totalCadena + totalSucursal;
        end;
    writln ("total vendido por la cadena:", totalCadena);
    close (a);
    close(txt);
end;




var 
   a: archivo;
   txt: text;
   nom: string;
begin
    writln ("ingrese nombre para el archivo de texto");
    readln (nom);
    totalizar (a,nom,txt);
end.






                                      

                                                     