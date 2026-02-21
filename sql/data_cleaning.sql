CREATE DATABASE credit_risk_analytics;
USE credit_risk_analytics;


CREATE TABLE base_file (
    Client_ID BIGINT PRIMARY KEY,
    Applied INT,
    Approved INT
);


CREATE TABLE enquiry_data (
    Client_ID BIGINT PRIMARY KEY,
    Total_Enquiry_6m_In INT,
    Total_Enquiry_1y_In INT,
    Total_Enquiry_2y_In INT
);


CREATE TABLE tradeline_data (
    Client_ID BIGINT PRIMARY KEY,
    Total_Tradelines_6m_In INT,
    Total_Tradelines_1y_In INT,
    Total_Tradelines_2y_In INT,
    Max_Trade_3m_Out INT
);


DESCRIBE base_file;
DESCRIBE enquiry_data;
DESCRIBE tradeline_data;

SHOW VARIABLES LIKE 'secure_file_priv';



LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/enquiry_data.csv'
INTO TABLE enquiry_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Client_ID,
 @Total_Enquiry_6m_In,
 @Total_Enquiry_1y_In,
 @Total_Enquiry_2y_In)
SET
Total_Enquiry_6m_In = NULLIF(@Total_Enquiry_6m_In, ''),
Total_Enquiry_1y_In = NULLIF(@Total_Enquiry_1y_In, ''),
Total_Enquiry_2y_In = NULLIF(@Total_Enquiry_2y_In, '');


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/tradeline_data.csv'
INTO TABLE tradeline_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Client_ID,
 @Total_Tradelines_6m_In,
 @Total_Tradelines_1y_In,
 @Total_Tradelines_2y_In,
 @Max_Trade_3m_Out)
SET
Total_Tradelines_6m_In = NULLIF(@Total_Tradelines_6m_In, ''),
Total_Tradelines_1y_In = NULLIF(@Total_Tradelines_1y_In, ''),
Total_Tradelines_2y_In = NULLIF(@Total_Tradelines_2y_In, ''),
Max_Trade_3m_Out = NULLIF(@Max_Trade_3m_Out, '');



SELECT COUNT(*) FROM base_file;

SELECT COUNT(*) FROM tradeline_data;

SELECT COUNT(*) FROM enquiry_data;





SELECT COUNT(DISTINCT Client_ID) FROM base_file;
SELECT COUNT(DISTINCT Client_ID) FROM enquiry_data;
SELECT COUNT(DISTINCT Client_ID) FROM tradeline_data;


SELECT COUNT(*)
FROM tradeline_data t
LEFT JOIN base_file b
ON t.Client_ID = b.Client_ID
WHERE b.Client_ID IS NULL;


SELECT COUNT(*)
FROM tradeline_data t
LEFT JOIN enquiry_data e
ON t.Client_ID = e.Client_ID
WHERE e.Client_ID IS NULL;


SELECT COUNT(*)
FROM enquiry_data e
LEFT JOIN base_file b
ON e.Client_ID = b.Client_ID
WHERE b.Client_ID IS NULL;



SELECT COUNT(*)
FROM base_file b
INNER JOIN enquiry_data e ON b.Client_ID = e.Client_ID
INNER JOIN tradeline_data t ON b.Client_ID = t.Client_ID;


SELECT COUNT(DISTINCT Client_ID) FROM
(
SELECT Client_ID FROM base_file
UNION
SELECT Client_ID FROM enquiry_data
UNION
SELECT Client_ID FROM tradeline_data
) all_clients;


SELECT 
COUNT(*) AS total_rows,
COUNT(DISTINCT Client_ID) AS distinct_clients
FROM base_file;

SELECT 
COUNT(*) AS total_rows,
COUNT(DISTINCT Client_ID) AS distinct_clients
FROM enquiry_data;


SELECT 
COUNT(*) AS total_rows,
COUNT(DISTINCT Client_ID) AS distinct_clients
FROM tradeline_data;



SELECT 
ROUND(SUM(CASE WHEN Total_Tradelines_6m_In IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2)
AS missing_percentage
FROM tradeline_data;


SELECT 
ROUND(SUM(CASE WHEN Total_Enquiry_6m_In IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2)
AS missing_percentage
FROM enquiry_data;


SELECT 
ROUND(SUM(CASE WHEN Applied IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2)
AS missing_applied,
ROUND(SUM(CASE WHEN Approved IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2)
AS missing_approved
FROM base_file;


SELECT COUNT(*) 
FROM tradeline_data
WHERE 
Total_Tradelines_6m_In > Total_Tradelines_1y_In
OR
Total_Tradelines_1y_In > Total_Tradelines_2y_In;


SELECT 
ROUND(
COUNT(*) / (SELECT COUNT(*) FROM tradeline_data) * 100
,2) AS violation_percentage
FROM tradeline_data
WHERE 
Total_Tradelines_6m_In > Total_Tradelines_1y_In
OR
Total_Tradelines_1y_In > Total_Tradelines_2y_In;



SELECT COUNT(*)
FROM enquiry_data
WHERE 
Total_Enquiry_6m_In > Total_Enquiry_1y_In
OR
Total_Enquiry_1y_In > Total_Enquiry_2y_In;


SELECT 
ROUND(
COUNT(*) / (SELECT COUNT(*) FROM enquiry_data) * 100
,2) AS violation_percentage
FROM enquiry_data
WHERE 
Total_Enquiry_6m_In > Total_Enquiry_1y_In
OR
Total_Enquiry_1y_In > Total_Enquiry_2y_In;


SELECT COUNT(*) FROM tradeline_data;

SELECT Total_Tradelines_6m_In
FROM tradeline_data
ORDER BY Total_Tradelines_6m_In
LIMIT 6249, 1;


SELECT Total_Tradelines_6m_In
FROM tradeline_data
ORDER BY Total_Tradelines_6m_In
LIMIT 18749, 1;

SELECT COUNT(*)
FROM tradeline_data
WHERE Total_Tradelines_6m_In > 29;


SELECT COUNT(*)
FROM base_file
WHERE Approved > Applied;


SELECT 
ROUND(
COUNT(*) / (SELECT COUNT(*) FROM base_file) * 100
,2) AS violation_percentage
FROM base_file
WHERE Approved > Applied;


SELECT DISTINCT Applied
FROM base_file
ORDER BY Applied;


SELECT DISTINCT Approved
FROM base_file
ORDER BY Approved;


SELECT 
MIN(Applied),
MAX(Applied),
MIN(Approved),
MAX(Approved)
FROM base_file;


SELECT Total_Tradelines_6m_In
FROM tradeline_data
ORDER BY Total_Tradelines_6m_In
LIMIT 12499, 2;

SELECT Total_Enquiry_6m_In
FROM enquiry_data
ORDER BY Total_Enquiry_6m_In
LIMIT 12249, 2;


DESCRIBE base_file;
DESCRIBE enquiry_data;
DESCRIBE tradeline_data;


SELECT COUNT(*)
FROM tradeline_data
WHERE Total_Tradelines_6m_In < 0
OR Total_Tradelines_1y_In < 0
OR Total_Tradelines_2y_In < 0;


SELECT COUNT(*)
FROM enquiry_data
WHERE Total_Enquiry_6m_In < 0
OR Total_Enquiry_1y_In < 0
OR Total_Enquiry_2y_In < 0;


SELECT COUNT(*)
FROM tradeline_data
WHERE Max_Trade_3m_Out < 0;



SELECT COUNT(*)
FROM base_file
WHERE Approved IS NULL
AND Applied IS NOT NULL;


SELECT COUNT(*)
FROM base_file
WHERE Applied > 0
AND Approved IS NULL;



SELECT COUNT(*) 
FROM tradeline_data
WHERE 
Total_Tradelines_6m_In > Total_Tradelines_1y_In
OR
Total_Tradelines_1y_In > Total_Tradelines_2y_In;



SELECT COUNT(*) 
FROM enquiry_data
WHERE 
Total_Enquiry_6m_In > Total_Enquiry_1y_In
OR
Total_Enquiry_1y_In > Total_Enquiry_2y_In;


SELECT Total_Tradelines_6m_In
FROM tradeline_data
ORDER BY Total_Tradelines_6m_In
LIMIT 24749, 1;


SELECT Total_Enquiry_6m_In
FROM enquiry_data
ORDER BY Total_Enquiry_6m_In
LIMIT 24254, 1;

SET SQL_SAFE_UPDATES = 0;

UPDATE tradeline_data
SET Total_Tradelines_6m_In = 19
WHERE Total_Tradelines_6m_In > 19;

UPDATE enquiry_data
SET Total_Enquiry_6m_In = 14
WHERE Total_Enquiry_6m_In > 14;


SELECT MAX(Total_Tradelines_6m_In) FROM tradeline_data;
SELECT MAX(Total_Enquiry_6m_In) FROM enquiry_data;


SELECT MAX(Total_Tradelines_6m_In) FROM tradeline_data;


CREATE TABLE master_credit_data AS
SELECT 
b.Client_ID,
b.Applied,
b.Approved,
t.Total_Tradelines_6m_In,
t.Total_Tradelines_1y_In,
t.Total_Tradelines_2y_In,
t.Max_Trade_3m_Out,
e.Total_Enquiry_6m_In,
e.Total_Enquiry_1y_In,
e.Total_Enquiry_2y_In
FROM base_file b
INNER JOIN tradeline_data t 
    ON b.Client_ID = t.Client_ID
INNER JOIN enquiry_data e 
    ON b.Client_ID = e.Client_ID;


SELECT COUNT(*) FROM master_credit_data;


SELECT *
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/master_credit_data_clean.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM master_credit_data;

