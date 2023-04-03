// Nischal Bhandari and Ricky(Jie Xu)
//1000111904 and 1000068349)



float sx=25;
float sy=25*18;

float jumpVelocity = -12; //the initial velocity of the jump
float gravity = 0.9; //the force of gravity pulling the sprite down
float verticalVelocity = 1; //the current vertical velocity of the sprite
boolean isJumping = false; //flag to indicate if the sprite is currently jumping

int topOffset = 0;
int cellWidth = 40;
int cellHeight = 60;

int frame = 0;
int maxFrames = 8;
int startGridX=0;


PImage left[] = new PImage[maxFrames];
PImage right[] = new PImage[maxFrames];
PImage up[] = new PImage[maxFrames];
PImage down[] = new PImage[maxFrames];
//PImage im = new PImage();
//float bgX=0,bgY=0;
Map map;
midpoint Midpoint;

Coins foods;
Animals animals;

import processing.sound.*;
SoundFile file;


final int STATUS_BEFORE = 0;
// Game state: in game
final int STATUS_PLAYING = 1;
// Game Status: Victory
final int STATUS_WIN = 2;
// Game State: Failed
final int STATUS_LOSE = 3;
// current state of the game
int gameStatus = STATUS_BEFORE;

 

void setup(){
     
size(626, 626);

   map = new Map();
 Midpoint = new midpoint(); 
 map.draw();
 Midpoint.setup();
 file = new SoundFile(this, "gamemusic.mp3");
  file.loop();
 
    PImage rightSprite = loadImage("hero_walk_right.png");
  PImage leftSprite = loadImage("hero_walk_left.png");
  PImage downSprite = loadImage("hero_walk_down.png");
  PImage upSprite = loadImage("hero_walk_up.png");
  
  for(int i = 0; i< maxFrames; i++) {
    right[i] = rightSprite.get(cellWidth*i,topOffset,cellWidth,cellHeight);
    left[i] = leftSprite.get(cellWidth*i,topOffset,cellWidth,cellHeight);
    up[i] = upSprite.get(cellWidth*i,topOffset,cellWidth,cellHeight);
    down[i] = downSprite.get(cellWidth*i,topOffset,cellWidth,cellHeight);
   
}
 
frameRate(50);


 foods = new Coins();
  foods.init(626, 626 - 75, 100);
  
  foods.restart(10);
    animals = new Animals();
  animals.init(626, 626 - 75);
} 



boolean isUp = false;
boolean isDown = false;
boolean isLeft = false;
boolean isRight = false;

 

PVector pv = new PVector(sx,sy);
PVector pvr = new PVector(25,0);
PVector pvl = new PVector(-25,0);
PVector pvu = new PVector(0,-25);
PVector pvd = new PVector(0,25);
PVector pvvc = pv;

PImage sprite[] = up;


void draw(){
 
 if (gameStatus == STATUS_BEFORE) {
    beforeStart();
    return;
  }
  if (gameStatus == STATUS_WIN) {
    afterWin();
    return;
  }
  if (gameStatus == STATUS_LOSE) {
    afterLose();
    return;
  }
 background(108, 198, 200);
Midpoint.draw();
map.draw();
image(sprite[frame],pv.x,pv.y,cellWidth*3,cellHeight*3);
int moveX = 0;

 if(keyPressed){
   

   if(keyCode == UP){ 
        if (!isJumping) {
      isJumping = true;
      verticalVelocity = jumpVelocity;
        {
        isUp = true; isDown = false; isRight = false; isLeft = false; 
         
       }
          frame = 0;
         maxFrames = 8;
          
    
    }
 }
        
      else if(keyCode == DOWN) {
        {
        isRight = false;
        isLeft = false;
        isUp = false;
        isDown = true;
          
         
        }
         frame = 0;
          maxFrames = 8;
        sprite = down;
         pvvc.add(pvd);    
        }
      else if(keyCode == LEFT) {
       // if(!isLeft)
       {
        isRight = false;
        isLeft = true;
        isUp = false;
          isDown = false;
          frame = 0;
          maxFrames = 8;
          
        }
        sprite = left;

 

pvvc.add(pvl);   
}
      else if(keyCode == RIGHT) 
       {
        // frame++;
         println(frame);
        if(pv.x>=size*18 && pv.x<=size*21) {
          if(startGridX % 15 ==0 ) Midpoint.setup();
          //pv.set(size*0,pv.y);
          pv.sub(pvr);
          startGridX++;
        
        }
 
        {
        isRight = true;
        isLeft = false;
        isUp = false;
        isDown = false;
          
        
        }
        sprite = right;
         pvvc.add(pvr);
        moveX= 10;
       
 if (pv.x>=size*25)
 {
 pv.x = 25;}
              
      }
map.draw(); 

 
 frame++; 
    if (frame >= maxFrames)
    {
      
      frame = 0;
    }
    
   
    
  }  
 
 
 float manTopLeftX = pv.x + 35 + 5;
  float manTopLeftY = pv.y + 30 + 5;
  float manBottomRightX = manTopLeftX + 50 - 10;
  float manBottomRightY = manTopLeftY + 75 - 10;
  
  boolean reachGoal = foods.move(moveX * -1, manTopLeftX, manTopLeftY, manBottomRightX, manBottomRightY);
  println(minute()+ ":" + second() + " reachGoal:" + reachGoal);
  
   boolean crashed = animals.move(manTopLeftX, manTopLeftY, manBottomRightX, manBottomRightY);
 // println(minute()+ ":" + second() + " crashed:" + crashed);
 // reach target score
 
 if (isJumping) {
   
    //apply gravity
    verticalVelocity += gravity;
    pv.y += verticalVelocity;
    
    //check if the sprite has landed
    if (pv.y >= sy) {
      pv.y = sy;
      verticalVelocity = 0;
      isJumping = false;
    }
  }
    if (reachGoal) {
      file = new SoundFile(this, "winmusic.wav");
  file.play();
   gameStatus = STATUS_WIN;
   return;
 }
 // Collision
 if (crashed) {
   file = new SoundFile(this, "losemusic.wav");
  file.play();
   gameStatus = STATUS_LOSE;
  
 }
}

void keyReleased() {
 //Midpoint.stable();
  isUp = false;
  isDown = false;
  isLeft = false;
  isRight = false;
   // Hit the keyboard S/s before the game starts
  if (gameStatus == STATUS_BEFORE && (key == 'S' || key == 's')) {
    this.restartGame();
  }
  
  // After the game is won, hit the keyboard R/r
  if (gameStatus == STATUS_WIN && (key == 'R' || key == 'r')) {
    
    this.restartGame();
  }
  
  // After the game fails, hit the keyboard R/r
  if (gameStatus == STATUS_LOSE && (key == 'R' || key == 'r')) {
      file = new SoundFile(this, "losemusic.wav");
  file.play();
  this.restartGame();
  }
}

void restartGame() {
  // Character coordinates and frame number
PVector pv = new PVector(sx,sy);
  frame = 0;
  // Gold coins, 10 points to win
  foods.restart(10);
  // animal
  animals.restart();
  // game state
  gameStatus = STATUS_PLAYING;
}
//before the game
void beforeStart() {
  pushMatrix();
  background(0);  //black
  translate(width/2, height/2 - 50);
  fill(255);  //white
  textAlign(CENTER);  //center alignment
  textSize(45);
   text("Platform Game", 0, -30);
  
  text("Press 'S' to start game.", 0, 50);
  text("Author:Ricky&Nischal", 0, 150);
  popMatrix();
}
// after winning the game
void afterWin() {
  pushMatrix();
  
  background(0);  //black
  translate(width/2, height/2 - 50);
  textAlign(CENTER);  //center alignment
  textSize(45);
  fill(0, 0, 255);
  text("You win, score:" + foods.getScore() + "/" + foods.getGoal(), 0, -50);
  fill(255);  //white
  text("Press 'R' to restart.", 0, 100);
  popMatrix();
}

// after losing the game
void afterLose() {
 
  pushMatrix();
  
  background(0);  //black
  translate(width/2, height/2 - 50);
  textAlign(CENTER);  //center alignment
  textSize(45);
  fill(255, 0, 0);
  text("Game Over, score:" + foods.getScore() + "/" + foods.getGoal(), 0, -50);
  fill(255);  //white
  text("Press 'R' to restart.", 0, 100);
  popMatrix();
}
