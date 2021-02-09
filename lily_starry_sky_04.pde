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
  for (int n=0; n<num; n++) {
    stars[n].draw();
  }
  time++;
  /*
  if (time == 2600) {
   saveFrame(timestamp()+"_####.png");
   resetAll();
   }
   */
   //println(time);
   
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
  if (num<maxnum) {
    stars[num] = new Star();
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
