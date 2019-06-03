--1/a

--Create new procedure called CreateGrade
--Procedure should create only Grade header info (not Grade Details) 
--Procedure should return the total number of grades in the system for the Student on input (from the CreateGrade)
--Procedure should return second resultset with the MAX Grade of all grades for the Student and Teacher on input (regardless the Course)

CREATE PROCEDURE dbo.CreateGrade (@StudentId int, @TeacherId int,@CourseID int, @Grade int ,@CreateDate date)
AS
BEGIN
	
	INSERT INTO Grade (StudentId,TeacherId,CourseID,Grade,CreatedDate)
	VALUES (@StudentId, @TeacherId,@CourseID,@Grade,@CreateDate)


SELECT COUNT(StudentID) AS NumOfGrades 
FROM Grade
WHERE Studentid =@StudentId

SELECT MAX(Grade) as MaxGrade
FROM Grade
WHERE Studentid =@StudentId and TeacherID=@TeacherId

END
GO

-- test execution
select * from grade
EXEC dbo.CreateGrade @StudentId=5,@TeacherId=7,@CourseId=8,@Grade=8,@CreateDate='2019-01-06'

select   * 
from Grade
WHERE StudentID=5 and TeacherID=7

--1/b

--Create new procedure called CreateGradeDetail
--Procedure should add details for specific Grade (new record for new AchievementTypeID, Points, MaxPoints, Date for specific Grade)
--Output from this procedure should be resultset with SUM of GradePoints calculated with formula AchievementPoints/AchievementMaxPoints*ParticipationRate for specific Grade

ALTER TABLE GRADEDETAILS
ALTER COLUMN AchievementPoints FLOAT(53)

CREATE PROCEDURE CreateGradeDetail(@GradeId int,@AchievementTypeID tinyint, @Points float,@MaxPoints tinyint,@Date date)
AS
BEGIN

BEGIN TRY
INSERT INTO GradeDetails(GradeId,AchievementTypeID, AchievementPoints ,AchievementMaxPoints ,AchievementDate )
VALUES ( @Gradeid,@AchievementTypeID, @Points ,@MaxPoints ,@Date)
END TRY

BEGIN CATCH
SELECT  
 

    ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage;  

END CATCH; 

SELECT SUM((gd.AchievementPoints /gd.AchievementMaxPoints)*ACT.ParticipationRate) as GradePoints
FROM GradeDetails gd
INNER JOIN AchievementType  act ON act.ID=gd.AchievementTypeID
WHERE GradeId=@GradeID
END


-- test execution

select * from GradeDetails
EXEC dbo.CreateGradeDetail @GradeId=5,@AchievementTypeID=0,@Points=80,@MaxPoints=100,@Date='2019-01-06'


--SELECT SUM((gd.AchievementPoints /gd.AchievementMaxPoints)*ACT.ParticipationRate) as GradePoints --, act.ParticipationRate,gd.AchievementMaxPoints,gd.AchievementPoints
--FROM GradeDetails gd
--INNER JOIN AchievementType  act ON act.ID=gd.AchievementTypeID
--WHERE GradeId=5

--2
--Add error handling on CreateGradeDetail procedure
--Test the error handling by inserting not-existing values for AchievementTypeID

ALTER TABLE GradeDetails
ADD CONSTRAINT chk_AchievementTypeID CHECK(AchievementTypeID>=0 AND AchievementTypeID<=8)

EXEC dbo.CreateGradeDetail @GradeId=5,@AchievementTypeID=80,@Points=80,@MaxPoints=100,@Date='2019-01-06'