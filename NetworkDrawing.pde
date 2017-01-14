

CountingNetwork<Integer>cnet;


public CountingNetwork<Integer> OddEven(int n, int load, int rand) {
  CountingNetwork<Integer>c = new CountingNetwork<Integer>(n+1, n, 24232);
  for (int d = 0; d < n+1; d++) {
    int delta = d%2;
    for (int w = 0; 2*w+1+delta < n; w++) {
      c.addBalancer(d, 2*w+delta, 2*w+1+delta);
    }
  }
  Random r = new Random(rand);

  for (int x = 0; x < load; x++) {
    c.loadToken(r.nextInt(n), x);
  }
  c.finalize();
  return c;
}

void setup() {
  size(1920, 1080); 
  cnet = new CountingNetwork<Integer>(4,4,1);
  cnet.addBalancer(0,0,1);
  cnet.addBalancer(0,2,3);
  cnet.addBalancer(1,0,2);
  cnet.addBalancer(2,1,3);
  cnet.addBalancer(3,1,2);
  for(int i = 0; i < 250; i++)cnet.loadToken(2, i);
  cnet.finalize();
  
  for(int i = 0; i < cnet.activeEnds.size(); i++)println(cnet.activeEnds.get(i));
  while (cnet.isActive()) {
    cnet.randomPushThrough(); 
    //println("YAH!:)++");
    System.out.println(Arrays.toString(cnet.endLoads()));
    //for(int i = 0; i < cnet.activeEnds.size(); i++)println(cnet.activeEnds.get(i));
  }
}


void draw() {
}