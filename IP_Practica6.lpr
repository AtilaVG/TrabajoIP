program IP_Practica6;

{$mode objfpc}{$H+}

uses
  dos,SysUtils,Ugaraje,Ucoche,Uplaza,Classes;

VAR
  garaje:tGaraje;
  opcion: integer;

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
           1: EntradaVehiculo(fichero);
           2: Salir(plaza, matricula, aux, aux1);
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


