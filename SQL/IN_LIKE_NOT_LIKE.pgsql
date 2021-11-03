SELECT actor_id
    , last_name
    , first_name
FROM actor
--WHERE first_name IN ('Ben', 'Tom')
WHERE last_name LIKE 'H%p%'
ORDER BY 2 ASC
    , 3 ASC;


-- Comparison Operators: test whether 2 expressions are equal to each other
-- Logical Operators: test whether some condition is true ( Like, EXISTS BETWEEN)
-- NOT in front of logical OPERATOR

-- %: wildcard anything can come after 'H'
-- % does not with IN operator 
