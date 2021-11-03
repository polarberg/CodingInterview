/* SELECT last_name
    , first_name
    , COUNT(*)
FROM actor 
GROUP BY last_name
    , first_name
-- From the actor table, return unique first & last names and last names plus a COUNT of the number of times they occur 
HAVING COUNT(*) > 1  */

-- Find all unique first names from the actor table that occur more than 3 times 
-- Sort the results in ASCENDING order by first name 

SELECT first_name
    , COUNT(*)
FROM actor 
GROUP BY first_name
HAVING COUNT(*) BETWEEN 3 AND 4
ORDER BY 1;