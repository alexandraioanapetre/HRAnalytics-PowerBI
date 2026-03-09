--Afișează toți angajații activi, cu numele complet, job title și departamentul lor.

SELECT FirstName, LastName, JobTitle, DepartmentName
FROM dbo.Employees e 
INNER JOIN dbo.Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.Status = 'Active';

--Afișează câți angajați are fiecare departament, ordonat descrescător.

SELECT  d.DepartmentName, COUNT(e.EmployeeID) AS TotalAngajati
FROM dbo.Employees e
INNER JOIN dbo.Departments d ON e.DepartmentID = d.DepartmentID
Group by d.DepartmentName
Order by TotalAngajati DESC;


--Afișează toți angajații care au plecat din companie (Resigned sau Terminated), cu numele complet, departamentul și motivul plecării.

SELECT e.FirstName, e.LastName, d.DepartmentName, r.Reason
FROM dbo.Employees e
INNER JOIN dbo.Departments d ON e.DepartmentID = d.DepartmentID
LEFT JOIN dbo.Resignations r ON e.EmployeeID = r.EmployeeID
WHERE e.Status IN ('Resigned', 'Terminated')

--Afișează salariul curent al fiecărui angajat activ, cu numele complet, departamentul și salariul lunar. 
--Ordonează descrescător după salariu.

SELECT e.FirstName, e.LastName, d.DepartmentName, s.MonthlySalary
FROM dbo.Employees e
INNER JOIN dbo.Departments d ON e.DepartmentID = d.DepartmentID
INNER JOIN dbo.Salaries s ON e.EmployeeID = s.EmployeeID
WHERE e.Status = 'Active'
AND s.EffectiveDate = (
    SELECT MAX(EffectiveDate) 
    FROM dbo.Salaries 
    WHERE EmployeeID = e.EmployeeID
)
ORDER BY s.MonthlySalary DESC;


--Afișează departamentele unde salariul mediu lunar depășește 12.000 RON, cu numărul de angajați și salariul mediu.
SELECT d.DepartmentName, 
       COUNT(DISTINCT e.EmployeeID) AS NrAngajati,
       ROUND(AVG(s.MonthlySalary), 2) AS SalariuMediuLunar
FROM dbo.Employees e
INNER JOIN dbo.Departments d ON e.DepartmentID = d.DepartmentID
INNER JOIN dbo.Salaries s ON e.EmployeeID = s.EmployeeID
WHERE e.Status = 'Active'
GROUP BY d.DepartmentName
HAVING AVG(s.MonthlySalary) > 12000
ORDER BY SalariuMediuLunar DESC;


--Afișează angajații care au primit un scor de performanță mai mare de 4.0 în 2023, cu numele complet, departamentul, scorul și categoria.
SELECT e.FirstName, e.LastName, d.DepartmentName, pr.Score, pr.Category
FROM dbo.Employees e
INNER JOIN dbo.Departments d ON e.DepartmentID = d.DepartmentID
INNER JOIN dbo.PerformanceReviews pr ON e.EmployeeID = pr.EmployeeID
Where pr.Score > 4.0 AND pr.ReviewYear = 2023

--Afișează numărul de angajați pe fiecare nivel de seniority (Junior, Mid, Senior, Lead, Manager, Director) și salariul mediu per nivel.

SELECT e.Seniority, AVG(s.MonthlySalary) AS SalariuMediu, COUNT(e.EmployeeID) AS NumarAngajati
FROM Employees e
INNER JOIN dbo.Salaries s ON e.EmployeeID = s.EmployeeID
Where e.Status = 'Active'
Group by e.Seniority
Order by SalariuMediu DESC;

--Afișează angajații care nu au nicio evaluare de performanță înregistrată.

SELECT FirstName, LastName, ReviewID
FROM dbo.Employees e
LEFT JOIN dbo.PerformanceReviews pr ON e.EmployeeID = pr.EmployeeID
WHERE pr.ReviewID IS NULL


--Afișează top 5 cele mai scumpe programe de training, cu numele angajatului, numele programului, categoria și costul.
SELECT TOP 5 e.FirstName, e.LastName, tp.ProgramName, tp.Category, tp.Cost
FROM dbo.Employees e
INNER JOIN dbo.TrainingPrograms tp ON e.EmployeeID = tp.EmployeeID
Order by tp.Cost DESC;

--Afișează departamentele cu rata de turnover (număr de angajați plecați / total angajați * 100), ordonate descrescător.
SELECT 
    d.DepartmentName,
    COUNT(e.EmployeeID) AS TotalAngajati,
    COUNT(CASE WHEN e.Status IN ('Resigned', 'Terminated') THEN 1 END) AS Plecati,
    ROUND(
        COUNT(CASE WHEN e.Status IN ('Resigned', 'Terminated') THEN 1 END) * 100.0 
        / COUNT(e.EmployeeID), 2
    ) AS TurnoverRate
FROM dbo.Employees e
INNER JOIN dbo.Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY TurnoverRate DESC;