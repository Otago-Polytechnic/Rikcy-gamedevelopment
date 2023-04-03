// Nischal Bhandari and Ricky(Jie Xu)
//1000111904 and 1000068349)


class Coins {
  // coin width and height
  private final int COIN_WIDTH = 30;
  private final int COIN_HEIGHT = 30;
  //The maximum number of gold coins on the screen
  private final int COIN_MAX = 2;
  
  private int screenWidth;
  private float minY;
  private float maxY;
  private int goal;
  
  private int score;
  private ArrayList<PVector> coinPositions;
  private PImage coinImg = loadImage("coin.png");

  /*
   * initialization
   * screenWidth: screen width
   * groundY: ground Y coordinate
   * maxHeightFromGround: The maximum height from the ground when generating gold coins
  */
  public void init(int screenWidth, float groundY, float maxHeightFromGround){
    this.screenWidth = screenWidth;
    this.maxY = groundY - COIN_HEIGHT;
    this.minY = this.maxY - maxHeightFromGround ;
    this.score = 0;
    this.coinPositions = new ArrayList<PVector>();
    this.coinImg = loadImage("coin.png");
  }

  /*
   * restart
   * goal: target score
  */
  public void restart(int goal){
    this.goal = goal;
    this.score = 0;
    this.coinPositions.clear();
  }

  /*
  * Move gold coins in the opposite direction to the protagonist's movement
   * moveX: The amount of movement in the X-axis direction
   * manTopLeftX: protagonist boundary: upper left X coordinate
   * manTopLeftY: protagonist boundary: upper left Y coordinate
   * manBottomRightX: protagonist boundary: bottom right X coordinate
   * manBottomRightY: protagonist boundary: bottom right Y coordinate
   *
   * Returns whether the target score has been reached
  */
  private boolean move(float moveX, float manTopLeftX, float manTopLeftY, float manBottomRightX, float manBottomRightY) {
    // Check the collision between the protagonist and the gold coin
    this.moveAndCheck(moveX, manTopLeftX, manTopLeftY, manBottomRightX, manBottomRightY);
    // generate new coins
    this.newCoin();
    // show score
    this.displayScore();
    // show coins
    this.displayCoins();
    
    return this.score >= this.goal;
  }

  /*
  * Move the gold coin, check the collision between the protagonist and the gold coin
   * moveX: The amount of movement in the X-axis direction
   * manTopLeftX: protagonist boundary: upper left X coordinate
   * manTopLeftY: protagonist boundary: upper left Y coordinate
   * manBottomRightX: protagonist boundary: bottom right X coordinate
   * manBottomRightY: protagonist boundary: bottom right Y coordinate
  */
 private void moveAndCheck(float moveX, float manTopLeftX, float manTopLeftY, float manBottomRightX, float manBottomRightY) {
    // move all coins
    for (int i = this.coinPositions.size() - 1; i >= 0; i--) {
      PVector coinPosition = this.coinPositions.get(i);
      coinPosition.add(moveX, 0);

      // Determine if a collision has occurred
      boolean crashed;
      if (manBottomRightX < coinPosition.x ||           // man on the left of the coin
          manTopLeftX > (coinPosition.x + COIN_WIDTH) ||  // man on the right of the coin
          manTopLeftY > (coinPosition.y + COIN_HEIGHT) || // man under the coin
          manBottomRightY < coinPosition.y)             // man on gold coin
      {
        crashed = false;
      } else {
        crashed = true;
      }
      // If the protagonist collides with the gold coin, score and remove the gold coin at the same time
      // if ((manBottomRightX > coinPosition.x && manTopLeftX < coinPosition.x + COIN_WIDTH) &&
      //     (manTopLeftY < coinPosition.y + COIN_HEIGHT && manBottomRightY > coinPosition.y)) {
      if(crashed) {
        this.score++;
        this.coinPositions.remove(i); 
      } else if (coinPosition.x + COIN_WIDTH < 0 || coinPosition.x > this.screenWidth) {
        // Gold coins out of the screen, remove
        this.coinPositions.remove(i); 
      }
    }
 }

  //show score
  
  private void displayScore() {
    // background
    fill(0);
    rectMode(CORNER);
    rect(this.screenWidth - 110, 5, 110, 30);
    // score
    fill(#FFF936);
    textAlign(LEFT);
    textSize(18);
    text("Score:  " + this.score, this.screenWidth - 100, 25 );
  }

  // show coin
  private void displayCoins() {
    imageMode(CORNER);
    for (int i = 0; i< coinPositions.size(); i++) {
      image(coinImg, coinPositions.get(i).x, coinPositions.get(i).y, COIN_WIDTH, COIN_HEIGHT);
    }
  }

 //generate new coins
  private void newCoin() {
    int count = this.coinPositions.size();
    // has reached the limit
    if (count >= COIN_MAX)
      return;

    //Determine whether gold coins need to be generated this time: random number block
    if (random(100) > 10)
      return;

    // Determine whether to generate gold coins this time
    if (count > 0 && this.screenWidth - this.coinPositions.get(count - 1).x < this.screenWidth/COIN_MAX/2 )
      return;

    // Gold coins only spawn on the far right of the screen
    float x  = this.screenWidth;
    //The ordinate is randomized between ground and highest
    float y = random(this.minY, this.maxY);

    this.coinPositions.add(new PVector(x, y));
  }
  
  // return target score
  public int getGoal() {
    return this.goal;
  }
  
  // return current score
  public int getScore() {
    return this.score;
  }
}
