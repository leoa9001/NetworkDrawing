




void setup(){
 //size(1920, 1080); 
 CountingNetwork<Integer>cnet = new CountingNetwork<Integer>(1,2);
 cnet.addBalancer(0,0,0,1);
 cnet.loadToken(0,1);
 cnet.loadToken(0,2);
 cnet.loadToken(0,3);
 cnet.finalize();
 //print("hello");
}


void draw(){
  
}