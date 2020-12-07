#Une fois le réseau de petri cree, la seule var qui peut changer en fct de l'état du sytème est jetons
#Place est mutable car on doit changer une var

#------Place------#
mutable struct Place
    nom::String
    id::Int16
    jetons::Int16
end


#------Transition------#
struct ArcFrom
    from::Int16
    capacite::Int16
end

struct ArcTo
    to::Int16
    capacite::Int16
end

struct Transition
    nom::String
    id::Int16
    arcsFrom::Array{ArcFrom}
    arcsTo::Array{ArcTo}
end


#------Evenement------#
struct Event
    name::String
    pointOnPlace::String
end


#------Petri------#
struct Petri
    places::Array{Place}
    transitions::Array{Transition}
    evenements::Array{Event}
end



#Constructeurs par defaut
Place() = Place("Undefined",0,-1)
Transition() = Transition("Undefined",0,[ArcFrom(-1,-1)],[ArcTo(-1,-1)])
Petri() = ([Place("Undefined",0,-1)], [Transition("Undefined",0,[ArcFrom(-1,-1)],[ArcTo(-1,-1)])],[Event("1", "2")])
