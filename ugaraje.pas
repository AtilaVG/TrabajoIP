unit Ugaraje;

{$mode ObjFPC}{$H+}

interface

uses
  dos, Uplaza, Ucoche, SysUtils;

CONST
  PisoIni= 1;
  PisoFin= 4;
  PlazaIni= 1;
  PlazaFin= 20;

TYPE
  tGaraje =  ARRAY [PisoIni..PisoFin,PlazaIni..PlazaFin] of tPlaza;
  tFichero = FILE OF tGaraje;

  PROCEDURE EntradaVehiculo(VAR fichero: tFichero);
  PROCEDURE CrearGarajeVacio(VAR garaje: tGaraje);
  PROCEDURE MostrarGaraje(garaje:tGaraje);




implementation


PROCEDURE CrearGarajeVacio(VAR garaje: tGaraje);
VAR
  aux,aux1: integer;
BEGIN
  for aux:= 1 to 4 do
      begin
      for aux1:= 1 to 20 do
          begin
               PonerPlazaVacia(garaje[aux,aux1],aux,aux1);

          end;
      end;
END;

PROCEDURE MostrarGaraje(garaje:tGaraje);
VAR
  aux,aux1: integer;
BEGIN
  for aux:= 4 downto 1 do
      begin
      writeln('planta', aux-1);
      for aux1:= 1 to 20 do
          begin
               if(garaje[aux,aux1].tamanio) then
               write('| x | ')
               else
               write('|x| ');
               if (aux1 = 20) then
               writeln;


          end;
      end;
END;

FUNCTION HayPlazas(VAR garaje: tGaraje; VAR tamanio: String): boolean; //comprobar si funciona
VAR
  aux,aux1: integer;
BEGIN
  HayPlazas := false;
  REPEAT
    aux := aux -1;
    REPEAT
      aux1 := aux1 + 1;
      IF (garaje[aux, aux1].ocupado = false) THEN
         if (tamanio = 'grande') then begin
             if (((aux-1)*20+aux1) mod 6 = 0)then //es grande
                HayPlazas := true
             else
                HayPlazas := false;
         end
         else
             if (((aux-1)*20+aux1) mod 6 <> 0)then //es pequenio
                HayPlazas := true
             else
                HayPlazas := false;

    until (aux1 = 20) OR (garaje[aux, aux1].ocupado = false);
  until (aux = 4) OR (garaje[aux, aux1].ocupado = false);

end;


PROCEDURE EntradaVehiculo(VAR fichero: tFichero; VAR garaje: tGaraje; VAR tamanio: String); //garaje y tamanio habria que pasarlo a HayPlazas()?
VAR
  tam: String;
BEGIN
  writeln('Escribe si el coche es grande o pequenio');
  readln(tam);
  HayPlazas(garaje, tamanio);

  CrearCoche(coche, numMat, distintivo);
  AsignarCoche(coche1, coche2);
END;


end.

