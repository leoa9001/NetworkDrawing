

CountingNetwork<Integer>cnet;


public CountingNetwork<Integer> OddEven(int n, int load) {
  CountingNetwork<Integer>c = new CountingNetwork<Integer>(n, n, 24232);
  for (int d = 0; d < n; d++) {
    int delta = d%2;
    for (int w = 0; 2*w+1+delta < n; w++) {
      c.addBalancer(d, 2*w+delta, 2*w+1+delta);
    }
  }
  Random r = new Random(2222);

  for (int x = 0; x < load; x++) {
    c.loadToken(r.nextInt(n), x);
  }
  c.finalize();
  return c;
}

void setup() {
  //size(1920, 1080); 
  cnet = OddEven(3, 5000);
  cnet = new CountingNetwork<Integer>(3,3,1);
  cnet.addBalancer(0,0,1);
  cnet.addBalancer(1,1,2);
  cnet.addBalancer(2,0,1);
  for(int i = 0; i < 2; i++)cnet.loadToken(2, i);
  cnet.finalize();

  while (cnet.isActive()) {
    cnet.randomPushThrough(); 
    //println("YAH!:)++");
    System.out.println(Arrays.toString(cnet.endLoads()));
  }
  println("Please be counting ;-;");
  println(Arrays.toString(cnet.endLoads()));
}


void draw() {
}