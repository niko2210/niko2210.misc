import oscP5.*;
import netP5.*;

OscP5 oscP5;

PShader shader;
float variable = 0.0;
String data;
float n;


void setup() {
    size(512, 512, P2D);

    oscP5 = new OscP5(this, 12000);

    shader = loadShader("shader.frag");
    shader.set("u_resolution",float(width), float(height));
    shader.set("variable", variable);
}

void draw() {
    shader(shader);
    rect(10, 10, width - 10 , height - 10);
}