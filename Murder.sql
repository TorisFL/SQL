SELECT *
FROM crime_scene_report
WHERE LOWER(city) ='sql city' and type = 'murder' and date = '20180115'

SELECT *
FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC LIMIT 1

SELECT *
FROM person
WHERE address_street_name = 'Franklin Ave' and name LIKE '%Annabel%'


SELECT p.name, i.transcript
FROM interview i
JOIN person p
ON i.person_id = p.id
WHERE i.person_id = 14887 OR i.person_id = 16371

SELECT *
FROM drivers_license dl
WHERE dl.plate_number LIKE '%H42W%'

SELECT *
FROM get_fit_now_member m
JOIN get_fit_now_check_in r
ON m.id = r.membership_id
WHERE m.membership_status = 'gold' and r.membership_id LIKE '48Z%'

SELECT * From get_fit_now_member gf
Join person p
On gf.person_id = p.id
Join drivers_license dl
On p.license_id = dl.id
WHERE gf.membership_status = 'gold'
And gf.id like '%48Z%'

INSERT INTO solution VALUES (1, 'Jeremy Bowers');
SELECT value FROM solution;