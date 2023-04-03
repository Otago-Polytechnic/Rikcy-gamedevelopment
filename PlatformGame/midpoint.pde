// Nischal Bhandari and Ricky(Jie Xu)
//1000111904 and 1000068349)

class midpoint{


public void mpd(int leftIndex, int rightIndex, float heightmap[], int level, int goal, float displacement)
{
  int pivot_point = (leftIndex + rightIndex) / 2;

  float left_point = heightmap[leftIndex];
  float right_point = heightmap[rightIndex];

  float mid_point = (left_point + right_point) / 2;

  heightmap[pivot_point] = mid_point + randomGaussian()*displacement;

  if (level < (goal - 0.2))
  {
    float displacement_reduction = displacement / 2.0f; // reduce the power of the displacement by 0.5 every iteration

    mpd(leftIndex, pivot_point, heightmap, level +1, goal, displacement_reduction);
    mpd(pivot_point, rightIndex, heightmap, level +1, goal, displacement_reduction);
  }
}

float[] createTerrain(int iterations, float initialHeight, float offset) {
  float slots = (int) pow(2,iterations) + 1; // we want 2^n + 1 slots so that we can find the middle
  
  int length = (int)slots;
  
  println(length);
  
  float heightmap[] = new float[length];
  
  heightmap[0] = initialHeight;
  heightmap[length-1] = initialHeight;

  mpd(0, length -1, heightmap, 0, iterations, offset);
  
  return heightmap;
}
float [] background;
float [] foreground;
//midpoint = new Midpoint;

public void setup() {
  size(626, 626);
  background(100,168,220);
  background = createTerrain(2, (height /2) - 100, 200);
  foreground = createTerrain(3, (height /2) + 100, 50);
}

public void draw() {  
  float slot_width = width / (background.length-1);
  
  beginShape();
  fill(158, 98, 204);
  for(int i = 0; i<background.length; i++) {
    vertex(i * slot_width, background[i]);
  }
  vertex(width,height);
  vertex(0, height);    
  endShape();
  
  slot_width = width / (foreground.length-1);
  
  beginShape();
  fill(127, 76, 136);
  for(int i = 0; i<foreground.length; i++) {
    vertex(i * slot_width, foreground[i]);
  }
  vertex(width,height);
  vertex(0, height);
  
  endShape();
}
public void display(){
     Midpoint.setup();
  
}
}
