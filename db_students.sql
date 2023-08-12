DROP TABLE IF EXISTS classrooms CASCADE;

CREATE TABLE classrooms (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    teacher VARCHAR(100)
);


DROP TABLE IF EXISTS students CASCADE;

CREATE TABLE students (
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(200),
	classroom_id INT,
	CONSTRAINT fk_classrooms
		FOREIGN KEY(classroom_id)
		REFERENCES classrooms(id)
);

INSERT INTO classrooms
	(teacher)
VALUES
	('Mary'),
	('Jonah');


INSERT INTO students
	(name, classroom_id)
VALUES
	('Adam', 1),
	('Bob', 1),
	('Marlin', 2),
	('Diana', NULL);
	
INSERT INTO students
	(name)
VALUES
	('Evan');

DROP TABLE IF EXISTS assignments CASCADE;
DROP TABLE IF EXISTS grades CASCADE;

CREATE TABLE assignments(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	category VARCHAR(20),
	name VARCHAR(200),
	due_date DATE,
	weight FLOAT
);

CREATE TABLE grades (
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	assignment_id INT,
	score INT,
	student_id INT,
	CONSTRAINT fk_assignments
		FOREIGN KEY(assignment_id)
		REFERENCES assignments(id),
	CONSTRAINT fk_students
		FOREIGN KEY(student_id)
		REFERENCES students(id)
);

COPY assignments(category, name, due_date, weight)
FROM 'C:\Users\Public\Documents\assignments.csv'
DELIMITER ','
CSV HEADER;

COPY grades(assignment_id,score,student_id)
FROM 'C:\Users\Public\Documents\grades.csv'
DELIMITER ','
CSV HEADER;

SELECT
    c.teacher,
    a.category,
    ROUND(AVG(g.score), 1) AS avg_score
FROM
    students AS s
INNER JOIN classrooms AS c
    ON c.id = s.classroom_id
INNER JOIN grades AS g
    ON s.id = g.student_id
INNER JOIN assignments AS a
    ON a.id = g.assignment_id
GROUP BY
    1,
    2
ORDER BY
    3 DESC;

