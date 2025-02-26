import oscP5.*;
import netP5.*;
import java.util.LinkedList;
import java.util.Queue;
import java.io.*;

OscP5 oscP5;

float delta;
float theta;
float alpha;
float beta;
float gamma;
String timestamp;
float[] eegDataArray;
// delta ; theta ; alpha ; beta ; gamma
String[] dataArray;
float alphaBetaRatio;
float averageRatio = 0;
float maxRecordedRatio = 0;
float maxAllowedRatio = 20;
int numberOfStringsRecieved = 0;
BoundedFloatQueue queue;

PShader shader;
String data;
float n;
float[] position;
float variable_x = 0.25;
float variable_y = 0.0;
float time = 0;
float centerX = -0.75;
float centerY = 0.0;
float zoom = 5.0;
float iterations = 100.0;
float colorParameter1 = 1;
float sensitivity = 1.5;
float parameter = 1;
String shaderType = "mandelbrot";
float timeIncrement = 0.05;
int queueSize = 30;
PrintWriter output;

void setup() {
    size(1480, 960, P2D);

    oscP5 = new OscP5(this, 12000);
    eegDataArray = new float[5];
    dataArray = new String[6];
    queue = new BoundedFloatQueue(queueSize);

    shader = loadShader("shader_" + shaderType + ".frag");
    shader.set("u_resolution",float(width), float(height));
    //shader.set("variable", variable);
    
    
    //setStateFromFile();
}

void keyPressed(){
  if( key == ' '){
    recordState();
  }
  if( key == 'l'){
    setStateFromFile();
  }
}
void recordState(){
  try {
    FileWriter fw = new FileWriter(sketchPath("state.txt"), true); // 'true' enables appending mode
    PrintWriter pw = new PrintWriter(fw);
    pw.print(centerX + ";" + centerY + ";" + zoom + ";" + iterations + "\n");
    pw.close();
    println("recorded");
  } catch (IOException e) {
    e.printStackTrace();
  }
}

void setStateFromFile(){
  String[] lines = loadStrings("state.txt");
  String line = lines[lines.length - 1];
  println(line);
  String[] dataString = line.split(";");
  
  centerX =     Float.parseFloat(dataString[0]);
  centerY =     Float.parseFloat(dataString[1]);
  zoom =        Float.parseFloat(dataString[2]);
  iterations =  Float.parseFloat(dataString[3]);
}

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/test")) {
    String data = msg.get(0).stringValue();
    numberOfStringsRecieved +=1 ;
    // println("Received: " + data);
    dataArray = data.split(",");
    timestamp = dataArray[0];
    for ( int i = 0 ; i < 5 ; i++){
      eegDataArray[i] = parseFloat(dataArray[i+1]);
    }
    // println(eegDataArray);
    

    delta = eegDataArray[0];
    theta = eegDataArray[1];
    alpha = eegDataArray[2];
    beta = eegDataArray[3];
    gamma = eegDataArray[4];
    //n = (float) parseInt(data.split("!")[1]);
    alphaBetaRatio = alpha / beta;
    println("Alpha/beta ratio: " + alphaBetaRatio );
    println("Queue size: " + queue.size() + " , " + queue.queueSize());
    if(alphaBetaRatio > maxRecordedRatio) { maxRecordedRatio = alphaBetaRatio;}
    println("Max recorded ratio: " + maxRecordedRatio);
    if (alphaBetaRatio > maxAllowedRatio) { alphaBetaRatio = maxAllowedRatio;}
    println("Sensitivity: " + sensitivity);
    println("Data transmissions: " + numberOfStringsRecieved);
    queue.offer(alphaBetaRatio);
    
    averageRatio = queue.getAverage();
    println("Average ratio: " + averageRatio);
  }
}

void draw() {
    position = position(parameter);
   // println("queue sum: " + queue.getAverage());
   // println("center x: " + centerX + " ;  " + "center y: " + centerY + " ;  " + "zoom: " + zoom + " ;  " + "iterations: " + iterations    );
   // println(n + " " + timeIncrement + " " + parameter + " " + position[0] + " " + position[1] + " " + variable_x + " " + variable_y);

    shader.set("time", time);
    shader.set("variable_x", position[0]);
    shader.set("variable_y", position[1]);
    shader.set("iterations", iterations*log(zoom*10));
    shader.set("u_center", centerX, centerY);
    shader.set("u_zoom", zoom);
    shader.set("colorParameter1", colorParameter1);
    shader.set("sensitivity", sensitivity);
    shader.set("meditationFactorAverage", averageRatio);
    shader(shader);
    rect(0,0,width,height);
    
    time += timeIncrement;

    if (keyPressed){
    float step = 0.1/zoom;
    
        //  center: a-s-w-d ; zoom: q-e ; iterations: r-f ; parameter: t-g ; time-increment: 1-2 ; sensitivity: y-h
        
        if (key == 'w'){
            centerY += step;
        }
        if (key == 's'){
            centerY -= step;
        }
        if (key == 'a'){
            centerX -= step;
        }
        if (key == 'd'){
            centerX += step;
        }
        if (key == 'q'){
            zoom /= 1.02;
        }
        if (key == 'e'){
            zoom *= 1.02;
        }
        if (key == 'r'){
            iterations *= 1.02;
        }
        if (key == 'f'){
            iterations /= 1.02;
        }
        if (key == 't'){
            parameter *= 1.2;
        }
        if (key == 'g'){
            parameter /= 1.2;
        }
        if (key == '1'){
            timeIncrement *= 1.2;
        }
        if (key == '2'){
            timeIncrement /= 1.2;
        }
        if (key == 'y'){
            sensitivity *= 1.05;
            if(sensitivity > 100) {sensitivity = 100;}
        }
        if (key == 'h'){
            sensitivity /= 1.05;
        }

    }
}

//what?
float[] position(float parameter){
    float x = parameter * cos(2*PI*parameter) - 0.75;
    float y = parameter * sin(2*PI*parameter) + 0.03;



    float[] result = new float[2];
    result[0] = x;
    result[1] = y;
    //println(x + " ; " + y);
    return result;
}

public class Queue {

    int length;
    float[] list;

    public Queue(int length){
        this.length = length;
        list = new float[length];
    }

    void add(float number){
        for(int i = length-1 ; i>-1; i--){
            list[i]=list[i-1];
        }
        list[0] = number;
    }

    float average (){
        float i=0;
        float sum = 0;
        for ( float n : list){
            if (n != 0){
                i++;
                sum += n;
            }
        }
        return sum/i;
    }
        

}

public class BoundedFloatQueue {
    private final LinkedList<Float> queue = new LinkedList<>();
    private final int maxSize;
    int size;
    float sum;

    public BoundedFloatQueue(int maxSize) {
        this.maxSize = maxSize;
        size = 0;
        sum = 0;
    }

    public boolean offer(float element) {
        if (queue.size() < maxSize) {
            queue.addLast(element);
            size++;
            sum += element;
            return true;
        } 
        if (queue.size() == maxSize) {
            float oldElement = queue.getFirst();
            queue.removeFirst();
            sum -= oldElement;
            queue.addLast(element);
            sum += element;
            return true;
        }
        else {
            System.out.println("Queue is more than full. Cannot add element: " + element);
            return false;
        }
    }

    public float poll() {
        if (queue.size() > 0) {
            float element = queue.getFirst();
            queue.removeFirst();
            size--;
            sum -= element;
            return element;
        } else {
            System.out.println("Queue is empty");
            return 0;
        }
    }

    public float peek() {
        if (queue.size() > 0) {
            float element = queue.getFirst();
            return element;
        } else {
            System.out.println("Queue is empty");
            return 0;
        }
    }

    public int queueSize(){ return queue.size();}

    public int size() {
        return size;
    }

    public boolean isEmpty() {
        return (size == 0);
    }

    public float getSum(){
        return sum;
    }

    public float getAverage(){
        return sum / (float) size;
    }
}


// void keyPressed(){

//     float step = 0.1/zoom;
    

//         if (key == 'w'){
//             centerY += step;
//         }
//         if (key == 's'){
//             centerY -= step;
//         }
//         if (key == 'a'){
//             centerX -= step;
//         }
//         if (key == 'd'){
//             centerX += step;
//         }
//         if (key == 'q'){
//             zoom /= 1.2;
//         }
//         if (key == 'e'){
//             zoom *= 1.2;
//         }

// }
