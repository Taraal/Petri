include("struct.jl")
include("functions.jl")
using Random

#------<BSS>------#
placesBSS = [Place("OFF",1,1), Place("ON",2,0)]
transitionsBSS = [Transition("Allumer",1,[ArcFrom(1,1)],[ArcTo(2,1)]), Transition("Eteindre",2,[ArcFrom(2,1)],[ArcTo(1,1)])]

bss = Petri( [placesBSS[1], placesBSS[2]], [transitionsBSS[1], transitionsBSS[2]], [] )
#-----------------#

aff(bss)    #Etat BSS

#Si la transition est possible
estFranchi = (franchissable(bss,"Allumer"))

if estFranchi
    transiter(bss,"Allumer")    #Effectuer la transition
else
    println("Non franchissable")
end

aff(bss)    #Etat BSS
