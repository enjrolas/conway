class Cell {
  int x;
  int y;
  boolean state=false;
  Cell(int _x, int _y) {
    x=_x;
    y=_y;
  }

  boolean getState()
  {
    return state;
  }

  void setState(boolean s)
  {
    state=s;
  }

  int calculateNumNeighbors(Cell[][][] cells, int index, boolean verbose) {
    int neighbors=0;
    for (int i=-1; i<=1; i++)
      for (int j=-1; j<=1; j++)
      {
        if (!((i==0) && (j==0)))
        {
          try {
            if (verbose)
            {
              println(" checking neighbors for cell "+x+", "+y+", "+ index+":  "+(x+i)+", "+(y+j));
            }


            if (cells[x+i][y+j][index].getState())
              neighbors++;
          }
          catch(Exception e)
          {
          }
        }
      }
    if (verbose)
      println();
    return neighbors;
  }
  void update(Cell[][][] cells, int index)
  {
    int otherIndex;
    if (index==0)
      otherIndex=1;
    else
      otherIndex=0;
    int neighbors=calculateNumNeighbors(cells, index, false);
    if (state==true) {
      if (neighbors<2)  //loneliness rule
        cells[x][y][otherIndex].setState(false);
      else if (neighbors>3)  //overcrowding rule
        cells[x][y][otherIndex].setState(false);
      else
        cells[x][y][otherIndex].setState(true);
    }
    if ((state==false) && (neighbors==3))  //ressurection rule
      cells[x][y][otherIndex].setState(true);
  }
  void draw(int scale, color fillColor, color strokeColor)
  {
    if (state)
      fill(fillColor);
    else
      fill(255);
    stroke(strokeColor);
    rect(x*scale, y*scale, scale, scale);
  }
}

Cell [][][] cells;
boolean updating=true;
boolean step=false;
int xSize=100;
int ySize=100;
int scale=5;
int index=0;
void settings()
{
  size(xSize*scale*2, ySize*scale);
}

void setup() {
  cells=new Cell[xSize][ySize][2];
  randomSeed(0);
  for (int i=0; i<xSize; i++)
    for (int j=0; j<ySize; j++)
    {
      cells[i][j][0]=new Cell(i, j);
      cells[i][j][1]=new Cell(i, j);
    }
  randomSeedGame();
}

void randomSeedGame()
{
  for (int i=0; i<xSize; i++)
    for (int j=0; j<ySize; j++)
      if (random(100)>75)
        cells[i][j][index].setState(true);
}

void clearGame()
{
  for (int i=0; i<xSize; i++)
    for (int j=0; j<ySize; j++)
      cells[i][j][index].setState(false);
}

void mouseClicked()
{
  int x=int(mouseX/scale);
  int y=int(mouseY/scale);
  cells[x][y][index].setState(!cells[x][y][index].getState());
}

void keyPressed()
{
  if (key==' ')
    updating=!updating;
  if (key=='s')
    step=true;
  if (key=='c')
    clearGame();
  if (key=='r')
    randomSeedGame();
}

void draw() {
  background(255);
  if (step)
    updating=true;
    
  if (updating)
    for (int i=0; i<xSize; i++)
      for (int j=0; j<ySize; j++)
        cells[i][j][index].update(cells, index);
        
  int x=int(mouseX/scale);
  int y=int(mouseY/scale);
  int neighbors=cells[x][y][index].calculateNumNeighbors(cells, index, true);  //calculate the neighbors under the mouse pointer

  int otherIndex=index;
  if (index==0)
    index=1;
  else
    index=0;

  for (int i=0; i<xSize; i++)
    for (int j=0; j<ySize; j++)
    {
      color strokeColor=color(255);
      if ((x==i) && (y==j))
        strokeColor=color(255, 0, 0);
      cells[i][j][0].draw(scale, color(0), strokeColor);
    }
  translate(xSize*scale,0);
  for (int i=0; i<xSize; i++)
    for (int j=0; j<ySize; j++)
    {
      color strokeColor=color(255);
      if ((x==i) && (y==j))
        strokeColor=color(255, 0, 0);
      cells[i][j][1].draw(scale, color(0), strokeColor);
    }
  

  if (step)
  {
    updating=false;
    step=false;
  }
  textSize(30);
  fill(255, 0, 0);
  text(neighbors, mouseX+20, mouseY+20);
}
