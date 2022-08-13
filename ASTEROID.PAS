uses mouse,crt,keyboard;

const
     marge_dalt=20;
     marge_baix=460;
     marge_esq=20;
     marge_dret=620;
     max_ipunts=30;
     max_ornis=15;
type
    ipunt=RECORD r,angle:real; END;
    punt=RECORD x,y:integer; END;
    ivector=array [0..max_ipunts-1] of ipunt;
    triangle=RECORD p1,p2,p3:ipunt;
                    centre:punt;
                    angle:real;
                    velocitat:real;
    END;
    poligon=RECORD ipunts:^ivector;
                   ipuntx:ivector;
                   centre:punt;
                   angle:real;
                   velocitat:real;
                   n:byte;
                   drotacio,rotacio:real;
    END;


    pvirt=array [1..38400] of byte;

var virt:^pvirt;

procedure volca;
var i:word;
begin
     for i:=1 to 38400 do mem[$A000:i]:=mem[seg(virt^):i];
end;

procedure crear_poligon_regular(var pol:poligon;n:byte;r:real);
var i:word;act,interval:real;aux:ipunt;
begin
     {getmem(pol.ipunts,{n*464000);}
     interval:=2*pi/n;
     act:=0;
     for i:=0 to n-1 do begin
         aux.r:=r;
         aux.angle:=act;
         pol.ipuntx[i]:=aux;
         act:=act + interval;
     end;
     pol.centre.x:=320;
     pol.centre.y:=240;
     pol.angle:=0;
     pol.velocitat:=2;
     pol.n:=n;
     pol.drotacio:=0.078539816;
     pol.rotacio:=0;
     end;

  procedure MCGA;
    begin
      asm
        mov  ax,0012h
        int  10h
      end;
      directvideo:= false;
    end;

  procedure Text;
    begin
      asm
        mov  ax,0003h
        int  10h
      end;
    end;

  procedure WaitRetrace; assembler;
    label
      l1,l2;

    asm
      mov dx,3DAh

      l1:
        in  al,dx
        and al,08h
        jnz l1

      l2:
        in  al,dx
        and al,08h
        jz  l2
    end;


procedure posa(x,y:word;color:byte);
begin
   if color=1 then
   case (x mod 8) of
     0:mem[seg(virt^):y*80+(x div 8)]:=(mem[seg(virt^):y*80+(x div 8)]AND $7F)OR $80;
     1:mem[seg(virt^):y*80+(x div 8)]:=(mem[seg(virt^):y*80+(x div 8)]AND $BF)OR $40;
     2:mem[seg(virt^):y*80+(x div 8)]:=(mem[seg(virt^):y*80+(x div 8)]AND $DF)OR $20;
     3:mem[seg(virt^):y*80+(x div 8)]:=(mem[seg(virt^):y*80+(x div 8)]AND $EF)OR $10;
     4:mem[seg(virt^):y*80+(x div 8)]:=(mem[seg(virt^):y*80+(x div 8)]AND $F7)OR $08;
     5:mem[seg(virt^):y*80+(x div 8)]:=(mem[seg(virt^):y*80+(x div 8)]AND $FB)OR $04;
     6:mem[seg(virt^):y*80+(x div 8)]:=(mem[seg(virt^):y*80+(x div 8)]AND $FD)OR $02;
     7:mem[seg(virt^):y*80+(x div 8)]:=(mem[seg(virt^):y*80+(x div 8)]AND $FE)OR $01;
   end;
   if color=0 then
   case (x mod 8) of
     0:mem[seg(virt^):y*80+(x div 8)]:=(mem[seg(virt^):y*80+(x div 8)]AND $7F);
     1:mem[seg(virt^):y*80+(x div 8)]:=(mem[seg(virt^):y*80+(x div 8)]AND $BF);
     2:mem[seg(virt^):y*80+(x div 8)]:=(mem[seg(virt^):y*80+(x div 8)]AND $DF);
     3:mem[seg(virt^):y*80+(x div 8)]:=(mem[seg(virt^):y*80+(x div 8)]AND $EF);
     4:mem[seg(virt^):y*80+(x div 8)]:=(mem[seg(virt^):y*80+(x div 8)]AND $F7);
     5:mem[seg(virt^):y*80+(x div 8)]:=(mem[seg(virt^):y*80+(x div 8)]AND $FB);
     6:mem[seg(virt^):y*80+(x div 8)]:=(mem[seg(virt^):y*80+(x div 8)]AND $FD);
     7:mem[seg(virt^):y*80+(x div 8)]:=(mem[seg(virt^):y*80+(x div 8)]AND $FE);
   end;
end;
procedure posavga(x,y:word;color:byte);
begin
   if color=1 then
   case (x mod 8) of
     0:mem[$A000:y*80+(x div 8)]:=(mem[$A000:y*80+(x div 8)]AND $7F)OR $80;
     1:mem[$A000:y*80+(x div 8)]:=(mem[$A000:y*80+(x div 8)]AND $BF)OR $40;
     2:mem[$A000:y*80+(x div 8)]:=(mem[$A000:y*80+(x div 8)]AND $DF)OR $20;
     3:mem[$A000:y*80+(x div 8)]:=(mem[$A000:y*80+(x div 8)]AND $EF)OR $10;
     4:mem[$A000:y*80+(x div 8)]:=(mem[$A000:y*80+(x div 8)]AND $F7)OR $08;
     5:mem[$A000:y*80+(x div 8)]:=(mem[$A000:y*80+(x div 8)]AND $FB)OR $04;
     6:mem[$A000:y*80+(x div 8)]:=(mem[$A000:y*80+(x div 8)]AND $FD)OR $02;
     7:mem[$A000:y*80+(x div 8)]:=(mem[$A000:y*80+(x div 8)]AND $FE)OR $01;
   end;
   if color=0 then
   case (x mod 8) of
     0:mem[$A000:y*80+(x div 8)]:=(mem[$A000:y*80+(x div 8)]AND $7F);
     1:mem[$A000:y*80+(x div 8)]:=(mem[$A000:y*80+(x div 8)]AND $BF);
     2:mem[$A000:y*80+(x div 8)]:=(mem[$A000:y*80+(x div 8)]AND $DF);
     3:mem[$A000:y*80+(x div 8)]:=(mem[$A000:y*80+(x div 8)]AND $EF);
     4:mem[$A000:y*80+(x div 8)]:=(mem[$A000:y*80+(x div 8)]AND $F7);
     5:mem[$A000:y*80+(x div 8)]:=(mem[$A000:y*80+(x div 8)]AND $FB);
     6:mem[$A000:y*80+(x div 8)]:=(mem[$A000:y*80+(x div 8)]AND $FD);
     7:mem[$A000:y*80+(x div 8)]:=(mem[$A000:y*80+(x div 8)]AND $FE);
   end;
end;

function modul(p:punt):real;
begin
     modul:=sqrt(sqr(p.x)+sqr(p.y));
end;

procedure diferencia(o,d:punt;var p:punt);
begin
     p.x:=o.x-d.x;
     p.y:=o.y-d.y;
end;

function distancia(o,d:punt):integer;
var p:punt;
begin
     diferencia(o,d,p);
     distancia:=round(modul(p));
end;
function angle(p:punt):real;
begin
     if p.y<>0 then angle:=arctan(p.x/p.y);
end;

procedure linea(x1,y1,x2,y2,color:word);

  function sign(x:integer):integer; {like sgn(x) in basic}
  begin if x<0 then sign:=-1 else if x>0 then sign:=1 else sign:=0 end;

  var
    x,y,count,xs,ys,xm,ym:integer;
  begin
    x:=x1;y:=y1;

    xs:=x2-x1;    ys:=y2-y1;

    xm:=sign(xs); ym:=sign(ys);
    xs:=abs(xs);  ys:=abs(ys);

    posa(x,y,color);

  if xs > ys
    then begin {flat line <45 deg}
      count:=-(xs div 2);
      while (x <> x2 ) do begin
        count:=count+ys;
        x:=x+xm;
        if count>0 then begin
          y:=y+ym;
          count:=count-xs;
          end;
        posa(x,y,color);
        end;
      end
    else begin {steep line >=45 deg}
      count:=-(ys div 2);
      while (y <> y2 ) do begin
        count:=count+xs;
        y:=y+ym;
        if count>0 then begin
          x:=x+xm;
          count:=count-ys;
          end;
        posa(x,y,color);
        end;
      end;
end;

procedure rota_tri(tri:triangle;angul,velocitat:real;color:byte);
var x1,x2,x3,y1,y2,y3:word;
begin
     x1:=round((tri.p1.r+velocitat/2)*cos(tri.p1.angle+angul))+tri.centre.x;
     x2:=round((tri.p2.r+velocitat/2)*cos(tri.p2.angle+angul+velocitat/10))+tri.centre.x;
     x3:=round((tri.p3.r+velocitat/2)*cos(tri.p3.angle+angul-velocitat/10))+tri.centre.x;
     y1:=round((tri.p1.r+velocitat/2)*sin(tri.p1.angle+angul))+tri.centre.y;
     y2:=round((tri.p2.r+velocitat/2)*sin(tri.p2.angle+angul+velocitat/10))+tri.centre.y;
     y3:=round((tri.p3.r+velocitat/2)*sin(tri.p3.angle+angul-velocitat/10))+tri.centre.y;
     linea(x1,y1,x2,y2,color);
     linea(x1,y1,x3,y3,color);
     linea(x3,y3,x2,y2,color);
end;

procedure rota_pol(pol:poligon;angul:real;color:byte);
var xy:array [0..max_ipunts] of punt;i:byte;
begin
   for i:=0 to pol.n-1 do begin
     xy[i].x:=round((pol.ipuntx[i].r)*cos(pol.ipuntx[i].angle+angul))+pol.centre.x;
     xy[i].y:=round((pol.ipuntx[i].r)*sin(pol.ipuntx[i].angle+angul))+pol.centre.y;
   end;
   for i:=0 to pol.n-2 do
     linea(xy[i].x,xy[i].y,xy[i+1].x,xy[i+1].y,color);
   linea(xy[pol.n-1].x,xy[pol.n-1].y,xy[0].x,xy[0].y,color);
end;

procedure mou_orni(var orni:poligon);
var dx,dy:real;
begin
     orni.angle:=orni.angle{+(random(256)/512)*(random(3)-1)};
     Dy:=round(orni.velocitat*sin(orni.angle-pi/2))+orni.centre.y;
     Dx:=round(orni.velocitat*cos(orni.angle-pi/2))+orni.centre.x;
     if (dy>marge_dalt) and (dy<marge_baix) then
        orni.centre.y:=round(Dy)
     else orni.angle:=orni.angle+(random(256)/512)*(random(3)-1);

     if (dx>marge_esq) and (dx<marge_dret) then
        orni.centre.x:=round(Dx)
     else orni.angle:=orni.angle+(random(256)/512)*(random(3)-1);
     orni.rotacio:=orni.rotacio+orni.drotacio;
end;

procedure clsvirt;
var i:word;
begin
     for i:=1 to 38400 do mem[seg(virt^):i]:=0;
end;

var nau:triangle;pol:poligon;
    ang:real;
    ch:char;
    Dx,Dy:word;
    i:byte;
    dist:integer;
    puntaux:punt;
    orni:array [1..max_ornis] of poligon;

begin
     randomize;
     getmem(virt,38400);
     clsvirt;
     nau.p1.r:=12;nau.p1.angle:=3*pi/2;
     nau.p2.r:=12;nau.p2.angle:=pi/4;
     nau.p3.r:=12;nau.p3.angle:=(3*pi)/4;
     nau.angle:=0;
     nau.centre.x:=320;nau.centre.y:=240;
     crear_poligon_regular(pol,10,200);
     for i:=1 to max_ornis do crear_poligon_regular(orni[i],5,20);
     mcga;
     initMouse;
     rota_pol(pol,0,1);
     instalarkb;
     repeat
     hideMouseCursor;
     showMouseCursor;
{           rota_tri(nau,nau.angle,nau.velocitat,0);}
            clsvirt;

           if teclapuls(KEYarrowright) then nau.angle:=nau.angle+0.157079632;
           if teclapuls(KEYarrowleft) then nau.angle:=nau.angle-0.157079632;
           if teclapuls(KEYarrowup) then begin
              if nau.velocitat<6 then nau.velocitat:=nau.velocitat+0.2;
           end;
           Dy:=round(nau.velocitat*sin(nau.angle-pi/2))+nau.centre.y;
           Dx:=round(nau.velocitat*cos(nau.angle-pi/2))+nau.centre.x;
           if (dy>marge_dalt) and (dy<marge_baix) then
                 nau.centre.y:=Dy;
           if (dx>marge_esq) and (dx<marge_dret) then
                 nau.centre.x:=Dx;
           if (nau.velocitat>0.1) then nau.velocitat:=nau.velocitat-0.1;
{           dist:=distancia(nau.centre,pol.centre);
           diferencia(pol.centre,nau.centre,puntaux);
           if dist<(pol.ipuntx[1].r+30) then begin
              nau.centre.x:=nau.centre.x
                 +round(dist*cos(angle(puntaux)+0.031415));
              nau.centre.y:=nau.centre.y
                 +round(dist*sin(angle(puntaux)+0.031415));
           end;}
           rota_tri(nau,nau.angle,nau.velocitat,1);
{           for i:=1 to 5 do begin
               rota_pol(orni[i],ang,0);
           end;}
           for i:=1 to max_ornis do begin
               mou_orni(orni[i]);
               rota_pol(orni[i],orni[i].rotacio,1);
           end;
           waitretrace;
           volca;
           gotoxy(50,24);
           write('¸ Visente i Sergi');
           gotoxy(50,25);
           write('áETA 1.0 1/6/99');
     until teclapuls(keyesc);
     desinstalarkb;
     ang:=0;
     repeat waitretrace;rota_pol(pol,ang,0); ang:=ang+0.031415 ;rota_pol(pol,ang,1);until keypressed;
     text;
end.