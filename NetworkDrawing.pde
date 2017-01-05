




void setup(){
 //size(1920, 1080); 
 CountingNetwork<Integer>cnet = new CountingNetwork<Integer>(1, 2, 43323);
 cnet.addBalancer(0,0,0,1);
 cnet.loadToken(0,1);
 cnet.loadToken(1,2);
 cnet.loadToken(0,3);
 cnet.finalize();
 
 while(cnet.isActive()){
  cnet.randomPushThrough(); 
  println("YAH!:)++");
  System.out.println(cnet.activeLength());
 }
 print("hello");
}


void draw(){
  
}