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

(defun c:vykaz_vymer ( / file_ptr s entita typ_entity pre_precision vrcholy vrchol delka)
(vl-load-com)
	
	; --- upozorn�n� kontroly polohy stani�en� a k�ivek
	
	(alert "Nutn� kontrola polohy stani�en� a k�ivek kubatur: NEJNI��� BOD K�IVKY MUS� LE�ET POD STANI�EN�M �EZU, VE KTER�M SE K�IVKA NACH�Z�.\nPokud jsi tuto podm�nku nezkontroloval, ukon�i p��kaz a prove� jej po kontrole.\nPokud je v�e v po��dku, vyber najednou v�echna stani�en� i k�ivky pro v�po�et kubatur.")
	
	; --- vytvo�en� souboru txt
	
	(setq file_ptr (open (strcat (getvar 'dwgprefix) "Vykaz_vymer_pricne_rezy.txt") "w"))
	
	; --- pr�ce s v�b�rem, z�pis do souboru
	
	(setq pre_precision (getvar "luprec"))
	(setvar "luprec" 6)
	(princ "Vyber v�echna stani�en� a v�echny k�ivky pro v�po�et kubatur.")
	    (if (setq s (ssget '((0 . "Text,Lwpolyline,Line")) ))
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
			(if (or (= typ_entity "TEXT") (= typ_entity "MTEXT"))
			    (progn
				;(print "stani�en�")
				(setq	x (cdr (assoc 0 (entget entita)))				; --- typ entity
					x (strcat x ";" (rtos (caddr (assoc 10 (entget entita))) 2) )	; --- y textu
					x (strcat x ";" (cdr (assoc 8 (entget entita))))		; --- hlad stan
					;x (strcat x ";" (cdr (assoc 1 (entget entita))))		; --- hodn stan
					x (strcat x ";" (LM:StringSubst "." "," (cdr (assoc 1 (entget entita)))   )   )		; --- hodn stan
				)
				(print x)
				(write-line x file_ptr)
			    )
			    (progn
				(if (= typ_entity "LINE")
				(progn
				    ;(print "�se�ka")
				    (setq y (rtos (distance (cdr (assoc 10 (entget entita))) (cdr (assoc 11 (entget entita))) ) 2))
				    ;(print y)								; --- d�lka �se�ky
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
				;(print "k�ivka kubatury")
				(setq	x (cdr (assoc 0 (entget entita)))				; --- typ entity
					w (cdr (assoc 8 (entget entita)))				; --- hl kubatury
				)
				
				(command "_.area" "_o" entita)
				(setq	y (rtos (getvar "perimeter") 2)					; --- obvod k�ivky
					z (rtos (getvar "area") 2)					; --- obsah k�ivky
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
				(setq   k 0					; --- y sou�adnice "nejni���ho" vrcholu
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
	    )
	(close file_ptr)
	(setvar "luprec" pre_precision)
	
	; --- zpr�va o ukon�en�

	(alert "Data byla exportov�na. Vytvo�en soubor Vykaz_vymer_pricne_rezy.txt.\nNyn� ve slo�ce v�kresu otev�i se�it Vykaz_vymer_vychozi.xlsm")
	(princ)
)