import java.awt.AWTException;
import java.awt.Rectangle;
import java.awt.Robot;
import java.util.ArrayList;
import java.util.Collections;
import processing.core.PApplet;
import javax.swing.JOptionPane;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

//when in doubt, consult the Processsing reference: https://processing.org/reference/

int margin = 450; //set the margin around the squares
final int padding = 50; // padding between buttons and also their width/height
final int buttonSize = 40; // padding between buttons and also their width/height
ArrayList<Integer> trials = new ArrayList<Integer>(); //contains the order of buttons that activate in the test
int trialNum = 0; //the current trial number (indexes into trials array above)
int startTime = 0; // time starts when the first click is captured
int finishTime = 0; //records the time of the final click
int hits = 0; //number of successful clicks
int misses = 0; //number of missed clicks
Robot robot; //initialized in setup 
float t = 0;
int initialmouseX = 0;
int initialmouseY = 0;

int lastClickTime = 0;
int startClickTime = 0;
int previousClickTime = 0;
int hit_miss = 0;
int numRepeats = 1; //sets the number of times each button repeats in the test

int participantID = -1; // Initialize participant ID to -1

void setup()
{
 // fullScreen();
  size(1200, 1200); // set the size of the window
  //noCursor(); //hides the system cursor if you want
  noStroke(); //turn off all strokes, we're just using fills here (can change this if you want)
  textFont(createFont("Arial", 16)); //sets the font to Arial size 16
  textAlign(CENTER);
  frameRate(60);
  ellipseMode(CENTER); //ellipses are drawn from the center (BUT RECTANGLES ARE NOT!)
  //rectMode(CENTER); //enabling will break the scaffold code, but you might find it easier to work with centered rects
  
  try {
    robot = new Robot(); //create a "Java Robot" class that can move the system cursor
  } 
  catch (AWTException e) {
    e.printStackTrace();
  }

  //===DON'T MODIFY MY RANDOM ORDERING CODE==
  for (int i = 0; i < 16; i++) //generate list of targets and randomize the order
      // number of buttons in 4x4 grid
    for (int k = 0; k < numRepeats; k++)
      // number of times each button repeats
      trials.add(i);

  Collections.shuffle(trials); // randomize the order of the buttons
  //System.out.println("trial order: " + trials);
  
  surface.setLocation(0,0);// put window in top left corner of screen (doesn't always work)
  
  
  // Prompt the user for their participant ID
  String inputID = JOptionPane.showInputDialog("Enter your participant ID (a unique number):");
  if (inputID != null && !inputID.isEmpty()) {
    participantID = int(inputID);
    //print(participantID);
  } else {
    // Handle the case where the user didn't enter an ID (optional)
    // You can display an error message, exit the program, or take other actions.
  }
}


void draw()
{
  startClickTime = millis();
  background(0); //set background to black
  noCursor();
  
  fill(255); //set text color to white
  text("Initial Cursor Position: X=" + initialmouseX + ", Y=" + initialmouseY, 0.25*width, 0.20*height);
  
  if (trialNum >= trials.size()) //check to see if test is over
  {
    float timeTaken = (finishTime-startTime) / 1000f;
    float penalty = constrain(((95f-((float)hits*100f/(float)(hits+misses)))*.2f),0,100);
    fill(255); //set fill color to white
    //write to screen (not console)
    text("Finished!", width / 2, height / 2); 
    text("Hits: " + hits, width / 2, height / 2 + 20);
    text("Misses: " + misses, width / 2, height / 2 + 40);
    text("Accuracy: " + (float)hits*100f/(float)(hits+misses) +"%", width / 2, height / 2 + 60);
    text("Total time taken: " + timeTaken + " sec", width / 2, height / 2 + 80);
    text("Average time for each button: " + nf((timeTaken)/(float)(hits+misses),0,3) + " sec", width / 2, height / 2 + 100);
    text("Average time for each button + penalty: " + nf(((timeTaken)/(float)(hits+misses) + penalty),0,3) + " sec", width / 2, height / 2 + 140);
    return; //return, nothing else to do now test is over
  }
  
  // Display current target position
  Rectangle currentTargetBounds = getButtonLocation(trials.get(trialNum));
  fill(255); //set text color to white
  text("Current Target Position: X=" + (currentTargetBounds.x + currentTargetBounds.width/2) + ", Y=" + (currentTargetBounds.y + currentTargetBounds.height/2), 0.25*width, 0.25*height);
  text("Target Width=" + currentTargetBounds.width, 0.25*width, 0.30*height);
  text("Time taken to click the previous button: " + nf((float)lastClickTime/1000, 0, 2) + " sec", 0.25*width, 0.35*height);
  text("Hit/ Miss on Previous click:" + hit_miss, 0.20*width, 0.40*height);
  text("Participant ID" + participantID, 0.20*width, 0.15*height);
  
  fill(255); //set fill color to white
  text((trialNum + 1) + " of " + trials.size(), 40, 20); //display what trial the user is on
  
  for (int i = 0; i < 16; i++)// for all button
    drawButton(i); //draw button

  //fill(0, 255, 255); // Make cursor Cyan
  //ellipse(mouseX, mouseY, 20, 20); //draw user cursor as a circle with a diameter of 20
  
  Rectangle bounds = getButtonLocation(trials.get(trialNum));
  
  //check to see if mouse cursor is inside button 
  if ((mouseX > bounds.x && mouseX < bounds.x + bounds.width) && (mouseY > bounds.y && mouseY < bounds.y + bounds.height)) // test to see if hit was within bounds
  {
    stroke(10, 255, 10);
    fill(10, 255, 10); // Make cursor Bright green
    ellipse(mouseX, mouseY, 10, 10); //draw user cursor as a circle with a diameter of 10
    stroke(0, 0, 0);
  } 
  else
  {
    stroke(10, 255, 10);
    fill(10, 255, 10); // Make cursor Bright green
    ellipse(mouseX, mouseY, 22, 22); //draw user cursor as a circle with a diameter of 20
    stroke(0, 0, 0);
    
    // When the cursor is outside the square add a stroke
    stroke(255, 255, 255);
    strokeWeight(3);
    line(mouseX, mouseY, bounds.x + buttonSize/2, bounds.y + buttonSize/2);
    stroke(0, 0, 0);
  }
  
  t += 0.3; // This controls the speed of flashing, higher value = faster
}

void mousePressed() // test to see if hit was in target!
{
  if (trialNum >= trials.size()) //if task is over, just return
    return;

  if (trialNum == 0) //check if first click, if so, start timer
    startTime = millis();

  if (trialNum == trials.size() - 1) //check if final click
  {
    finishTime = millis();
    //write to terminal some output. Useful for debugging too.
    //println("we're done!");
  }

  Rectangle bounds = getButtonLocation(trials.get(trialNum));

 //check to see if mouse cursor is inside button 
  if ((mouseX > bounds.x && mouseX < bounds.x + bounds.width) && (mouseY > bounds.y && mouseY < bounds.y + bounds.height)) // test to see if hit was within bounds
  {
   // System.out.println("HIT! " + trialNum + " " + (millis() - startTime)); // success
    hit_miss = 1;
    hits++; 
  } 
  else
  {
    //System.out.println("MISSED! " + trialNum + " " + (millis() - startTime)); // fail
    misses++;
    hit_miss = 0;
  }

  trialNum++; //Increment trial number

  //in this example code, we move the mouse back to the middle
  //robot.mouseMove(width/2, (height)/2); //on click, move cursor to roughly center of window!
    
  initialmouseX = mouseX;
  initialmouseY = mouseY;
   
  if (previousClickTime != 0) { // Check to ensure this is not the first click
    lastClickTime = millis() - previousClickTime; // Calculate time taken since the previous click
  }
  
  previousClickTime = millis(); // Update the time of the previous click
  
  Rectangle currentTargetBounds = getButtonLocation(trials.get(trialNum));
  displayTextAndWriteToFile(trialNum + "," + participantID + "," + initialmouseX + "," + initialmouseY + "," + (currentTargetBounds.x + currentTargetBounds.width/2) + "," + 
   (currentTargetBounds.y + currentTargetBounds.height/2) + "," + currentTargetBounds.width + "," + 
    nf((float)lastClickTime/1000) + "," +  hit_miss, 0.25*width, 0.5*height);
}  

//probably shouldn't have to edit this method
Rectangle getButtonLocation(int i) //for a given button ID, what is its location and size
{
   int x = (i % 4) * (padding + buttonSize) + margin;
   int y = (i / 4) * (padding + buttonSize) + margin;
   return new Rectangle(x, y, buttonSize, buttonSize);
}

//you can edit this method to change how buttons appear
void drawButton(int i)
{
  Rectangle bounds = getButtonLocation(i);
  if (trials.get(trialNum) == i) // see if current button is the target
  {
    float redIntensity = (sin(t) + 1) * 0.5; // This will range from 0 to 1
    if (redIntensity > 0.5) {
      fill(255, 0, 0); // Red
    } else {
      fill(225, 255, 255); // White
    }
  }
  else
  {
    fill(200); 
  }

  rect(bounds.x, bounds.y, bounds.width, bounds.height); //draw button
}

void displayTextAndWriteToFile(String txt, float x, float y) {
  fill(255);
  text(txt, x, y); // Display the text on screen
  println(txt);

  try (BufferedWriter writer = new BufferedWriter(new FileWriter("output.txt", true))) {
    writer.write(txt); // Write the text to the file
    writer.newLine();  // Add a new line for the next text
  } catch (IOException e) {
    e.printStackTrace();
  }
}


void mouseMoved()
{
   //can do stuff everytime the mouse is moved (i.e., not clicked)
   //https://processing.org/reference/mouseMoved_.html
   
}

void mouseDragged()
{
  //can do stuff everytime the mouse is dragged
  //https://processing.org/reference/mouseDragged_.html
}

void keyPressed() 
{
  //can use the keyboard if you wish
  //https://processing.org/reference/keyTyped_.html
  //https://processing.org/reference/keyCode.html
}
