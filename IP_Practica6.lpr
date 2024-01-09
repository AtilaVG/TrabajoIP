program IP_Practica6;

uses
  dos,SysUtils,ugaraje, Classes;

VAR
  garaje:tGaraje;
  ganancia: tGanancias;
  opcion, minutos, tamanioCoche: integer;
  numMat: string[7];
  distintivo: AnsiString;
  fichero: fich;
  ficheroAntiguosUsers: Text;
  tamanio, comprobar: boolean;
  numMatConcat: AnsiString;
  precioTotal: real;


PROCEDURE Menu();
BEGIN
  writeln(' ');
  writeln('-----');
  writeln('1. Nueva entrada de vehiculo');
  writeln('2. Nueva salida de vehiculo');
  writeln('3. Mostrar plano del garaje');
  writeln('4. Calcular porcentaje de ocupacion');
  writeln('5. Calcular numero de vehiculos estacionados segun distintivo');
  writeln('6. Calcular ganancias totales');
  writeln('7. Funcionalidad extra');
  writeln('8. Salir');
  writeln('-----');
  writeln(' ');

END;


begin

  randomize;

  ASSIGN(fichero, 'datos.dat');
  ASSIGN(ficheroAntiguosUsers, 'antiguos.txt');

  InicializarGaraje(garaje, fichero);

  REPEAT
    Menu();
    readln(opcion);
      CASE opcion OF
           1: BEGIN
              writeln('Escribe si el coche es grande(1) o pequenio(0)');
              readln(tamanioCoche);
              IF tamanioCoche = 1 THEN
                tamanio := true
              ELSE
                tamanio := false;
               IF HayPlazas(garaje, tamanio, fichero) THEN BEGIN
                  MostrarGaraje(garaje, fichero);
                  writeln('Introduce la matricula');
                  REPEAT
                    readln(numMat);
                    ComprobarMat(numMat);
                  UNTIL ComprobarMat(numMat) = true;
                    numMatConcat := numMat;
                    writeln('Introduce el distintivo');
                    readln(distintivo);
                    BuscarPlaza(garaje, numMatConcat, distintivo, tamanio, fichero);
                    //CrearCoche(garaje, numMatConcat, distintivo, tamanio, fichero, aux, aux1) ;
                    //Aparcar(plaza, coche, tamanioCoche)
                 END


                ELSE
                    writeln('En este momento no hay plazas libres en el garaje');
           END;


           2: BEGIN
               writeln('Escribe la matricula de tu coche');
               readln(numMatConcat);
               writeln('Escribe los minutos que has estado aparcado');
               readln(minutos);
               writeln('Escribe el tamanio de tu coche');
               readln(tamanioCoche);
               IF tamanioCoche = 1 THEN
                  tamanio := true
               ELSE
               tamanio := false;
               Salir(numMatConcat, minutos, tamanio, fichero, ganancia);
              END;

           3: MostrarGaraje(garaje, fichero);
           4: PorcentajeOcupacion(garaje, fichero);
           5: BEGIN
                   writeln('Escriba el distintivo que desea buscar');
                   readln(distintivo);
                   Pepe(garaje, distintivo, fichero);
              END;
           6: BEGIN
                 comprobar := true;
                 //ganancia.gananciaTotal := 6;
                 Ganancias(ganancia, precioTotal, comprobar);
              end;
           7:  BEGIN
                     writeln('Escribe la matricula de tu coche');
                     readln(numMatConcat);
                     writeln('Escribe los minutos que has estado aparcado');
                     readln(minutos);
                     writeln('Escribe el tamanio de tu coche');
                     readln(tamanioCoche);
                     IF tamanioCoche = 1 THEN
                        tamanio := true
                     ELSE
                         tamanio := false;
                     Descuento(numMatConcat, minutos, tamanio, ficheroAntiguosUsers, fichero, ganancia);
                END;
      end;



  UNTIL (opcion = 8);
readln();
end.


