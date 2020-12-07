include("struct.jl")
include("functions.jl")
using Random


function testAffichagePetri(petri::Petri)
    aff(petri)
    repr(petri)
end

function testFranchissable(petri::Petri, TrName::String)
    result = franchissable(petri, TrName)
    if result
        println("Franchissable")
    else
        println("Non franchissable")
    end

end

function testTransiter(petri::Petri, TrName::String)
    repr(petri)
    println(" ")
    transiter(petri, TrName)
    repr(petri)
end

function testTransiterAlea(petri::Petri)
    transiterAlea(petri)
end

function testActionner(nomAction::String)
    #Petri propre a la fonction car jetonsP3 = 0
    places = [Place("P1",1,1), Place("P2",2,0),Place("P3",3,0)]
    transitions = [Transition("T1",1,[ArcFrom(1,1), ArcFrom(3,1)],[ArcTo(2,1)]), Transition("T2",2,[ArcFrom(2,1), ArcFrom(3,1)],[ArcTo(1,1)])]
    event = [Event("Action", "P3")]
    petri = Petri( [places[1], places[2], places[3]], [transitions[1], transitions[2]], [event[1]] )

    repr(petri)
    println(" ")

    actionner(petri, nomAction)

    repr(petri)
    println(" ")

    if franchissable(petri, "T1")
        transiter(petri, "T1")
    end

    repr(petri)
end


function testMatrices(petri::Petri)
    aff(petri)
    result = matrices(petri)
    M = result[1]
    U = result[2]
    UPlus = result[3]
    UMoins = result[4]
    println("M : $M")
    println("U : $U")
    println("UPlus : $UPlus")
    println("UMoins : $UMoins")
end

function testReseau(petri::Petri)
    result = matrices(petri)
    M = result[1]
    UPlus = result[3]
    UMoins = result[4]

    newR = reseau(UPlus, UMoins, M)
    println(petri.places)
    println(newR.places)
    println(" ")
    println(petri.transitions)
    println(newR.transitions)
    println(" ")
    println(petri.evenements)
    println(newR.evenements)
end

function main()
    places = [Place("P1",1,1), Place("P2",2,0),Place("P3",3,1)]
    transitions = [Transition("T1",1,[ArcFrom(1,1), ArcFrom(3,1)],[ArcTo(2,1)]), Transition("T2",2,[ArcFrom(2,1), ArcFrom(3,1)],[ArcTo(1,1)])]
    event = [Event("Action", "P3")]
    petri = Petri( [places[1], places[2], places[3]], [transitions[1], transitions[2]], [event[1]] )

    #testAffichagePetri(petri)
    #testFranchissable(petri,"T1")      #Franchissable
    #testFranchissable(petri,"T2")      #Non franchissable
    #testTransiter(petri,"T1")          #T1 Franchissable
    #testTransiterAlea(petri)           #Aleatoire
    #testActionner("Action")            #Action sur P3
    #testMatrices(petri)                #Creation de matrices a partir d'un Petri object
    #testReseau(petri)                  #Creation reseau a partir de matrices
end


main()
