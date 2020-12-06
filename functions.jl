#Coder une fct d'aff graphique (dessin) ?



#-----------Affichage de la structure Petri et de ses composants-----------#
function aff(petriInstance::Petri)

    println("La structure de petri contient $(size(petriInstance.places)[1]) Places et $(size(petriInstance.transitions)[1]) Transitions")
    println(" ")

    for p in petriInstance.places
        println("Place $(p.nom), numero $(p.id). Elle contient $(p.jetons) jetons")
    end
    println(" ")
    for t in petriInstance.transitions
        println("Transition $(t.nom), numero $(t.id).")
        for af in t.arcsFrom
            println("- Elle a un arc entrant de capacité $(af.capacite) venant de la Place numero $(af.from)")
        end
        for at in t.arcsTo
            println("- Elle a un arc sortant de capacité $(at.capacite) allant vers la Place numero $(at.to)")
        end
        println(" ")
    end
end

#-----------Affichage des Places de la structure Petri-----------#
function repr(petriInstance::Petri)
    for p in petriInstance.places
        println("Place $(p.nom), numero $(p.id). Elle contient $(p.jetons) jetons")
    end
end

#-----------Determine si une Transition est franchissable-----------#
function franchissable(petriInstance::Petri, nomTransition::String)
    cpt1 = 0
    cpt2 = 0

    #On parcourt toutes les transitions
    for t in petriInstance.transitions
        #Si on trouve celle correspondant a notre requete
        if t.nom == nomTransition
            #Alors on partourt tous ses arcs entrants
            for af in t.arcsFrom
                cpt1 = cpt1 + 1
                #Pour chaque arc on parcourt tous les Places pour trouver celui auquel l'arc est relié
                for p in petriInstance.places
                    #Si on trouve un Place correspondant a l'arc entrant etudie
                    if p.id == af.from
                        #Si le Place a plus ou egal de jetons que la capacite de l'arc
                        if p.jetons >= af.capacite
                            cpt2 = cpt2 + 1
                        end
                    end
                end
            end
            if cpt1 == cpt2
                #println("Franchissable")
                return true
            else
                #println("Pas franchissable")
                return false
            end

        end
    end
    error("Transition non trouvée")
end

#-----------Effectue une transition-----------#
function transiter(petriInstance::Petri, nomTransition::String)

    #On parcourt toutes les transitions
    for t in petriInstance.transitions
        #Si on trouve celle correspondant a notre requete
        if t.nom == nomTransition
            #Parcourir arcs from
            for af in t.arcsFrom
                #Pour chaque arc on parcourt tous les Places pour trouver celui auquel l'arc est relié
                for p in petriInstance.places
                    #Si on trouve un Place correspondant a l'arc entrant etudie
                    if p.id == af.from
                        #On retire a la Place la capacite de l'arc en jetons
                        p.jetons = p.jetons - af.capacite
                    end
                end
            end
            #Parcourir arcs to
            for at in t.arcsTo

                #Pour chaque arc on parcourt tous les places pour trouver celui auquel l'arc est relié
                for p in petriInstance.places
                    #Si on trouve un place correspondant a l'arc entrant etudie
                    if p.id == at.to
                        #On ajoute a la Place la capacite de l'arc en jetons
                        p.jetons = p.jetons + at.capacite

                    end
                end
            end
            return true
        end
    end
end

#-----------Effectue une/des transition/s aleatoire-----------#
function transiterAlea(petriInstance::Petri)
    transitionsNames = String[]
    #Recuperations des noms des transitions
    for i in petriInstance.transitions
        push!(transitionsNames, i.nom)
    end

    #Choix aleatoire d'une transition
    currentT = transitionsNames[rand(1:size(transitionsNames)[1])]
    println("Transition aleatoire choisie : $currentT")

    estFranchi = (franchissable(petriInstance,currentT))    #Check si la transition est franchissable

    if estFranchi
        transiter(petriInstance,currentT)   #Si oui on active la transition
        println("Transition actionnee")
        println(" ")
        return true
    else
        println("Transition non franchissable")
        println(" ")
        return false
    end
end


#-----------Verifie l'etat du systeme quant aux transitions-----------#
function checkTransitionsState(petriInstance::Petri)
    #Parcourt des transitions
    for t in petriInstance.transitions
        #On teste pour chaque transition si elle est activable
        result = franchissable(petriInstance, t.nom)
        #Si il y en a au moins une d'activable, le systeme n'est pas bloque
        if result
            return true
        end
    end
    #Le systeme est bloque
    return false
end

#-----------Action-----------#
#Ajoute un jeton dans un evenement
function actionner(petriInstance::Petri, eventName::String)
    for p in petriInstance.places
        if p.nom == eventName
            p.jetons = p.jetons + 1
            return true
        end
    end
    error("Do not find event called : $eventName")
end

#-----------Script aleatoire-----------#
function mainAleaScript(petriInstance::Petri)

    while true
        result = checkTransitionsState(petriInstance)   #Etat des transitions
        if result   #Si on peut activer une transition

            println(" ")
            repr(petriInstance)             #Affichage etat des Places
            println(" ")
            transiterAlea(petriInstance)    #Transiter

        else        #Activer une action choisie au hasard
            println("Action enclenchee")
            nbEvent =  size(petriInstance.evenements)[1]
            if nbEvent != 0
                index = rand(1:nbEvent)
                actionner(petriInstance, petriInstance.evenements[index].pointOnPlace)
            end
        end
    end
end


#-----------Creation du vecteur de Marquage-----------#
function getM(petriInstance::Petri)
    #Array de zeros de la taille du nombre de places
    sortedById = zeros(Int8, size(petriInstance.places)[1])

    #Tri des objets par id, et tableau des jetons créé
    for p in petriInstance.places
        sortedById[(p.id)] = p.jetons
    end

    return sortedById
end

#-----------Creation des matrices U- et U+-----------#
function getUplusUmoins(petriInstance::Petri)
    i = size(petriInstance.places)[1]           #Nombre de places
    j = size(petriInstance.transitions)[1]      #Nombre de transitions

    uPlus = zeros(Int16, i, j)          #Array size : ixj, content : zeros
    uMoins = zeros(Int16, i, j)         #Array size : ixj, content : zeros

    #Pour chaque transition
    for t in petriInstance.transitions
        #Pour chaque arcFrom et ArcTo
        #i est egal à la place liée à l'arc
        #j vaut la transition actuelle
        #U+[i, j] vaut la capacité de l'arc
        for at in t.arcsTo
            uPlus[at.to, t.id] = at.capacite
        end

        for af in t.arcsFrom
            uMoins[af.from, t.id] = af.capacite
        end
    end
    return [uPlus, uMoins]
end



function matrices(petriInstance::Petri)
    M = getM(petriInstance)     #Vecteur de marquage

    ArraysU = getUplusUmoins(petriInstance)     #Matrices U+ et U-

    UPlus = ArraysU[1]
    UMoins = ArraysU[2]

    U = UPlus - UMoins
    return [M, U, UPlus, UMoins]
end

function reseau(UP, UM, Marq)
    places = Place[]

    for i = 1:size(Marq)[1]
        push!(places, Place("Place $i",i,Marq[i]))
    end

    transitions = Transition[]

    if (size(UP)[2]) != (size(UM)[2])
        error("Pas le meme nombre de transitions entre UPlus et UMoins")
    else
        for j = 1:size(UM)[2]
            arcsF = ArcFrom[]
            arcsT = ArcTo[]

            for i = 1:size(Marq)[1]
                if UP[i,j] != 0
                    push!(arcsT, ArcTo(i, UP[i,j]))
                end

                if UM[i,j] != 0
                    push!(arcsF, ArcFrom(i, UM[i,j]))
                end
            end
            push!(transitions, Transition("T $j", j, arcsF, arcsT))
        end
    end
    return Petri(places, transitions, [])
end
