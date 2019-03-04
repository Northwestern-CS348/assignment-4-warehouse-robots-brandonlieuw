(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
      :parameters (?r - robot ?loc1 - location ?loc2 - location)
      :precondition (and (connected ?loc1 ?loc2) (at ?r ?loc1) (no-robot ?loc2))
      :effect (and (at ?r ?loc2) (no-robot ?loc1) (not (at ?r ?loc1)) (not (no-robot ?loc2)))
   )
   
   (:action robotMoveWithPallette
      :parameters (?r - robot ?loc1 - location ?loc2 - location ?p - pallette)
      :precondition (and (connected ?loc1 ?loc2) (at ?r ?loc1) (no-robot ?loc2) (no-pallette ?loc2) (at ?p ?loc1))
      :effect (and (at ?r ?loc2) (not (at ?r ?loc1)) 
        (no-robot ?loc1) (not (no-robot ?loc2))
        (no-pallette ?loc1) (not (no-pallette ?loc2)) 
        (at ?p ?loc2) (not (at ?p ?loc1)))
   )
   
   (:action moveItemFromPalletteToShipment
      :parameters (?s - shipment ?o - order ?l - location ?si - saleitem ?p - pallette)
      :precondition (and (ships ?s ?o) (packing-at ?s ?l) (at ?p ?l) (orders ?o ?si) (contains ?p ?si) (started ?s) (not (includes ?s ?si)))
      :effect (and (not (contains ?p ?si)) (includes ?s ?si))
   )
   
   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (started ?s) (packing-at ?s ?l) (ships ?s ?o) (packing-location ?l))
      :effect (and (complete ?s) (not (started ?s)) (available ?l))
   )

)
