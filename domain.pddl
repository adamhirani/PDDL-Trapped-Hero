(define (domain Dungeon)

    (:requirements
        :typing
        :negative-preconditions
    )

    (:types
        swords cells traps monsters
    )

    (:predicates
        ;Hero's cell location
        (at-hero ?loc - cells)
        
        ;Sword cell location
        (at-sword ?s - swords ?loc - cells)
        
        ;Indicates if a cell location has a monster
        (has-monster ?loc - cells)
        
        ;Indicates if a cell location has a trap
        (has-trap ?loc - cells)
        
        ;Indicates if a chell or sword has been destroyed
        (is-destroyed ?obj)
        
        ;connects cells
        (connected ?from ?to - cells)
        
        ;Hero's hand is free
        (arm-free)
        
        ;Hero's holding a sword
        (holding ?s - swords)
    
        ;It becomes true when a trap is disarmed
        (trap-disarmed ?loc)
        
    )

    ;Hero can move if the
    ;    - hero is at current location
    ;    - cells are connected, 
    ;    - there is no trap in current loc, and 
    ;    - destination does not have a trap/monster/has-been-destroyed
    ;Effects move the hero, and destroy the original cell. No need to destroy the sword.
    (:action move
        :parameters (?from ?to - cells)
        :precondition (and 
            (at-hero ?from)
            (connected ?from ?to)
            (not(has-trap ?from))
            (not(has-trap ?to))
            (not(has-monster ?to))
            (not(is-destroyed ?to))

                            
                            
        )
        :effect (and 
                     (at-hero ?to)
                     (is-destroyed ?from)       
                )
    )
    
    ;When this action is executed, the hero gets into a location with a trap
    ;   - hero is at a current location
    ;   - has a trap
    ;   - cells are connected
    ;   - there is no monsters
    ;   - destination is not destroyed
    ;   - hero is not holding anything
    ;effects: move hero, destroy original cell
    (:action move-to-trap
        :parameters (?from ?to - cells)
        :precondition (and 
            (at-hero ?from)
            (has-trap ?to)
            (connected ?from ?to)
            (not(has-monster ?to))
            (not(is-destroyed ?to))
            (not(trap-disarmed ?to))
            (not(trap-disarmed ?from))
            (arm-free)

                            
        )
        :effect (and 
                     (at-hero ?to)
                     (is-destroyed ?from)       
                )
    )

    ;When this action is executed, the hero gets into a location with a monster
    ;   - hero is at a current location
    ;   - has a monster
    ;   - cells connected
    ;   - there is no trap
    ;   - dest not destroyed
    ;   - hero holding something
    ;effects: move hero, destroy original cell
    (:action move-to-monster
        :parameters (?from ?to - cells ?s - swords)
        :precondition (and 
            (at-hero ?from)
            (has-monster ?to)
            (connected ?from ?to)
            (not(has-trap ?to))
            (not(is-destroyed ?to))
            (not(arm-free))
                            
        )
        :effect (and 
                    (at-hero ?to)
                    (is-destroyed ?from)        
                )
    )
    
    ;Hero picks a sword if he's in the same location
    ;   - hero is at a current location
    ;   - location has a sword
    ;   - arm is free
    ;   - not holding sword
    ;effect, arm is not free, holding
    (:action pick-sword
        :parameters (?loc - cells ?s - swords)
        :precondition (and 
            (at-hero ?loc)
            (at-sword ?s ?loc)
            (arm-free)
            (not(holding ?s))
                            
                      )
        :effect (and
                  (at-hero ?loc)
                  (not(arm-free))
                  (holding ?s)        
                )
    )
    
    ;Hero destroys his sword. 
    ;   - at a current location
    ;   - location has no monster
    ;   - location has no trap
    ;   - has sword
    ;effect: destroys sword, not holding
    (:action destroy-sword
        :parameters (?loc - cells ?s - swords)
        :precondition (and 
                          (at-hero ?loc)
                          (not(has-monster ?loc))
                          (not(has-trap ?loc))
                          (not(arm-free))
                          (not(is-destroyed ?loc))
                          (not(is-destroyed ?s))

         
                      )
        :effect (and
                          (arm-free) 
                          (at-hero ?loc) 
                          (not(holding ?s))
                )
    )
    
    ;Hero disarms the trap with his free arm
    ;   - at current location
    ;   - location has a trap
    ;   - trap is not disarmed
    ;  
    ;effect:trap is disarmed
    (:action disarm-trap
        :parameters (?loc - cells)
        :precondition (and 
                           (at-hero ?loc)
                           (has-trap ?loc)
                           (not(trap-disarmed ?loc)) 
                      )
        :effect (and
                     (not(has-trap ?loc))  
                     (at-hero ?loc)     
                )
    )
    
)