// Averaging images from webcam. 
// For course MAS.S48: Recreating the past (MAS.S68), instr. Zach Lieberman
// Fall 2020 [11/2/2020]


import processing.video.*;

Capture cam;

PGraphics pg;
int img_num = 10;
int total_pixels;
PImage[] images = new PImage[img_num];

color c;    // Color of pixel pix
float[] red_sum, new_red, green_sum, new_green, blue_sum, new_blue, new_image;  // RGB values of c

int frame_counter = 0;

void setup(){
  size(1280, 720);
  background(255);
  
  cam = new Capture(this, width, height);
  cam.start();
  
  pg = createGraphics(width, height);
  total_pixels = width*height;
  for (int i = 0; i < img_num; i++){
    images[i] = loadImage(i + ".jpg");
  }
  //Initialize color arrays
  red_sum = new_red = green_sum = new_green = blue_sum = new_blue = new float[total_pixels];
  for (int i = 0; i < total_pixels ; i++){
    red_sum[i] = green_sum[i] = blue_sum[i] = 0;
  } 
}

void draw(){
  if (cam.available()){
    cam.read();
  }
  
  if ((frameCount % 30 == 0) && (frame_counter < img_num)){
  scale(-1, 1);
  image(cam, - width, 0);
  // save it on the folder data/
  saveFrame("data/"+frame_counter+".jpg");
  frame_counter += 1;
  }
  
  if (frame_counter == 10){
    calculateSum();
    calculateAverage();
  
    pg.beginDraw();
    pg.loadPixels();
    // Set pixel color inside the PGraphic:
    int pix;
    for (int x = 0; x < width; x++){
      for (int y = 0; y < height; y++) {
        //Set new average color value:
        pix = (x + y * width);
        pg.pixels[pix] = color(new_red[pix], new_green[pix], new_blue[pix]);
      }
    }
    pg.updatePixels();
    pg.endDraw();
    //Draw what is in the PGraphic:
    println("Drawing PGraphic on canvas...");
    imageMode(CENTER);
    image(pg, width/2, height/2); 
    //image(pg, 0, 0); 
    println("Done!");
  }
}

void calculateSum(){
  for (int i = 0; i < img_num; i++){    
    for (int x = 0; x < width; x++){
      for (int y = 0; y < height; y++) {
        //Pixel location on grid
        int pix = (x + y * width);    
        // Color of pixel pix, in image images[i]
        c = images[i].pixels[pix];
        // RGB values of c added to r g b sums:
        red_sum[pix] += red(c);
        green_sum[pix] += green(c);
        blue_sum[pix] += blue(c); 
        //println(blue_sum[pix]);  // for images 0 - i
      }
    }  
  }
}


void calculateAverage(){
  int pix;
  for (int x = 0; x < width; x++){
    for (int y = 0; y < height; y++) {
      //Average values:
      pix = (x + y * width);
      new_red[pix] = red_sum[pix] / img_num;
      new_green[pix] = green_sum[pix] / img_num;
      new_blue[pix] = blue_sum[pix] / img_num;
    }
  }
}


  
