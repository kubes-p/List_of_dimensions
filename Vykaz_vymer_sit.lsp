(defun LM:StringSubst ( new old str / inc len )
    (setq len (strlen new)
          inc 0
    )
    (while (setq inc (vl-string-search old str inc))
        (setq str (vl-string-subst new old str inc)
              inc (+ inc len)
        )
    )
    str
)

(defun c:vykaz_vymer_sit ( / file_ptr s entita typ_entity pre_precision vrcholy vrchol delka)
(vl-load-com)
	
	; --- upozornìní - bere pouze køivky
	
	(alert "Nutná kontrola: lisp ète pouze køivky a úseèky, neète napø. oblouky.\nPokud jsi tuto podmínku nezkontroloval, ukonèi pøíkaz a proveï jej po kontrole.\nPokud je vše v poøádku, vyber najednou všechny køivky a úseèky pro výpoèet kubatur.")	

	; --- nová verze lispu 2.0 (Excel 2.1)
	
	(alert "Od verze 2.0 je možné konkrétním obsahem názvu hladin kubatur pøedem pøipravit jednotky výstupu. Není to podmínkou, pokud nìkteré (nebo všechny) hladiny koncovky +m2+/+m+ nemají, u neoznaèených hladin bude výstup stejný jako døíve plocha i objem (viz manuál). ")
	
	; --- vytvoøení souboru txt
	
	(setq file_ptr (open (strcat (getvar 'dwgprefix) "Vykaz_vymer_sit.txt") "w"))
	
	; --- práce s výbìrem, zápis do souboru
	
	(setq pre_precision (getvar "luprec"))
	(setvar "luprec" 6)
	(princ "Vyber všechny køivky pro výpoèet kubatur.")
	    (if (setq s (ssget '((0 . "Lwpolyline,Line")) ))
		(progn
		    (setq i 0
			  n (sslength s)
		    )
		    (while (< i n)
			(setq entita (ssname s i)
			      typ_entity (cdr (assoc 0 (entget entita)))
			      i (+ 1 i)
			)
			;(print typ_entity)
			    (progn
				(if (= typ_entity "LINE")
				(progn
				    ;(print "úseèka")
				    (setq y (rtos (distance (cdr (assoc 10 (entget entita))) (cdr (assoc 11 (entget entita))) ) 2))
				    ;(print y)								; --- délka úseèky
				    (setq x (cdr (assoc 0 (entget entita)))				; --- typ entity
					  w (cdr (assoc 8 (entget entita)))				; --- hl kubatury
					  vrchol (car (cddr (assoc 10 (entget entita))))
					  vrcholk (car (cddr (assoc 11 (entget entita))))
				    )
				    (if (< vrcholk vrchol)
					(setq vrchol vrcholk)
				    )
				    (setq x (strcat x ";" (rtos vrchol) )
					  x (strcat x ";" w)
					  x (strcat x ";" y)
					  x (strcat x ";0.0")
				    )
				    (print x)
				    (write-line x file_ptr)
				)
				(progn
				;(print "køivka kubatury")
				(setq	x (cdr (assoc 0 (entget entita)))				; --- typ entity
					w (cdr (assoc 8 (entget entita)))				; --- hl kubatury
				)
				
				(command "_.area" "_o" entita)
				(setq	y (rtos (getvar "perimeter") 2)					; --- obvod køivky
					z (rtos (getvar "area") 2)					; --- obsah køivky
				)
				
				(setq	vrcholy(list)
					enlist (entget entita)
					j 0
				)
				(foreach a enlist
				    (if (= 10 (car a))
					(progn
					    (setq   vrcholy (append vrcholy (list (cdr a)))
						    j (+ 1 j)
					    )
					)
				    )
				)
				;(print j)
				;(print vrcholy)
				;(print (car (cdr (nth 0 vrcholy))))
				;(print (car (cdr (nth (- j 1) vrcholy))))
				(setq   k 0					; --- y souøadnice "nejnižšího" vrcholu
					vrchol (car (cdr (nth k vrcholy)))
				)
				;(print vrchol)
				(while (< k j)
				    (setq vrcholk (car (cdr (nth k vrcholy)))
				    )
				    ;(print vrcholk)
				    (if (< vrcholk vrchol)
					(progn
					    (setq vrchol vrcholk
					    )
					)
				    )
				    (setq k (+ 1 k)
				    )
				    ;(print vrchol)
				)
				(print (rtos vrchol))
				(print w)
				(print y)
				(print z)
				(setq	x (strcat x ";" (rtos vrchol) )
					x (strcat x ";" w)
					x (strcat x ";" y)
					x (strcat x ";" z)
				)
				(print x)
				(write-line x file_ptr)
				)
				)
			    )
		    )
		)
	    )
	(close file_ptr)
	(setvar "luprec" pre_precision)
	
	; --- zpráva o ukonèení

	(alert "Data byla exportována. Vytvoøen soubor Vykaz_vymer_sit.txt.\nNyní ve složce výkresu otevøi sešit Vykaz_vymer_sit_vychozi.xlsm")
	(princ)
)