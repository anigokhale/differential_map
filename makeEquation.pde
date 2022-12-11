PVector equation(float t, float x, float y) {
  float xprime = 0, yprime = 0;

  if (coefficientType == "manual") {
    xprime = 60 * x - 4 * x * x - 3 * x * y;
    yprime = 42 * y - 2 * y * y - 3 * x * y;
  } else {
    xprime += x * coefficients[0][0];
    xprime += y * coefficients[0][1];
    xprime += t * coefficients[0][2];
    xprime += x*t * coefficients[0][3];
    xprime += y*t * coefficients[0][4];
    xprime += x*y * coefficients[0][5];
    xprime += x*x * coefficients[0][6];
    xprime += y*y * coefficients[0][7];
    xprime += t*t * coefficients[0][8];

    yprime += x * coefficients[1][0];
    yprime += y * coefficients[1][1];
    yprime += t * coefficients[1][2];
    yprime += x*t * coefficients[1][3];
    yprime += y*t * coefficients[1][4];
    yprime += x*y * coefficients[1][5];
    yprime += x*x * coefficients[1][6];
    yprime += y*y * coefficients[1][7];
    yprime += t*t * coefficients[1][8];
  }

  xprime = constrain(xprime, -1000000, 1000000);
  yprime = constrain(yprime, -1000000, 1000000);

  return new PVector(xprime, yprime);
}

float[][] makeCoefficients() {
  if (coefficientType == "fromText") {
    BufferedReader reader = createReader("equation.txt");
    String line = null;
    String[][] coefficientString = new String[3][10];
    float[][] coefficients = new float[2][9];
    try {
      int row = 0;
      while ((line = reader.readLine()) != null) {
        coefficientString[row] = split(line, TAB);
        row++;
      }
      reader.close();

      for (int i = 0; i < coefficients.length; i++) {
        for (int j = 0; j < coefficients[i].length; j++) {
          coefficients[i][j] = float(coefficientString[i+1][j+1]);
        }
      }
    }
    catch (IOException e) {
      e.printStackTrace();
    }
    return coefficients;
  } else {
    float[][] coefficients = new float[2][9];
    for (int i = 0; i < coefficients.length; i++) {
      for (int j = 0; j < coefficients[i].length; j++) {
        coefficients[i][j] = ((int)(Math.random()*3))-1;
      }
    }
    return coefficients;
  }
}

void printCoefficients() {
  println("\tx\ty\tt\txt\tyt\txy\tx^2\ty^2\tt^2");
  print("xprime");
  for (int i = 0; i < coefficients[0].length; i++) {
    print("\t" + coefficients[0][i]);
  }
  println();
  print("yprime");
  for (int i = 0; i < coefficients[1].length; i++) {
    print("\t" + coefficients[1][i]);
  }
  println();
}
