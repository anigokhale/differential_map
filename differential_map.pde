float timestep = 0.0001;
float startTime = 0;
float endTime = 100000;

float t = startTime;

float left = -100;
float right = 100;
float bottom = -100;
float top = 100;

float xMin = -100;
float xMax = 100;
float yMin = -100;
float yMax = 100;

String spawnType = "uniform";
String coefficientType = "manual";
boolean includeTimeStep = true;
boolean displayColor = true;
boolean stack = false;

float[][] coefficients;

ArrayList<Point> points = new ArrayList<Point>();
ArrayList<Point> toRemove = new ArrayList<Point>();

int numPoints = 100000;

void setup() {
  colorMode(HSB, 100);
  coefficients = makeCoefficients();
  printCoefficients();

  fullScreen();
  background(0);

  points = startPoints(spawnType);
  println("Number of points: " + points.size());
}

void draw() {
  toRemove.clear();
  if (!stack) {
    background(0);
  }
  if (frameCount % 1000 == 0) println("t: ", t);

  for (Point p : points) {
    p.update(t);
  }
  for (Point p : toRemove) {
    points.remove(p);
  }

  t += timestep;

  if (t > endTime) noLoop();
}

void mouseWheel(MouseEvent event) {
  if (!stack) {
    float e = event.getCount();

    if (e > 0) {
      float lrconstant = 0.1 * (right-left);
      float tbconstant = 0.1 * (top-bottom);
      left -= lrconstant;
      right += lrconstant;
      bottom -= tbconstant;
      top += tbconstant;
    } else if (e < 0) {
      float lrconstant = 0.1 * (right-left);
      float tbconstant = 0.1 * (top-bottom);
      left += lrconstant;
      right -= lrconstant;
      bottom += tbconstant;
      top -= tbconstant;
    }
  }
}

void mouseDragged() {
  if (!stack) {
    if (mouseButton == CENTER) {
      float lrconstant = 0.01 * (right-left);
      float tbconstant = 0.01 * (top-bottom);
      left += lrconstant * (pmouseX - mouseX);
      right += lrconstant * (pmouseX - mouseX);
      bottom -= tbconstant * (pmouseY - mouseY);
      top -= tbconstant * (pmouseY - mouseY);
    }
    if (mouseButton == RIGHT) {
      points.add(new Point(map(mouseX, 0, width, left, right), map(mouseY, height, 0, bottom, top)));
    }
  }
}

void keyReleased() {
  if (!stack) {
    if (keyCode == UP) {
      float tbconstant = 0.1 * (top - bottom);
      top += tbconstant;
      bottom -= tbconstant;
    }
    if (keyCode == DOWN) {
      float tbconstant = 0.1 * (top - bottom);
      top -= tbconstant;
      bottom += tbconstant;
    }
    if (keyCode == RIGHT) {
      float lrconstant = 0.1 * (right - left);
      right += lrconstant;
      left -= lrconstant;
    }
    if (keyCode == LEFT) {
      float lrconstant = 0.1 * (right - left);
      right -= lrconstant;
      left += lrconstant;
    }
  }
}

//void mouseClicked() {
//  if (keyPressed && key == 's') noLoop();
//}

class Point {
  PVector pos;

  Point(float x, float y) {
    pos = new PVector(x, y);
  }

  void update(float t) {
    float screenx, screeny;

    PVector posPrime = equation(t, pos.x, pos.y);
    //println("log: " + log(posPrime.mag()));

    if (!displayColor) {
      stroke(0, 0, 100);
    } else {
      stroke(map(log(posPrime.mag()), -1, .5, 0, 75), 100, 100);
    }

    strokeWeight(1.5);
    if (includeTimeStep)
      pos.add(posPrime.mult(timestep));
    else
      pos.add(posPrime);

    screenx = map(pos.x, left, right, 0, width);
    screeny = map (pos.y, bottom, top, height, 0);

    point(screenx, screeny);

    if (pos.mag() > 10000) toRemove.add(this);
  }
}

ArrayList<Point> startPoints(String type) {
  ArrayList<Point> p = new ArrayList<Point>();
  if (type == "uniform") {
    for (float i = xMin; i <= xMax; i += (xMax - xMin) / sqrt(numPoints)) {
      for (float j = yMin; j < yMax; j += (yMax - yMin) / sqrt(numPoints)) {
        p.add(new Point(i, j));
      }
    }
  } else if (type == "random") {
    for (int i = 0; i < numPoints; i++) {
      p.add(new Point(random(xMin, xMax), random(yMin, yMax)));
    }
  }

  return p;
}
