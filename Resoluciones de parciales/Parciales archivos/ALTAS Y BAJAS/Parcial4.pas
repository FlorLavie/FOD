{Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con la información correspondiente a las prendas que se encuentran a la venta.
De cada prenda se registra:
código de prenda, descripción, colores, tipo de prenda, stock y precio unitario.

Ante un eventual cambio de temporada, se deben actualizar las prendas a la venta.
Las prendas que quedarán obsoletas deberán ser eliminadas.

Para ello, se implementará un archivo contenedor con los códigos de las prendas que deben darse de baja.
Deberá implementarse un procedimiento que reciba ambos archivos y realice la baja lógica de las prendas correspondientes (asignando el stock de la prenda correspondiente a valor negativo).

Por último, una vez finalizadas las bajas lógicas, deberá efectivizar las mismas compactando el archivo.
Para ello no podrá utilizar ninguna estructura auxiliar: la compactación debe resolverse dentro del mismo archivo.
Solo deben quedar en el archivo las prendas que no fueron borradas.}


