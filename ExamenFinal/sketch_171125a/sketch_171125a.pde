import gab.opencv.*;
import processing.video.*;
import grafica.*;
import java.util.*;

//Global variables
PImage image;
PImage binImage;
int RADIO = 70;
ArrayList<Pixel> graph = new ArrayList<Pixel>();
int SLICES = 5;
//


//Setup method
void setup(){
  image = loadImage("canny.jpg");
  size(1000, 1000);
  PImage ponderado = algoritmoPonderado(image);
  PImage binImg = binariza(127, ponderado);
  binImage = binImg;
  ArrayList<ArrayList<Integer>> grid = createGrid(binImg);
  ArrayList<Pixel> nodes = createNodes(grid, binImg);
  paintGrid(grid, binImg);
  paintNodes(nodes, binImg);
  
  printNodes(nodes);
  image = loadImage("canny.jpg");
  ponderado = algoritmoPonderado(image);
  binImage = binariza(127, ponderado);
  generateGraph(RADIO, nodes, binImage);
  graph = nodes;
  PImage completeGraph = paintGraph(binImage, nodes);
  Pixel prueba = getPixel(100,300, graph);
  Pixel fin = getPixel(450, 250, graph);
  AEstrella searcher = new AEstrella(image, prueba, fin, graph);
  System.out.println("Buscando camino entre");
  System.out.println(prueba.x + "," + prueba.y + "   y   " + fin.x + "," + fin.y);
  System.out.println("----------------------");
  
  ArrayList<Pixel>path = searcher.makePath();
  
  paintPath(completeGraph, path);
  
  System.out.println("Pixel mas cercano a 50, 50: " + prueba.x + "," + prueba.y);
}



//Creates the grid on the image, saves grid's vertex coordinates in an ArrayList
public ArrayList<ArrayList<Integer>> createGrid(PImage img){
  ArrayList<ArrayList<Integer>> grid = new ArrayList<ArrayList<Integer>>();
  
  //Vertical lines creation
  
  int numberVerticalLines = (int)((img.width / SLICES));
  ArrayList<Integer> positionVerticalLines = new ArrayList<Integer>(); //Aqui se guarda la posición
  for(int i = 0; i < numberVerticalLines; i++){
    int pos = (int)(Math.random() * img.width);
    int corrimiento = (int)(Math.random() * ((img.width/100)*3)); //Maximo corrimiento de 3 por ciento la width de la imagen
    if(pos+corrimiento > img.width || positionVerticalLines.contains(pos+corrimiento)){
      i--;
    }
    else{
      positionVerticalLines.add(pos+corrimiento);
    }
  }
  
  Collections.sort(positionVerticalLines); //Lo ordenamos para que no nos confundamos
  //Ahora hacemos lo mismo para las lineas horizontales
  
  //Horizontal lines creation
   
  int numberHorizontalLines = (int)((img.height / SLICES));
  ArrayList<Integer> positionHorizontalLines = new ArrayList<Integer>(); //Aqui se guarda la posición
  for(int i = 0; i < numberHorizontalLines; i++){
    int pos = (int)(Math.random() * img.height);
    int corrimiento = (int)(Math.random() * ((img.height/100)*3)); //Maximo corrimiento de 3 por ciento la height de la imagen
    if(pos+corrimiento > img.height || positionHorizontalLines.contains(pos+corrimiento)){
      i--;
    }
    else{
      positionHorizontalLines.add(pos+corrimiento);
    }
  }
  
  Collections.sort(positionHorizontalLines);
  
  //Lo agregamos al grid
  grid.add(positionVerticalLines);
  grid.add(positionHorizontalLines);
  
  //Debug
  System.out.println(grid.get(0));
  System.out.println();
  System.out.println(grid.get(1));
  //retorna
  return grid;
}


//Pinta el grid en la imagen
void paintGrid(ArrayList<ArrayList<Integer>> grid, PImage imgn){
  PImage img = imgn;
  
  //Paint vertical lines
  for(int i = 0; i < grid.get(0).size(); i++){
    int k = grid.get(0).get(i);
    for(int j = 0; j < img.height; j++){
      color red = color(255,0,0);
      img.set(k, j, red);
    }
  }
  
  //Paint horizontal lines
  for(int i = 0; i < grid.get(1).size(); i++){
    int k = grid.get(1).get(i);
    for(int j = 0; j < img.width; j++){
      color red = color(255,0,0);
      img.set(j, k, red);
    }
  }
  
  img.updatePixels();
  img.save("grid.jpg");
  
}



//Crea los nodos válidos (aun sin conectar)
ArrayList<Pixel> createNodes(ArrayList<ArrayList<Integer>> grid, PImage imagen){
  ArrayList<Pixel> nodes = new ArrayList<Pixel>();
  //Por cada linea verticale, agregar cada linea horizontal que se le atraviesa
  for(int i = 0; i < grid.get(0).size(); i++){
    for(int j = 0; j < grid.get(1).size(); j++){
      //Revisar si caen en un pixel no válido
      if(red(imagen.get(grid.get(0).get(i), grid.get(1).get(j))) != 255){
        Pixel actPixel = new Pixel(grid.get(0).get(i), grid.get(1).get(j),0);
        nodes.add(actPixel); 
      }
    }
  }
  
  return nodes;
}


//Binariza la imagen
PImage binariza(int umbral, PImage img){
  for(int i = 0; i < img.width; i++){
    for(int j = 0; j < img.height; j++){
      if(red(img.get(i,j)) > umbral){
        img.set(i,j,color(255,255,255));
      }
      else{
        
        img.set(i,j,color(0,0,0));
      }
    }
  }
  img.updatePixels();
  img.save("binarizada.jpg");
  return img;
}


//Imprime los nodos
void printNodes(ArrayList<Pixel> nodes){
  for(int i = 0; i < nodes.size(); i++){
    System.out.println(nodes.get(i).x + "," + nodes.get(i).y);
  }
}


//Pinta los nodos en la imagen
PImage paintNodes(ArrayList<Pixel> nodes, PImage imagen){
  for(int i = 0; i < nodes.size(); i++){
    Pixel act = nodes.get(i);
    imagen.set(act.x, act.y, color(255,255,0));
  }
  imagen.updatePixels();
  imagen.save("nodos.jpg");
  return imagen;
}


//Convierte la imagen a escala de grises
PImage algoritmoPonderado(PImage imagen){
  imagen.loadPixels();
  int dimension = imagen.width * imagen.height;
  for(int i = 0; i < dimension; i++){
    float c_red = red(imagen.pixels[i]);
    float c_blue = blue(imagen.pixels[i]);
    float c_green = green(imagen.pixels[i]);
    int aux = (int)((0.21 * c_red) + (0.72 * c_green) + (0.07 * c_blue));
    imagen.pixels[i] = color(aux,aux,aux);
  }
  image.updatePixels();
  image.save("ponderado.jpg");
  
  return imagen;
}

//Calcula la distancia euclidiana entre dos pixeles
int distance(Pixel pix1, Pixel pix2){
  int x1 = pix1.x;
  int y1 = pix1.y;
  int x2 = pix2.x;
  int y2 = pix2.y;
  
  return (int)(Math.sqrt(Math.pow(x2-x1,2) + Math.pow(y2-y1,2)));
}


//Genera los vecinos de un pixel dado
boolean generateNeighbors(int r, Pixel pix, ArrayList<Pixel> nodes, PImage img){
  for(int i = 0; i < nodes.size(); i++){
    Pixel act = nodes.get(i);
    if((act.x != pix.x || act.y != pix.y) && distance(pix, act) < r && checkIntersections(pix, act, img)){
      pix.neighbors.add(act);
    }
  }
  //Añadir de donde vinieron
  /*for(int i = 0; i < pix.neighbors.size(); i++){
    pix.neighbors.get(i).cameFrom = pix;
  }*/
  return true;
}

boolean checkIntersections(Pixel pix1, Pixel pix2, PImage img){
  
  if(pix1.x > pix2.x){
    Pixel aux = pix1;
    pix1 = pix2;
    pix2 = aux;
  }
  
  double dx = pix1.x - pix2.x;
  double dy = pix1.y - pix2.y;

  if(dx == 0){
    if(pix1.y < pix2.y){
      for(int i = pix1.y; i < pix2.y; i++){
        color black = color(0,0,0);
        if(img.get(pix1.x, i) != black){
          return false;
        }
      } 
    }
    else{
      for(int i = pix2.y; i < pix1.y; i++){
        color black = color(0,0,0);
        if(img.get(pix2.x, i) != black){
          return false;
        }
      }
    }
    
  }
  /*else if(dy == 0){
    if(pix1.x < pix2.x){
      for(int i = pix1.x; i < pix2.x; i++){
        color black = color(0,0,0);
        if(img.get(i, pix1.y) != black){
          return false;
        }
      } 
    }
    else{
      for(int i = pix2.x; i < pix1.x; i++){
        color black = color(0,0,0);
        if(img.get(i,pix2.y) != black){
          return false;
        }
      }
    }
  }*/
  else{
    for(double i = (double)pix1.x; i < pix2.x; i+=0.1){
      double y = (pix1.y + dy * (i - pix1.x) / dx);
      color black = color(0,0,0);
      if(img.get((int)i,(int)y) != black){
        return false;
      }
    }
  }
  return true;
}


//Genera el grafo al hacerlo conexo
boolean generateGraph(int r, ArrayList<Pixel> nodes, PImage img){
  for(int i = 0; i < nodes.size(); i++){
    generateNeighbors(r, nodes.get(i), nodes, img);
  }
  
  return true;
}

PImage paintGraph(PImage imgn, ArrayList<Pixel> nodes){
  PImage img = imgn;
  PGraphics pg = createGraphics(img.width, img.height);
  pg.beginDraw();
  pg.background(img);
  pg.stroke(color(255,255,0));
  for(int i = 0; i < nodes.size(); i++){
    Pixel act = nodes.get(i);
    for(int j = 0; j < act.neighbors.size(); j++){
      Pixel vecino = act.neighbors.get(j);
      //Dibujar la conexión
      pg.line(act.x, act.y, vecino.x, vecino.y); 
    }
  }
  
  pg.endDraw();
  image(pg, 0,0);
  img.save("grafo.jpg");
  return img;
}

PImage paintPath(PImage imgn, ArrayList<Pixel> path){
  PImage img = imgn;
  PGraphics pg = createGraphics(img.width, img.height);
  pg.beginDraw();
  pg.background(img);
  pg.stroke(color(42,255,0));
  for(int i = 1; i < path.size(); i++){
    Pixel act = path.get(i);
    Pixel ant = path.get(i-1);
    //Dibujar la conexión
    pg.line(act.x, act.y, ant.x, ant.y); 
    
  }
  
  pg.endDraw();
  image(pg, 0,0);
  img.save("path.jpg");
  return img;
}
//Obtiene el pixel más cercano a ciertas coordenadas
Pixel getPixel(int x, int y, ArrayList<Pixel> grid){
  double distanceAct = Double.MAX_VALUE;
  double dx = Double.MAX_VALUE;
  double dy = Double.MAX_VALUE;
  Pixel best = new Pixel((int)dx, (int)dy, 1);
  for(int i = 0; i < grid.size(); i++){
    Pixel act = grid.get(i);
    if(Math.sqrt(Math.pow(act.x-x,2) + Math.pow(act.y-y,2)) < distanceAct){
      distanceAct = Math.sqrt(Math.pow(act.x-x,2) + Math.pow(act.y-y,2));
      best = grid.get(i);
    }
  }
    
  return best;
}