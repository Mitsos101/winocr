(*  GSA-Win-OCR.dpr
    Copyright (C) 2015 Sven Bansemer/GSA

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this library.  If not, see <http://www.gnu.org/licenses/>.
*)

{$APPTYPE CONSOLE}
uses windows, sysutils;

var dojob_ext:function(input:pchar; certainty:integer; Output:pchar; Charset:pchar):integer; cdecl;
    ocrad_dojob:function(input:pchar; Output:pchar):integer; cdecl;

function get_ocrad(const filename:string):string;
var p:pchar;
begin
  getmem(p,102);
  ocrad_dojob(pchar(filename),p);
  result:=p; result:=trim(result);
  FreeMem(p,102);
end;

function get_gocr(const filename:string;charset:string):string;
var p:pchar;
    f1:integer;
begin
  getmem(p,102);
  f1:=DoJob_ext(pchar(filename),0,p,pchar(charset));
  if f1>=1 then begin
    result:=p; result:=trim(result);
  end else result:='';
  FreeMem(p,102);
end;

var dll_gsa:thandle;

begin
  writeln('GSA-Win-OCR v1.00 (C) 2015 GSA ');
  writeln('');
  writeln('This tool and the DLL''s are licensed under GNU General Public License.');
  writeln('It uses GOCR and OCRAD (both GPL licensed) to extract text from images');
  writeln('in ppm format.');
  writeln('');

  if (paramcount=0) or (not fileexists(paramstr(1))) then begin
    writeln('usage: '+paramstr(0)+' [image.ppm]');
    exit;
  end;

  dll_gsa:=Windows.LoadLibrary('gocr.dll');
  if dll_gsa<>0 then begin
    dojob_ext:=GetProcAddress(dll_gsa, 'DoJob_ext');
    writeln('GOCR: '+get_gocr(paramstr(1),'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+-*?='));
    windows.FreeLibrary(dll_gsa);
  end else begin
    writeln('Error loading DLL: gocr.dll');
  end;

  dll_gsa:=Windows.LoadLibrary('ocrad.dll');
  if dll_gsa<>0 then begin
    ocrad_dojob:=GetProcAddress(dll_gsa, '_Z5DoJobPcS_');
    writeln('OCRAD: '+get_ocrad(paramstr(1)));
    windows.FreeLibrary(dll_gsa);
  end else begin
    writeln('Error loading DLL: ocrad.dll');
  end;

end.