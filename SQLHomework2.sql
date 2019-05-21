--1

--Find all Students with FirstName = Antonio
SELECT *
FROM Student
WHERE FirstName='Antonio'

--Find all Students with DateOfBirth greater than ‘01.01.1999’
SELECT *
FROM Student
WHERE DateOfBirth>'1999-01-01'

--Find all Male students
SELECT *
FROM Student
WHERE Gender='M'

--Find all Students with LastName starting With ‘T’
SELECT *
FROM Student
WHERE LastName LIKE 'T%'

--Find all Students Enrolled in January/1998
SELECT *
FROM Student
WHERE EnrolledDate BETWEEN '1998-01-01' AND '1998-02-01'
 
--Find all Students with LastName starting With ‘J’ enrolled in January/1998 
SELECT *
FROM Student
WHERE LastName LIKE 'J%' AND EnrolledDate BETWEEN '1998-01-01' AND '1998-02-01'
 
--2
--Find all Students with FirstName = Antonio ordered by Last Name
SELECT *
FROM Student
WHERE FirstName='Antonio'
ORDER BY LastName

--List all Students ordered by FirstName
SELECT *
FROM Student
ORDER BY FirstName

--Find all Male students ordered by EnrolledDate, starting from the last enrolled
 SELECT *
FROM Student
WHERE Gender='M'
ORDER BY EnrolledDate DESC
 
--3

--List all Teacher First Names and Student First Names in single result set with duplicates
 SELECT FirstName
FROM Teacher
UNION ALL
SELECT FirstName
FROM Student

--List all Teacher Last Names and Student Last Names in single result set. Remove duplicates
 SELECT LastName
FROM Teacher
UNION
SELECT LastName
FROM Student

--List all common First Names for Teachers and Students
 SELECT FirstName
FROM Teacher
INTERSECT
SELECT FirstName
FROM Student
 
--4

--Change GradeDetails table always to insert value 100 in AchievementMaxPoints column if no value is provided on insert
 ALTER TABLE GradeDetails
ADD CONSTRAINT DF_Grade_Details
DEFAULT 100 FOR AchievementMaxPoints
 
--Change GradeDetails table to prevent inserting AchievementPoints that will more than AchievementMaxPoints
 ALTER TABLE GradeDetails WITH CHECK
ADD CONSTRAINT CHK_Achievement_Points
CHECK (AchievementPoints<=AchievementMaxPoints)

--Change AchievementType table to guarantee unique names across the Achievement types
 ALTER TABLE AchievementType WITH CHECK
ADD CONSTRAINT UC_Achievement_Name
UNIQUE(Name)
 
--5

--Change AchievementType table to guarantee unique names across the Achievement types
 ALTER TABLE Grade
ADD CONSTRAINT FK_Grade_Student FOREIGN KEY (STudentId)
REFERENCES Student (Id)
 
ALTER TABLE Grade
ADD CONSTRAINT FK_Grade_Teacher FOREIGN KEY (TeacherId)
REFERENCES Teacher (Id)
 
ALTER TABLE Grade
ADD CONSTRAINT FK_Grade_Course FOREIGN KEY (CourseId)
REFERENCES Course (Id)
 
ALTER TABLE GradeDetails
ADD CONSTRAINT FK_GradeDetails_Grade FOREIGN KEY(GradeId)
REFERENCES Grade (Id)
 
ALTER TABLE GradeDetails
ADD CONSTRAINT FK_GradeDetails_AchievementType FOREIGN KEY (AchievementTypeId)
REFERENCES AchievementType (Id)
 
--6

--List all possible combinations of Courses names and AchievementType names that can be passed by student
SELECT c.Name , at.Name
FROM Course c
CROSS JOIN
AchievementType at

--List all Teachers that has any exam Grade
 SELECT t.*
FROM Teacher t
INNER JOIN Grade g
ON t.ID=g.TeacherId

--List all Teachers without exam Grade
 SELECT t.*
FROM Teacher t
LEFT JOIN
Grade g
ON t.Id=g.TeacherId
WHERE g.TeacherId is null

--List all Students without exam Grade (using Right Join)
 
SELECT s.*
FROM Grade g
RIGHT JOIN
Student s
ON g.StudentId=s.Id
WHERE g.StudentId IS NULL