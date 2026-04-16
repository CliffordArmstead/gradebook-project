-- Task 4
SELECT AVG(score), MAX(score), MIN(score)
FROM Score
WHERE assignment_id = 1;
-- Task 5
SELECT s.*
FROM Student s
JOIN Enrollment e ON s.student_id = e.student_id
WHERE e.course_id = 101;
-- Task 6
SELECT s.first_name, s.last_name, a.assignment_name, sc.score
FROM Student s
JOIN Score sc ON s.student_id = sc.student_id
JOIN Assignment a ON sc.assignment_id = a.assignment_id;
-- Task 7
INSERT INTO Assignment VALUES (4, 1, 'HW3', 100);
-- Task 8
UPDATE Category
SET percentage = 25
WHERE category_id = 1;
-- Task 9
UPDATE Score
SET score = score + 2
WHERE assignment_id = 1;
-- Task 10
UPDATE Score
SET score = score + 2
WHERE student_id IN (
    SELECT student_id
    FROM Student
    WHERE last_name LIKE '%Q%'
);
-- Task 11
SELECT s.student_id,
SUM((sc.score / a.max_score) * c.percentage /
(SELECT COUNT(*) FROM Assignment WHERE category_id = c.category_id)) AS final_grade
FROM Student s
JOIN Score sc ON s.student_id = sc.student_id
JOIN Assignment a ON sc.assignment_id = a.assignment_id
JOIN Category c ON a.category_id = c.category_id
GROUP BY s.student_id;
-- Task 12
SELECT student_id, SUM(weighted_score)
FROM (
    SELECT s.student_id,
           c.category_id,
           ((sc.score / a.max_score) * c.percentage /
           COUNT(*) OVER (PARTITION BY c.category_id)) AS weighted_score,
           RANK() OVER (PARTITION BY s.student_id, c.category_id ORDER BY sc.score) AS rnk
    FROM Student s
    JOIN Score sc ON s.student_id = sc.student_id
    JOIN Assignment a ON sc.assignment_id = a.assignment_id
    JOIN Category c ON a.category_id = c.category_id
) t
WHERE rnk > 1
GROUP BY student_id;
