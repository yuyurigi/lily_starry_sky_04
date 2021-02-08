import java.util.Calendar;

int num = 0;
int maxnum = 800;
int dimborder = 20; //縁の太さ
int time = 0;

Star[] stars;

color[] colors = {color(246, 193, 208), //ピンク
  color(242, 107, 149), //濃いピンク
  color(244, 216, 140), //黄色
  color(243, 196, 143), //オレンジ
  color(128, 203, 238), //水色
  color(173, 139, 196)  //紫
};

PShape moonSvg; //月のsvg画像
PShape starSvg; //星のsvg画像

// background image
PImage backImage; 

color backColor = color(242, 242, 250); //背景色
color borderColor = color(255, 255, 255); //縁の色
// MAIN -----------------------------------------------------------

void setup() {
  size(800, 800);
  frameRate(30);

  // create stars
  stars = new Star[maxnum];

  moonSvg = loadShape("moon.svg");
  starSvg = loadShape("star.svg");
  moonSvg.disableStyle();
  starSvg.disableStyle();
  shapeMode(CENTER);
  backImage = loadImage("lily.png");
  imageMode(CENTER);

  resetAll();
}

void draw() {
  background(backColor);
  image(backImage, width/2, height/2); //リリィ
  drawWhiteBorder();

  for (int n=0; n<num; n++) {
    stars[n].draw();
  }
  time++;
  /*
  if (time == 2600) {
   saveFrame(timestamp()+"_####.png");
   resetAll();
   }
   println(time);
   */
}

void mousePressed() {
  resetAll();
}

void resetAll() {      
  // stop drawing
  num=0;
  time = 0;

  background(backColor);
  image(backImage, width/2, height/2); //リリィ
  drawWhiteBorder();

  makeNewStar();
  makeNewStar();
}


void makeNewStar() {
  int x = int(dimborder+random(width-dimborder*2));
  int y = int(dimborder+random(height-dimborder*2));
  color myc = get(x, y);
  //星のx、y値がキャラと他の星と重ならないようにする
  if (myc != backColor) {
    while(myc != backColor){
      x = int(dimborder+random(width-dimborder*2));
      y = int(dimborder+random(height-dimborder*2));
      myc = get(x, y);
    }
  }
  float s = random(1);
  int shape;
  if(s<0.4){ //星が出る確率をすこし高くする
    shape = 0;
  } else {
  shape = int(random(4)); //形のランダム値
  }
  int col1 = int(random(colors.length)); //塗り色のランダム値
  int col2 = int(random(colors.length)); //塗り色のランダム値
  //col1とcol2の色を同じにしない
  if (col1 == col2) {
    col2 = (col2 + 1) % colors.length;
  }
  
  float ro = random(TWO_PI);
  
  if (num<maxnum) {
    stars[num] = new Star(x, y, shape, col1, col2, ro);
    num+=1;
  }
  
  //println("num:"+ num);
}

void drawWhiteBorder() {
  fill(borderColor);
  noStroke();
  rect(0, 0, width, dimborder); //縁
  rect(0, 0, dimborder, height); //縁
  rect(0, height-dimborder, width, dimborder); //縁
  rect(width-dimborder, 0, dimborder, height); //縁
}

void keyReleased() {
  if (key == 's' || key == 'S')saveFrame(timestamp()+"_####.png");
}


String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
