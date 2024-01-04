program IP_Practica6;

{$mode objfpc}{$H+}

uses
  dos,SysUtils,Ugaraje,Ucoche,Uplaza,Classes;

TYPE
  //RELATIVO A GARAJE
  tGaraje =  ARRAY [PisoIni..PisoFin,PlazaIni..PlazaFin] of tPlaza;
  tFichero = FILE OF tGaraje;

  //RELATIVO A PLAZA
  tPlaza = RECORD
    tamanio: boolean; //1 grande y 0 pequenia
    ocupado: boolean;
    coche: tCoche;
  END;

  tGanancias = RECORD
      gananciaTotal: real;
  END;

  //RELATIVO A COCHE
  intervalo = 1..4;
  tCoche = RECORD
    numMatricula: String[7];
    distintivo: string[20];

  END;

  fich = FILE OF tGaraje;

VAR
  garaje:tGaraje;
  opcion, minutos, tamanioCoche: integer;
  numMat: string[7];
  distintivo: string[20];
  fichero: fich;
  ficheroAntiguosUsers: Text;
  tamanio: boolean;


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

  ASSIGN(fichero, 'datos.dat');
  ASSIGN(ficheroAntiguosUsers, 'antiguos.txt');

  REPEAT
    Menu();
    readln(opcion);
    IF (opcion <> 8) THEN BEGIN
      CASE opcion OF
           1: BEGIN
              writeln('Escribe si el coche es grande(1) o pequenio(0)');
              readln(tamanioCoche);
              IF tamanioCoche = 1 THEN
                tamanio := true
              ELSE
                tamanio := false;
               //IF HayPlazas(garaje, tamanio) THEN BEGIN
                  writeln('Introduce la matricula');
                  REPEAT
                    readln(numMat);
                    ComprobarMat(numMat);
                  UNTIL ComprobarMat(numMat) = true;

                    writeln('Introduce el distintivo');
                    readln(distintivo);
                    CrearCoche(garaje, numMat, distintivo, tamanio, fichero);
                    //Aparcar(plaza, coche, tamanioCoche);


                END
                ELSE
                    writeln('En este momento no hay plazas libres en el garaje');

           end;
           {
           2: readln(tamanioCoche);
              readln(minutos);
             Salir(plaza, matricula, aux, aux1);
           3: MostrarGaraje(garaje);
           4: ;
           5: ;
           6: ;
           7: ; BEGIN
                     writeln('Escribe la matricula de tu coche');
                     readln(numMat);
                     Descuento(numMat, fichero);
                END;}
      end;
    end;

  UNTIL (opcion = 8);
readln();
end.


