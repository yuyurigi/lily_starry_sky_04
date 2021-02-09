// space filling box
class Star {

  int x;
  int y;
  int d, d2;
  color myc;
  float ro;
  boolean okToDraw;
  boolean chaste = true;
  int shapeRandom, mnPoints, col1, col2;
  color[] colorData;
  int min = 15; //星のサイズの最小値（１５以下は描かれない）

  //コンストラクタ
  Star() {
    selfinit();
    // random initial conditions
  }

  void selfinit() {
    okToDraw = false;    
    x = int(dimborder+random(width-dimborder*2));
    y = int(dimborder+random(height-dimborder*2));
    myc = get(x, y);
    //星のx、y値がキャラと他の星と重ならないようにする
    if (myc != backColor) {
      while (myc != backColor) {
        x = int(dimborder+random(width-dimborder*2));
        y = int(dimborder+random(height-dimborder*2));
        myc = get(x, y);
      }
    }
    float s = random(1);
    if (s<0.4) { //星が出る確率をすこし高くする
      shapeRandom = 0;
    } else {
      shapeRandom = int(random(4)); //形のランダム値
    }
    col1 = int(random(colors.length)); //塗り色のランダム値
    col2 = int(random(colors.length)); //塗り色のランダム値
    //col1とcol2の色を同じにしない
    if (col1 == col2) {
      col2 = (col2 + 1) % colors.length;
    }
    ro = random(TWO_PI);
    d2 = int(random(20, 50)); //丸のサイズの最大値
    mnPoints = 5 + (int)random(1, 5);
  }

  void draw() {
    expand();

    if (okToDraw) {

      if (d>min) { //星のサイズの最小値
        switch(shapeRandom) {
        case 0 : 
          star(x, y, d);
          break;
        case 1 :
          moon(x, y, d);
          break;
        case 2:
          twinkle(x, y, d, mnPoints);
          break;
        case 3:
          maru(x, y, d);
          break;
        }
      }
    }
  }

  void expand() {
    int obstructions = 0;

    // look for obstructions around perimeter at width d
    //int obstructions = 0;
    colorData = new color[360];
    for (int ang=0; ang<360; ang++) {
      float rad = radians(ang);
      float x2 = int(x + ( (d/2+2) * cos(rad)));
      float y2 = int(y + ( (d/2+2) * sin(rad)));
      colorData[ang] = checkPixel(int(x2), int(y2));
    }

    for (int l=0; l<colorData.length; l++) {
      if (colorData[l] != backColor) {
        obstructions += 1;
      }
      if (obstructions > 0) {
        break;
      }
    } 

    if ((shapeRandom == 3) & (d > d2)) {
      obstructions += 1;
    }

    if (obstructions>0) {
      if (chaste) {
        makeNewStar();
        chaste = false;
      }
    } else {
      d += 2;
      okToDraw = true;
    }
  }

  color checkPixel(int x, int y) {
    color c = get(x, y);
    return c;
  }

  void star(int x, int y, int radius) {
    PGraphics pg1 = createGraphics(radius, radius);
    PGraphics pg2 = createGraphics(radius, radius);
    float c = 50;

    pg1.beginDraw();
    for (int i = 0; i < c; i++) {
      color col = lerpColor(colors[col2], colors[col1], i/c);
      float hh = lerp(radius, 0, i/c);
      float yy = lerp(0, 0-(radius/2), i/c);
      pg1.fill(col);
      pg1.noStroke();
      pg1.rect(0, yy, radius, hh);
    }
    pg1.endDraw();

    float size = float(radius)*0.89;

    pg2.beginDraw();
    pg2.translate(radius/2, radius/2);
    pg2.background(0);
    pg2.noStroke();
    pg2.fill(255, 255, 255);
    pg2.rotate(ro);
    pg2.scale(.01*size);
    pg2.shapeMode(CENTER);
    pg2.shape(starSvg, 0, 0);
    pg2.endDraw();
    
    fill(backColor);
    ellipse(x, y, radius, radius);

    pg1.mask(pg2);
    image(pg1, x, y);
  }

  void moon(int x, int y, int radius) {
    PGraphics pg1 = createGraphics(radius, radius);
    PGraphics pg2 = createGraphics(radius, radius);
    float c = 50;

    pg1.beginDraw();
    for (int i = 0; i < c; i++) {
      color col = lerpColor(colors[col2], colors[col1], i/c);
      float hh = lerp(radius, 0, i/c);
      float yy = lerp(0, 0-(radius/2), i/c);
      pg1.fill(col);
      pg1.noStroke();
      pg1.rect(0, yy, radius, hh);
    }
    pg1.endDraw();

    float size = float(radius)*0.89;

    pg2.beginDraw();
    pg2.translate(radius/2, radius/2);
    pg2.background(0);
    pg2.noStroke();
    pg2.fill(255, 255, 255);
    pg2.rotate(ro);
    pg2.scale(.01*size);
    pg2.shapeMode(CENTER);
    pg2.shape(moonSvg, 0, 0);
    pg2.endDraw();
    
    fill(backColor);
    ellipse(x, y, radius, radius);

    pg1.mask(pg2);
    image(pg1, x, y);
  }

  void twinkle(int x, int y, int radius, int nPoints) {
    PGraphics pg1 = createGraphics(radius, radius);
    PGraphics pg2 = createGraphics(radius, radius);
    float c = 50;

    pg1.beginDraw();
    for (int i = 0; i < c; i++) {
      color col = lerpColor(colors[col2], colors[col1], i/c);
      float hh = lerp(radius, 0, i/c);
      float yy = lerp(0, 0-(radius/2), i/c);
      pg1.fill(col);
      pg1.noStroke();
      pg1.rect(0, yy, radius, hh);
    }
    pg1.endDraw();

    float angle = TWO_PI / nPoints;
    float angle2 = angle / 2;
    float origAngle = 0.0;
    float rad1 = radius/2*0.95;
    float rad2 = rad1/4;
    pg2.beginDraw();
    pg2.translate(radius/2, radius/2);
    pg2.background(0);
    pg2.fill(255, 255, 255);
    pg2.stroke(255, 255, 255);
    pg2.stroke(1);
    pg2.strokeJoin(ROUND);
    pg2.rotate(ro);
    pg2.beginShape();
    for (int i = 0; i < nPoints; i++) {
      float y1 = rad1 * sin(origAngle);
      float x1 = rad1 * cos(origAngle);
      float y2 = rad2 * sin(origAngle + angle2);
      float x2 = rad2 * cos(origAngle + angle2);
      pg2.vertex(x1, y1);
      pg2.vertex(x2, y2);
      origAngle += angle;
    }
    pg2.endShape(CLOSE);
    pg2.endDraw();
    
    fill(backColor);
    ellipse(x, y, radius, radius);

    pg1.mask(pg2);
    image(pg1, x, y);
  }

  void maru(int x, int y, int rad) {
    fill(colors[col1]);
    noStroke();
    ellipse(x, y, rad*0.5, rad*0.5);
  }
}
