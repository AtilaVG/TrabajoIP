program IP_Practica6;

{$mode objfpc}{$H+}

uses
  dos,SysUtils,Ugaraje,Ucoche,Uplaza,Classes;

VAR
  garaje:tGaraje;
  opcion, minutos, tamanioCoche: integer;
  numMat, distintivo: string;


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

  REPEAT
    Menu();
    readln(opcion);
    CrearGarajeVacio(garaje);
    IF (opcion <> 8) THEN BEGIN
      CASE opcion OF
           1: IF HayPlazas(garaje, tamanio) THEN BEGIN
                writeln('Introduce la matricula');
                readln(numMat);
                writeln('Introduce el distintivo');
                readln(distintivo);
                CrearCoche(coche, numMat, distintivo);
                writeln('Introduce el tamanio del coche, 0 si es pequenio y 1 si es grande');
                readln(tamanioCoche);
                Aparcar(plaza, coche, tamanioCoche);
                EntradaVehiculo(fichero);
              END
              ELSE
                  writeln('En este momento no hay plazas libres en el garaje');

           end;

           2: readln(tamanioCoche);
              readln(minutos);
             Salir(plaza, matricula, aux, aux1);
           3: MostrarGaraje(garaje);
           4: ;
           5: ;
           6: ;
           7: ;
      end;
    end;

  UNTIL (opcion = 8);
readln();
end.


