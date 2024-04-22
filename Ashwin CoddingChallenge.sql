create database Crime_Management;
use Crime_Management;

CREATE TABLE Crime (
 CrimeID INT PRIMARY KEY,
 IncidentType VARCHAR(255),
 IncidentDate DATE,
 Location VARCHAR(255),
 Description TEXT,
 Status VARCHAR(20)
);

CREATE TABLE Victim (
 VictimID INT PRIMARY KEY,
 CrimeID INT,
 Name VARCHAR(255),
 ContactInfo VARCHAR(255),
 Injuries VARCHAR(255),
 FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);

CREATE TABLE Suspect (
 SuspectID INT PRIMARY KEY,
 CrimeID INT,
 Name VARCHAR(255),
 Description TEXT,
 CriminalHistory TEXT,
 FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);

INSERT INTO Crime (CrimeID, IncidentType, IncidentDate, Location, Description, Status)
VALUES
 (1, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a convenience store', 'Open'),
 (2, 'Homicide', '2023-09-20', '456 Elm St, Townsville', 'Investigation into a murder case', 'Under 
Investigation'),
 (3, 'Theft', '2023-09-10', '789 Oak St, Villagetown', 'Shoplifting incident at a mall', 'Closed');
 
INSERT INTO Victim (VictimID, CrimeID, Name, ContactInfo, Injuries)
VALUES
 (1, 1, 'John Doe', 'johndoe@example.com', 'Minor injuries'),
 (2, 2, 'Jane Smith', 'janesmith@example.com', 'Deceased'),
 (3, 3, 'Alice Johnson', 'alicejohnson@example.com', 'None');
 
INSERT INTO Suspect (SuspectID, CrimeID, Name, Description, CriminalHistory)
VALUES
 (1, 1, 'Robber 1', 'Armed and masked robber', 'Previous robbery convictions'),
 (2, 2, 'Unknown', 'Investigation ongoing', NULL),
 (3, 3, 'Suspect 1', 'Shoplifting suspect', 'Prior shoplifting arrests');

  -- 1. Select all open incidents
 select * from Crime where Status='Open';
 
  -- 2. Find the total number of incidents
 select count(*) as Total_Incidents from Crime;
 
  -- 3. List all unique incident types
  select distinct IncidentType from crime;
  
  -- 4. Retrieve incidents that occurred between '2023-09-01' and '2023-09-10'
  select * from Crime where IncidentDate between '2023-09-01' and '2023-09-10';
  
   -- 5. List persons involved in incidents in descending order of age
   
   alter table Victim add age int;
   desc Victim;
   update Victim set age='30' where VictimID='1';
   update Victim set age='40' where VictimID='2';
   update Victim set age='38' where VictimID='3';
   select * from Victim;
   
   select * from Victim order by age desc;
   
   
   
   -- 6. Find the average age of persons involved in incidents.
   select avg(age) as averag_age from Victim; 
   
   -- 7. List incident types and their counts, only for open cases.
   select IncidentType,count(*) 
   from Crime
   where status='Open'
   group by IncidentType;
   
   -- 8. Find persons with names containing 'Doe'
   select * from Victim
   where name like '%Doe';
   
   -- 9. Retrieve the names of persons involved in open cases and closed cases
   select Victim.name
   from Victim join Crime
   on Crime.CrimeID=Victim.CrimeID
   where Crime.status in ('open','closed');
   
   -- 10. List incident types where there are persons aged 30 or 35 involved.
   select IncidentType
   from Victim join Crime 
   on Victim.CrimeID=Crime.CrimeID
   where age in(30,35);
   
   -- 11. Find persons involved in incidents of the same type as 'Robbery'.
	select name
    from Crime join Victim on Victim.CrimeID = Crime.CrimeID
    where IncidentType='Robbery';
    
    -- 12. List incident types with more than one open case.
    select IncidentType
    from Crime 
    where Status='open'
    group by IncidentType
    having count(*) >1;
    
    -- 13. List all incidents with suspects whose names also appear as victims in other incidents.
    select * from Crime 
    join (select CrimeID
    from Suspect where exists (select 1
    from Victim where Victim.CrimeID=Suspect.CrimeID
    and Victim.name=Suspect.name)
    )as Subquery on Crime.CrimeID = Subquery.CrimeID;
    
    -- 14. Retrieve all incidents along with victim and suspect details.
   SELECT crime.*, 
       Victim.Name AS VictimName,Victim.VictimID, Victim.ContactInfo, Victim.Injuries,
       Suspect.Name AS SuspectName,Suspect.SuspectID, Suspect.Description, Suspect.CriminalHistory
       from Crime
       join Victim on Victim.CrimeID=Crime.CrimeID
       join Suspect on Suspect.CrimeID=Crime.CrimeID
       
	-- 15. Find incidents where the suspect is older than any victim.
       alter table Suspect add age int;
   desc Suspect;
   update Suspect set age='37' where SuspectID='1';
   update Suspect set age='46' where SuspectID='2';
   update Suspect set age='35' where SuspectID='3';
   select * from Suspect
    
    select * from Crime 
    join Victim on Crime.CrimeID=Victim.CrimeID
    join Suspect on Crime.CrimeID=Suspect.CrimeID
    where Suspect.age > Victim.age;
    
    -- 16. Find suspects involved in multiple incidents.
    select Name, count(distinct CrimeID) AS IncidentCount
	from Suspect
	group by  Name
	having count(distinct CrimeID) > 1;

    -- 17. List incidents with no suspects involved
    select * from crime
    left join Suspect on Crime.CrimeID = Suspect.CrimeID
	WHERE Suspect.SuspectID IS NULL;
    
    -- 18.List all cases where at least one incident is of type 'Homicide' and all other incidents are of type 'Robbery'
    select Crime.*
from Crime 
where exists (
 select 1
 from Crime
 where CrimeID = Crime.CrimeID and IncidentType = 'Homicide'
)
and not exists (
 select 1
 from Crime
 where CrimeID = Crime.CrimeID and IncidentType != 'Robbery'
 );
 
	-- 19. Retrieve a list of all incidents and the associated suspects, showing suspects for each incident, or 'No Suspect' if there are none.
SELECT Crime.*, COALESCE(Suspect.Name, 'No Suspect') AS SuspectName
FROM Crime 
LEFT JOIN Suspect  ON Crime.CrimeID = Suspect.CrimeID;

-- 20. List all suspects who have been involved in incidents with incident types 'Robbery' or 'Assault

SELECT DISTINCT Name
FROM Suspect
WHERE CrimeID IN (
 SELECT CrimeID
 FROM Crime
 WHERE IncidentType IN ('Robbery', 'Assault')
 );
 
  