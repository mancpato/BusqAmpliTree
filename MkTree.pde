/*
    MkTree
    
    Función recursiva para generar árboles, con fines educativos.
    
    Cada nodo puede tener un mínimo y un máximo de nodos, seleccionado
    aleatoriamente. Se termina la generación de una rama cuando los nodos
    están demasiado juntos.
    
    Cada nodo tiene una cantidad aleatoria de hijos, de 1 a 3, como los
    movimientos posibles del juego del 15 o Taken.
    
    Miguel Angel Norzagaray Cosío
    UABCS/DSC
*/

Nodo MkTree(int xIni, int xFin, int Y, Nodo Padre)
{
    if ( xFin-xIni < Radio )
        return null;
    int Hijos = int(random(3)) + 1;
    int TamSubTree = (xFin-xIni)/Hijos;
    int Centro = xIni + (xFin-xIni)/2;
    
    Nodo n = new Nodo( Centro, Y+TamMin/2 );
    Nodos.add(n);
    n.padre = Padre;
    
    for ( int i=0 ; i<Hijos  ; i++ ) {
        Nodo v = MkTree(xIni+i*TamSubTree, xIni+(i+1)*TamSubTree, 
                                Y+TamMin, n);
        if ( v != null )
            n.AgregarArista(v);
    }
    return n;
}

/* Fin de archivo */
