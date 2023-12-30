unit Ucoche;

{$mode ObjFPC}{$H+}

interface

uses
  dos,SysUtils;

type
  intervalo = 1..4;
  tCoche = RECORD
    numMatricula: String[7];
    distintivo: string[20];

  END;

 PROCEDURE AsignarCoche(VAR coche1: tCoche; VAR coche2: tCoche);
 PROCEDURE CrearCoche(VAR coche: tCoche; VAR numMat: string;VAR distintivo: string);


implementation


PROCEDURE AsignarCoche(VAR coche1: tCoche; VAR coche2: tCoche); //en vez de borrar los datos del coche antiguo, se sobreescriben con el nuevo
BEGIN
  coche1.numMatricula:= coche2.numMatricula;
  coche1.distintivo:= coche2.distintivo;
END;


PROCEDURE CrearCoche(VAR coche: tCoche; VAR numMat: string;VAR distintivo: string);

BEGIN
  coche.numMatricula:= numMat;
  coche.distintivo:= distintivo;
END;

PROCEDURE SacarCoche(VAR coche: tCoche);
VAR
  minutos: integer;

BEGIN
  writeln('Escribe cuántos minutos has tenido el coche aparcado');
  readln(minutos);




END;

end.


