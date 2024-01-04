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
  //RELATIVO A GARAJE
  tGaraje =  ARRAY [PisoIni..PisoFin,PlazaIni..PlazaFin] of tPlaza;
  tFichero = FILE OF tGaraje;


  //RELATIVOS A PLAZA
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

  //RELATIVO A GARAJE
  PROCEDURE MostrarGaraje(garaje:tGaraje);
  PROCEDURE PorcentajeOcupacion(garaje:tGaraje);
  //PROCEDURE Distintivo(VAR coche: tCoche; VAR distintivo: string);

  //RELATIVO A PLAZA
  PROCEDURE PonerPlazaVacia(VAR plaza:tPlaza; aux: integer; aux1: integer);
  PROCEDURE Salir(VAR plaza:tPlaza; VAR matricula: String; aux: integer; aux1: integer; VAR tGanancias: tGanancias);

  //RELATIVO A COCHE
  PROCEDURE AsignarCoche(VAR coche1: tCoche; VAR coche2: tCoche);
  PROCEDURE CrearCoche(VAR garaje: tGaraje; VAR numMat: string;VAR distintivo: string; tamanio: boolean; VAR fichero: fich);
  FUNCTION ComprobarMat(numMat: string): boolean;

VAR
    ficheroAntiguosUsers: Text;

implementation

 {
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
END; }

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

  HayPlazas(garaje, tamanio);

END;


PROCEDURE PorcentajeOcupacion(garaje:tGaraje);
VAR
  aux,aux1, cont, cont2: integer; //cont1 numerador, cont2 denominador
  porcentaje: real;
BEGIN
  cont:= 0;
  cont2 := 0;
  for aux:= 4 downto 1 do
      begin

      for aux1:= 1 to 20 do
          begin

               if (garaje[aux, aux1].ocupado) then begin
                  cont := cont + 1;
               end

          end;
      end;
  porcentaje := (cont / 80);
END;




PROCEDURE Distintivo(VAR garaje:tGaraje; VAR distintivo: string);
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

// EMPEZAMOS PROCEDURES DE PLAZA

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


PROCEDURE Salir(VAR plaza:tPlaza; VAR matricula: String; aux: integer; aux1: integer; VAR tGanancias: tGanancias); //ojo con si es grande o pequenia que es diferente precio
VAR
  opcion: String;
  minutos, precioEstacionar: real;
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
        precioEstacionar := (0.02 * minutos)
     ELSE
        precioEstacionar := (0.06 * minutos);
  END

  ELSE //la opcion es 'pequenia'
  IF (minutos > 60) THEN
     precioEstacionar := 0.01 * minutos
  ELSE
      precioEstacionar := 0.04 * minutos;

  tGanancias.gananciaTotal := tGanancias.gananciaTotal + precioEstacionar;

END;

//EMPEZAMOS CON COCHE


PROCEDURE AsignarCoche(VAR coche1: tCoche; VAR coche2: tCoche); //en vez de borrar los datos del coche antiguo, se sobreescriben con el nuevo
BEGIN
  coche1.numMatricula:= coche2.numMatricula;
  coche1.distintivo:= coche2.distintivo;
END;


PROCEDURE CrearCoche(VAR garaje: tGaraje; VAR numMat: string;VAR distintivo: string; tamanio: boolean; VAR fichero: fich);
VAR
   aux, aux1: integer;

BEGIN


   {$I-}
   RESET(fichero);
   {$I+}
   if (IOResult = 0) then begin

   FOR aux := 4 DOWNTO 1 DO
       FOR aux1 := 1 TO 20 DO
           IF tamanio THEN BEGIN

             IF (garaje[aux, aux1].tamanio) THEN BEGIN
               IF (garaje[aux, aux1].ocupado = false) THEN BEGIN
                  garaje[aux, aux1].coche.numMatricula:= numMat;
                  garaje[aux, aux1].coche.distintivo:= distintivo;
                  garaje[aux, aux1].tamanio:= tamanio;
                  garaje[aux, aux1].ocupado:= true;

               END;
             END;
           END
           ELSE
               IF (garaje[aux, aux1].tamanio = false) THEN BEGIN
                 IF (garaje[aux, aux1].ocupado = false) THEN BEGIN
                    garaje[aux, aux1].coche.numMatricula:= numMat;
                    garaje[aux, aux1].coche.distintivo:= distintivo;
                    garaje[aux, aux1].tamanio:= tamanio;
                    garaje[aux, aux1].ocupado:= true;
                 END;
               END;

    write(fichero, garaje);
    end
   else
       REWRITE(fichero);

   close(fichero);
END;


FUNCTION ComprobarMat(numMat: string): boolean;
VAR
   caracter: char;
   aux: integer;
BEGIN
  ComprobarMat := true;

  IF length(numMat) <> 7 THEN
     ComprobarMat := false
  ELSE BEGIN
    FOR aux:= 1 TO 4 DO BEGIN
        caracter := numMat[aux];
        IF NOT (caracter IN ['0'..'9']) THEN
           ComprobarMat := false
       END;
    FOR aux:= 5 TO 7 DO BEGIN
        caracter := numMat[aux];
        IF NOT (caracter IN ['A'..'Z', 'a'..'z']) THEN
           ComprobarMat := false;
   END;
    IF ComprobarMat = false THEN
       writeln('Escriba un formato correcto de matricula');

END;

PROCEDURE Descuento(VAR numMat: string; VAR ficheroAntiguosUsers: Text);
VAR
   aux: string[7];
BEGIN
  {$I-}
   RESET(ficheroAntiguosUsers);
  {$I+}
   IF (IOResult = 0) THEN BEGIN
    WHILE NOT EOF DO
          readln(ficheroAntiguosUsuarios, aux);
          IF aux = numMat THEN
               writeln('ENHORABUENA! Eres VIP. Tienes un descuento del 20%');
          //hacemos salir pero con el 20%




END;


{
PROCEDURE SacarCoche(VAR coche: tCoche);
VAR
  minutos: integer;

BEGIN
  writeln('Escribe cuántos minutos has tenido el coche aparcado');
  readln(minutos);




END; }
end;
end.

