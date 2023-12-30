unit Uplaza;

{$mode ObjFPC}{$H+}

interface

uses
  dos, Ucoche, SysUtils;

TYPE
  tPlaza = RECORD
    tamanio: boolean; //1 grande y 0 pequenia
    ocupado: boolean;
    coche: tCoche;
  END;

  tGanancias = RECORD
      gananciaTotal: integer;
  END;

  PROCEDURE PonerPlazaVacia(VAR plaza:tPlaza; aux: integer; aux1: integer);
  PROCEDURE Aparcar(VAR plaza:tPlaza; VAR coche: tCoche);
  PROCEDURE Salir(VAR plaza:tPlaza; VAR matricula: String; aux: integer; aux1: integer);


implementation
PROCEDURE PonerPlazaVacia(VAR plaza:tPlaza; aux: integer; aux1: integer);
BEGIN
  plaza.ocupado:= false;

  if (((aux-1)*20+aux1) mod 6 = 0) then
     begin
       plaza.tamanio:= true;
     end
  else
      plaza.tamanio:= false;
END;

PROCEDURE Aparcar(VAR plaza:tPlaza; VAR coche: tCoche);
BEGIN
  plaza.ocupado:= true;
  AsignarCoche(plaza.coche,coche);
END;


PROCEDURE Salir(VAR plaza:tPlaza; VAR matricula: String; aux: integer; aux1: integer; VAR ganancias: tGanancias); //ojo con si es grande o pequenia que es diferente precio
VAR
  opcion: String;
  minutos, precioEstacionar: integer;
BEGIN
  precioEstacionar := 0;

  for aux:= 1 to 4 do
      begin
      for aux1:= 1 to 20 do
          begin
               if (plaza.coche.numMatricula = matricula)then
                  plaza.ocupado := false;

          end;
      end;
  writeln('Escribe si tu coche es grande o pequenio');
  readln(opcion);
  writeln('Escribe el tiempo que has estado en minutos');
  readln(minutos);

  IF (opcion = 'grande') THEN BEGIN
     IF (minutos > 60) THEN
        precioEstacionar := 0,02 * minutos
     ELSE
        precioEstacionar := 0,06 * minutos;
  END

  ELSE //la opcion es 'pequenia'
  IF (minutos > 60) THEN
     precioEstacionar := 0,01 * minutos
  ELSE
      precioEstacionar := 0,04 * minutos;

  ganancias := ganancias + precioEstacionar;

END;

END.


