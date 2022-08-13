uses crt,keyboard;

const
     marge_dalt=10;
     marge_baix=192;
     marge_esq=7;
     marge_dret=312;

type
    ipunt=RECORD r,angle:real; END;
    punt=RECORD x,y:integer; END;
    triangle=RECORD p1,p2,p3:ipunt;
                    centre:punt;
                    angle:real;
                    velocitat:real;
    END;

  procedure MCGA;
    begin
      asm
        mov  ax,0013h
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
     mem[$A000:y*320+x]:=color;
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
     x2:=round((tri.p2.r+velocitat/2)*cos(tri.p2.angle+angul+velocitat/5))+tri.centre.x;
     x3:=round((tri.p3.r+velocitat/2)*cos(tri.p3.angle+angul-velocitat/5))+tri.centre.x;
     y1:=round((tri.p1.r+velocitat/2)*sin(tri.p1.angle+angul))+tri.centre.y;
     y2:=round((tri.p2.r+velocitat/2)*sin(tri.p2.angle+angul+velocitat/5))+tri.centre.y;
     y3:=round((tri.p3.r+velocitat/2)*sin(tri.p3.angle+angul-velocitat/5))+tri.centre.y;
     linea(x1,y1,x2,y2,color);
     linea(x1,y1,x3,y3,color);
     linea(x3,y3,x2,y2,color);
end;


var nau:triangle;
    ang:real;
    ch:char;
    Dx,Dy:word;

begin
     nau.p1.r:=6;nau.p1.angle:=3*pi/2;
     nau.p2.r:=6;nau.p2.angle:=pi/4;
     nau.p3.r:=6;nau.p3.angle:=(3*pi)/4;
     nau.angle:=0;
     nau.centre.x:=160;nau.centre.y:=100;
     instalarkb;
     mcga;
     repeat
           waitretrace;
           rota_tri(nau,nau.angle,nau.velocitat,0);

           if teclapuls(KEYarrowright) then nau.angle:=nau.angle+0.157079632;
           if teclapuls(KEYarrowleft) then nau.angle:=nau.angle-0.157079632;
           if teclapuls(KEYarrowup) then begin
              if nau.velocitat<3 then nau.velocitat:=nau.velocitat+0.1;
           end;
           Dy:=round(nau.velocitat*sin(nau.angle-pi/2))+nau.centre.y;
           Dx:=round(nau.velocitat*cos(nau.angle-pi/2))+nau.centre.x;
           if (dy>marge_dalt) and (dy<marge_baix) then
                 nau.centre.y:=Dy;
           if (dx>marge_esq) and (dx<marge_dret) then
                 nau.centre.x:=Dx;
           if (nau.velocitat>0.05) then nau.velocitat:=nau.velocitat-0.05;
           rota_tri(nau,nau.angle,nau.velocitat,2);
     until teclapuls(keyesc);
     desinstalarkb;
     text;
end.