drop table if exists Student_Mark;

CREATE TABLE Student_Marks (
    id INT PRIMARY KEY,
    maths INT,
    english INT,
    physics INT,
    chemistry INT,
    computer INT
);

INSERT INTO Student_Marks
(id, maths, english, physics, chemistry, computer)
VALUES
(1, 58, 52, 83, NULL, 52),
(2, NULL, 94, 49, 88, 51),
(3, 53, 87, NULL, 61, 66),
(4, 55, NULL, 51, 83, 78),
(5, 42, 73, 71, NULL, 66);

SELECT id,
       IFNULL(maths,0) +
       IFNULL(english,0) +
       IFNULL(physics,0) +
       IFNULL(chemistry,0) + 
       IFNULL(computer,0) AS sum_of_marks
FROM Student_Marks;

select id,nullif(sum_of_marks,267)  sum_of_marks from
(select id,
       IFNULL(maths,0) +
       IFNULL(english,0) +
       IFNULL(physics,0) +
       IFNULL(chemistry,0) + 
       IFNULL(computer,0) AS sum_of_marks
FROM Student_Marks) a;
select nullif(267,267);
select nullif(260,267);