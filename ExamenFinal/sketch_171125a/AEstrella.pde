import gab.opencv.*;
import processing.video.*;
import grafica.*;
import java.util.*;
//Realiza búsquedas AEstrella sobre una imagen, dados dos pixeles
public class AEstrella{
  //Variables globales
  PImage imagen;
  Pixel start;
  Pixel end;
  ArrayList<Pixel> path;
  ArrayList<Pixel> graph;
  LinkedList<Pixel> queue;
  //Constructor
  public AEstrella(PImage imagen, Pixel start, Pixel end, ArrayList<Pixel> graph){
    this.imagen = imagen;
    this.start = start;
    this.end = end;
    this.graph = graph;
    this.path = new ArrayList<Pixel>();
    this.queue = new LinkedList<Pixel>();
  }
  
  public ArrayList<Pixel> makePath(){ //Hace el algoritmo de AEstrella, genera el path
    start.visited = true;
    path.add(start);
    queue.add(start);
    
    int k = 0;
    //BFS first to add cameFrom attribute
    while(queue.size() > 0){
      Pixel act = queue.pollFirst();
      if(act != null){
        act.visited = true;
        for(int i = 0; i < act.neighbors.size(); i++){
          if(act.neighbors.get(i).visited == false){
            act.neighbors.get(i).visited = true;
            act.neighbors.get(i).cameFrom = act;
            queue.add(act.neighbors.get(i));
          } 
        }
        
      }
      //System.out.println("Me estoy ciclando " + k + "Tamaño: " + queue.size());
      k++;
    }
    
    //
    start.visitedAgain = true;
    Pixel act = start;
    
    while(act != end){ //A* ! :D
      act.visitedAgain = true;
      double h = Double.MAX_VALUE;
      Pixel next = act;
      for(int i = 0; i < act.neighbors.size(); i++){
        double euclid = distance(act.neighbors.get(i), end);
        double manhattan = manhattanDistance(end, act.neighbors.get(i));
        double heuristic = euclid + manhattan;
        if(heuristic < h && !act.neighbors.get(i).visitedAgain){
          h = heuristic;
          next = act.neighbors.get(i);
        }
      }
      System.out.println("Me estoy ciclando "+ "X: " + act.x + " Y:" + act.y);
      path.add(next);
      act = next;
      
   
    }
    /*Pixel act = start;
    path.add(start);
    Pixel best = start;
    
    int k = 0;
    while(h > 0){
      act.visited = true;
      double cost = Integer.MAX_VALUE;
      for(int i = 0; i < act.neighbors.size(); i++){
        double costAct = distance(act.neighbors.get(i), end) + Math.abs(end.x-act.x) + Math.abs(end.y-act.y);
        if(costAct <= cost && !act.neighbors.get(i).visited){
          cost = costAct;
          best = act.neighbors.get(i);
        }
      }
      
      path.add(best);
      act = best;
      k++;
      h--;
      if(best.x == end.x && best.y == end.y) break;      
      //System.out.println("Ya me ciclé" + k);
      

    }
    
    //Debug
    for(int i = 0; i < path.size(); i++){
      System.out.println(path.get(i).x + "," + path.get(i).y);
    }*/
    return path;
  }
  
  //Calcula la distancia euclidiana entre dos pixeles
  public double distance(Pixel pix1, Pixel pix2){
    int x1 = pix1.x;
    int y1 = pix1.y;
    int x2 = pix2.x;
    int y2 = pix2.y;
    
    return (Math.sqrt(Math.pow(x2-x1,2) + Math.pow(y2-y1,2)));
  }
  
  public double manhattanDistance(Pixel pix1, Pixel start){
    double total = 0;
    Pixel act = pix1;
    while(act != start && act.cameFrom != null){
      total += distance(act, act.cameFrom);
      act = act.cameFrom;
    }
    
    return total;
  }
  
  public double heuristic(Pixel pix1, Pixel pix2){
    return distance(pix1, pix2) + manhattanDistance(pix1, pix2);
  }
  
  
  
  
}