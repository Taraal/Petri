include("struct.jl")
include("functions.jl")
using Random

#------<BSE>------#
placesBSE = [Place("OFF",1,1), Place("ON",2,0),Place("Changement",3,0)]
transitionsBSE = [Transition("Allumer",1,[ArcFrom(1,1), ArcFrom(3,1)],[ArcTo(2,1)]), Transition("Eteindre",2,[ArcFrom(2,1), ArcFrom(3,1)],[ArcTo(1,1)])]
eventBSE = [Event("Action", "Changement")]

bse = Petri( [placesBSE[1], placesBSE[2], placesBSE[3]], [transitionsBSE[1], transitionsBSE[2]], [eventBSE[1]] )
#-----------------#

#Fonction main
#mainAleaScript(bse)

matrices(bse)
