/* 
    Para mostrar recorridos en espacios de búsqueda
    
    Búsqeuda en Amplitud
*/

import java.util.Queue;
import java.util.ArrayDeque;

int Radio = 9;
boolean MostrarId = false;
boolean Buscando = false;
boolean Avanzar = false;

int Divisiones=40;
int TamMin;

int AnchoPincel = 2;
int SizeId = 12;

color ColorFondo = 240;

// Para la edición inicial
color ColorNodoNormal = #8080FF;
color ColorNodoTocado = #0000FF;
color ColorNodoMarcado = #80FF80;
color ColorNodoMarcadoTocado = #00FF00;
color ColorNodoVecino = #FF8000;

// Para el recorrido
color ColorNoVisitado = #0000FF;
color ColorPendiente = #00FF00;
color ColorVisitado = #FFFF00;
color ColorCamino = #F000F0;

color ColorAristaNormal = 150;
color COlorAristaAdyacente = 50;

int NodosMarcados = 0;
boolean MoviendoNodo = false;
boolean MarcandoNodos = false;

Nodo NodoEnMovimiento;
Nodo NodoMarcado1, NodoMarcado2;
Nodo Raiz;

int CuantosNodosHay = 0;

ArrayList<Nodo> Nodos = new ArrayList();

Queue<Nodo> Cola = new ArrayDeque();

void setup()
{
    size(displayWidth, displayHeight);
    TamMin = (displayWidth-2*Radio)/Divisiones;
    if ( TamMin<Radio )
        TamMin = Radio;
    println("TamMin = "+str(TamMin));
    
    Raiz = MkTree(0, width, 0, null);
}

void draw()
{
    background(ColorFondo);
    cursor(CROSS);
    strokeWeight(AnchoPincel);
  
    for (Nodo n : Nodos) 
        n.DibujarAristas();
  
    if ( !Buscando ) {
        for (Nodo n : Nodos) {
            if ( MostrarId || n.SeMuestraOrden )
                n.MostrarOrden();
            if ( n.mouseIn()==true ) {
                n.Color = n.Marcado ? ColorNodoMarcadoTocado : ColorNodoTocado;
                n.MostrarId();
            } else
                n.Color = n.Marcado ? ColorNodoMarcado : ColorNodoNormal;
            if ( n.Vecino == true )
                n.Color = ColorNodoVecino;
        }

        // Aquí inicia el algoritmo de búsqueda en amplitud
        if ( NodosMarcados > 0  &&  key == ' ' ) {
            Buscando = true;
            for (Nodo n : Nodos) {
                n.Color = ColorNoVisitado;
                n.Marcado = n.Vecino = false;
            }
            Cola.add(NodoMarcado1);
            if ( NodosMarcados == 2 )
                NodoMarcado2.Color = ColorNodoMarcado;
        }
    } else if ( Buscando ) {
        // Iteraciones de la búsqueda en amplitud
        Nodo u;
        if ( !Cola.isEmpty() ) {
            u = Cola.poll();
            for ( Nodo v : u.aristas ) {
                if ( NodosMarcados == 2  &&  v == NodoMarcado2 ) {
                    v.padre = u;
                    ObjetivoEncontrado();
                }
                if ( v.Color  == ColorNoVisitado ) {
                    v.Color = ColorPendiente;
                    v.padre = u;
                    Cola.add(v);
                }
            }
            u.Color = ColorVisitado;
            noLoop();
        }
    }
    for (Nodo n : Nodos) {
        if ( n.SeMuestraOrden )
            n.MostrarOrden();
        n.Dibujar();
    } //<>//
}

void ObjetivoEncontrado()
{
    Nodo p = NodoMarcado2;
    fill(ColorCamino);
    textSize(30);
    text("¡Nodo objetivo encontrado!", 250, height-50);
    noStroke();
    circle(NodoMarcado2.x, NodoMarcado2.y, Radio+5);
    print("p="+p.Id);
    while ( p.padre != null ) {
        fill(ColorCamino);
        circle(p.x, p.y, Radio+5);
        p.MostrarId();
        print(" -> "+p.padre.Id);
        p = p.padre;
    }
    noLoop();
}

void mouseClicked()
{
  Nodo n = null;
  
  if ( Buscando )
    redraw();

  // Nuevo nodo o arista
  if ( mouseButton == RIGHT ) {
    
    // Mouse sobre un nodo: no se agrega nada
    for ( Nodo a : Nodos ) 
      if ( a.mouseIn() )
        return;
    
    if ( NodosMarcados == 2 ) {
      
        if ( NodoMarcado1.aristas.contains(NodoMarcado2) ) {
            println(NodoMarcado1.Id+" y "+NodoMarcado2.Id+" son adyacentes");
            return;
        }
        NodoMarcado1.AgregarArista(NodoMarcado2);
        println("Se agrega arista entre "+NodoMarcado1.Id+" y "+NodoMarcado2.Id);
    }
  
  } else { // Botón izquierdo: marcar
  
    for ( Nodo a : Nodos) {
      if ( a.mouseIn() ) {
        n = a;
        break;
      }
    }
    if ( n == null )
      return;

    switch ( NodosMarcados ) {
      case 0:
        NodosMarcados = 1;
        NodoMarcado1 = n;
        for ( Nodo v : n.aristas )
          v.Vecino = true;
        break;
      case 1: 
        // Click sobre nodo marcado lo desmarca
        if ( NodoMarcado1 == n ) {
          NodosMarcados = 0;
          for ( Nodo v : n.aristas )
            v.Vecino = false;
        } else {
          NodoMarcado2 = n;
          NodosMarcados = 2;
          NodoMarcado2.Vecino = false;
        }
        break;
      case 2:
        // Click sobre nodo marcado lo desmarca
        if ( NodoMarcado1 == n ) {
          NodosMarcados = 1;
          for ( Nodo v : NodoMarcado1.aristas )
            v.Vecino = false;
          for ( Nodo v : NodoMarcado2.aristas )
            v.Vecino = true;
          NodoMarcado1 = NodoMarcado2;
          NodoMarcado2 = null;
        } else if ( NodoMarcado2 == n ) {
          NodosMarcados = 1;
          for ( Nodo v : NodoMarcado2.aristas )
            v.Vecino = false;
          for ( Nodo v : NodoMarcado1.aristas )
            v.Vecino = true;
          NodoMarcado2 = null;
        } else {
          NodoMarcado1.Marcado = false;
          for ( Nodo v : NodoMarcado1.aristas )
            v.Vecino = false;
          NodoMarcado1.Color = ColorNodoNormal;
          NodoMarcado1 = NodoMarcado2;
          NodoMarcado2 = n;
        }
        break;
      } // switch

      n.Marcado = !n.Marcado;
      n.Color = n.Marcado ? ColorNodoMarcado : ColorNodoNormal;
  } // Botón izquierdo
  
} // mouseClicked

void mouseDragged() 
{
  if ( MoviendoNodo == false  &&  mouseButton == LEFT ) {
    for (Nodo n : Nodos) {
      if ( n.mouseIn()==true ) {
        MoviendoNodo = true;
        NodoEnMovimiento = n;
      }
    }
  }
  if (MoviendoNodo == true )
    NodoEnMovimiento.Mover(mouseX,mouseY);
}

void mouseReleased() 
{
  MoviendoNodo = false;
  NodoEnMovimiento = null;
}

/* Fin de archivo */
