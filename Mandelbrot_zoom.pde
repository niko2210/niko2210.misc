void setup(){
 size(800,800);
 background(0);
}

float Re_focal_point = -0.71;
float Im_focal_point = 0.31;

float initial_zoom = 1;
float zoom_speed = 0.2;
float color_speed = 0.4;
float m = color_speed;

int n=0;

void draw(){
  
  background(0);
  
  for(int x= - width/2 ;  x<width/2 ; x++){
    for(int y=-height/2 ; y<height/2 ; y++){
      
      float Re_f=0;
      float Im_f=0;
      
      float Re_c = (x/(200*initial_zoom*exp(n*zoom_speed))) + Re_focal_point;
      float Im_c = (y/(200*initial_zoom*exp(n*zoom_speed))) - Im_focal_point;
      
      int i=0;
      while(i<100+exp(n*2*zoom_speed)){
        
        float next_Re_f = Re_f*Re_f - Im_f*Im_f + Re_c;
        float next_Im_f = 2*Re_f*Im_f + Im_c;
        
        Re_f = next_Re_f;
        Im_f = next_Im_f;
        
        if (Re_f*Re_f + Im_f*Im_f >4){
          break;
        }
        
        i++;
      }
      
      if (i<99){
        stroke((0.75+0.25*sin(log(i+n*m)+5))*150-(1.7*log((i+2*n*m)%(n%100 + 100)+1)%(n%50 + 50)),(0.75+0.25*sin(1+2*log((i+n*m)%220)))*255-(5*i+n*m)%200,(0.75+0.25*sin(0.08*i+n*m-5))*255-(5*i+n*m)%255 );
        
        point(x+(width/2),y+(height/2));
      }
      
      
    }
  }
  n++;
  
}
