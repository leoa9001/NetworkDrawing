import java.util.*;

class CountingNetwork {
  // number of wires
  private int wireNum;
  private int depth;

  private boolean moving; // if something is moving

  public CountingNetwork(int wires, int depth) {
    this.wireNum = wires;
    this.depth = depth;
    this.wires = new ArrayList<ArrayList<BalancerEnd>>(wires);
    for(int i = 0; i < wires; i++)this.wires.add(new ArrayList<BalancerEnd>());
    balancers = new ArrayList<Balancer>();
    balancerEnds = new ArrayList<BalancerEnd>();
  }
  
  //list of things which are drawable: balancers and BalancerEnds (the drawing of balancer ends is the drawing of tokens which are in it's queue)
  List<Balancer>balancers;
  List<BalancerEnd>balancerEnds;
  
  
  
  //wire list of ends for forwarding through.
  List<ArrayList<BalancerEnd>>wires;



  //subclasses: 

  class Balancer {
    boolean bit = true;
    BalancerEnd upper,lower;
    
    public Balancer(int d1, int w1, int d2, int w2){
     upper = new BalancerEnd(d1,w1);
     lower = new BalancerEnd(d2,w2);
     upper.bal = this;
     lower.bal = this;
     balancers.add(this);
    }
    
    public void pushToken(Token x){
      if(bit){
        
      }
      bit = !bit;
    }
  }



  class BalancerEnd {
    private int d,w;//depth and wire number: bothw 0 to x-1
    Balancer bal;
    List<Token>queue;
    public BalancerEnd(int d, int w){
      this.d = d;
      this.w = w;
      queue = new ArrayList<Token>();
      balancerEnds.add(this);
    }
    
    public void enqueueTok(Token x){
     queue.add(x);
    }
    //the balancer calls this and pushes a token through this end to the end in front of it
    public void pushThroughTok(){
      
    }
  }
  
  class Token{
   
  }
}


//class Balancer<T>{
//  boolean bit = true;
//  //boolean active = false;
//  BalancerEnd<T>upper, lower;


//  public Balancer(int d1,int w1,int d2,int w2){//assume w1 > w2
//  upper = new BalancerEnd(d1,w1);
//  lower = new BalancerEnd(d2,w2);
//  upper.bal = this;
//  lower.bal = this;
//  }

//  public void pushThrough(Token<T> tok){
//   if(bit){

//   }
//  }


//}

//class BalancerEnd<T>{
// ArrayList<Token<T>>inputEnd; 
// int d,w;//depth and wire number;
// Balancer<T>bal; //balancer connected to: the balancer knows which end this is.
// ArrayList<BalancerEnd>wire;
// boolean active = false;

//  public BalancerEnd(int d, int w){
//    this.d = d;
//    this.w = w;
//  }

//  public void addToken(Token<T> tok){
//    inputEnd.add(tok);
//    active = true;
//  }

//  //push through a token
//  public void balance(){
//   if(!active)return;
//   Token x = inputEnd.get(0);
//   inputEnd.remove(0);
//   bal.
//  }
//}


////simple Token
//class Token<T>{
//  T data;
//  public Token(T data){
//    this.data = data;
//  }
//}