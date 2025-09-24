
# EXERCICI 2

SELECT c.country
FROM company c
JOIN transaction t
ON t.company_id = c.id
WHERE declined = 0
GROUP BY c.country;

# Des de quants països es generen les vendes.

SELECT COUNT(distinct c.country) AS Numero_Paises
FROM company c
JOIN transaction t
ON t.company_id = c.id
WHERE declined = 0;

# Identifica la companyia amb la mitjana més gran de vendes.

SELECT c.company_name AS Empresa, round(avg(t.amount),2) AS Ventas_Medias
FROM company c
JOIN transaction t
ON t.company_id = c.id
WHERE declined = 0
GROUP BY c.id 
ORDER BY Ventas_Medias DESC
LIMIT 1;

# EXERCICI 3

# Mostra totes les transaccions realitzades per empreses d'Alemanya.

 SELECT *
 FROM transaction t
 WHERE declined = 0 and t.company_id IN (SELECT c.id 
								         FROM company c
							             WHERE country = "Germany");
							
# Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.

SELECT c.company_name								
FROM company c
WHERE c.id IN (SELECT t.company_id
					 FROM transaction t
					 WHERE t.declined = 0 AND t.amount > (SELECT AVG(t.amount) as Media
														FROM transaction t
                                                        WHERE t.declined = 0));

# Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.

SELECT c.company_name
FROM company c
WHERE  NOT EXISTS (SELECT t.company_id
				  FROM transaction t
                  WHERE t.declined = 0);
                  
### Nivell 2

# Exercici 1

# Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. Mostra la data de cada transacció juntament amb el total de les vendes.

SELECT date(timestamp) as Fecha, round(SUM(t.amount),2) AS Total_Transacciones
FROM transaction t
WHERE declined = 0
GROUP BY Fecha
ORDER BY Total_Transacciones DESC
LIMIT 5;

# Exercici 2
# Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.

SELECT c.country AS País, round(AVG(t.amount),2) AS Media_ventas
FROM company c
JOIN transaction t
ON c.id = t.company_id
WHERE declined = 0
GROUP BY c.country
ORDER BY Media_ventas DESC;

# Exercici 3

# En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes 
# publicitàries per a fer competència a la companyia "Non Institute". 
# Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.

# Mostra el llistat aplicant JOIN i subconsultes

SELECT * 
FROM transaction t
JOIN (SELECT c.id
      FROM company c
      WHERE c.company_name != "Non Institute"
      AND c.country = (SELECT c.country
					   FROM company c
					   WHERE c.company_name = "Non Institute")) AS p
ON t.company_id = p.id
WHERE t.declined = 0;

# Mostra el llistat aplicant solament subconsultes.

SELECT *
FROM transaction t
WHERE declined = 0 AND t.company_id IN (SELECT c.id
										FROM company c
                                        WHERE c.company_name != "Non Institute"
										AND c.country = (SELECT c.country
						                                   FROM company c
                                                           WHERE c.company_name = "Non Institute")); 

# NIVELL 3

# EXERCICI 1
# Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès entre 350 i 400 euros i en alguna 
# d'aquestes dates: 29 d'abril del 2015, 20 de juliol del 2018 i 13 de març del 2024. Ordena els resultats de major a menor quantitat.

SELECT c.company_name, c.phone, c.country, date(t.timestamp) as date, t.amount
FROM company c
JOIN transaction t
ON c.id = t.company_id
WHERE t.amount BETWEEN 350 AND 400
AND (t.timestamp like ("2015-04-29%")
     OR t.timestamp like ("2018-07-20%")
     OR t.timestamp like ("2024-03-13%")) 
ORDER BY t.amount DESC;

# EXERCICI 2
# Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, 
# per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, però el departament de recursos 
# humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 400 transaccions o menys

SELECT c.company_name Empresa, COUNT(t.id) Total_Transacciones,
CASE
    WHEN COUNT(t.id) > 400 THEN "Més de 400 transaccions"
    ELSE "Menys de 400 transaccion"
    END AS Clasificación
FROM company c
JOIN transaction t
ON t.company_id = c.id
WHERE declined = 0
GROUP BY c.company_name;