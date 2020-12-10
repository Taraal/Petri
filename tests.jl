include("struct.jl")
include("functions.jl")
using Random


function testAffichagePetri(petri::Petri)
    println("Affichage complet")
    aff(petri)
    println("Affichage partiel")
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

function testSolMat()


    places = [Place("OFF",1,1), Place("ON",2,0),Place("Changement",3,0)]
    transitions = [Transition("Allumer",1,[ArcFrom(1,1), ArcFrom(3,1)],[ArcTo(2,1)]), Transition("Eteindre",2,[ArcFrom(2,1), ArcFrom(3,1)],[ArcTo(1,1)])]
    event = [Event("Action", "Changement")]

    instance = Petri( [places[1], places[2], places[3]], [transitions[1], transitions[2]], [event[1]] )

    #Etat initial
    result = matrices(instance)

    Mz = result[1]
    M = Mz
    U = result[2]
    X = (solMat(M,Mz,U))

    println(X)

    actionner(instance, "Action")
    transiter(instance, "Allumer")

    result = matrices(instance)
    M = result[1]
    U = result[2]
    X = solMat(M,Mz,U)

    println(X)

end

function testResolution()
    places = [Place("OFF",1,1), Place("ON",2,0),Place("Changement",3,0)]
    transitions = [Transition("Allumer",1,[ArcFrom(1,1), ArcFrom(3,1)],[ArcTo(2,1)]), Transition("Eteindre",2,[ArcFrom(2,1), ArcFrom(3,1)],[ArcTo(1,1)])]
    event = [Event("Action", "Changement")]
    instance = Petri( [places[1], places[2], places[3]], [transitions[1], transitions[2]], [event[1]] )

    places1 = [Place("P1",1,1), Place("P2",2,0),Place("P3",3,0)]
    transitions1 = [Transition("T1",1,[ArcFrom(1,1)],[ArcTo(2,1)]), Transition("T2",2,[ArcFrom(1,1)],[ArcTo(3,1), ArcTo(1,1)])]
    instance1 = Petri( [places1[1], places1[2], places1[3]], [transitions1[1], transitions1[2]], [] )

    places2 = [Place("P1",1,1), Place("P2",2,0),Place("P3",3,0)]
    transitions2 = [Transition("T1",1,[ArcFrom(1,1)],[ArcTo(2,1)]), Transition("T2",2,[ArcFrom(1,1)],[ArcTo(3,1), ArcTo(1,1)])]
    event2 = [Event("Action", "P1")]
    instance2 = Petri( [places2[1], places2[2], places2[3]], [transitions2[1], transitions2[2]], [event2[1]] )


    #result = resolution(instance, [0,1,0])
    #println(result)


    result = resolution(instance1, [0,1,1])
    println(result)

    #result = resolution(instance2, [0,1,1])
    #println(result)

end





function main()
    places = [Place("P1",1,1), Place("P2",2,0),Place("P3",3,1)]
    transitions = [Transition("T1",1,[ArcFrom(1,1), ArcFrom(3,1)],[ArcTo(2,1)]), Transition("T2",2,[ArcFrom(2,1), ArcFrom(3,1)],[ArcTo(1,1)])]
    event = [Event("Action", "P3")]
    petri = Petri( [places[1], places[2], places[3]], [transitions[1], transitions[2]], [event[1]] )

    #testAffichagePetri(petri)          #Test Affichage
    #testFranchissable(petri,"T1")      #Franchissable
    #testFranchissable(petri,"T2")      #Non franchissable
    #testTransiter(petri,"T1")          #T1 Franchissable
    #testTransiterAlea(petri)           #Aleatoire
    #testActionner("Action")            #Action sur P3
    #testMatrices(petri)                #Creation de matrices a partir d'un Petri object
    #testReseau(petri)                  #Creation reseau a partir de matrices
    #testSolMat()                       #Test fonction solMat
    #testResolution()                   #Test fonction résolution
end


main()
