public class Pixel{
  //Global variables
  int x;
  int y;
  int weight;
  boolean visited;
  boolean visitedAgain;
  ArrayList<Pixel> neighbors;
  Pixel cameFrom;
  
  //Constructor
  public Pixel(int x, int y, int weight){
    this.x = x;
    this.y = y;
    this.weight = weight;
    this.visited = false;
    this.visitedAgain = false;
    this.neighbors = new ArrayList<Pixel>();
    this.cameFrom = null;
  }
}