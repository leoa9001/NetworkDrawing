import java.util.*;

class CountingNetwork<T> {
  // number of wires
  private int wireNum;
  private int depth;
  private int seed;
  private Random rand;

  private boolean moving = false; // if something is moving
  private boolean fin = false;

  public CountingNetwork(int depth, int wires, int seed) {
    this.wireNum = wires;
    this.depth = depth;
    this.seed = seed;
    this.rand = new Random(seed);
    this.wires = new ArrayList<ArrayList<End>>(wires);
    for (int i = 0; i < wires; i++)this.wires.add(new ArrayList<End>());
    balancersDraw = new ArrayList<Balancer>();
    endsDraw = new ArrayList<End>();

    //temp structures initialization
    balancerWires = new ArrayList<ArrayList<BalancerEnd>>();
    wireStarts = new ArrayList<WireStart>();
    for (int i = 0; i < wires; i++) {
      balancerWires.add(new ArrayList<BalancerEnd>());
      wireStarts.add(new WireStart(i));
    }
  }

  public void addBalancer(int d, int w1, int w2) {//0 to wireNum-1, 0 to depth-1
    if (fin) {
      println("finished: did not add balancer.");
      return;
    }
    balancersDraw.add(new Balancer(d, w1, w2));
  }

  public void loadToken(int w, T data) {
    wireStarts.get(w).enqueueTok(new Token(data));
  }

  //last step of construction of CountingNetwork: sorts the wires by depth and adds the wire ends (and starts)
  //It also fills in all the nexts of End
  public void finalize() {
    if (fin)return;
    //sort the balancerEnds
    for (ArrayList<BalancerEnd>list : balancerWires) {
      Collections.sort(list, new Comparator<BalancerEnd>() {
        public int compare(BalancerEnd a, BalancerEnd b) {
          return a.d - b.d;
        }
      }
      );
    }
    //println("THE SET: " + Arrays.toString(balancerWires.get(0).toArray()));
    //making the final wires
    for (int i = 0; i < wireNum; i++) {
      wires.get(i).add(wireStarts.get(i));
      wires.get(i).addAll(balancerWires.get(i));
      wires.get(i).add(new WireEnd(i));
    }

    for (List<End>l : wires) {
      for (int i = 0; i < l.size()-1; i++) {
        l.get(i).setNext(l.get(i+1));
      }
    }

    activeEnds = new ArrayList<End>();
    for (End e : wireStarts)if (e.active())activeEnds.add(e);

    balancerWires = null;
    wireStarts = null;
  }

  //list of things which are drawable: balancers and BalancerEnds (the drawing of balancer ends is the drawing of tokens which are in it's queue)
  List<Balancer>balancersDraw;
  List<End>endsDraw;

  //datastructures for the internal shtuffs: to be initialized and used after finalize() is called. 
  List<End>activeEnds;
  List<ArrayList<End>>wires;//wire structure



  //wire list of balancerEnds before through. both temporary (eliminate after finalize())
  ArrayList<ArrayList<BalancerEnd>>balancerWires;
  ArrayList<WireStart>wireStarts;



  //actual network actions as methods:
  public boolean randomPushThrough() {
    if (!isActive())return false;
    int i = rand.nextInt(activeEnds.size());
    End e = activeEnds.get(i);
    e.popTok();
    if (!e.active())activeEnds.remove(e);
    return true;
  }

  public boolean isActive() {
    return !activeEnds.isEmpty();
  }

  public int activeLength() {
    return activeEnds.size();
  }

  public int[] endLoads() {
    int[] x = new int[wireNum];
    for (int i = 0; i < wireNum; i++)x[i] = wires.get(i).get(wires.get(i).size()-1).load();
    return x;
  }

  //subclasses: 

  class Balancer {
    boolean bit = true;
    BalancerEnd upper, lower;
    
    //debug
    //public String toString(){
      
    //}
    
    //end debug

    public Balancer(int d, int w1, int w2) {
      upper = new BalancerEnd(d, w1);
      lower = new BalancerEnd(d, w2);
      upper.bal = this;
      lower.bal = this;
    }
    //the functionality of a balancer
    public void pushThroughToken(Token x) {
      if (bit) {
        upper.pushThroughTok(x);
      } else {
        lower.pushThroughTok(x);
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
    public abstract void setNext(End n);
    public abstract int load();
    public abstract String name();
  }




  class BalancerEnd extends End {
    private int d, w;//depth and wire number: bothw 0 to x-1
    Balancer bal;//main balancer class.
    End e; //next end along the wire.
    List<Token>queue;
    
    //debug
    public String name(){
       if(this == this.bal.upper)return "BLU" + w + "."+d;
       return "BLL" + d + "." + w;
    }
    
    public String toString(){
       String ret = name() +" -> " + next().name();
       ret += " :: Tok: "+Arrays.toString(queue.toArray())+ " Act: "+ active();
       return ret;
    }
    //end debug

    public BalancerEnd(int d, int w) {
      this.d = d;
      this.w = w;
      queue = new ArrayList<Token>();
      endsDraw.add(this);
      balancerWires.get(w).add(this);
    }

    public void enqueueTok(Token x) {
      queue.add(x);
      if (!activeEnds.contains(this))activeEnds.add(this);
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

    public void setNext(End e) {
      this.e = e;
    }
    
    public int load(){
     return queue.size(); 
    }
  }

  class Token {
    T data;
    public Token(T data) {
      this.data = data;
    }
    public String toString(){
     return data.toString(); 
    }
  }

  //minor but necessary classes:
  class WireStart extends End {
    int wireId;
    End e;
    List<Token>queue;
    
    //debug
    public String name(){
        return "WS"+wireId;
    }
    public String toString(){
       String ret = name() +" -> " + next().name();
       ret += " :: Tok: "+Arrays.toString(queue.toArray())+ " Act: "+ active();
       return ret;
    }
    //end debug

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
      return !queue.isEmpty();
    }

    public End next() {
      return e;
    }

    public void setNext(End e) {
      this.e = e;
    }
    
    public int load(){
     return queue.size(); 
    }
  }

  class WireEnd extends End {
    int wireId;
    End e;
    List<Token>queue;
    
    //debug 
    public String name(){
      return "WE"+wireId;
    }
    
    public String toString(){
       String ret = name() +" -> " + next().name();
       ret += " :: Tok: "+Arrays.toString(queue.toArray())+ " Act: "+ active();
       return ret;
    }
    //end debug

    public WireEnd(int w) {
      wireId = w;
      queue = new ArrayList<Token>();
      e = this;
      endsDraw.add(this);
    }

    public void enqueueTok(Token x) {
      queue.add(x);
    }

    public void popTok() {
      queue.remove(0);
    }

    public boolean active() {
      return false;
    }

    public End next() {
      return e;
    }

    public void setNext(End e) {
      this.e = e;
    }
    
    public int load(){
     return queue.size(); 
    }
  }
}