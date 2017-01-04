import java.util.*;

class CountingNetwork {
  // number of wires
  private int wireNum;
  private int depth;

  private boolean moving; // if something is moving

  public CountingNetwork(int wires, int depth) {
    this.wireNum = wires;
    this.depth = depth;
    this.wires = new ArrayList<ArrayList<End>>(wires);
    for (int i = 0; i < wires; i++)this.wires.add(new ArrayList<End>());
    balancers = new ArrayList<Balancer>();
    balancerEnds = new ArrayList<BalancerEnd>();
  }

  //list of things which are drawable: balancers and BalancerEnds (the drawing of balancer ends is the drawing of tokens which are in it's queue)
  List<Balancer>balancers;
  List<BalancerEnd>balancerEnds;



  //wire list of ends for forwarding through.
  List<ArrayList<End>>wires;



  //subclasses: 

  class Balancer {
    boolean bit = true;
    BalancerEnd upper, lower;

    public Balancer(int d1, int w1, int d2, int w2) {
      upper = new BalancerEnd(d1, w1);
      lower = new BalancerEnd(d2, w2);
      upper.bal = this;
      lower.bal = this;
      balancers.add(this);
    }
    //the functionality of a balancer
    public void pushThroughToken(Token x) {
      if (bit) {
        upper.enqueueTok(x);
      } else {
        lower.enqueueTok(x);
      }
      bit = !bit;
    }
  }

  //should probably be a proper abstract class but already typed lots in other class :p
  abstract class End {
    public abstract void enqueueTok(Token x);
    public abstract void popTok();
    public abstract boolean active();
    public abstract End next();
  }




  class BalancerEnd extends End {
    private int d, w;//depth and wire number: bothw 0 to x-1
    Balancer bal;//main balancer class.
    End e; //next end along the wire.
    List<Token>queue;
    public BalancerEnd(int d, int w) {
      this.d = d;
      this.w = w;
      queue = new ArrayList<Token>();
      balancerEnds.add(this);
    }

    public void enqueueTok(Token x) {
      queue.add(x);
    }
    //pop from queue
    public void popTok() {
      if (active()) {
        Token x = queue.get(0);
        queue.remove(0);
        bal.pushThroughToken(x);
      }
    }
    //the balancer calls this and pushes a token through this end to the end in front of it
    public void pushThroughTok(Token x) {
      next().enqueueTok(x);
    }

    public boolean active() {
      return !queue.isEmpty();
    }

    public End next() {
      return e;
    }
  }

  class Token {
  }

  //minor but necessary classes:
  class WireStart extends End {
    int wireId;
    End e;
    List<Token>queue;

    public WireStart(int w) {
      wireId = w;
      queue = new ArrayList<Token>();
    }

    public void enqueueTok(Token x) {
      queue.add(x);
    }

    public void popTok() {
      if (active()) {
        Token x = queue.get(0);
        queue.remove(0);
        next().enqueueTok(x);
      }
    }

    public boolean active() {
      return queue.isEmpty();
    }

    public End next() {
      return e;
    }
  }

  class WireEnd extends End {
    int wireId;
    End e;
    List<Token>queue;

    public WireEnd(int w) {
      wireId = w;
      queue = new ArrayList<Token>();
      e = this;
    }

    public void enqueueTok(Token x){
      queue.add(x);
    }
  
    public void popTok(){
     queue.remove(0); 
    }
   
    public boolean active(){
     return false; 
    }
    
    public End next(){
     return e; 
    }
  }
}