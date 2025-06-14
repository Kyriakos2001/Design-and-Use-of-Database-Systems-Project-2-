#Erotima 1
SELECT DISTINCT m.title AS Title
FROM movie m, actor a, role r, movie_has_genre mg, genre g
WHERE a.last_name = 'Allen'
AND a.actor_id = r.actor_id
AND r.movie_id = m.movie_id
AND m.movie_id = mg.movie_id
AND mg.genre_id = g.genre_id
AND g.genre_name = 'Comedy';

#Erotima 2
SELECT DISTINCT d.last_name AS LastName, m.title AS Title
FROM director d, movie m, movie_has_director md, actor a, role r
WHERE a.last_name = 'Allen'
AND d.director_id = md.director_id
AND a.actor_id = r.actor_id
AND r.movie_id = m.movie_id
AND m.movie_id = md.movie_id
AND md.director_id = d.director_id
AND d.director_id IN(
 SELECT md.director_id
 FROM movie_has_director md, movie_has_genre mg
 WHERE mg.movie_id = md.movie_id
 GROUP BY md.director_id
 HAVING COUNT(DISTINCT mg.genre_id)  >= 2
);

#Erotima 3
SELECT DISTINCT a.last_name AS LastName
FROM actor a, director d, movie m1, movie m2, movie_has_director md1, movie_has_director md2, role r1, role r2, movie_has_genre mg1, movie_has_genre mg2
WHERE a.last_name = d.last_name
AND d.director_id = md1.director_id
AND md1.movie_id = m1.movie_id
AND a.actor_id = r1.actor_id
AND r1.movie_id = m1.movie_id
AND a.actor_id = r2.actor_id
AND r2.movie_id = m2.movie_id
AND m2.movie_id = md2.movie_id
AND md2.director_id != d.director_id
AND mg1.movie_id = m1.movie_id
AND mg2.movie_id = m2.movie_id
AND mg1.genre_id = mg2.genre_id;

#Erotima 4
SELECT DISTINCT 'yes' AS Answer
WHERE EXISTS (
 SELECT 1
 FROM movie m, movie_has_genre mg, genre g
 WHERE m.movie_id = mg.movie_id 
 AND mg.genre_id = g.genre_id
 AND m.year = 1995 
 AND g.genre_name = 'Drama'
)
UNION
SELECT DISTINCT 'no' AS Answer
WHERE NOT EXISTS (
 SELECT 1
 FROM movie m, movie_has_genre mg, genre g
 WHERE m.movie_id = mg.movie_id 
 AND mg.genre_id = g.genre_id
 AND m.year = 1995 
 AND g.genre_name = 'Drama'
);

#Erotima 5
SELECT DISTINCT  d1.last_name AS Director1, d2.last_name AS Director2
FROM director d1, director d2, movie_has_director md1, movie_has_director md2, movie m, movie_has_genre mg
WHERE md1.director_id = d1.director_id
AND md2.director_id = d2.director_id
AND md1.movie_id = md2.movie_id
AND md1.director_id < md2.director_id
AND md1.movie_id = m.movie_id
AND m.year BETWEEN 2000 AND 2006
AND m.movie_id = mg.movie_id
AND (
 SELECT COUNT(DISTINCT mg2.genre_id)
 FROM movie_has_genre mg2
 WHERE mg2.movie_id IN (
  SELECT md3.movie_id 
  FROM movie_has_director md3 
  WHERE md3.director_id = d1.director_id
)
) >= 6
AND (
 SELECT COUNT(DISTINCT mg2.genre_id)
 FROM movie_has_genre mg2
 WHERE mg2.movie_id IN (
  SELECT md4.movie_id 
  FROM movie_has_director md4 
  WHERE md4.director_id = d2.director_id
)
) >= 6;

#Erotima 6
SELECT a.first_name AS ActorFirstName, a.last_name AS ActorLastName, COUNT(DISTINCT md.director_id) AS Count
FROM actor a, role r, movie m, movie_has_director md
WHERE a.actor_id = r.actor_id 
AND r.movie_id = m.movie_id 
AND m.movie_id = md.movie_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(DISTINCT m.movie_id) = 3;

#Erotima 7
SELECT g.genre_id AS GenreID, COUNT(DISTINCT md.director_id) AS Count
FROM genre g, movie_has_genre mg, movie m, movie_has_director md
WHERE mg.genre_id = g.genre_id
AND m.movie_id = mg.movie_id
AND md.movie_id = m.movie_id
AND m.movie_id IN (
 SELECT movie_id
 FROM movie_has_genre
 GROUP BY movie_id
 HAVING COUNT(DISTINCT genre_id) = 1
)
GROUP BY g.genre_id;

#Erotima 8
SELECT a.actor_id AS ActorID
FROM actor a
WHERE (
 SELECT COUNT(DISTINCT genre_id)
 FROM genre
) = (
  SELECT COUNT(DISTINCT genre_id)
  FROM movie_has_genre
  WHERE movie_id IN (
   SELECT movie_id
   FROM role
   WHERE actor_id = a.actor_id
)
);

#Erotima 9
SELECT mg1.genre_id AS GenreID1, mg2.genre_id AS GenreID2, COUNT(DISTINCT md1.director_id) AS Count
FROM movie_has_director md1, movie_has_director md2, movie_has_genre mg1, movie_has_genre mg2, director d
WHERE md1.director_id = d.director_id 
AND md2.director_id = d.director_id
AND md1.movie_id = mg1.movie_id 
AND md2.movie_id = mg2.movie_id
AND mg1.genre_id < mg2.genre_id
AND md1.director_id = md2.director_id
GROUP BY mg1.genre_id, mg2.genre_id;

#Erotima 10
SELECT g.genre_id AS GenreID, a.actor_id AS ActorID, COUNT(DISTINCT m.movie_id) AS Count
FROM genre g, movie_has_genre mg, movie m, role r, actor a
WHERE g.genre_id = mg.genre_id 
AND mg.movie_id = m.movie_id 
AND m.movie_id = r.movie_id 
AND r.actor_id = a.actor_id 
AND NOT EXISTS (
 SELECT 1
 FROM movie_has_director md, movie_has_genre mg2
 WHERE md.movie_id = mg2.movie_id 
 AND md.director_id IN (
  SELECT md2.director_id
  FROM movie_has_director md2, movie_has_genre mg3
  WHERE md2.movie_id = mg3.movie_id
  GROUP BY md2.director_id
  HAVING COUNT(DISTINCT mg3.genre_id) > 1
) 
 AND md.movie_id = m.movie_id
)
GROUP BY g.genre_id, a.actor_id;