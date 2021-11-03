-- Return all actors whose nlast names begin with W,X,Y,Z
/* SELECT last_name
	, first_name
FROM actor
WHERE last_name between 'A' and 'B'
ORDER BY 1
	, 2;
*/

-- quick way to get all members of 
/* SELECT COUNT(*) -- COUNT = AGGREGATE function 
FROM actor;  */

/* SELECT last_name
    , first_name
    , COUNT(*)
FROM actor
GROUP BY last_name, first_name
ORDER BY 3 DESC
 */

/* SELECT last_name
    , COUNT(*)
FROM actor
WHERE last_name > 'A'
GROUP BY last_name
ORDER BY 1; 
 */
SELECT last_name
	, first_name
	, COUNT(*)
FROM actor
WHERE last_name > 'A'
GROUP BY last_name, 
	first_name
ORDER BY 3 DESC; 