import org.processing.wiki.triangulate.*;

int seed = int(random(999999));


float nwidth =  960; 
float nheight = 960;
float swidth = 960; 
float sheight = 960;
float scale = 1;

boolean export = false;

void settings() {
  scale = nwidth/swidth;
  size(int(swidth*scale), int(sheight*scale), P2D);
  smooth(8);
  pixelDensity(2);
}

void setup() {

  generate();

  if (export) {
    saveImage();
    exit();
  }
}

void draw() {
}

void keyPressed() {
  if (key == 's') saveImage();
  else {
    seed = int(random(999999));
    generate();
  }
}

class Rect {
  float x, y, w, h;
  Rect(float x, float y, float w, float h) {
    this.x = x;
    this.y = y; 
    this.w = w; 
    this.h = h;
  }
}

void generate() { 

  randomSeed(seed);
  noiseSeed(seed);

  background(#A5AA75);

  rectMode(CENTER);

  float ss = 40; 
  fill(255, 40);
  noStroke();
  for (int j = 0; j <= height; j+=ss) {
    for (int i = 0; i <= width; i+=ss) {
      rect(i, j, 2, 2);
    }
  }

  int div = int(width*4/ss);
  ArrayList<Rect> rects = new ArrayList<Rect>();
  rects.add(new Rect(0, 0, div, div));

  for (int i = 0; i < 6; i++) {
    int ind = int(random(rects.size()));
    Rect r = rects.get(ind);
    if (r.w <= 1 || r.h <= 1) continue;
    int w1 = int(random(1, r.w));
    int w2 = int(r.w)-w1;
    int h1 = int(random(1, r.h));
    int h2 = int(r.h)-h1;
    rects.add(new Rect(r.x, r.y, w1, h1));
    rects.add(new Rect(r.x+w1, r.y, w2, h1));
    rects.add(new Rect(r.x+w1, r.y+h1, w2, h2));
    rects.add(new Rect(r.x, r.y+h1, w1, h2));

    rects.remove(ind);
  }

  for (int i = 0; i < rects.size(); i++) {
    Rect r = rects.get(i);
    float xx = r.x*ss;
    float yy = r.y*ss;
    float ww = r.w*ss;
    float hh = r.h*ss;
    xx += ww*0.5;
    yy += hh*0.5;
    fill(rcol());
    //rect(xx, yy, r.w*ss, r.h*ss);

    if (random(1) < 0.5) {
      beginShape();
      fill(rcol());
      vertex(xx-ww*0.5, yy-hh*0.5);
      vertex(xx+ww*0.5, yy-hh*0.5);
      fill(rcol());
      vertex(xx+ww*0.5, yy+hh*0.5);
      vertex(xx-ww*0.5, yy+hh*0.5);
      endShape();
    }
    else{
      
      beginShape();
      fill(rcol());
      vertex(xx+ww*0.5, yy-hh*0.5);
      vertex(xx+ww*0.5, yy+hh*0.5);
      fill(rcol());
      vertex(xx-ww*0.5, yy+hh*0.5);
      vertex(xx-ww*0.5, yy-hh*0.5);
      endShape();
    }
  }


  float bb = 1.5;
  for (int i = 0; i < 300; i++) {
    float x = random(width+ss*4);
    float y = random(height+ss);
    float w = ss*0.5;
    float h = ss*2.5;
    x -= x%ss;
    y -= y%ss;
    fill(rcol());
    rect(x, y, w, h);

    fill(255, 220);
    beginShape();
    vertex(x+w*0.5, y-h*0.5);
    vertex(x+w*0.5+bb, y-h*0.5+bb);
    vertex(x+w*0.5+bb, y+h*0.5+bb);
    vertex(x+w*0.5, y+h*0.5);
    endShape();

    fill(0, 220);
    beginShape();
    vertex(x+w*0.5, y+h*0.5);
    vertex(x+w*0.5+bb, y+h*0.5+bb);
    vertex(x-w*0.5+bb, y+h*0.5+bb);
    vertex(x-w*0.5, y+h*0.5);
    endShape();



    beginShape();
    fill(rcol(), 240);
    vertex(x-w*0.5, y-h*0.5+bb);
    vertex(x-w*0.5, y+h*0.5);
    fill(rcol(), 100);
    vertex(x-w*0.5-w*15, y+h*0.5+h);
    vertex(x-w*0.5-w*15, y-h*0.5+bb+h);
    endShape();
  }
}

void arc2(float x, float y, float s1, float s2, float a1, float a2, int col, float alp1, float alp2) {
  float r1 = s1*0.5;
  float r2 = s2*0.5;
  int cc = (int) max(4, PI*pow(max(s1, s2)*0.1, 1)*3);

  beginShape(QUADS);
  for (int i = 0; i < cc; i++) {
    float ang1 = map(i+0, 0, cc, a1, a2); 
    float ang2 = map(i+1, 0, cc, a1, a2);
    fill(col, alp1);
    vertex(x+cos(ang1)*r1, y+sin(ang1)*r1);
    vertex(x+cos(ang2)*r1, y+sin(ang2)*r1);
    fill(col, alp2);
    vertex(x+cos(ang2)*r2, y+sin(ang2)*r2);
    vertex(x+cos(ang1)*r2, y+sin(ang1)*r2);
  }
  endShape();
}

void saveImage() {
  String timestamp = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
  saveFrame(timestamp+"-"+seed+".png");
}

int colors[] = {#7E5C25, #B8BA89, #EBE5BB, #ECDD6A, #E58F28, #E72E05};
//int colors[] = {#80D2F0, #D4F5F4, #472176, #030234, #F7CE5B };
//int colors[] = {#F7AA06, #35B1CA, #DA4974, #B9100F, #214CA2};
//int colors[] = {#FBFF38, #889DD8, #FFD8EB, #F41D3A, #164BB7, #ffffff, #000000};
//int colors[] = {#E255EB, #2A6DD1, #E255EB, #F5C203};
//int colors[] = {#0F2442, #0168AD, #8AC339, #E65B61, #EDA787};
//int colors[] = {#EFE5D1, #F09BC4, #F54034, #1F43B1, #02ADDC};
int rcol() {
  return colors[int(random(colors.length))];
}
int getColor() {
  return getColor(random(colors.length));
}
int getColor(float v) {
  v = abs(v);
  v = v%(colors.length); 
  int c1 = colors[int(v%colors.length)]; 
  int c2 = colors[int((v+1)%colors.length)]; 
  return lerpColor(c1, c2, v%1);
}
