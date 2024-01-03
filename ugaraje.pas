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
  PROCEDURE PorcentajeOcupacion(garaje:tGaraje);
  PROCEDURE Distintivo(VAR coche: tCoche, VAR distintivo: string);




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
               if(garaje[aux,aux1].tamanio) then begin
               if (garaje[aux, aux1].ocupado) then
                  write('| x | ')
               else
                  write('|   |');

               end
               else
               if (garaje[aux, aux1].ocupado) then
                  write('|x| ')
               else
                  write('| |');
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

END;


PROCEDURE PorcentajeOcupacion(garaje:tGaraje);
VAR
  aux,aux1, cont, cont2: integer; //cont1 numerador, cont2 denominador
  porcentaje: real;
BEGIN
  cont, cont2 := 0;
  for aux:= 4 downto 1 do
      begin

      for aux1:= 1 to 20 do
          begin

               if (garaje[aux, aux1].ocupado) then begin
                  cont := cont + 1;
               end

          end;
      end;
  porcentaje := cont1 / 80;
END;


PROCEDURE BuscarPlaza(garaje: tGaraje);
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
                Aparcar(plaza, coche, tamanio, aux, aux1);
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



PROCEDURE Distintivo(VAR garaje:tGaraje, VAR distintivo: string);
VAR
  aux,aux1,contador: integer;
begin
  contador:= 0;
   for aux:= 1 to 4 do
      begin
      for aux1:= 1 to 20 do
          begin
               if(garaje[aux,aux1].coche.distintivo = distintivo) then
                  contador:= contador + 1;



          end;
      end;
   if contador = 0 then
      writeln('No existen coches con ese distintivo')
   else
      writeln('Hay ', contador, 'coches con ese distintivo');

end;


end.

