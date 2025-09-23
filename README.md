# SPRINT-2
# EXERCICI 1

# Llistat dels països que estan generant vendes.

SELECT company.country as País
FROM company
JOIN transaction
ON transaction.company_id = company.id
GROUP BY company.country;

# Des de quants països es generen les vendes.

SELECT COUNT(distinct company.country) AS Numero_Paises
FROM company
JOIN transaction
ON transaction.company_id = company.id;

# Identifica la companyia amb la mitjana més gran de vendes.

SELECT company.company_name AS Empresa, avg(transaction.amount) AS Ventas_Medias
FROM company
JOIN transaction
ON transaction.company_id = company.id
GROUP BY company.company_name
ORDER BY Ventas_Medias DESC
LIMIT 1;

# EXERCICI 3

# Mostra totes les transaccions realitzades per empreses d'Alemanya.

 SELECT transaction.id
 FROM transaction
 WHERE transaction.company_id IN (SELECT company.id
								 FROM company
								 WHERE country = "Germany");
							
# Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.

SELECT company.company_name
FROM company
WHERE company.id IN (SELECT transaction.company_id
					 FROM transaction
					 GROUP BY transaction.company_id
					 HAVING SUM(transaction.amount) > (SELECT AVG(transaction.amount) as Media
														FROM transaction));
								
# Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.

SELECT company.company_name
FROM company
WHERE NOT EXISTS (SELECT company_id
				  FROM transaction);
                  
### Nivell 2

# Exercici 1

# Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. Mostra la data de cada transacció juntament amb el total de les vendes.

SELECT transaction.timestamp, SUM(transaction.amount) AS Total_Transacciones
FROM transaction
GROUP BY transaction.timestamp
ORDER BY Total_Transacciones DESC
LIMIT 5;

# Exercici 2
# Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.

SELECT company.country AS País, AVG(transaction.amount) AS Media_ventas
FROM company
JOIN transaction
ON company.id = transaction.company_id
GROUP BY company.country
ORDER BY Media_ventas DESC;

# Exercici 3

# En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes 
# publicitàries per a fer competència a la companyia "Non Institute". 
# Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.

# Mostra el llistat aplicant JOIN i subconsultes

SELECT *
FROM transaction
JOIN company
ON transaction.company_id = company.id
JOIN (SELECT company.country
	  FROM company
      WHERE company.company_name = "Non Institute") AS p
ON company.country = p.country;

# Mostra el llistat aplicant solament subconsultes.

SELECT *
FROM transaction
WHERE transaction.company_id IN (SELECT company.id
                                 FROM company
                                 WHERE company.country = (SELECT company.country
						         FROM company
                                 WHERE company.company_name = "Non Institute"));

# NIVELL 3

# EXERCICI 1
# Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès entre 350 i 400 euros i en alguna 
# d'aquestes dates: 29 d'abril del 2015, 20 de juliol del 2018 i 13 de març del 2024. Ordena els resultats de major a menor quantitat.

SELECT company.company_name, company.phone, company.country, transaction.timestamp, transaction.amount
FROM company
JOIN transaction
ON company.id = transaction.company_id
WHERE transaction.amount BETWEEN 350 AND 400
AND (transaction.timestamp like ("2015-04-29%")
     OR transaction.timestamp like ("2018-07-20%")
     OR transaction.timestamp like ("2024-03-13%"))
ORDER BY transaction.amount DESC;

# EXERCICI 2
# Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, 
# per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, però el departament de recursos 
# humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 400 transaccions o menys

SELECT company.company_name Empresa, COUNT(transaction.id) AS Total_Transaccions,
CASE
    WHEN COUNT(transaction.id) > 400 THEN "Més de 400 transaccions"
    ELSE "Menys de 400 transaccion"
    END AS Clasificació
FROM company
JOIN transaction
ON transaction.company_id = company.id
GROUP BY company.company_name;
