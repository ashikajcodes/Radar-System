import processing.serial.*;

Serial myPort;

String data = "";
int angle = 0;
int distance = 0;

void setup() {
  fullScreen(); // Fullscreen mode
  smooth();
  
  // Directly targeting COM8
  try {
    myPort = new Serial(this, "COM8", 9600);
    myPort.bufferUntil('.');
    println("Successfully connected to COM8!");
  } catch (Exception e) {
    println("ERROR: Could not connect to COM8. Make sure Arduino Serial Monitor is closed.");
  }
}

void draw() {
  // Cyber dark background with smooth radar trail effect
  fill(10, 15, 20, 25);
  noStroke();
  rect(0, 0, width, height - 60);
  
  // Bottom status bar background
  fill(10, 15, 20);
  rect(0, height - 60, width, 60);

  drawRadar();
  drawLine();
  drawObject();
  drawText();
}

void serialEvent(Serial port) {
  data = port.readStringUntil('.');
  if (data != null) {
    data = data.substring(0, data.length() - 1); // Trim trailing '.'
    int index1 = data.indexOf(",");
    if (index1 > 0) {
      try {
        angle = int(data.substring(0, index1).trim());
        distance = int(data.substring(index1 + 1).trim());
      } catch (Exception e) {
        // Ignore malformed serial packets
      }
    }
  }
}

void drawRadar() {
  pushMatrix();
  // Move origin to lower center of display
  translate(width / 2, height - 80);
  noFill();
  
  // Calculate maximum arc radius to comfortably fit screen height
  float maxRadius = (height - 120) * 0.88;
  float diameter = maxRadius * 2;
  
  // --- Concentric Range Arcs (25cm, 50cm, 75cm) ---
  strokeWeight(1.5);
  stroke(30, 180, 80, 150); // Subtle neon green
  
  arc(0, 0, diameter * 0.25, diameter * 0.25, PI, TWO_PI);
  arc(0, 0, diameter * 0.50, diameter * 0.50, PI, TWO_PI);
  arc(0, 0, diameter * 0.75, diameter * 0.75, PI, TWO_PI);
  
  // 100cm Outer Boundary Arc
  strokeWeight(2.5);
  stroke(98, 245, 31);
  arc(0, 0, diameter, diameter, PI, TWO_PI);
  
  // --- Angle Grid Lines (30° intervals) ---
  strokeWeight(1);
  stroke(30, 180, 80, 120);
  
  // 0° to 180° Baseline
  line(-maxRadius, 0, maxRadius, 0);
  
  // Constrain radial lines strictly to the 100cm outer arc boundary
  for (int a = 30; a <= 150; a += 30) {
    float x = maxRadius * cos(radians(a));
    float y = maxRadius * sin(radians(a));
    line(0, 0, -x, -y);
  }
  
  // --- Radial Angle Labels ---
  fill(98, 245, 31, 200);
  textSize(14);
  textAlign(CENTER, CENTER);
  
  for (int a = 0; a <= 180; a += 30) {
    float labelRad = maxRadius + 22;
    float lx = labelRad * cos(radians(a));
    float ly = labelRad * sin(radians(a));
    text(a + "°", -lx, -ly);
  }
  
  // --- Distance Labels along vertical (90°) axis ---
  textAlign(LEFT, CENTER);
  fill(30, 200, 100, 180);
  text("25cm", 8, -maxRadius * 0.25);
  text("50cm", 8, -maxRadius * 0.50);
  text("75cm", 8, -maxRadius * 0.75);
  text("100cm", 8, -maxRadius * 1.00);
  
  popMatrix();
}

void drawObject() {
  pushMatrix();
  translate(width / 2, height - 80);
  
  float maxRadius = (height - 120) * 0.88;
  float pixsDistance = distance * (maxRadius / 100.0);
  
  if (distance <= 100 && distance > 0) {
    // Red target warning glow
    noStroke();
    fill(255, 30, 30, 80);
    ellipse(pixsDistance * cos(radians(angle)), -pixsDistance * sin(radians(angle)), 22, 22);
    
    // Core target point
    strokeWeight(10);
    stroke(255, 30, 30);
    point(pixsDistance * cos(radians(angle)), -pixsDistance * sin(radians(angle)));
  }
  popMatrix();
}

void drawLine() {
  pushMatrix();
  translate(width / 2, height - 80);
  
  float maxRadius = (height - 120) * 0.88;
  
  // Rotating sweep beam line
  strokeWeight(3);
  stroke(30, 250, 60, 220);
  line(0, 0, maxRadius * cos(radians(angle)), -maxRadius * sin(radians(angle)));
  popMatrix();
}

void drawText() {
  pushMatrix();
  fill(98, 245, 31);
  textSize(20);
  
  textAlign(LEFT, CENTER);
  text("RADAR SYSTEM (COM8)", 40, height - 30);
  
  textAlign(CENTER, CENTER);
  text("ANGLE: " + angle + "°", width / 2, height - 30);
  
  textAlign(RIGHT, CENTER);
  if (distance <= 100 && distance > 0) {
    fill(255, 50, 50);
    text("TARGET DETECTED: " + distance + " cm", width - 40, height - 30);
  } else {
    fill(98, 245, 31);
    text("RANGE: CLEAR (>100 cm)", width - 40, height - 30);
  }
  popMatrix();
}
