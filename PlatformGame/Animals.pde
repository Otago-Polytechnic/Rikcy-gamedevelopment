// Nischal Bhandari and Ricky(Jie Xu)
//1000111904 and 1000068349)


class Animals {
  // animal movement maximum speed and minimum speed
  private final float ANIMAL_STEP_MAX = 5;
  private final float ANIMAL_STEP_MIN = 2;
  // animal width and height
  private final static int ANIMAL_WIDTH = 34;
  private final static int ANIMAL_HEIGHT = 23;
  // Image interception start Y coordinate
  private final static int ANIMAL_OFFSET_TOP = 359;
  // Animals showing width and height
  private final static int ANIMAL_DISPLAY_WIDTH = 68;
  private final static int ANIMAL_DISPLAY_HEIGHT = 46;
  // total frames
  private final static int MAX_FRAMES = 4;
  private final static int speed = 4;
  
  private int screenWidth;
  private float animalY;

  private int frame = 0;
  private float stepX = 0;
  private PVector position = null;
  private PImage[] IMG_ANIMAL_LEFT = null;

  /*
* initialization
   * screenWidth: screen width
   * groundY: ground Y coordinate
  */
  public void init(int screenWidth, float groundY){
    this.screenWidth = screenWidth;
    // The Y coordinate of the animal display is fixed
    this.animalY = groundY - ANIMAL_DISPLAY_HEIGHT + 2;
    PImage animalImgLoad = loadImage("cattle.png");
    IMG_ANIMAL_LEFT = new PImage[MAX_FRAMES];
    for (int i = 0; i < MAX_FRAMES; i++) {
      IMG_ANIMAL_LEFT[i] = animalImgLoad.get(ANIMAL_WIDTH*i, ANIMAL_OFFSET_TOP, ANIMAL_WIDTH - 3, ANIMAL_HEIGHT);
    }
  }

  /*
   * restar
  */
  public void restart(){
    this.frame = 0;
    this.stepX = 0;
    this.position = null;
  }

  /*
  * move animals
   * manTopLeftX: protagonist boundary: upper left X coordinate
   * manTopLeftY: protagonist boundary: upper left Y coordinate
   * manBottomRightX: protagonist boundary: bottom right X coordinate
   * manBottomRightY: protagonist boundary: bottom right Y coordinate
   *
   * Returns whether a collision occurred
  */
  private boolean move(float manTopLeftX, float manTopLeftY, float manBottomRightX, float manBottomRightY) {
    boolean crashed = false;
    // if there are no animals
    if (this.position == null) {
      // generate new animals
      this.newAnimal();
    } else {
      // Move the animal, check the collision between the protagonist and the animal
      crashed = this.moveAndCheck(manTopLeftX, manTopLeftY, manBottomRightX, manBottomRightY);
    }

    // if there are animals
    if (this.position != null) {
      // If the animal has moved off the screen
      if (position.x + ANIMAL_DISPLAY_WIDTH < 0 || position.x > this.screenWidth) {
        // restart
        this.restart();
      } else {
        // show animals
        this.displayAnimals();
      }
    }

    return crashed;
  }

  /*
  * Move the animal, check the collision between the protagonist and the animal
   * manTopLeftX: protagonist boundary: upper left X coordinate
   * manTopLeftY: protagonist boundary: upper left Y coordinate
   * manBottomRightX: protagonist boundary: bottom right X coordinate
   * manBottomRightY: protagonist boundary: bottom right Y coordinate
   *
   * Returns whether a collision occurred
  */
 public boolean moveAndCheck(float manTopLeftX, float manTopLeftY, float manBottomRightX, float manBottomRightY) {
    // move Place
    position.add(stepX * -1, 0);
    frame = (frame + 1) % (MAX_FRAMES * speed);

    // Determine if a collision has occurred
    if (manBottomRightX < position.x ||                     // man on left of animal
        manTopLeftX > (position.x + ANIMAL_DISPLAY_WIDTH) ||  // man on the right of animal
        manTopLeftY > (position.y + ANIMAL_DISPLAY_HEIGHT) || // man under animals
        manBottomRightY < position.y)                       // man on top of animals
    {
      // no collision
      return false;
    } else {
      // collision
      return true;
    }
 }

  //show animals
  
  private void displayAnimals() {
    imageMode(CORNER);

// move to the left
    // 1/speed double speed
    image(this.IMG_ANIMAL_LEFT[frame/speed], this.position.x, this.position.y, ANIMAL_DISPLAY_WIDTH, ANIMAL_DISPLAY_HEIGHT);
  }

  //generate new animals
 
  private void newAnimal() {
    // Determine whether animals need to be generated this time: random number prevents
    if (random(100) > 10)
      return;

    // Animals only spawn on the far right of the screen
    float positionX  = this.screenWidth;
    // Each movement distance is randomly generated between the minimum and maximum
    this.stepX = random(ANIMAL_STEP_MIN, ANIMAL_STEP_MAX);

    this.position = new PVector(positionX, this.animalY);
  }
}
