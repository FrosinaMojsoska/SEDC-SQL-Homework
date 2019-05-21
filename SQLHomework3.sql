--1

--Calculate the count of all grades in the system
SELECT COUNT(*) 
FROM Grade

--Calculate the count of all grades per Teacher in the system
SELECT  TeacherID,COUNT(ID) AS NumOfGrade 
FROM GRADE 
GROUP BY TeacherID
ORDER BY TeacherID

--Calculate the count of all grades per Teacher in the system for first 100 Students (ID < 100)

-- students with ID<100
SELECT TeacherID, StudentID, COUNT(Grade)
FROM Grade 
WHERE StudentID<100
GROUP BY TeacherID,StudentID
ORDER BY TeacherID


--FIRST 100 students

CREATE VIEW FirstHundredStudents
AS
SELECT TOP 100 *
FROM Grade

SELECT TeacherID,COUNT(Grade) as GradePerTeacher
FROM FirstHundredStudents
GROUP BY TeacherID
ORDER BY TeacherID


--Find the Maximal Grade, and the Average Grade per Student on all grades in the system
SELECT StudentId,MAX(Grade) as MaxGrade , AVG(Grade) as AvgGrade
FROM Grade
GROUP BY StudentID
ORDER BY StudentID


--2

--Calculate the count of all grades per Teacher in the system and filter only grade count greater then 200
SELECT TeacherId,COUNT(Grade) as NumOfGrade
FROM Grade
GROUP BY TeacherID
HAVING COUNT(Grade)>200
ORDER BY TeacherID


--Calculate the count of all grades per Teacher in the system for first 100 Students (ID < 100) and filter teachers with more than 50 Grade count
--ID<100
SELECT TeacherID, StudentID, COUNT(Grade)
FROM Grade 
WHERE StudentID<100
GROUP BY TeacherID,StudentID
HAVING COUNT(Grade)>50
ORDER BY TeacherID

--FIRST 100 students
SELECT TeacherID,COUNT(Grade) as GradePerTeacher
FROM FirstHundredStudents
GROUP BY TeacherID
HAVING COUNT(Grade)>50
ORDER BY TeacherID

--Find the Grade Count, Maximal Grade, and the Average Grade per Student on all grades in the system. Filter only records where Maximal Grade is equal to Average Grade
SELECT StudentId, COUNT(Grade) as NumOfGrades,AVG(Grade) AS AvgGrade, MAX(Grade) AS MaxGrade
FROM Grade
GROUP BY StudentID
HAVING AVG(Grade)=MAX(Grade)
ORDER BY StudentID

--List Student First Name and Last Name next to the other details from previous query
SELECT g.StudentId,s.FirstName,s.LastName,COUNT (g.Grade) as NumOfGrades,AVG(g.Grade) AS AvgGrade, MAX(g.Grade) AS MaxGrade
FROM Grade g
INNER JOIN Student s
ON g.StudentID=s.ID
GROUP BY g.StudentID,s.FirstName,s.LastName
HAVING AVG(g.Grade)=MAX(g.Grade)
ORDER BY g.StudentID

--3
--Create new view (vv_StudentGrades) that will List all StudentIds and count of Grades per student
CREATE VIEW vv_StudentGrades
AS
SELECT StudentID, COUNT(Grade) AS NumOfGrades
FROM Grade
GROUP BY StudentID

--Change the view to show Student First and Last Names instead of StudentID
ALTER VIEW vv_StudentGrades
AS
SELECT s.FirstName,s.LastName, COUNT(Grade) AS NumOfGrades
FROM Grade g 
INNER JOIN Student s
ON g.StudentID=s.ID
GROUP BY g.StudentID,s.FirstName,s.LastName

--List all rows from view ordered by biggest Grade Count
SELECT *
FROM vv_StudentGrades
ORDER BY NumOfGrades DESC

--Create new view (vv_StudentGradeDetails) that will List all Students (FirstName and LastName) and Count the courses he passed through the exam(Ispit)
/*select * from AchievementType -- ispit id =5
select * from GradeDetails 
select * from Grade*/
CREATE VIEW vv_StudentGradeDetails
AS
SELECT s.FirstName,s.LastName,COUNT (g.CourseID) AS NumOfCourses
FROM GradeDetails gd
INNER JOIN Grade g
ON gd.GradeID=g.ID
INNER JOIN Student s
ON s.ID=g.StudentID
WHERE gd.AchievementTypeID=5
GROUP BY  s.FirstName,s.LastName

