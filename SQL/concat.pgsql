-- Combine 2 or more columns together to
-- Full name - concat first name and last name
SELECT last_name
    , first_name
    , first_name || ' ' || last_name
    , concat(first_name, ' ', last_name) AS "Full Name"
    , concat(last_name, ', ', first_name)
FROM actor;