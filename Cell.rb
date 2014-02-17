#Definition of class Cell
class Cell
  
  #attribute definition
  attr_accessor :x, :y, :live_neighbor, :state
  def initialize(state,x,y)
    @state=state
    @x=x
    @y=y
  end
  
  #Cell state modifiers, 1 represents a live cell and 0 a dead cell  
  def live
    @state=1
  end
  def die
    @state=0
  end
  
  #Function to get state of an adjacent cell and count number of neighbors living cells
  def get_next_state(matrix,x2,y2)
    if 1==matrix[[@x+x2,@y+y2]].state
      @live_neighbor=@live_neighbor.to_i+1
    end
  end
  
  #Function to get number of living neighbors
  def get_neighbor(matrix)
    @live_neighbor=0
    get_next_state(matrix,0,1)   #NORTH
    get_next_state(matrix,1,1)   #NORTHEAST
    get_next_state(matrix,1,0)   #EAST
    get_next_state(matrix,1,-1)  #SOUTHEAST
    get_next_state(matrix,0,-1)  #SOUTH
    get_next_state(matrix,-1,-1) #SOUTHWEST
    get_next_state(matrix,-1,0)  #WEST
    get_next_state(matrix,-1,1)  #NORTHWEST
  end
end
#End definition of Cell class

#Function to make new cells and put them in the grid
def set_cell(matrix,cell,state,x,y)
    cell=Cell.new(state,x,y)
    matrix[[cell.x,cell.y]]=cell
end

#Function to generate the next grid or world and set cells state
def state_next_gen(matrix,next_matrix,x,y)
  #Get number of neighbors
  matrix[[x,y]].get_neighbor(matrix)
  #Rules for live cells
  if matrix[[x,y]].state==1
    if matrix[[x,y]].live_neighbor<2||matrix[[x,y]].live_neighbor>3
      next_matrix[[x,y]].die
    else next_matrix[[x,y]].live
    end
  #Rules for dead cells
  else
    if matrix[[x,y]].live_neighbor==3
      next_matrix[[x,y]].live
    else next_matrix[[x,y]].die
  end
  end
end

#Create 1° cell world ,next generation world and fill borders with dead cells
border=Cell.new(0,0,0)
world=Hash.new(border)
next_world=Hash.new(border)

#Fill worlds with cells
for i in (1..7) do
  for j in (1..7) do
    set_cell(world,"cell_#{i}#{j}",0,i,j)
    set_cell(next_world,"next_cell_#{i}#{j}",0,i,j)  
  end
end

#First Message
puts "***GAME OF LIFE***\n  The game results will be shown in a zeroes and ones grid (7x7)"
puts "  There, number 1 represents a living cell and number 0 a dead cell"
puts "  First, you will set the living cells typing their coordinates of the grid\n\n"

#Request first world configuration
x_coord=y_coord=0
current_cell=1
while true
  #Request coordinate X
  until (x_coord.instance_of? Fixnum) && x_coord>0 && x_coord<8 
    puts "Set X coordinate of cell No. #{current_cell} (number between 1 and 7)"
    x_coord= gets().to_i
  end
  #Request coordinate Y
  until (y_coord.instance_of? Fixnum) && y_coord>0 && y_coord<8 
    puts "Set Y coordinate of cell No. #{current_cell} (number between 1 and 7)"
    y_coord= gets().to_i
  end
  world[[x_coord,y_coord]].live
  puts "Do you want to put another cell? [yes/no]"
  if gets().chomp=="no"
    break
  else
    current_cell+=1
    x_coord=y_coord=0
  end
end


#Print first configuration
puts "\n*** First world configuration ***\n\n"
puts "    1  2  3  4  5  6  7\n\n"
for i in (1..7) do
    print "#{i}>"
  for j in (1..7) do
    print "  #{world[[i,j]].state}"
  end
    print "\n"
end

#Generate next "k" worlds
for k in (1..10) do
  puts "\n\n  PRESS ANY KEY TO CONTINUE TO NEXT GENERATION"
  gets()
  #Get states of next cell world
  for i in (1..7) do
    for j in (1..7) do
      state_next_gen(world,next_world,i,j)
    end
  end
  #Print next world
  puts "\n****** #{k} generation ******\n\n"
  puts "    1  2  3  4  5  6  7\n\n"
  for i in (1..7) do
    print "#{i}>"
    for j in (1..7) do
      print "  #{next_world[[i,j]].state}"
    end
    print "\n"
  end
  #Refresh cells state(tick) 
  for i in (1..7) do
    for j in (1..7) do
      world[[i,j]].state=next_world[[i,j]].state
    end
  end
end

puts"\n\n  PRESS ANY KEY TO EXIT"
gets()
