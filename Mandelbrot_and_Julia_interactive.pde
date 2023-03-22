void setup(){
 size(1940,970);
 background(0);
}

//float Re_c = -0.71;
//float Im_c = -0.31;



float Re_c = -0.71;
float Im_c = -0.31;

float offsetX = 0.75; 
float color_speed = 0.4;
float m = color_speed;

int n=0;
int i=0;

void draw(){
  
  background(0);
  
  
  //                     Mandelbrot
  
  for(float x= -width/4 ;  x<width/4 ; x++){
    for(float y=-height/2 ; y<height/2 ; y++){
      
      float Re_f=0;
      float Im_f=0;
      
      float Re_c = (8*x/width)-offsetX;
      float Im_c = (4*y/height);
      
      i=0;
      while(i<45){
        
        float next_Re_f = Re_f*Re_f - Im_f*Im_f + Re_c;
        float next_Im_f = 2*Re_f*Im_f + Im_c;
        
        Re_f = next_Re_f;
        Im_f = next_Im_f;
        
        if (Re_f*Re_f + Im_f*Im_f >4){
          break;
        }
        
        i++;
      }
      
      if (i<44){
        stroke((0.75+0.25*sin(log(i+n*m)+5))*150-(1.7*log((i+2*n*m)%(n%100 + 100)+1)%(n%50 + 50)),(0.75+0.25*sin(1+2*log((i+n*m)%220)))*255-(5*i+n*m)%200,(0.75+0.25*sin(0.08*i+n*m-5))*255-(5*i+n*m)%255 );
        
        point(x+(float(width)/4),y+(float(height)/2));
      }
    }
  }
  
  
  
  
  //                    Julia
  
  for(int x= -width/4 ;  x<width/4 ; x++){
    for(int y=-height/2 ; y<height/2 ; y++){
      
      Re_c = (8*float(mouseX)/width)-(2+offsetX);
      Im_c = (4*float(mouseY)/height)-2;
      
      float Re_f = (4*x/float(height));
      float Im_f = (8*y/float(width));
      
      i=0;
      while(i<100){
        
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
        
        point(x+(3*width/4),y+(height/2));
      }
      
      
    }
  }
  n++;
  
  
  //         Dividing line
  for (int y=0; y<height; y++){
    stroke(0);
    point(width/2,y);
  }
  
}
