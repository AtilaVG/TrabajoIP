unit Ugaraje;

{$mode ObjFPC}{$H+}

interface

uses
  dos, SysUtils;

CONST
  PisoIni= 1;
  PisoFin= 4;
  PlazaIni= 1;
  PlazaFin= 20;

TYPE

//RELATIVO A COCHE
  intervalo = 1..4;
  tCoche = RECORD
    numMatricula: String[7];
    distintivo: string[20];

  END;

  //RELATIVOS A PLAZA
  tPlaza = RECORD
    tamanio: boolean; //1 grande y 0 pequenia
    ocupado: boolean;
    coche: tCoche;
  END;

  //RELATIVO A GARAJE
  tGaraje =  ARRAY [PisoIni..PisoFin,PlazaIni..PlazaFin] of tPlaza;
  tFichero = FILE OF tGaraje;




  tGanancias = RECORD
      gananciaTotal: real;
  END;



  fich = FILE OF tGaraje;

  //RELATIVO A GARAJE
  PROCEDURE MostrarGaraje(garaje:tGaraje; VAR fichero: fich);
  PROCEDURE PorcentajeOcupacion(garaje:tGaraje; VAR fichero: fich);
  PROCEDURE Pepe(VAR garaje: tGaraje; VAR distintivo: AnsiString; VAR fichero: fich);
  PROCEDURE Descuento(VAR numMat: string; VAR minutos: integer; VAR tamanio: boolean; VAR ficheroAntiguosUsers: Text; VAR fichero: fich; VAR ganancia: tGanancias);
  PROCEDURE InicializarGaraje(VAR garaje: tGaraje; VAR fichero: fich);
  PROCEDURE Ganancias(VAR ganancia: tGanancias; VAR precio: real; comprobar: boolean);
  PROCEDURE BuscarPlaza(VAR garaje: tGaraje; VAR numMat: string; VAR distintivo: string; VAR tamanio: boolean; VAR fichero: fich);

  //RELATIVO A PLAZA
  PROCEDURE PonerPlazaVacia(VAR plaza:tPlaza; aux: integer; aux1: integer);
  PROCEDURE Salir(VAR numMat: string; VAR minutos: integer; VAR tamanio: boolean; VAR fichero: fich; VAR ganancia: tGanancias);
  FUNCTION HayPlazas(VAR garaje: tGaraje; VAR tamanio: boolean; VAR fichero: fich): boolean;


  //RELATIVO A COCHE
  PROCEDURE AsignarCoche(VAR coche1: tCoche; VAR coche2: tCoche);
  PROCEDURE CrearCoche(VAR garaje: tGaraje; VAR numMat: string;VAR distintivo: string; tamanio: boolean; VAR fichero: fich; aux: integer; aux1: integer);
  FUNCTION ComprobarMat(numMat: string): boolean;


VAR
    ficheroAntiguosUsers: Text;

implementation

PROCEDURE InicializarGaraje(VAR garaje: tGaraje; VAR fichero: fich);
VAR
  aux,aux1: integer;
BEGIN
  {$I-}
  RESET(fichero);
  {$I+}
  IF IORESULT = 0 THEN BEGIN
     WHILE NOT EOF(fichero) DO  BEGIN
           read(fichero, garaje);
           FOR aux := 1 TO 4 DO BEGIN
             FOR aux1 := 1 TO 20 DO BEGIN
                 IF garaje[aux, aux1].ocupado THEN
                      garaje[aux,aux1].ocupado := true

                 ELSE
                     garaje[aux,aux1].ocupado := false;
             END;

           END;
     END;


  for aux:= 1 to 4 do
      begin
      for aux1:= 1 to 20 do
          begin
               PonerPlazaVacia(garaje[aux,aux1],aux,aux1);

          end;
      end;

  end
  else
      REWRITE(fichero);
  write(fichero,garaje);
  close(fichero);

END;




PROCEDURE MostrarGaraje(garaje:tGaraje; VAR fichero: fich);
VAR
  aux,aux1: integer;
BEGIN
  {$I-}
  RESET(fichero);
  {$I+}
  IF IORESULT = 0 THEN BEGIN
     SEEK(fichero, 0);
     WHILE NOT EOF(fichero) DO
        read(fichero, garaje);
        for aux:= 4 downto 1 do
            begin
            writeln('planta', aux-1);
            for aux1:= 1 to 20 do
                begin
                     if(garaje[aux,aux1].tamanio) then begin
                     if (garaje[aux,aux1].ocupado) then
                        write('| X |')
                     else
                        write('|   |');
                     end
                     else begin
                        if (garaje[aux,aux1].ocupado) then
                          write('|x|')
                       else
                          write('| |');
                     end;
                     if (aux1 = 20) then
                     writeln;


                end;
            end;

        END
     ELSE
         REWRITE(fichero);
     close(fichero);

END;

FUNCTION HayPlazas(VAR garaje: tGaraje; VAR tamanio: boolean; VAR fichero: fich): boolean; //comprobar si funciona
VAR
  aux,aux1: integer;
  found: boolean;
BEGIN
  found:= false;
  aux := 0;
  aux1 := 1;

  HayPlazas := true;

  {$I-}
        RESET(fichero);
  {$I+}
  IF IORESULT = 0 THEN BEGIN

  SEEK(fichero, 0);
  WHILE (NOT EOF(fichero)) DO
       read(fichero, garaje);
  REPEAT

    REPEAT


      IF (garaje[aux, aux1].ocupado <> true) THEN  BEGIN
         if (tamanio) then begin
             if (((aux-1)*20+aux1) mod 6 = 0)then begin //es grande
                HayPlazas := true;
                found:= true;
             end
             else
                HayPlazas := false;
         end
         else BEGIN
             if (((aux-1)*20+aux1) mod 6 <> 0)then begin //es pequenio
                HayPlazas := true ;
                found:= true;
             end
             else BEGIN
                HayPlazas := false;
             END;

         end;

      end;
      aux1 := aux1 + 1;
    until (aux1 = 20) OR (found);
    aux := aux +1;
  until (aux = 1) OR (found);

end
  else
      rewrite(fichero);
  close(fichero);
end;


PROCEDURE BuscarPlaza(VAR garaje: tGaraje; VAR numMat: string; VAR distintivo: string; VAR tamanio: boolean; VAR fichero: fich);
VAR
  aux, aux1: integer;
  found: boolean;
BEGIN
  found := false;
  aux := 1;
  aux1 := 1;

  {$I-}
  RESET(fichero);
  {$I+}
  IF IORESULT <> 0 THEN
     rewrite(fichero);

    SEEK(fichero, 0);
    WHILE (NOT EOF(fichero)) DO
      read(fichero, garaje);
    REPEAT
      REPEAT
        IF (garaje[aux, aux1].ocupado <> true) THEN BEGIN
          if (tamanio) then begin
            if (((aux-1)*20+aux1) mod 6 = 0)then begin //es grande
              CrearCoche(garaje, numMat, distintivo, tamanio, fichero,  aux, aux1);
              found:= true;
            end
            else
              begin
                // Handle the case where the parking space doesn't match the criteria
              end;
          end
          else BEGIN
            if (((aux-1)*20+aux1) mod 6 <> 0)then begin //es pequeño
              CrearCoche(garaje, numMat, distintivo, tamanio, fichero,  aux, aux1);
              found:= true;
            end
            else BEGIN
              // Handle the case where the parking space doesn't match the criteria
            END;
          end;
        end;
        aux1 := aux1 + 1;
      until (aux1 = 20) OR (found);
      aux := aux + 1;
    until (aux = 4) OR (found);

  // Close the file before leaving the procedure
  close(fichero);
END;




PROCEDURE PorcentajeOcupacion(garaje:tGaraje; VAR fichero: fich);
VAR
  aux,aux1, cont, cont2: integer; //cont1 numerador, cont2 denominador
  porcentaje: real;
BEGIN
  {$I-}
        RESET(fichero);
  {$I+}
  IF IORESULT = 0 THEN BEGIN

  SEEK(fichero, 0);
  WHILE (NOT EOF(fichero)) DO
        read(fichero, garaje);

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
  porcentaje := (cont / 80) * 100;
  writeln('Porcentaje de ocupacion: ',porcentaje:0:2, '%');
  END
  ELSE
      REWRITE(fichero);
  close(fichero);

END;




PROCEDURE Pepe(VAR garaje:tGaraje; VAR distintivo: string; VAR fichero: fich);
VAR
  aux,aux1,contador: integer;
begin
  {$I-}
        RESET(fichero);
  {$I+}
  IF IORESULT = 0 THEN BEGIN

  SEEK(fichero, 0);
  WHILE (NOT EOF(fichero)) DO
        read(fichero, garaje);

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
      writeln('Hay ', contador, ' coches con ese distintivo');

  END
  ELSE
      REWRITE(fichero);
  close(fichero);

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


PROCEDURE Salir(VAR numMat: string; VAR minutos: integer; VAR tamanio: boolean; VAR fichero: fich; VAR ganancia: tGanancias); //ojo con si es grande o pequenia que es diferente precio
VAR
   aux,aux1: integer;
   precioTotal: real;
   i, j, aleatorio: integer;
   fich: Text;
   aleatorioStr, date: string;
   hour,mins,secs,secs100 : word;
   year,month,day,week : word;
   garaje: tGaraje;
   comprobar: boolean;

BEGIN

  comprobar := false;

  aleatorio := random(10000) + 1;
  aleatorioStr := IntToStr(aleatorio);

  {$I-}
        RESET(fichero);
  {$I+}
  IF IORESULT = 0 THEN BEGIN
  WHILE (NOT EOF(fichero)) DO
        read(fichero, garaje);
 FOR aux:= 1 to 4 do begin
     FOR aux1:= 1 to 20 do begin
         IF (garaje[aux,aux1].coche.numMatricula = numMat) THEN BEGIN
            PonerPlazaVacia(garaje[aux,aux1],aux,aux1);
            write(fichero,garaje);

            IF (minutos > 60) THEN BEGIN

               IF tamanio THEN
                  precioTotal := 0.02 * minutos
               ELSE
                   precioTotal := 0.01 * minutos;

            END
         ELSE BEGIN
             IF tamanio THEN
                precioTotal := 0.04 * minutos
             ELSE
                 precioTotal := 0.06 * minutos;
         END;

         END;
    END;
 END;


      Ganancias(ganancia, precioTotal, comprobar);


      FOR i := 4 DOWNTO 1 DO BEGIN
         FOR j := 1 TO 20 DO BEGIN
             IF tamanio THEN BEGIN
               IF (garaje[i, j].tamanio) THEN BEGIN
                 IF (garaje[i, j].coche.numMatricula = numMat) THEN BEGIN
                    (garaje[i, j].ocupado) := false;
                 END;
               END;
             END;
          END;
      END;
    END;

  close(fichero);

    aleatorioStr := numMat + '-' + aleatorioStr + '.txt';
    ASSIGN(fich, aleatorioStr);

   {$I-}
        REWRITE(fich);
   {$I+}
      GetDate(year,month,day,week);
      GetTime(hour,mins,secs,secs100);
      date:= IntToStr(day) + '-' + IntToStr(month) + '-' + IntToStr(year) + '-' + IntToStr(hour) + '-' + IntToStr(mins);
      writeln(fich, date);
      writeln(fich, numMat);
      writeln(fich, minutos);
      writeln(fich, precioTotal:0:2);
      close(fich);


END;


PROCEDURE Ganancias(VAR ganancia: tGanancias; VAR precio: real; comprobar: boolean);

BEGIN
    IF comprobar THEN
       writeln('Las ganancias de todos los coches son ', ganancia.gananciaTotal:0:2, ' euros')
    ELSE
        ganancia.gananciaTotal := ganancia.gananciaTotal + precio;


END;

//EMPEZAMOS CON COCHE


PROCEDURE AsignarCoche(VAR coche1: tCoche; VAR coche2: tCoche); //en vez de borrar los datos del coche antiguo, se sobreescriben con el nuevo
BEGIN
  coche1.numMatricula:= coche2.numMatricula;
  coche1.distintivo:= coche2.distintivo;
END;


PROCEDURE CrearCoche(VAR garaje: tGaraje; VAR numMat: string;VAR distintivo: string; tamanio: boolean; VAR fichero: fich; aux: integer; aux1: integer);

BEGIN


   if (IORESULT = 0) then begin

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
   END

   else
       REWRITE(fichero);

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
END;

PROCEDURE Descuento(VAR numMat: string; VAR minutos: integer; VAR tamanio: boolean; VAR ficheroAntiguosUsers: Text; VAR fichero: fich; VAR ganancia: tGanancias);
VAR
   aux: string[7];
   precioTotal: real;
   i, j, aleatorio: integer;
   fich: Text;
   aleatorioStr, date: string;
   hour,mins,secs,secs100 : word;
   year,month,day,week : word;
   garaje: tGaraje;

BEGIN
  aux := '';
  aleatorio := random(10000) + 1;
  aleatorioStr := IntToStr(aleatorio);

  {$I-}
   RESET(ficheroAntiguosUsers);
  {$I+}
   IF (IOResult = 0) THEN BEGIN
    WHILE (NOT EOF(ficheroAntiguosUsers)) DO BEGIN
          read(ficheroAntiguosUsers, aux);
          IF aux = numMat THEN BEGIN
               PonerPlazaVacia(garaje[aux,aux1],aux,aux1);
               write(fichero,garaje);
               writeln('ENHORABUENA! Eres VIP. Tienes un descuento del 20%');
               IF tamanio THEN
                  precioTotal := 0.02 * minutos
               ELSE
                  precioTotal := 0.01 * minutos;
               break;
          END
          ELSE
          BEGIN
               Salir(numMat, minutos, tamanio, fichero, ganancia);
               break;
          END;

    END;
    close(ficheroAntiguosUsers);

   {$I-}
        RESET(fichero);
   {$I+}
   IF (IOResult = 0) THEN BEGIN
      read(fichero, garaje);

      FOR i := 4 DOWNTO 1 DO BEGIN
         FOR j := 1 TO 20 DO BEGIN
             IF tamanio THEN BEGIN
               IF (garaje[i, j].tamanio) THEN BEGIN
                 IF (garaje[i, j].coche.numMatricula = numMat) THEN BEGIN
                    (garaje[i, j].ocupado) := false;
                 END;
               END;
             END;
          END;
      END;
    END;

    aleatorioStr := numMat + '-' + aleatorioStr + '.txt';
    ASSIGN(fich, aleatorioStr);

   {$I-}
        REWRITE(fich);
   {$I+}
      GetDate(year,month,day,week);
      GetTime(hour,mins,secs,secs100);
      date:= IntToStr(day) + '-' + IntToStr(month) + '-' + IntToStr(year) + '-' + IntToStr(hour) + '-' + IntToStr(mins);
      writeln(fich, date);
      writeln(fich, numMat);
      writeln(fich, minutos);
      writeln(fich, precioTotal:0:2);
      close(fich);

   END
   ELSE
       REWRITE(ficheroAntiguosUsers);



END;


{
PROCEDURE SacarCoche(VAR coche: tCoche);
VAR
  minutos: integer;

BEGIN
  writeln('Escribe cuántos minutos has tenido el coche aparcado');
  readln(minutos);




END; }
end.

